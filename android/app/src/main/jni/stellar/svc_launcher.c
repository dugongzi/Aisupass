/*
 * Stellar 特权服务的单二进制入口（双模式）。
 *
 * 模式 A —— starter（默认，参数里没有 `--serve`）：
 *   1. 拒绝非 root / 非 shell 身份启动；
 *   2. 探测端口三态：本协议已在跑 → 直接返回；旧版服务 → 发 STOP 清场；
 *      被其它程序占用 → 报 portTaken 并退出，不碰对方进程；
 *   3. 清掉同名残留，保证单实例；
 *   4. fork 出子进程 → setsid → 重定向到日志 → execv 自身（带 `--serve`）。
 *
 * 模式 B —— serve（`--serve --svc-token=<hex>`）：
 *   监听回环端口并在 stellar_serve.c 里分派请求。
 *
 * 为什么要自 exec 而不是拉 app_process：服务端已经全是 C 实现，
 * 走 JVM 只会多一层 ART 启动开销与 dex 版本约束。fork + setsid 之后
 * 本进程与 adbd 再无关系，无线调试关掉也不掉线。
 *
 * 只用公开系统能力：setsid(2)、socket(2)、fork(2)、execv(2)、prctl(2)。
 */

#include <arpa/inet.h>
#include <dirent.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

#include "stellar_proto.h"

/* 服务端入口；实现位于 stellar_serve.c。
 * 用前向声明而不新增头文件，避免引入未登记路径（任务文档 00 §6.1）。 */
int serve_main(const char *token, int allow_uid);

/* ---------------------------------------------------------------- 常量 --- */

/** 服务进程展示名，同时用于残留进程识别。 */
#define HOST_TAG "aisupass-stellar"

/** 服务自身日志；服务脱离 adbd 之后就靠这个文件排查。 */
#define HOST_LOG_FILE "/data/local/tmp/aisupass-stellar.log"

/** 探测阶段的单次连接与等待上限。 */
#define PROBE_WAIT_US 300000

/** 等旧版实例释放端口的轮询次数与间隔。 */
#define LEGACY_RETRY 10
#define LEGACY_INTERVAL_US 200000

/** 引导器自身的退出码，供上层按码归因。 */
#define RC_OK 0
#define RC_WRONG_IDENTITY 10
#define RC_STALE_ALIVE 12
#define RC_LAUNCH_FAILED 13
#define RC_PORT_TAKEN 14

/** 端口上是谁。 */
enum host_state {
    PROBE_ABSENT = 0,
    PROBE_V2,
    PROBE_V1,
    PROBE_FOREIGN
};

/* ------------------------------------------------------------ 输出与退出 --- */

/** 统一出口：先给一行可解析的原因码，再退出。 */
static void bail(int code, const char *tag) {
    fprintf(stdout, "error=%s\n", tag);
    fflush(stdout);
    exit(code);
}

/** 成功提示；内容只供人看，调用方应以端口探测为准。 */
static void announce(const char *tag, int value) {
    fprintf(stdout, "ok=%s value=%d\n", tag, value);
    fflush(stdout);
}

/* ---------------------------------------------------------------- 探测 --- */

/** 连一次回环端口；失败返回 -1。 */
static int dial_host(void) {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) return -1;

    struct timeval wait;
    wait.tv_sec = 0;
    wait.tv_usec = PROBE_WAIT_US;
    (void) setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &wait, sizeof(wait));
    (void) setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &wait, sizeof(wait));

    struct sockaddr_in target;
    memset(&target, 0, sizeof(target));
    target.sin_family = AF_INET;
    target.sin_port = htons(PROTO_PORT);
    target.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    if (connect(sock, (struct sockaddr *) &target, sizeof(target)) != 0) {
        close(sock);
        return -1;
    }
    return sock;
}

/**
 * 从应答里取协议版本。
 *
 * 只认 `"protocol":` 之后的十进制整数：端口上可能是任意程序，
 * 不能凭「能连上」就认定是自己的实例。
 */
static int parse_protocol(const char *reply) {
    const char *mark = strstr(reply, "\"protocol\":");
    if (mark == NULL) return -1;

    mark += strlen("\"protocol\":");
    while (*mark == ' ') mark++;
    if (*mark < '0' || *mark > '9') return -1;

    return atoi(mark);
}

/** 问一次端口上是谁。 */
static enum host_state probe_host(void) {
    int sock = dial_host();
    if (sock < 0) return PROBE_ABSENT;

    const char ping[] = "PING\n";
    ssize_t sent = write(sock, ping, sizeof(ping) - 1);
    if (sent != (ssize_t) (sizeof(ping) - 1)) {
        close(sock);
        return PROBE_FOREIGN;
    }

    char reply[128];
    memset(reply, 0, sizeof(reply));
    ssize_t got = read(sock, reply, sizeof(reply) - 1);
    close(sock);
    if (got <= 0) return PROBE_FOREIGN;

    int version = parse_protocol(reply);
    if (version == PROTO_VERSION) return PROBE_V2;
    if (version == 1) return PROBE_V1;
    return PROBE_FOREIGN;
}

/**
 * 让旧版（protocol 1）实例退出。
 *
 * 旧版不校验 token，收到一行 `STOP` 就会应答并退出；之后端口要再过一小会儿
 * 才真正释放，所以在预算内反复探测。
 *
 * @return 端口已释放返回 1，仍在占用返回 0。
 */
static int stop_legacy(void) {
    int sock = dial_host();
    if (sock >= 0) {
        const char stop[] = "STOP\n";
        ssize_t ignored = write(sock, stop, sizeof(stop) - 1);
        (void) ignored;
        close(sock);
    }

    for (int i = 0; i < LEGACY_RETRY; i++) {
        usleep(LEGACY_INTERVAL_US);
        sock = dial_host();
        if (sock < 0) return 1;
        close(sock);
    }
    return 0;
}

/* ------------------------------------------------------------ 残留清理 --- */

/**
 * 判断 pid 是不是我们的服务进程。
 *
 * /proc/<pid>/cmdline 是 NUL 分隔的参数表，首段即进程名：
 * serve 模式由本文件以 `argv[0] = HOST_TAG` 启动，按 C 字符串比较即可。
 */
static int is_host_process(pid_t pid) {
    char path[48];
    snprintf(path, sizeof(path), "/proc/%d/cmdline", (int) pid);

    int fd = open(path, O_RDONLY);
    if (fd < 0) return 0;

    char head[192];
    ssize_t got = read(fd, head, sizeof(head) - 1);
    close(fd);
    if (got <= 0) return 0;

    head[got] = '\0';
    return strcmp(head, HOST_TAG) == 0;
}

/** 结束所有旧的同名进程；有杀不掉的返回 0。 */
static int sweep_stale_host(void) {
    DIR *procfs = opendir("/proc");
    if (procfs == NULL) return 1;

    const pid_t me = getpid();
    int clean = 1;

    struct dirent *item;
    while ((item = readdir(procfs)) != NULL) {
        char *tail = NULL;
        long parsed = strtol(item->d_name, &tail, 10);
        if (tail == item->d_name || *tail != '\0' || parsed <= 0) continue;

        pid_t pid = (pid_t) parsed;
        if (pid == me) continue;
        if (!is_host_process(pid)) continue;

        if (kill(pid, SIGKILL) != 0 && errno != ESRCH) clean = 0;
    }

    closedir(procfs);
    return clean;
}

/* ---------------------------------------------------------------- 拉起 --- */

/**
 * 起服务进程并立即返回。
 *
 * 子进程先 setsid 脱离原会话，再把三个标准流换掉：adbd 断掉时父进程的管道会关，
 * 子进程若还握着它，任何一次写都会收到 SIGPIPE 而莫名其妙退出。
 * 之后 execv 自身进入 serve 模式，argv[0] 固定为 HOST_TAG，便于残留识别。
 */
static void spawn_host(const char *token) {
    pid_t child = fork();
    if (child < 0) bail(RC_LAUNCH_FAILED, "forkFailed");
    if (child > 0) {
        announce("spawned", (int) child);
        exit(RC_OK);
    }

    setsid();
    chdir("/");

    int dev_null = open("/dev/null", O_RDWR);
    if (dev_null >= 0) {
        dup2(dev_null, STDIN_FILENO);
        if (dev_null > STDERR_FILENO) close(dev_null);
    }

    int sink = open(HOST_LOG_FILE, O_WRONLY | O_CREAT | O_APPEND, 0600);
    if (sink >= 0) {
        dup2(sink, STDOUT_FILENO);
        dup2(sink, STDERR_FILENO);
        if (sink > STDERR_FILENO) close(sink);
    }

    char self[512];
    ssize_t got = readlink("/proc/self/exe", self, sizeof(self) - 1);
    if (got <= 0) {
        fprintf(stderr, "launchFailed: readlink %s\n", strerror(errno));
        _exit(RC_LAUNCH_FAILED);
    }
    self[got] = '\0';

    char token_arg[TOKEN_MAX + 16];
    snprintf(token_arg, sizeof(token_arg), "--svc-token=%s",
             token != NULL ? token : "");

    char *const args[] = {
        (char *) HOST_TAG,
        (char *) "--serve",
        token_arg,
        NULL,
    };

    execv(self, args);
    fprintf(stderr, "launchFailed: %s\n", strerror(errno));
    _exit(RC_LAUNCH_FAILED);
}

/* ----------------------------------------------------------------- 主流程 --- */

int main(int argc, char *argv[]) {
    const char *token = NULL;
    int serve = 0;

    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "--serve") == 0) {
            serve = 1;
            continue;
        }
        const char flag[] = "--svc-token=";
        if (strncmp(argv[i], flag, sizeof(flag) - 1) == 0) {
            token = argv[i] + sizeof(flag) - 1;
        }
    }

    uid_t identity = getuid();

    /* 探测阶段会对陌生监听者写 PING，对方提前关连接时不要被 SIGPIPE 打死。 */
    (void) signal(SIGPIPE, SIG_IGN);

    if (serve) return serve_main(token, (int) identity);

    if (identity != 0 && identity != 2000) {
        bail(RC_WRONG_IDENTITY, "wrongIdentity");
    }
    fprintf(stdout, "identity=%d\n", (int) identity);
    fflush(stdout);

    switch (probe_host()) {
        case PROBE_V2:
            announce("alreadyAlive", 0);
            return RC_OK;
        case PROBE_V1:
            if (!stop_legacy()) bail(RC_STALE_ALIVE, "legacyAlive");
            break;
        case PROBE_FOREIGN:
            bail(RC_PORT_TAKEN, "portTaken");
            break;
        case PROBE_ABSENT:
        default:
            break;
    }

    if (!sweep_stale_host()) bail(RC_STALE_ALIVE, "staleHostAlive");

    spawn_host(token);
    return RC_OK;
}

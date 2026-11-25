/*
 * Stellar 特权服务的拉起器（一次性程序，跑完即退）。
 *
 * 它只负责把「本 APK 里的服务主类」以调用者的特权身份跑起来，之后就再无作用：
 *
 *   1. 拒绝非 root / 非 shell 身份启动；
 *   2. 已有健康实例时直接返回，不打断；
 *   3. 清掉同名残留，保证单实例；
 *   4. fork 出子进程 → setsid → exec app_process，子进程与 adbd 彻底解绑。
 *
 * 只用公开系统能力：execv(/system/bin/app_process)、setsid(2)、socket(2)。
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

/* ---------------------------------------------------------------- 常量 --- */

/** 服务进程展示名，同时用于残留进程识别。 */
#define HOST_TAG "aisupass-stellar"

/** 服务主类全名，必须与本 APK 中的实现一致。 */
#define HOST_ENTRY_CLASS "org.supass.ai_su_pass.core.stellar.StellarServiceHost"

/** 系统自带的裸 Java 启动器。 */
#define JAVA_LAUNCHER "/system/bin/app_process"

/** 探活端口，必须与 Kotlin 侧 StellarServiceHost.PORT 保持一致。 */
#define HOST_PORT 39187

/** 服务自身日志；服务脱离 adbd 之后就靠这个文件排查。 */
#define HOST_LOG_FILE "/data/local/tmp/aisupass-stellar.log"

/** 引导器自身的退出码，供上层按码归因。 */
#define RC_OK 0
#define RC_WRONG_IDENTITY 10
#define RC_APK_UNRESOLVED 11
#define RC_STALE_ALIVE 12
#define RC_LAUNCH_FAILED 13

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

/**
 * 问一次服务在不在。
 *
 * 判定依据是「端口能否完成一次 PING/PONG」，不是进程名：同名进程可能是上一次
 * 崩在半路的残余，而能应答才代表它真的在服务。
 */
static int host_replies(void) {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) return 0;

    struct timeval wait;
    wait.tv_sec = 0;
    wait.tv_usec = 300000;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &wait, sizeof(wait));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &wait, sizeof(wait));

    struct sockaddr_in target;
    memset(&target, 0, sizeof(target));
    target.sin_family = AF_INET;
    target.sin_port = htons(HOST_PORT);
    target.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    if (connect(sock, (struct sockaddr *) &target, sizeof(target)) != 0) {
        close(sock);
        return 0;
    }

    const char ping[] = "PING\n";
    if (write(sock, ping, sizeof(ping) - 1) != (ssize_t) (sizeof(ping) - 1)) {
        close(sock);
        return 0;
    }

    char chunk[96];
    ssize_t got = read(sock, chunk, sizeof(chunk) - 1);
    close(sock);
    return got > 0;
}

/* ------------------------------------------------------------ 残留清理 --- */

/**
 * 判断 pid 是不是我们的服务进程。
 *
 * /proc/<pid>/cmdline 是 NUL 分隔的参数表，首段即进程名，按 C 字符串比较即可。
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

/* -------------------------------------------------------------- APK 路径 --- */

/** 向包管理器要一次本应用的 APK 路径；调用方给的路径优先。 */
static int ask_apk_path(const char *hint, char *out, size_t cap) {
    if (hint != NULL && hint[0] != '\0' && access(hint, R_OK) == 0) {
        snprintf(out, cap, "%s", hint);
        return 1;
    }

    FILE *answer = popen("pm path org.supass.ai_su_pass", "r");
    if (answer == NULL) return 0;

    char line[512];
    int ok = 0;
    if (fgets(line, sizeof(line), answer) != NULL) {
        size_t len = strlen(line);
        while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
            line[--len] = '\0';
        }
        const char prefix[] = "package:";
        if (strncmp(line, prefix, sizeof(prefix) - 1) == 0) {
            snprintf(out, cap, "%s", line + sizeof(prefix) - 1);
            ok = access(out, R_OK) == 0;
        }
    }
    pclose(answer);
    return ok;
}

/* ---------------------------------------------------------------- 拉起 --- */

/**
 * 起服务进程并立即返回。
 *
 * 子进程先 setsid 脱离原会话，再把三个标准流换掉：adbd 断掉时父进程的管道会关，
 * 子进程若还握着它，任何一次写都会收到 SIGPIPE 而莫名其妙退出。
 */
static void spawn_host(const char *apk) {
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

    char classpath[640];
    snprintf(classpath, sizeof(classpath), "-Djava.class.path=%s", apk);

    char *const args[] = {
        (char *) JAVA_LAUNCHER,
        classpath,
        (char *) "/system/bin",
        (char *) "--nice-name=" HOST_TAG,
        (char *) HOST_ENTRY_CLASS,
        NULL,
    };

    execv(JAVA_LAUNCHER, args);
    fprintf(stderr, "launchFailed: %s\n", strerror(errno));
    _exit(RC_LAUNCH_FAILED);
}

/* ----------------------------------------------------------------- 主流程 --- */

int main(int argc, char *argv[]) {
    const char *apk_hint = NULL;
    for (int i = 1; i < argc; i++) {
        const char flag[] = "--entry-apk=";
        if (strncmp(argv[i], flag, sizeof(flag) - 1) == 0) {
            apk_hint = argv[i] + sizeof(flag) - 1;
        }
    }

    uid_t identity = getuid();
    if (identity != 0 && identity != 2000) bail(RC_WRONG_IDENTITY, "wrongIdentity");
    fprintf(stdout, "identity=%d\n", (int) identity);
    fflush(stdout);

    if (host_replies()) {
        announce("alreadyAlive", 0);
        return RC_OK;
    }

    if (!sweep_stale_host()) bail(RC_STALE_ALIVE, "staleHostAlive");

    char apk[512];
    if (!ask_apk_path(apk_hint, apk, sizeof(apk))) bail(RC_APK_UNRESOLVED, "apkUnresolved");

    spawn_host(apk);
    return RC_OK;
}

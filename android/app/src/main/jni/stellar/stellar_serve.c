/*
 * Stellar 服务端：监听回环端口、分派请求、按连接 fork 处理进程。
 *
 * 生命周期：
 *   starter（见 svc_launcher.c）fork + setsid + execv 自身带 `--serve`，
 *   因此本进程与 adbd 之间没有父子关系，无线调试关掉也不掉线。
 *
 * 并发模型：
 *   父进程只做 accept；每条连接 fork 一个处理进程，处理完即退。
 *   不用线程：fork 之后无共享状态，隔离最简单，也不存在与 fork 混用线程的死锁风险。
 *
 * 鉴权：
 *   除裸 `PING`（只回协议版本）外，所有请求必须带 token；不匹配立即断连、
 *   不回任何字节。详见任务文档 00 的 §5.4。
 */

#include "stellar_exec.h"
#include "stellar_proto.h"
#include "stellar_pty.h"

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <netinet/in.h>
#include <signal.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <unistd.h>

/* ---------------------------------------------------------------- 常量 --- */

/** 服务进程展示名；必须与 svc_launcher.c 的 HOST_TAG 同值。 */
#define SERVE_TAG "aisupass-stellar"

/** 同时处理的连接上限；超出的连接直接关闭，避免异常连打耗尽进程。 */
#define MAX_CONN 8

/** listen 积压队列。 */
#define LISTEN_BACKLOG 4

/** 单连接读写的等待上限，防止只连不说的客户端占住处理进程。 */
#define IO_TIMEOUT_SEC 2

/** 关停时留给处理进程收尾的时间。 */
#define REAP_WAIT_MS 300

/* ------------------------------------------------------------ 全局状态 --- */

/** 置位后 accept 循环退出；信号处理里只写它。 */
static volatile sig_atomic_t g_stop = 0;

/** 活跃处理进程；0 表示空槽。 */
static pid_t g_children[MAX_CONN];

/* ------------------------------------------------------------ 日志输出 --- */

/**
 * 写一行日志到标准输出。
 *
 * 服务由 starter 的 `--serve` 分支拉起时，stdout 已被重定向到
 * /data/local/tmp/aisupass-stellar.log，因此这里只需要 printf。
 * 禁止在此打印 token 或命令全文。
 */
static void tracef(const char *fmt, ...) {
    char line[256];
    va_list args;

    va_start(args, fmt);
    vsnprintf(line, sizeof(line), fmt, args);
    va_end(args);

    printf("[%s] %s\n", SERVE_TAG, line);
    fflush(stdout);
}

/* ------------------------------------------------------------ 信号处理 --- */

/**
 * 关停信号：只置标志。
 *
 * 不在处理函数里碰套接字——`accept` 未带 SA_RESTART，信号到达后会返回
 * EINTR，主循环据此看到标志并自行收尾。
 */
static void on_terminate(int sig) {
    (void) sig;
    g_stop = 1;
}

/* ------------------------------------------------------------ 子进程簿记 --- */

/** 找空闲槽位；没有则返回 -1。 */
static int free_slot(void) {
    for (int i = 0; i < MAX_CONN; i++) {
        if (g_children[i] == 0) return i;
    }
    return -1;
}

/** 回收任意已退出的处理进程，并清掉对应槽位。 */
static void reap_children(void) {
    for (;;) {
        int status = 0;
        pid_t pid = waitpid(-1, &status, WNOHANG);
        if (pid <= 0) return;

        for (int i = 0; i < MAX_CONN; i++) {
            if (g_children[i] == pid) {
                g_children[i] = 0;
                break;
            }
        }
    }
}

/** 依次 SIGTERM → 等待 → SIGKILL → 收尸。 */
static void terminate_children(void) {
    int alive = 0;
    for (int i = 0; i < MAX_CONN; i++) {
        if (g_children[i] > 0) {
            kill(g_children[i], SIGTERM);
            alive++;
        }
    }

    if (alive > 0) usleep(REAP_WAIT_MS * 1000);

    for (int i = 0; i < MAX_CONN; i++) {
        if (g_children[i] > 0) kill(g_children[i], SIGKILL);
    }
    for (int i = 0; i < MAX_CONN; i++) {
        if (g_children[i] > 0) {
            waitpid(g_children[i], NULL, 0);
            g_children[i] = 0;
        }
    }
}

/* ---------------------------------------------------------------- 应答 --- */

/** 发一行 JSON（自动补换行）。 */
static void reply_line(int fd, const char *json) {
    (void) proto_send_all(fd, json, strlen(json));
    (void) proto_send_all(fd, "\n", 1);
}

/** 解析十进制整数；非法或缺失返回 -1。 */
static long parse_long(const char *text) {
    if (text == NULL) return -1;

    char *end = NULL;
    long value = strtol(text, &end, 10);
    if (end == text || end == NULL || *end != '\0') return -1;
    return value;
}

/* ------------------------------------------------------------ 请求处理 --- */

/** 丢弃用的最大字节数：超限后不再排空，直接断开（避免被异常长度拖住）。 */
#define DRAIN_CAP (64L << 20)

/** 读走并丢弃最多 remain 字节的体，避免关闭时对端收到 RST 而丢应答。 */
static void drain_body(int fd, long remain) {
    unsigned char hole[8192];
    if (remain > DRAIN_CAP) remain = DRAIN_CAP;
    while (remain > 0) {
        size_t want = (size_t) (remain < (long) sizeof(hole) ? remain : (long) sizeof(hole));
        if (proto_recv_all(fd, hole, want) != 0) return;
        remain -= (long) want;
    }
}

/** EXEC / OPEN 共用的命令体读取：读满即 `\0` 结尾，失败返回 NULL。 */
static char *read_command(int fd, long body_len) {
    if (body_len <= 0) return NULL;
    if (body_len > CMD_MAX) {
        /* 超长：排空体再回错，避免残留数据让 close 触发 RST 丢掉应答。 */
        drain_body(fd, body_len);
        return NULL;
    }

    char *cmd = malloc((size_t) body_len + 1);
    if (cmd == NULL) {
        drain_body(fd, body_len);
        return NULL;
    }

    if (proto_recv_all(fd, cmd, (size_t) body_len) != 0) {
        free(cmd);
        return NULL;
    }
    cmd[body_len] = '\0';
    return cmd;
}

/** 标准输入体读取；长度为 0 时返回 NULL 且不算失败。 */
static uint8_t *read_stdin(int fd, long body_len, int *failed) {
    *failed = 0;
    if (body_len <= 0) return NULL;
    if (body_len > (long) IN_CAP) {
        /* 超限：把体排空再报错。不排空直接 close 会因接收缓冲有残留数据触发
         * RST，客户端连 badStdin 应答都读不到。 */
        drain_body(fd, body_len);
        *failed = 1;
        return NULL;
    }

    uint8_t *data = malloc((size_t) body_len);
    if (data == NULL) {
        drain_body(fd, body_len);
        *failed = 1;
        return NULL;
    }
    if (proto_recv_all(fd, data, (size_t) body_len) != 0) {
        free(data);
        *failed = 1;
        return NULL;
    }
    return data;
}

/** 处理一条连接；返回即表示该连接结束。 */
static void handle_conn(int fd, const char *token, int self_uid) {
    struct timeval wait;
    wait.tv_sec = IO_TIMEOUT_SEC;
    wait.tv_usec = 0;
    (void) setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &wait, sizeof(wait));
    (void) setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &wait, sizeof(wait));

    char line[512];
    if (proto_read_line(fd, line, sizeof(line)) <= 0) return;

    char *save = NULL;
    char *verb = strtok_r(line, " ", &save);
    char *arg1 = strtok_r(NULL, " ", &save);
    char *arg2 = strtok_r(NULL, " ", &save);
    char *arg3 = strtok_r(NULL, " ", &save);
    char *arg4 = strtok_r(NULL, " ", &save);

    if (verb == NULL) return;

    /* 裸 PING：只回协议版本，用于拉起器与客户端判定「端口上是不是本协议」。
     * 不返回 uid / pid，避免无凭证的探测者拿到身份信息。 */
    if (strcmp(verb, "PING") == 0 && arg1 == NULL) {
        char out[32];
        snprintf(out, sizeof(out), "{\"protocol\":%d}", PROTO_VERSION);
        reply_line(fd, out);
        return;
    }

    if (strcmp(verb, "PING") == 0) {
        if (!proto_token_match(arg1, token)) return;

        char out[128];
        snprintf(
            out,
            sizeof(out),
            "{\"protocol\":%d,\"uid\":%d,\"pid\":%d}",
            PROTO_VERSION,
            self_uid,
            (int) getpid()
        );
        reply_line(fd, out);
        return;
    }

    if (strcmp(verb, "STOP") == 0) {
        if (!proto_token_match(arg1, token)) return;

        reply_line(fd, "{\"ok\":1}");
        tracef("stop requested");
        /* 让父进程收摊：父进程收到 SIGUSR1 后退出 accept 循环，
         * 再逐个终止处理进程（包括本进程）。 */
        kill(getppid(), SIGUSR1);
        return;
    }

    if (strcmp(verb, "EXEC") == 0) {
        if (!proto_token_match(arg1, token)) return;

        long timeout_ms = parse_long(arg2);
        long cmd_body_len = parse_long(arg3);
        /* 第 5 段是可选的标准输入长度；缺省按 0（不喂输入）。 */
        long stdin_body_len = parse_long(arg4);
        if (stdin_body_len < 0) stdin_body_len = 0;

        /* 超时原样透传：<= 0 表示不限时，正数按调用方要求等。
         * 这里不夹上限——服务不是策略层，替调用方改写等待时间属于越权。
         * 唯一的处理是类型安全：int 装不下 long，溢出会翻成负数被当成「不限时」。 */
        if (timeout_ms < 0) timeout_ms = 0;
        if (timeout_ms > (long) INT_MAX) timeout_ms = (long) INT_MAX;

        char *cmd = read_command(fd, cmd_body_len);
        if (cmd == NULL) {
            reply_line(fd, "{\"ok\":0,\"reason\":\"badCommand\"}");
            return;
        }

        int stdin_failed = 0;
        uint8_t *stdin_data = read_stdin(fd, stdin_body_len, &stdin_failed);
        if (stdin_failed) {
            free(cmd);
            reply_line(fd, "{\"ok\":0,\"reason\":\"badStdin\"}");
            return;
        }

        (void) exec_once(
            fd,
            cmd,
            (uint32_t) cmd_body_len,
            stdin_data,
            (uint32_t) stdin_body_len,
            (int) timeout_ms
        );
        free(stdin_data);
        free(cmd);
        return;
    }

    if (strcmp(verb, "OPEN") == 0) {
        if (!proto_token_match(arg1, token)) return;

        long rows = parse_long(arg2);
        long cols = parse_long(arg3);
        long body_len = parse_long(arg4);

        /* 尺寸只用于 pty 排版；越界值会让全屏程序按错误网格画图。 */
        if (rows < 1) rows = 24;
        if (rows > 1000) rows = 1000;
        if (cols < 1) cols = 80;
        if (cols > 1000) cols = 1000;

        char *cmd = read_command(fd, body_len);
        if (cmd == NULL) {
            reply_line(fd, "{\"ok\":0,\"reason\":\"badCommand\"}");
            return;
        }

        (void) pty_serve(
            fd,
            cmd,
            (uint32_t) body_len,
            (int) rows,
            (int) cols
        );
        free(cmd);
        return;
    }

    /* 未知请求：token 通过才解释原因，否则按鉴权失败静默断连。 */
    if (proto_token_match(arg1, token)) {
        reply_line(fd, "{\"ok\":0,\"reason\":\"unsupported\"}");
    }
}

/* ---------------------------------------------------------------- 主循环 --- */

/**
 * 服务端入口。
 *
 * @param token     拉起时注入的鉴权串；为空视为配置错误，拒绝启动。
 * @param allow_uid 调用方声明的身份；必须与当前 getuid() 一致。
 * @return 进程退出码。
 */
int serve_main(const char *token, int allow_uid) {
    if (token == NULL || token[0] == '\0') {
        tracef("serve denied: missing token");
        return 10;
    }

    uid_t uid = getuid();
    if (allow_uid != (int) uid) {
        tracef("serve denied: identity changed");
        return 10;
    }
    if (uid != 0 && uid != (uid_t) 2000) {
        tracef("serve denied uid=%d", (int) uid);
        return 10;
    }

    (void) prctl(PR_SET_NAME, (unsigned long) SERVE_TAG, 0UL, 0UL, 0UL);
    (void) signal(SIGPIPE, SIG_IGN);

    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_handler = on_terminate;
    sa.sa_flags = 0;
    (void) sigaction(SIGTERM, &sa, NULL);
    (void) sigaction(SIGINT, &sa, NULL);
    (void) sigaction(SIGUSR1, &sa, NULL);

    int fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0) {
        tracef("socket failed errno=%d", errno);
        return 11;
    }

    int reuse = 1;
    (void) setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuse, sizeof(reuse));

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(PROTO_PORT);
    addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    if (bind(fd, (struct sockaddr *) &addr, sizeof(addr)) != 0) {
        /* 端口被占说明已有实例在服务，交给探测方确认，这里安静退出。 */
        tracef("port busy: errno=%d", errno);
        close(fd);
        return 0;
    }
    if (listen(fd, LISTEN_BACKLOG) != 0) {
        tracef("listen failed errno=%d", errno);
        close(fd);
        return 11;
    }

    const int self_uid = (int) uid;
    tracef("serve boot uid=%d pid=%d", self_uid, (int) getpid());

    while (!g_stop) {
        struct sockaddr_in peer;
        socklen_t peer_len = sizeof(peer);
        int conn = accept(fd, (struct sockaddr *) &peer, &peer_len);

        if (conn < 0) {
            if (g_stop) break;
            if (errno == EINTR) continue;
            tracef("accept aborted errno=%d", errno);
            break;
        }

        reap_children();

        int slot = free_slot();
        if (slot < 0) {
            tracef("conn rejected: busy");
            close(conn);
            continue;
        }

        pid_t child = fork();
        if (child < 0) {
            tracef("fork failed errno=%d", errno);
            close(conn);
            continue;
        }

        if (child == 0) {
            /* 处理进程不持有监听套接字，父进程收摊后才能释放端口。
             * 03 会在这里接上 pty 子进程的清理处理。 */
            close(fd);
            handle_conn(conn, token, self_uid);
            close(conn);
            _exit(0);
        }

        g_children[slot] = child;
        tracef("conn accepted pid=%d slot=%d", (int) child, slot);
        close(conn);
    }

    tracef("shutting down");
    close(fd);
    terminate_children();
    tracef("bye pid=%d", (int) getpid());
    return 0;
}

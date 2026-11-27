/*
 * 伪终端会话。
 *
 * 用 forkpty 一次完成「分配 pty + fork + 设置控制终端 + 把 slave 设为子进程的
 * 三条标准流」，本进程只持有 master 端。
 *
 * 为什么必须是真 pty 而不是管道：没有 line discipline 就没有远端回显、行编辑、
 * `^C → SIGINT` 与窗口尺寸，`isatty()` 返回 false 会让 `top` / `vi` 直接拒绝工作。
 *
 * 会话生命周期绑定连接（任务文档 00 D8）：连接断即收尾，不做 detach / 输出回放。
 */

#include "stellar_pty.h"

#include "stellar_proto.h"

#include <errno.h>
#include <poll.h>
#include <pty.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <termios.h>
#include <unistd.h>

/* ---------------------------------------------------------------- 常量 --- */

/** 客户端没给尺寸时的回落值。 */
#define DEFAULT_ROWS 24
#define DEFAULT_COLS 80

/** 单次从 pty 读的块大小。 */
#define PTY_CHUNK 4096

/** 收尾时等子进程自行退出的轮询次数与间隔（合计 300 ms）。 */
#define REAP_TRIES 30
#define REAP_INTERVAL_US 10000

/* ---------------------------------------------------------------- 工具 --- */

/** 回一行错误并返回。 */
static int reject(int fd, const char *reason) {
    char line[96];
    int size = snprintf(
        line,
        sizeof(line),
        "{\"ok\":0,\"reason\":\"%s\"}\n",
        reason
    );
    (void) proto_send_all(fd, line, (size_t) size);
    return -1;
}

/** 把一段字节写进 pty master；返回 0 成功，-1 失败。 */
static int write_all(int fd, const unsigned char *data, uint32_t size) {
    uint32_t done = 0;
    while (done < size) {
        ssize_t sent = write(fd, data + done, size - done);
        if (sent < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        if (sent == 0) return -1;
        done += (uint32_t) sent;
    }
    return 0;
}

/** 处理一帧客户端数据；返回 1 表示应结束会话。 */
static int handle_frame(int fd, int master, unsigned char *buf, uint32_t cap) {
    uint8_t type = 0;
    uint32_t size = 0;

    int rc = proto_recv_frame(fd, &type, buf, cap, &size);
    if (rc == -2) {
        /* 帧体超过缓冲：流里已残留数据，继续读必然错位，只能断连。 */
        return 1;
    }
    if (rc != 0) return 1;

    if (type == FRAME_STDIN) {
        if (size > 0 && write_all(master, buf, size) != 0) return 1;
        return 0;
    }

    if (type == FRAME_RESIZE) {
        if (size >= 4) {
            unsigned short rows = (unsigned short) (buf[0] | (buf[1] << 8));
            unsigned short cols = (unsigned short) (buf[2] | (buf[3] << 8));
            if (rows > 0 && cols > 0) {
                struct winsize win;
                memset(&win, 0, sizeof(win));
                win.ws_row = rows;
                win.ws_col = cols;
                (void) ioctl(master, TIOCSWINSZ, &win);
            }
        }
        return 0;
    }

    if (type == FRAME_CLOSE) return 1;

    /* 未知帧类型：忽略，保持会话继续（比直接断连更宽容）。 */
    return 0;
}

/** 发退出帧；返回 0 成功。 */
static int send_exit(int fd, int exit_code) {
    uint8_t body[5];
    proto_put_u32le(body, (uint32_t) exit_code);
    body[4] = 0; /* timedOut：pty 会话本身不设总超时 */
    return proto_send_frame(fd, FRAME_EXIT, body, sizeof(body));
}

/* ---------------------------------------------------------------- 主体 --- */

int pty_serve(int fd, const char *cmd, uint32_t cmd_len, int rows, int cols) {
    if (cmd == NULL || cmd_len == 0 || cmd_len > CMD_MAX) {
        return reject(fd, "badCommand");
    }

    if (rows <= 0) rows = DEFAULT_ROWS;
    if (cols <= 0) cols = DEFAULT_COLS;

    /* 会话可以长期空闲：清掉连接上 2 秒的读超时，否则用户不发键就会被误判成断开。
     * 写超时保留，用于在客户端长时间不取输出时止损。 */
    struct timeval no_wait;
    memset(&no_wait, 0, sizeof(no_wait));
    (void) setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &no_wait, sizeof(no_wait));

    struct winsize win;
    memset(&win, 0, sizeof(win));
    win.ws_row = (unsigned short) rows;
    win.ws_col = (unsigned short) cols;

    int master = -1;
    pid_t pid = forkpty(&master, NULL, NULL, &win);
    if (pid < 0) return reject(fd, "ptyFailed");

    if (pid == 0) {
        /* 子进程：forkpty 已把 slave 接到 0/1/2 并建好会话与控制终端。 */
        chdir("/");
        close(fd);
        /* 复位 SIGPIPE：服务端 SIG_IGN 会随 exec 继承，导致 `yes | head` 挂住。 */
        (void) signal(SIGPIPE, SIG_DFL);
        execl("/system/bin/sh", "sh", "-c", cmd, (char *) NULL);
        _exit(127);
    }

    char hello[64];
    int hello_len = snprintf(
        hello,
        sizeof(hello),
        "{\"ok\":1,\"session\":\"s%d\"}\n",
        (int) pid
    );
    if (proto_send_all(fd, hello, (size_t) hello_len) != 0) {
        close(master);
        (void) kill(-pid, SIGKILL);
        (void) waitpid(pid, NULL, 0);
        return -1;
    }

    unsigned char *buf = malloc(CMD_MAX);
    if (buf == NULL) {
        close(master);
        (void) kill(-pid, SIGKILL);
        (void) waitpid(pid, NULL, 0);
        return -1;
    }

    int peer_gone = 0;
    int stopped = 0;

    while (!stopped) {
        struct pollfd fds[2];
        fds[0].fd = master;
        fds[0].events = POLLIN;
        fds[1].fd = fd;
        fds[1].events = POLLIN;

        int ready = poll(fds, 2, -1);
        if (ready < 0) {
            if (errno == EINTR) continue;
            peer_gone = 1;
            break;
        }

        /* 先处理 pty 侧：命令自己退出时优先把剩余输出送出去。 */
        if (fds[0].revents & (POLLIN | POLLHUP | POLLERR)) {
            ssize_t got = read(master, buf, PTY_CHUNK);
            if (got > 0) {
                if (proto_send_frame(fd, FRAME_OUTPUT, buf, (uint32_t) got) != 0) {
                    peer_gone = 1;
                    break;
                }
            } else if (got == 0) {
                stopped = 1;
                break;
            } else if (errno != EINTR) {
                stopped = 1;
                break;
            }
        }

        if (fds[1].revents & (POLLIN | POLLHUP | POLLERR)) {
            int done = handle_frame(fd, master, buf, CMD_MAX);
            if (done) {
                /* 分不清是「客户端发 CLOSE」还是「客户端断了」，统一按结束处理；
                 * 退出帧发不发由下面的写结果决定，不额外试探。 */
                stopped = 1;
                if (fds[1].revents & POLLHUP) peer_gone = 1;
                break;
            }
        }
    }

    /* 先关 master：内核向 slave 发 SIGHUP，交互式 shell 会自行退出。 */
    close(master);

    int status = 0;
    int reaped = 0;
    for (int i = 0; i < REAP_TRIES; i++) {
        if (waitpid(pid, &status, WNOHANG) == pid) {
            reaped = 1;
            break;
        }
        usleep(REAP_INTERVAL_US);
    }
    if (!reaped) {
        (void) kill(-pid, SIGKILL);
        (void) kill(pid, SIGKILL);
        if (waitpid(pid, &status, 0) == pid) reaped = 1;
    }

    int exit_code = -1;
    if (reaped) {
        if (WIFEXITED(status)) exit_code = WEXITSTATUS(status);
        else if (WIFSIGNALED(status)) exit_code = 128 + WTERMSIG(status);
    }

    if (!peer_gone) (void) send_exit(fd, exit_code);

    fprintf(
        stderr,
        "[aisupass-stellar] pty pid=%d exit=%d cmdLen=%u\n",
        (int) pid,
        exit_code,
        (unsigned) cmd_len
    );
    fflush(stderr);

    free(buf);
    return 0;
}

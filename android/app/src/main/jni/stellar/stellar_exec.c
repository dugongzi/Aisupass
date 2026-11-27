/*
 * 一次性命令执行。
 *
 * 语义对齐 Pigeon 契约 ShellExecResult 的五个字段：退出码、两路输出、耗时、
 * 是否超时。上层（Dart 的 stellarShellExec）不需要知道这里是管道还是 pty。
 *
 * 关键点：
 *   1. 子进程 setsid 成为进程组首进程，超时用 kill(-pid) 整组收掉，
 *      否则 `sh -c 'sleep 300 &'` 里的后台进程会逃逸；
 *   2. 子进程必须关掉连接 fd，否则客户端会一直等到子进程退出才看到应答结束；
 *   3. 输出超过 OUT_CAP 的部分继续读但丢弃——不读会让子进程写阻塞，命令永远退不了。
 *
 * 不记录命令全文（可能含路径、账号），只记长度与结果统计。
 */

#include "stellar_exec.h"

#include "stellar_proto.h"

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

/* ---------------------------------------------------------------- 常量 --- */

/** 调用方没给超时时的默认值；与 Dart 侧 _defaultTimeoutMs 同值。 */
#define DEFAULT_TIMEOUT_MS 30000

/** 超时上限；再长就是用户对着屏幕干等。 */
#define MAX_TIMEOUT_MS 600000

/** 单次 read 的块大小。 */
#define READ_CHUNK 4096

/* ---------------------------------------------------------------- 工具 --- */

/** 单调时钟毫秒数；只用差值，不受系统时间跳变影响。 */
static long now_ms(void) {
    struct timespec ts;
    (void) clock_gettime(CLOCK_MONOTONIC, &ts);
    return (long) ts.tv_sec * 1000L + (long) (ts.tv_nsec / 1000000L);
}

/** 一路输出的累积缓冲；超出容量后只记截断标志。 */
typedef struct {
    unsigned char *data;
    size_t len;
    size_t cap;
    int truncated;
} sink_t;

/** 追加一段输出；容量不足时丢弃多余部分并置截断。 */
static void sink_append(sink_t *sink, const unsigned char *src, size_t size) {
    if (sink->len >= sink->cap) {
        sink->truncated = 1;
        return;
    }

    size_t room = sink->cap - sink->len;
    size_t take = size < room ? size : room;
    memcpy(sink->data + sink->len, src, take);
    sink->len += take;
    if (take < size) sink->truncated = 1;
}

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

/* ---------------------------------------------------------------- 主体 --- */

int exec_once(int fd, const char *cmd, uint32_t cmd_len, int timeout_ms) {
    if (cmd == NULL || cmd_len == 0 || cmd_len > CMD_MAX) {
        return reject(fd, "badCommand");
    }

    if (timeout_ms <= 0) timeout_ms = DEFAULT_TIMEOUT_MS;
    if (timeout_ms > MAX_TIMEOUT_MS) timeout_ms = MAX_TIMEOUT_MS;

    int out_pipe[2];
    int err_pipe[2];
    if (pipe(out_pipe) != 0) return reject(fd, "pipeFailed");
    if (pipe(err_pipe) != 0) {
        close(out_pipe[0]);
        close(out_pipe[1]);
        return reject(fd, "pipeFailed");
    }

    int dev_null = open("/dev/null", O_RDONLY);

    long started = now_ms();
    pid_t pid = fork();
    if (pid < 0) {
        close(out_pipe[0]);
        close(out_pipe[1]);
        close(err_pipe[0]);
        close(err_pipe[1]);
        if (dev_null >= 0) close(dev_null);
        return reject(fd, "forkFailed");
    }

    if (pid == 0) {
        /* 子进程：新会话 + 三条标准流换掉，然后把继承来的 fd 全关掉。 */
        (void) setsid();

        if (dev_null >= 0) (void) dup2(dev_null, STDIN_FILENO);
        (void) dup2(out_pipe[1], STDOUT_FILENO);
        (void) dup2(err_pipe[1], STDERR_FILENO);

        close(out_pipe[0]);
        close(out_pipe[1]);
        close(err_pipe[0]);
        close(err_pipe[1]);
        if (dev_null > STDERR_FILENO) close(dev_null);
        /* 不关连接 fd，客户端会一直等到本进程退出才看到应答结束。 */
        close(fd);

        execl("/system/bin/sh", "sh", "-c", cmd, (char *) NULL);
        _exit(127);
    }

    close(out_pipe[1]);
    close(err_pipe[1]);
    if (dev_null >= 0) close(dev_null);

    unsigned char *out_buf = malloc(OUT_CAP);
    unsigned char *err_buf = malloc(OUT_CAP);
    if (out_buf == NULL || err_buf == NULL) {
        free(out_buf);
        free(err_buf);
        close(out_pipe[0]);
        close(err_pipe[0]);
        (void) kill(-pid, SIGKILL);
        (void) waitpid(pid, NULL, 0);
        return reject(fd, "bufferFailed");
    }

    sink_t out = { out_buf, 0, OUT_CAP, 0 };
    sink_t err = { err_buf, 0, OUT_CAP, 0 };

    struct pollfd fds[2];
    fds[0].fd = out_pipe[0];
    fds[0].events = POLLIN;
    fds[1].fd = err_pipe[0];
    fds[1].events = POLLIN;

    int open_count = 2;
    int timed_out = 0;
    unsigned char chunk[READ_CHUNK];

    while (open_count > 0) {
        long remain = (long) timeout_ms - (now_ms() - started);
        if (remain <= 0) {
            timed_out = 1;
            break;
        }

        int ready = poll(fds, 2, (int) remain);
        if (ready < 0) {
            if (errno == EINTR) continue;
            break;
        }
        if (ready == 0) {
            timed_out = 1;
            break;
        }

        for (int i = 0; i < 2; i++) {
            if (fds[i].fd < 0) continue;
            if ((fds[i].revents & (POLLIN | POLLHUP | POLLERR)) == 0) continue;

            ssize_t got = read(fds[i].fd, chunk, sizeof(chunk));
            if (got > 0) {
                sink_append(i == 0 ? &out : &err, chunk, (size_t) got);
                continue;
            }
            if (got < 0 && errno == EINTR) continue;

            /* 0 = EOF；负值 = 读错误。两者都表示这一路没有更多数据。 */
            close(fds[i].fd);
            fds[i].fd = -1;
            open_count--;
        }
    }

    if (fds[0].fd >= 0) close(fds[0].fd);
    if (fds[1].fd >= 0) close(fds[1].fd);

    /* 整组收掉：`sh -c` 里可能还有后台子进程。 */
    (void) kill(-pid, SIGKILL);
    (void) kill(pid, SIGKILL);

    int status = 0;
    int exit_code = -1;
    if (waitpid(pid, &status, 0) == pid) {
        if (WIFEXITED(status)) exit_code = WEXITSTATUS(status);
        else if (WIFSIGNALED(status)) exit_code = 128 + WTERMSIG(status);
    }

    long duration = now_ms() - started;
    int truncated = (out.truncated || err.truncated) ? 1 : 0;

    char head[256];
    int head_len = snprintf(
        head,
        sizeof(head),
        "{\"ok\":1,\"exitCode\":%d,\"timedOut\":%d,\"durationMs\":%ld,"
        "\"outLen\":%zu,\"errLen\":%zu,\"truncated\":%d}\n",
        exit_code,
        timed_out,
        duration,
        out.len,
        err.len,
        truncated
    );

    int failure = 0;
    if (proto_send_all(fd, head, (size_t) head_len) != 0) {
        failure = 1;
    } else if (out.len > 0 && proto_send_all(fd, out.data, out.len) != 0) {
        failure = 1;
    } else if (err.len > 0 && proto_send_all(fd, err.data, err.len) != 0) {
        failure = 1;
    }

    fprintf(
        stderr,
        "[aisupass-stellar] exec pid=%d exit=%d out=%zu err=%zu "
        "timeout=%d trunc=%d ms=%ld cmdLen=%u\n",
        (int) pid,
        exit_code,
        out.len,
        err.len,
        timed_out,
        truncated,
        duration,
        (unsigned) cmd_len
    );
    fflush(stderr);

    free(out_buf);
    free(err_buf);
    return failure ? -1 : 0;
}

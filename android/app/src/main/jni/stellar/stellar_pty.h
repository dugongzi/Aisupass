/*
 * 伪终端会话的入口声明。
 *
 * 实现见 03-伪终端OPEN与会话.md。
 */

#ifndef STELLAR_PTY_H
#define STELLAR_PTY_H

#include <stdint.h>

/**
 * 在连接上跑一条 pty 会话，直到会话结束或连接断开。
 *
 * @param fd      已连接的 socket。
 * @param cmd     命令文本（通常是一条 `sh -c` 脚本）。
 * @param cmd_len 命令字节数（不含结尾 `\0`）。
 * @param rows    字符行数；<= 0 时回落默认值。
 * @param cols    字符列数；<= 0 时回落默认值。
 * @return 仅用于日志区分。
 */
int pty_serve(int fd, const char *cmd, uint32_t cmd_len, int rows, int cols);

#endif /* STELLAR_PTY_H */

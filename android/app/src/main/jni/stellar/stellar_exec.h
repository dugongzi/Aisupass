/*
 * 一次性命令执行的入口声明。
 *
 * 与协议层分开：stellar_proto 只管字节搬运，本模块负责 fork / 管道 / 超时。
 * 实现见 02-一次性命令EXEC.md。
 */

#ifndef STELLAR_EXEC_H
#define STELLAR_EXEC_H

#include <stdint.h>

/**
 * 执行一条命令并把结果写回连接。
 *
 * 调用前 [cmd] 已由上层读满 [cmd_len] 字节并保证 `\0` 结尾。
 *
 * @param fd        已连接的 socket；应答（一行头 + 双路体）直接写这里。
 * @param cmd       命令文本。
 * @param cmd_len   命令字节数（不含结尾 `\0`）。
 * @param timeout_ms 超时毫秒；<= 0 时用调用方默认值。
 * @return 仅用于日志区分，不影响已写出的应答。
 */
int exec_once(int fd, const char *cmd, uint32_t cmd_len, int timeout_ms);

#endif /* STELLAR_EXEC_H */

/*
 * 一次性命令执行的入口声明。
 *
 * 与协议层分开：stellar_proto 只管字节搬运，本模块负责 fork / 管道 / 超时。
 */

#ifndef STELLAR_EXEC_H
#define STELLAR_EXEC_H

#include <stdint.h>

/**
 * 执行一条命令并把结果写回连接。
 *
 * 调用前 [cmd] 已由上层读满 [cmd_len] 字节并保证 `\0` 结尾；
 * [stdin_data] 为可选的命令标准输入，长度 [stdin_len]，为 0 时子进程接到
 * `/dev/null`（立即 EOF，读输入的命令不会挂到超时）。
 *
 * @param fd         已连接的 socket；应答（一行头 + 双路体）直接写这里。
 * @param cmd        命令文本。
 * @param cmd_len    命令字节数（不含结尾 `\0`）。
 * @param stdin_data 标准输入字节；可为 NULL。
 * @param stdin_len  标准输入字节数；0 表示没有输入。
 * @param timeout_ms 超时毫秒；**<= 0 表示不限时**，由调用方自己决定要等多久。
 *                   通道不设默认值：命令该跑多久是调用方的策略，不是协议的一部分。
 * @return 仅用于日志区分，不影响已写出的应答。
 */
int exec_once(
    int fd,
    const char *cmd,
    uint32_t cmd_len,
    const uint8_t *stdin_data,
    uint32_t stdin_len,
    int timeout_ms
);

#endif /* STELLAR_EXEC_H */

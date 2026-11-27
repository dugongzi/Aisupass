/*
 * Stellar 服务的线上协议：常量与编解码声明。
 *
 * 协议分两段：
 *   1. 请求行：ASCII 单行（`\n` 结尾），最多 5 段，形如
 *      `EXEC <token> <timeoutMs> <len> [<stdinLen>]`；
 *   2. 二进制体：请求行之后紧跟 `len` 字节命令（`EXEC` 再跟 `stdinLen` 字节
 *      标准输入）；应答同样「一行头 + 字节体」。
 *
 * 行分隔只用于头，不用于命令与输出——`dumpsys` / `cat` 的输出含换行与任意字节，
 * 按行切会把命令输出和协议混在一起。
 *
 * 本文件只放常量与函数声明，不含逻辑；实现见 stellar_proto.c。
 */

#ifndef STELLAR_PROTO_H
#define STELLAR_PROTO_H

#include <stddef.h>
#include <stdint.h>
#include <sys/types.h>

/* ---------------------------------------------------------------- 常量 --- */

/** 协议版本；响应字段变化时递增，Dart 侧据此判兼容。 */
#define PROTO_VERSION 2

/** 探活端口；必须与 Dart 侧 stellarProbePort 一致。 */
#define PROTO_PORT 39187

/** token 最长字符数：32 字节随机数转十六进制即 64 个字符。 */
#define TOKEN_MAX 64

/** 单条命令的最大字节数；超过按 badCommand 拒绝，避免一次读爆内存。 */
#define CMD_MAX 65536

/** 单条命令附带标准输入的最大字节数。 */
///
/// 导入载荷要把几 MB 的 .so 通过 `cat > file` 推过去，比 CMD_MAX 大得多；
/// 上限存在的意义只是防止一条请求把服务进程的内存吃光。
#define IN_CAP (16u << 20)

/** 单路输出上限；超出部分丢弃并置截断标志。 */
#define OUT_CAP (1u << 20)

/** 帧类型：客户端 → 服务端。 */
#define FRAME_STDIN 1
#define FRAME_RESIZE 2
#define FRAME_CLOSE 3

/** 帧类型：服务端 → 客户端。 */
#define FRAME_OUTPUT 1
#define FRAME_EXIT 2

/** 帧头长度：type(u8) + len(u32 小端)。 */
#define FRAME_HEAD 5

/* ---------------------------------------------------------------- 声明 --- */

/**
 * 读一行请求头。
 *
 * 读到 `\n` 或缓冲将满为止，`\r` 直接跳过，结果以 `\0` 结尾。
 *
 * @return 行长度（不含换行符）；`-1` 表示 EOF 或读失败。
 */
ssize_t proto_read_line(int fd, char *buf, size_t cap);

/** 循环写满 [len] 字节；返回 0 成功，-1 失败（对端已关或写超时）。 */
int proto_send_all(int fd, const void *data, size_t len);

/** 循环读满 [len] 字节；返回 0 成功，-1 失败（对端已关或读超时）。 */
int proto_recv_all(int fd, void *data, size_t len);

/** 发一帧；返回 0 成功，-1 失败。 */
int proto_send_frame(int fd, uint8_t type, const void *body, uint32_t len);

/**
 * 收一帧。
 *
 * @param body 输出缓冲；@param cap 其容量。
 * @param len 输出实际帧体长度（即使因超长被拒也写入）。
 * @return 0 成功；-1 读失败或 EOF；-2 帧体超过 cap（调用方应断连，
 *         此时 body 未被读取，流里还留着数据，重试必然错位）。
 */
int proto_recv_frame(
    int fd,
    uint8_t *type,
    void *body,
    size_t cap,
    uint32_t *len
);

/** 常量时间比较 token；相等返回 1，否则 0。空串一律不相等。 */
int proto_token_match(const char *given, const char *expected);

/** 写一个小端 u32。 */
void proto_put_u32le(uint8_t *dst, uint32_t value);

/** 读一个小端 u32。 */
uint32_t proto_get_u32le(const uint8_t *src);

#endif /* STELLAR_PROTO_H */

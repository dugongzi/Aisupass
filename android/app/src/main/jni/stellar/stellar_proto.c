/*
 * Stellar 服务协议的编解码实现。
 *
 * 只做「字节 ↔ 结构」：不判断身份、不看业务状态、不认识任何具体请求。
 * 上层（stellar_serve.c）负责请求分派与鉴权，本文件只管搬运。
 */

#include "stellar_proto.h"

#include <errno.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

/* 老平台可能没有 MSG_NOSIGNAL；serve 启动后已把 SIGPIPE 置为忽略，
 * 这里只是为了在单测/手工调用时也不至于被写断连打死。 */
#ifndef MSG_NOSIGNAL
#define MSG_NOSIGNAL 0
#endif

ssize_t proto_read_line(int fd, char *buf, size_t cap) {
    if (buf == NULL || cap < 2) return -1;

    size_t used = 0;
    while (used + 1 < cap) {
        char ch = 0;
        ssize_t got = read(fd, &ch, 1);
        if (got == 0) {
            /* 对端关闭：半行按无效请求处理，不返回残行。 */
            return -1;
        }
        if (got < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        if (ch == '\n') break;
        if (ch == '\r') continue;
        buf[used++] = ch;
    }

    buf[used] = '\0';
    return (ssize_t) used;
}

int proto_send_all(int fd, const void *data, size_t len) {
    const uint8_t *cursor = (const uint8_t *) data;
    size_t left = len;

    while (left > 0) {
        ssize_t sent = send(fd, cursor, left, MSG_NOSIGNAL);
        if (sent < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        if (sent == 0) return -1;
        cursor += (size_t) sent;
        left -= (size_t) sent;
    }
    return 0;
}

int proto_recv_all(int fd, void *data, size_t len) {
    uint8_t *cursor = (uint8_t *) data;
    size_t left = len;

    while (left > 0) {
        ssize_t got = recv(fd, cursor, left, 0);
        if (got == 0) return -1;
        if (got < 0) {
            if (errno == EINTR) continue;
            return -1;
        }
        cursor += (size_t) got;
        left -= (size_t) got;
    }
    return 0;
}

void proto_put_u32le(uint8_t *dst, uint32_t value) {
    dst[0] = (uint8_t) (value & 0xFFu);
    dst[1] = (uint8_t) ((value >> 8) & 0xFFu);
    dst[2] = (uint8_t) ((value >> 16) & 0xFFu);
    dst[3] = (uint8_t) ((value >> 24) & 0xFFu);
}

uint32_t proto_get_u32le(const uint8_t *src) {
    return (uint32_t) src[0]
        | ((uint32_t) src[1] << 8)
        | ((uint32_t) src[2] << 16)
        | ((uint32_t) src[3] << 24);
}

int proto_send_frame(int fd, uint8_t type, const void *body, uint32_t len) {
    uint8_t head[FRAME_HEAD];
    head[0] = type;
    proto_put_u32le(head + 1, len);

    if (proto_send_all(fd, head, sizeof(head)) != 0) return -1;
    if (len == 0) return 0;
    return proto_send_all(fd, body, len);
}

int proto_recv_frame(
    int fd,
    uint8_t *type,
    void *body,
    size_t cap,
    uint32_t *len
) {
    uint8_t head[FRAME_HEAD];
    if (proto_recv_all(fd, head, sizeof(head)) != 0) return -1;

    uint32_t size = proto_get_u32le(head + 1);
    *type = head[0];
    *len = size;

    /* 超长帧不读：留在流里下一次读必然错位，交给调用方断连。 */
    if ((size_t) size > cap) return -2;
    if (size == 0) return 0;

    return proto_recv_all(fd, body, size);
}

int proto_token_match(const char *given, const char *expected) {
    if (given == NULL || expected == NULL) return 0;

    size_t given_len = strlen(given);
    size_t expected_len = strlen(expected);
    if (given_len == 0 || given_len != expected_len) return 0;

    /* 逐字节异或累加后统一判 0：不早退，避免泄漏前缀匹配长度。 */
    unsigned char diff = 0;
    for (size_t i = 0; i < expected_len; i++) {
        diff |= (unsigned char) (given[i] ^ expected[i]);
    }
    return diff == 0 ? 1 : 0;
}

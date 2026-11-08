package org.supass.ai_su_pass.core.shell

import java.util.Locale

/**
 * ADB shell protocol v2 的线格式常量。
 *
 * 抽出来共用的原因：[org.supass.ai_su_pass.core.adb.AdbShellChannel] 做一次性
 * 执行、[org.supass.ai_su_pass.core.adb.ExecJob] 做流式执行，两者读的是同一条
 * 协议。各写一份的话，将来改一处忘另一处，表现是「某条路径莫名解不出退出码」，
 * 而两边代码单独看都对。
 *
 * 参考 AOSP `shell_protocol.h`。
 */
internal object ShellProtocol {

    /**
     * `raw` 禁 pty：只有 raw 模式才分离 stdout/stderr 且 stdin 直通进程。
     *
     * 一次性 [org.supass.ai_su_pass.core.adb.AdbShellChannel.exec] 必须留在 raw：
     * 提权流程按 stdout 文本做判定（找标记、解析路径），而 pty 会把 stderr 并进
     * stdout、把换行改成 `\r\n`、还会混进 sh 的提示符，判定会全部失准。
     */
    const val SERVICE_PREFIX = "shell,v2,raw:"

    /**
     * `pty` 让子进程拿到一条真正的控制终端。
     *
     * 只给常驻交互 shell（[org.supass.ai_su_pass.core.adb.ExecJob]）用：有了 pty，
     * `isatty()` 为真、`^C` 是真 SIGINT、termios 自己负责回显与行编辑、`ls` 自动上色、
     * `sh` 会打提示符。代价是 stdout/stderr 合并成一路，且**必须**同步窗口尺寸
     * （见 [buildWindowSizeFrame]），否则远端一直按默认 80x24 排版。
     *
     * 必须显式带 `TERM=`：`services.cpp` 里 `terminal_type` 默认是 `"dumb"`，
     * 只有服务串里出现 `TERM=xxx` 才会被覆盖。`dumb` 会让远端（以及走 terminfo
     * 的程序）关掉颜色、光标定位和清屏，`top`/`vi`/进度条全部变成滚屏输出。
     */
    const val PTY_SERVICE_PREFIX = "shell,v2,pty,TERM=xterm-256color:"

    // 帧 id。
    const val ID_STDIN = 0
    const val ID_STDOUT = 1
    const val ID_STDERR = 2
    const val ID_EXIT = 3
    const val ID_CLOSE_STDIN = 4

    /** 窗口尺寸变更；pty 模式下只有本端主动发，不会从设备侧收到。 */
    const val ID_WINDOW_SIZE_CHANGE = 5

    /** 1B id + 4B 小端长度。 */
    const val HEADER_SIZE = 5

    /** 帧长度上限：ADB 单包最大 1MB（api >= 28），超过说明流已错位。 */
    const val MAX_FRAME_BYTES = 1024 * 1024

    /** 单帧 stdin 大小，留足余量避免一次挤爆写窗口。 */
    const val MAX_STDIN_CHUNK = 32 * 1024

    /** 读缓冲大小。 */
    const val BUFFER_SIZE = 4096

    /** 命令没跑起来（通道未连接、流未建立、被超时前关闭）。 */
    const val EXIT_NOT_STARTED = -1

    /**
     * 拼一帧：`[1B id][4B 小端长度][payload]`。
     *
     * @param length 要拷贝的字节数。
     * @param src 源数组；为 null 时表示空负载（如 `kIdCloseStdin`）。
     */
    fun buildFrame(id: Int, src: ByteArray?, offset: Int, length: Int): ByteArray {
        val frame = ByteArray(HEADER_SIZE + length)
        frame[0] = id.toByte()
        frame[1] = (length and 0xFF).toByte()
        frame[2] = ((length ushr 8) and 0xFF).toByte()
        frame[3] = ((length ushr 16) and 0xFF).toByte()
        frame[4] = ((length ushr 24) and 0xFF).toByte()
        if (src != null && length > 0) {
            System.arraycopy(src, offset, frame, HEADER_SIZE, length)
        }
        return frame
    }

    /**
     * 拼一帧窗口尺寸变更（`kIdWindowSizeChange`）。
     *
     * 负载**不是**四个 uint32，而是 AOSP 为了方便调试写成的人类可读 ASCII：
     * `snprintf("%dx%d,%dx%d", ws_row, ws_col, ws_xpixel, ws_ypixel)`，长度取
     * `l + 1`，即字符串末尾带一个 `\0`。发成二进制结构的话，设备侧会把乱码
     * 当 winsize 解析，终端宽度直接错乱。
     *
     * 像素尺寸我们不知道（xterm3 的 `onResize` 给的是单格尺寸，不是窗口像素），
     * 传 0 让远端按字符数排版——这正是没有缩放需求时的常规做法。
     *
     * @param rows 行数（`ws_row`）。
     * @param cols 列数（`ws_col`）。
     */
    fun buildWindowSizeFrame(rows: Int, cols: Int, xPixel: Int = 0, yPixel: Int = 0): ByteArray {
        // 用 Locale.US：某些区域设置会把数字格式化成带分隔符的形态，
        // 而设备侧只认纯 ASCII 十进制。
        val text = String.format(Locale.US, "%dx%d,%dx%d", rows, cols, xPixel, yPixel)
        val payload = text.toByteArray(Charsets.UTF_8)
        val frame = ByteArray(HEADER_SIZE + payload.size + 1)
        val length = payload.size + 1 // 含结尾 NUL。
        frame[0] = ID_WINDOW_SIZE_CHANGE.toByte()
        frame[1] = (length and 0xFF).toByte()
        frame[2] = ((length ushr 8) and 0xFF).toByte()
        frame[3] = ((length ushr 16) and 0xFF).toByte()
        frame[4] = ((length ushr 24) and 0xFF).toByte()
        System.arraycopy(payload, 0, frame, HEADER_SIZE, payload.size)
        // 末尾一个字节默认就是 0x00，不用显式写。
        return frame
    }
}

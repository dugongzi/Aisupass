package org.supass.ai_su_pass.core.adb

import android.os.SystemClock
import android.util.Log
import io.github.muntashirakon.adb.AdbStream
import org.supass.ai_su_pass.core.shell.ShellProtocol
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

/**
 * 一次命令的流式执行会话。
 *
 * 与 [AdbShellChannel.exec] 的区别只有一点，但很关键：后者把输出全部攒在内存里、
 * 等进程退出才一次性返回；这里每读到一段就交出去，长命令因此能边跑边看，
 * 也能在跑的过程中往 stdin 喂数据（pty 下 stdin 就是终端输入队列，远端自带
 * 回显与行编辑，`^C` 会被翻译成 SIGINT）。
 *
 * 三个必须守住的约束：
 * 1. **stdout 与 stderr 必须同时消费**。adbd 侧两路共用一条 socket，只读一路会让
 *    另一路塞满缓冲、整条流一起卡死。pty 模式下 adbd 只往 stdout 发（stderr 已合并），
 *    但这里两条分支都保留——同一份读取逻辑要同时兼容 `raw` 会话。
 * 2. **交付给上层的字符串必须是完整 UTF-8**。帧边界按字节切，一个汉字/emoji 可能
 *    被切成两帧；不按字符边界交付，中文路径输出就会变成一串 `�`。
 * 3. **未交付缓冲要有上限**。上层轮询慢了（或干脆没人轮询），不能让 `logcat`
 *    式的输出把堆撑爆——超限就丢最老的字节，并把丢弃量报上去，让上层知道输出不全。
 *
 * 生命周期：构造后调 [start]，之后 [poll] 反复取增量，[writeStdin] 喂输入，
 * 结束（自然退出、超时、取消）后 [finished] 为 true，会话由持有方移除。
 */
internal class ExecJob(
    val sessionId: String,
    val command: String,
    private val stream: AdbStream,
    private val timeoutMs: Long,
) {

    private val startedAt = SystemClock.elapsedRealtime()

    /** 未交付的 stdout / stderr 字节，由 [bufferLock] 保护。 */
    private val outBuffer = ByteArrayOutputStream()
    private val errBuffer = ByteArrayOutputStream()
    private val bufferLock = Any()

    /**
     * stdin 写入专用单线程。
     *
     * [AdbStream.write] 会等对端腾出写窗口，可能长时间阻塞；若直接在 Pigeon 的
     * 调用线程上写，一次「对端不读 stdin」就能把整个通道卡住。
     */
    private val stdinExecutor = Executors.newSingleThreadExecutor { runnable ->
        Thread(runnable, "adb-shell-stdin-$sessionId").apply { isDaemon = true }
    }

    /** 惰性打开的写通道；只在 [stdinExecutor] 线程上访问。 */
    private var stdinOutput: OutputStream? = null

    /** 是否已经发过 `kIdCloseStdin`。发过就不能再写，否则对端会收到乱序帧。 */
    private val stdinClosed = AtomicBoolean(false)

    @Volatile
    var finished: Boolean = false
        private set

    @Volatile
    var exitCode: Int = ShellProtocol.EXIT_NOT_STARTED
        private set

    @Volatile
    var timedOut: Boolean = false
        private set

    /** 读流出错时的异常类名，写进 stderr 让上层有据可查。 */
    @Volatile
    var failure: String? = null
        private set

    /** 因缓冲溢出被丢弃的累计字节数；`0` 表示输出完整。 */
    @Volatile
    var droppedBytes: Long = 0L
        private set

    /** 读到退出帧或流关闭时置位，用来让 watchdog 立刻收手。 */
    private val streamClosed = AtomicBoolean(false)

    private val reader = Thread({ readLoop() }, "adb-shell-read-$sessionId").apply {
        isDaemon = true
    }

    /**
     * 超时看守。
     *
     * [timeoutMs] <= 0 表示**不设上限**：常驻交互 shell 本来就该一直活着，
     * 到点掐断会把用户 `cd` 过去的工作目录、`export` 的变量一起销毁，
     * 表现是「用着用着目录突然回到 `/`」。这种情况干脆不起这条线程。
     */
    private val watchdog: Thread? =
        if (timeoutMs > 0) {
            Thread({ watchdogLoop() }, "adb-shell-timeout-$sessionId").apply { isDaemon = true }
        } else {
            null
        }

    /** 起读线程与超时看守。读完自然结束，上层靠 [finished] 判定收尾。 */
    fun start() {
        Log.i(
            TAG,
            "exec session $sessionId start " +
                "timeout=${if (timeoutMs > 0) "${timeoutMs}ms" else "unbounded"} " +
                "cmd='${command.take(LOG_SNIPPET)}'",
        )
        reader.start()
        watchdog?.start()
    }

    /**
     * 取走自上次调用以来积累的输出与当前状态。
     *
     * 必须由**单一调用方**串行调用：这里会把已交付的字节从缓冲里摘掉，
     * 并发调用会让同一段输出被两个调用方各拿一半。
     */
    fun poll(): ExecChunkResult = ExecChunkResult(
        sessionId = sessionId,
        stdout = drain(outBuffer),
        stderr = drain(errBuffer),
        finished = finished,
        exitCode = exitCode,
        timedOut = timedOut,
        durationMs = SystemClock.elapsedRealtime() - startedAt,
        droppedBytes = droppedBytes,
        failure = failure.orEmpty(),
    )

    /**
     * 把用户输入喂给正在跑的命令。
     *
     * @return `false` 表示会话已经结束或 stdin 已关闭，调用方应按「命令不再接收输入」处理。
     */
    fun writeStdin(data: ByteArray): Boolean {
        if (finished || stdinClosed.get() || data.isEmpty()) return false
        return try {
            stdinExecutor.execute {
                try {
                    val output = stdinOutput ?: stream.openOutputStream().also { stdinOutput = it }
                    var offset = 0
                    while (offset < data.size) {
                        val len = minOf(data.size - offset, ShellProtocol.MAX_STDIN_CHUNK)
                        val frame = ShellProtocol.buildFrame(ShellProtocol.ID_STDIN, data, offset, len)
                        output.write(frame, 0, frame.size)
                        offset += len
                    }
                    output.flush()
                } catch (t: Throwable) {
                    // 进程已退出 / 流被关 / 写窗口不再打开，都是正常收尾。
                    Log.d(TAG, "exec session $sessionId stdin write stopped: ${t.javaClass.simpleName}")
                }
            }
            true
        } catch (t: Throwable) {
            // 会话刚被取消，[stdinExecutor] 已经 shutdown：这条输入注定送不到，
            // 只能回 false，让上层按「命令不再接收输入」处理。异常不能往外抛，
            // 否则 Pigeon 的回调永远不会回，Dart 侧会一直等下去。
            Log.d(TAG, "exec session $sessionId stdin closed: ${t.javaClass.simpleName}")
            false
        }
    }

    /**
     * 同步终端窗口尺寸给 pty。
     *
     * pty 的 `winsize` 初始是 0x0（或 80x24），远端据此决定折行与全屏程序的布局。
     * 不同步的话，`top` 只会画左上角一小块，长命令输出也会在固定列宽处被硬折。
     *
     * 走 [stdinExecutor] 而不是直接写：与 [writeStdin] 共用同一个写通道，
     * 避免两个线程同时拿 [stdinOutput] 造成帧字节交叉。
     *
     * @return `false` 表示会话已结束，尺寸同步无意义。
     */
    fun resize(rows: Int, cols: Int): Boolean {
        if (finished || stdinClosed.get() || rows <= 0 || cols <= 0) return false
        return try {
            val frame = ShellProtocol.buildWindowSizeFrame(rows, cols)
            stdinExecutor.execute {
                runCatching {
                    val output = stdinOutput ?: stream.openOutputStream().also { stdinOutput = it }
                    output.write(frame, 0, frame.size)
                    output.flush()
                }
            }
            true
        } catch (t: Throwable) {
            // 会话刚被回收，[stdinExecutor] 已 shutdown。
            Log.d(TAG, "exec session $sessionId resize dropped: ${t.javaClass.simpleName}")
            false
        }
    }

    /**
     * 主动中断。
     *
     * pty 模式下 stdin 就是终端输入队列，写一个 `\x03` 等价于用户按 Ctrl+C：
     * 内核 line discipline 会把它变成 SIGINT 送给前台进程组。因此先发 `\x03`
     * 让远端自己收尾——`sh` 会打印新提示符、会话继续可用，`cd` 过的工作目录也还在。
     *
     * 但 SIGINT 是可以被忽略的（`trap '' INT`、死循环里的阻塞调用等），所以发完
     * 后起一个短命线程等 [CANCEL_GRACE_MS]：仍未结束就关流兜底，让 adbd 回收
     * 整条服务，进程收到 SIGHUP 强制退出。
     */
    fun cancel() {
        if (finished) return
        Log.i(TAG, "exec session $sessionId cancel")
        val queued = try {
            stdinExecutor.execute {
                runCatching {
                    val output = stdinOutput ?: stream.openOutputStream().also { stdinOutput = it }
                    val frame = ShellProtocol.buildFrame(ShellProtocol.ID_STDIN, CTRL_C, 0, CTRL_C.size)
                    output.write(frame, 0, frame.size)
                    output.flush()
                }
                // 不占 stdinExecutor 做等待：中断之后用户可能马上要打字。
                Thread({ forceCloseAfterGrace() }, "adb-shell-cancel-$sessionId").apply {
                    isDaemon = true
                }.start()
            }
            true
        } catch (t: Throwable) {
            false
        }
        // \x03 都送不出去（线程池已关），只剩关流一条路。
        if (!queued) closeQuietly()
    }

    /** 给前台进程组一点时间响应 SIGINT；到点还没结束就关流兜底。 */
    private fun forceCloseAfterGrace() {
        try {
            Thread.sleep(CANCEL_GRACE_MS)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
        }
        if (finished) return
        Log.w(TAG, "exec session $sessionId still alive after Ctrl+C, closing stream")
        closeQuietly()
    }

    private fun readLoop() {
        try {
            val input = stream.openInputStream()
            val header = ByteArray(ShellProtocol.HEADER_SIZE)
            val chunk = ByteArray(ShellProtocol.BUFFER_SIZE)

            while (true) {
                if (!readFully(input, header, ShellProtocol.HEADER_SIZE)) break

                val id = header[0].toInt() and 0xFF
                val length = (header[1].toInt() and 0xFF) or
                    ((header[2].toInt() and 0xFF) shl 8) or
                    ((header[3].toInt() and 0xFF) shl 16) or
                    ((header[4].toInt() and 0xFF) shl 24)
                if (length < 0 || length > ShellProtocol.MAX_FRAME_BYTES) {
                    throw IOException("bad frame id=$id length=$length")
                }

                when (id) {
                    ShellProtocol.ID_STDOUT,
                    ShellProtocol.ID_STDERR,
                    -> {
                        val sink = if (id == ShellProtocol.ID_STDOUT) outBuffer else errBuffer
                        var remaining = length
                        while (remaining > 0) {
                            val want = minOf(remaining, chunk.size)
                            val read = input.read(chunk, 0, want)
                            if (read < 0) return
                            append(sink, chunk, read)
                            remaining -= read
                        }
                    }

                    ShellProtocol.ID_EXIT -> {
                        // 退出帧负载是 1 字节，值 0..255；被信号杀死时是 128 + signal。
                        val payload = ByteArray(length)
                        if (!readFully(input, payload, length)) return
                        if (length >= 1) exitCode = payload[0].toInt() and 0xFF
                        return
                    }

                    ShellProtocol.ID_WINDOW_SIZE_CHANGE -> {
                        // 本端只发不收；走到这里说明对端也发了尺寸通知，读掉即可，
                        // 否则下一帧头会错位。
                        if (!skip(input, length)) return
                    }

                    else -> {
                        // 未知帧整帧丢弃，但 payload 必须读掉，否则下一帧头会错位。
                        if (!skip(input, length)) return
                    }
                }
            }

            // 流正常关闭却始终没收到退出帧：adbd 那边命令根本没跑起来。
            failure = "exit frame missing"
        } catch (t: Throwable) {
            // 超时被 close()、设备掉线、开流被拒都走这里，统一记为失败原因。
            if (!timedOut) failure = t.javaClass.simpleName
        } finally {
            closeQuietly()
            finished = true
            val elapsed = SystemClock.elapsedRealtime() - startedAt
            Log.i(
                TAG,
                "exec session $sessionId finish exit=$exitCode timedOut=$timedOut " +
                    "failure=${failure ?: "-"} dropped=$droppedBytes elapsed=${elapsed}ms",
            )
        }
    }

    /** 到点仍未结束就关流。进程会因服务回收收到 SIGHUP。 */
    private fun watchdogLoop() {
        val deadline = startedAt + timeoutMs
        while (!finished && !streamClosed.get()) {
            val remaining = deadline - SystemClock.elapsedRealtime()
            if (remaining <= 0L) {
                timedOut = true
                Log.w(TAG, "exec session $sessionId timed out after ${timeoutMs}ms, closing stream")
                closeQuietly()
                return
            }
            try {
                Thread.sleep(minOf(remaining, WATCHDOG_SLICE_MS))
            } catch (_: InterruptedException) {
                Thread.currentThread().interrupt()
                return
            }
        }
    }

    /** 一趟只关一次；读线程与 watchdog 都会走到这里。 */
    private fun closeQuietly() {
        if (!streamClosed.compareAndSet(false, true)) return
        // 关流同时踢醒还卡在 write 上的 stdin 任务。
        runCatching { stream.close() }
        stdinExecutor.shutdownNow()
    }

    /** 追加输出；超上限时丢最老的字节并记账。 */
    private fun append(sink: ByteArrayOutputStream, data: ByteArray, length: Int) {
        synchronized(bufferLock) {
            sink.write(data, 0, length)
            if (sink.size() <= MAX_PENDING_BYTES) return

            // 丢头部而不是丢尾部：终端要的是「最新进展」，老输出已经滚出屏幕了。
            val all = sink.toByteArray()
            val drop = all.size - MAX_PENDING_BYTES
            // 丢弃点必须落在字符边界，否则剩下的第一段就是半截 UTF-8。
            val alignedDrop = safeUtf8Start(all, drop)
            sink.reset()
            sink.write(all, alignedDrop, all.size - alignedDrop)
            droppedBytes += alignedDrop
        }
    }

    /**
     * 摘走缓冲里的完整 UTF-8 文本，半个字符留在缓冲里等下一帧。
     *
     * 帧边界按字节切，一个多字节字符可能横跨两帧；不在这里挡住，中文输出就会碎成 `�`。
     */
    private fun drain(sink: ByteArrayOutputStream): String {
        synchronized(bufferLock) {
            if (sink.size() == 0) return ""
            val all = sink.toByteArray()
            val safeLength = safeUtf8Length(all)
            if (safeLength == 0) return ""
            sink.reset()
            if (safeLength < all.size) sink.write(all, safeLength, all.size - safeLength)
            return String(all, 0, safeLength, Charsets.UTF_8)
        }
    }

    /** 从 [start] 往后找第一个能安全当作字符串起点的位置。 */
    private fun safeUtf8Start(bytes: ByteArray, start: Int): Int {
        var index = start.coerceAtMost(bytes.size)
        // 续字节（10xxxxxx）不能作为起点，往后挪到下一个起始字节。
        while (index < bytes.size && (bytes[index].toInt() and 0xC0) == 0x80) index++
        return index
    }

    /**
     * 返回 [bytes] 里能构成完整字符的前缀长度。
     *
     * 从尾部往前找最后一个起始字节，看它声明的长度是否已经被满足：
     * 满足说明末尾是完整字符，全部交付；不满足就把它连同尾部一起留到下一轮。
     */
    private fun safeUtf8Length(bytes: ByteArray): Int {
        var index = bytes.size - 1
        var inspected = 0
        while (index >= 0 && inspected < 4) {
            val byte = bytes[index].toInt() and 0xFF
            if ((byte and 0xC0) == 0x80) {
                index--
                inspected++
                continue
            }
            val needed = when {
                (byte and 0x80) == 0x00 -> 1
                (byte and 0xE0) == 0xC0 -> 2
                (byte and 0xF0) == 0xE0 -> 3
                (byte and 0xF8) == 0xF0 -> 4
                // 非法起始字节交给 String 去产出替换符，不在这里拦。
                else -> 1
            }
            return if (bytes.size - index >= needed) bytes.size else index
        }
        return bytes.size
    }

    private fun readFully(input: InputStream, buffer: ByteArray, length: Int): Boolean {
        var offset = 0
        while (offset < length) {
            val read = input.read(buffer, offset, length - offset)
            if (read < 0) return false
            offset += read
        }
        return true
    }

    private fun skip(input: InputStream, length: Int): Boolean {
        var remaining = length
        val scratch = ByteArray(minOf(length, ShellProtocol.BUFFER_SIZE))
        while (remaining > 0) {
            val want = minOf(remaining, scratch.size)
            val read = input.read(scratch, 0, want)
            if (read < 0) return false
            remaining -= read
        }
        return true
    }

    private companion object {
        const val TAG = "AdbShell"
        const val LOG_SNIPPET = 120

        /** 未交付缓冲上限：正常轮询下远小于此，超了只可能是没人消费。 */
        const val MAX_PENDING_BYTES = 512 * 1024

        /** 超时检查粒度：只影响掐断的及时性，不占 CPU。 */
        const val WATCHDOG_SLICE_MS = 100L

        /** Ctrl+C：pty 的 line discipline 会把它翻译成前台进程组的 SIGINT。 */
        val CTRL_C = byteArrayOf(0x03)

        /** 等远端响应 SIGINT 的宽限期；过了还没结束就关流兜底。 */
        const val CANCEL_GRACE_MS = 600L
    }
}

/**
 * [ExecJob.poll] 的返回：自上次轮询以来的增量 + 会话当前状态。
 *
 * 与 `ShellExecResult` 分开是刻意的：那个描述「一次跑完的结果」，这个描述
 * 「一次快照」。把两者合并会让调用方分不清 `stdout` 是全量还是增量。
 */
internal class ExecChunkResult(
    val sessionId: String,
    /** 自上次 poll 以来新增的标准输出。 */
    val stdout: String,
    /** 自上次 poll 以来新增的标准错误。 */
    val stderr: String,
    val finished: Boolean,
    /** 仅在 [finished] 为 true 时有意义；`-1` 表示没拿到退出码。 */
    val exitCode: Int,
    val timedOut: Boolean,
    val durationMs: Long,
    /** 因缓冲溢出被丢弃的累计字节数。 */
    val droppedBytes: Long,
    /** 读出错的异常类名，或 `exit frame missing`；空串表示没有异常。 */
    val failure: String,
)

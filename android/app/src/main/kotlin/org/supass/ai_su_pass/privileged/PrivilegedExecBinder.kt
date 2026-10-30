package org.supass.ai_su_pass.privileged

import android.os.Binder
import android.os.Bundle
import android.os.Parcel
// 必须起别名：本文件同时用到 java.lang.Process（子进程）与 android.os.Process（pid/uid），
// 直接 import android.os.Process 会把 `Process` 这个名字抢走，导致 process.waitFor 等全部无法解析。
import android.os.Process as AndroidProcess
import android.os.SystemClock
import android.util.Log
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.util.concurrent.TimeUnit

/**
 * 特权进程对宿主暴露的唯一 Binder 对象。
 *
 * 职责只有「起子进程 + 收输出 + 保证超时一定杀掉」：
 * 不做业务判定、不猜外部状态、不向调用方抛异常。所有失败都折叠成结构化 Bundle，
 * 由链侧决定这算 `Failed` 还是 `Unsafe`。
 *
 * 超时处理要点：命令统一用 `setsid sh -c` 起，让子进程成为进程组组长；
 * 超时后按 `-pgid` 整组杀，否则只杀 `sh`、它拉起的载荷会变成孤儿继续跑。
 */
internal class PrivilegedExecBinder : Binder() {

    override fun onTransact(code: Int, data: Parcel, reply: Parcel?, flags: Int): Boolean {
        if (code != SupassProtocol.CODE_PING && code != SupassProtocol.CODE_EXEC) {
            return super.onTransact(code, data, reply, flags)
        }
        // 没有 reply 说明调用方用的是一向事务，本协议不支持。
        val out = reply ?: return true

        val result = try {
            data.enforceInterface(SupassProtocol.DESCRIPTOR)
            when (code) {
                SupassProtocol.CODE_PING -> pingInfo()
                else -> {
                    val command = data.readString().orEmpty()
                    val timeoutMs = data.readLong()
                    exec(command, timeoutMs)
                }
            }
        } catch (t: Throwable) {
            // 协议错配、Parcel 读失败都收敛成结果，绝不让异常穿出 Binder。
            Log.e(SupassProtocol.TAG, "onTransact failed code=$code", t)
            failure(EXIT_NOT_STARTED, "binderTransactFailed", t.javaClass.simpleName, 0L)
        }

        return try {
            out.writeNoException()
            out.writeBundle(result)
            true
        } catch (t: Throwable) {
            Log.e(SupassProtocol.TAG, "writeReply failed", t)
            true
        }
    }

    private fun pingInfo(): Bundle = Bundle().apply {
        // 三个字段的类型必须与客户端读取方式一致：version/pid 用 Int，uid 用 Long。
        putInt(SupassProtocol.KEY_VERSION, SupassProtocol.VERSION)
        putInt(SupassProtocol.KEY_PID, AndroidProcess.myPid())
        putLong(SupassProtocol.KEY_UID, AndroidProcess.myUid().toLong())
    }

    /**
     * 执行一条命令。
     *
     * @param timeoutMs 调用方给的超时；`<= 0` 时回落到 [DEFAULT_TIMEOUT_MS]，
     *   防止调用方漏传导致命令无限挂住。
     */
    private fun exec(command: String, timeoutMs: Long): Bundle {
        val startedAt = SystemClock.elapsedRealtime()
        val process = try {
            startProcess(command)
        } catch (t: Throwable) {
            Log.e(SupassProtocol.TAG, "spawn failed: ${command.take(LOG_SNIPPET)}", t)
            return failure(
                EXIT_NOT_STARTED,
                "spawnFailed",
                t.javaClass.simpleName,
                SystemClock.elapsedRealtime() - startedAt,
            )
        }

        val stdout = StreamCollector(process.inputStream).also { it.start() }
        val stderr = StreamCollector(process.errorStream).also { it.start() }
        val effective = if (timeoutMs <= 0L) DEFAULT_TIMEOUT_MS else timeoutMs

        val finished = try {
            process.waitFor(effective, TimeUnit.MILLISECONDS)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
            false
        }

        if (!finished) {
            // 先整组杀，再收尸；不重试，避免把危险原语跑第二遍。
            killProcessGroup(process)
            runCatching { process.waitFor(KILL_GRACE_MS, TimeUnit.MILLISECONDS) }
        }

        val exitCode = if (finished) {
            runCatching { process.exitValue() }.getOrDefault(EXIT_NOT_STARTED)
        } else {
            EXIT_NOT_STARTED
        }
        val outText = stdout.awaitText(DRAIN_TIMEOUT_MS)
        val errText = stderr.awaitText(DRAIN_TIMEOUT_MS)
        if (!finished) runCatching { process.destroyForcibly() }

        return Bundle().apply {
            putInt(SupassProtocol.KEY_EXIT_CODE, exitCode)
            putString(SupassProtocol.KEY_STDOUT, outText)
            putString(
                SupassProtocol.KEY_STDERR,
                if (!finished && errText.isEmpty()) TIMEOUT_MARK else errText,
            )
            putLong(
                SupassProtocol.KEY_DURATION_MS,
                SystemClock.elapsedRealtime() - startedAt,
            )
            putBoolean(SupassProtocol.KEY_TIMED_OUT, !finished)
        }
    }

    /**
     * `setsid` 让子进程成为独立进程组的组长，超时才能整组杀。
     * 个别 ROM 裁剪了 `setsid`，退回普通 `sh -c`——此时超时只能杀 sh 本身。
     */
    private fun startProcess(command: String): Process = try {
        ProcessBuilder("setsid", "sh", "-c", command)
            .redirectErrorStream(false)
            .start()
    } catch (_: IOException) {
        ProcessBuilder("sh", "-c", command).start()
    }

    private fun killProcessGroup(process: Process) {
        val pid = pidOf(process)
        if (pid != null) {
            runCatching {
                ProcessBuilder("kill", "-9", "-$pid")
                    .start()
                    .waitFor(KILL_GRACE_MS, TimeUnit.MILLISECONDS)
            }.onFailure {
                Log.w(SupassProtocol.TAG, "kill process group $pid failed", it)
            }
        } else {
            // 拿不到 pid 就只能杀直接子进程，载荷拉起的孙进程可能残留。
            // 这是能力边界，记日志让上层判 Unsafe，不要假装清理干净了。
            Log.w(SupassProtocol.TAG, "pid unavailable, process group kill skipped")
        }
        runCatching { process.destroyForcibly() }
    }

    /**
     * 取子进程 pid。
     *
     * `java.lang.Process.pid()` 是 Java 9 的 API，Android 的 `android.jar` 里没有
     * （Android 的 `Process` 只到 API 26 的 `destroyForcibly()` / `waitFor(ms, unit)`），
     * 直接调用编译期就报 Unresolved reference。两条路都试：
     * 1. 运行时若存在无参 `pid()`（部分新 ROM 补齐了），直接调用；
     * 2. 否则反射实现类的 `pid` 字段（AOSP 的 ProcessImpl 源自 OpenJDK 8 的 UNIXProcess）。
     */
    private fun pidOf(process: Process): Int? {
        val byMethod = runCatching {
            val method = Process::class.java.getMethod("pid")
            (method.invoke(process) as? Number)?.toInt()
        }.getOrNull()
        if (byMethod != null) return byMethod

        var type: Class<*>? = process.javaClass
        while (type != null && type != Any::class.java) {
            val current = type
            val value = runCatching {
                current.getDeclaredField("pid").apply { isAccessible = true }.get(process)
            }.getOrNull()
            if (value is Number) return value.toInt()
            type = current.superclass
        }
        return null
    }

    private fun failure(
        exitCode: Int,
        stderr: String,
        detail: String,
        durationMs: Long,
    ): Bundle = Bundle().apply {
        putInt(SupassProtocol.KEY_EXIT_CODE, exitCode)
        putString(SupassProtocol.KEY_STDOUT, "")
        putString(SupassProtocol.KEY_STDERR, "$stderr:$detail")
        putLong(SupassProtocol.KEY_DURATION_MS, durationMs)
        putBoolean(SupassProtocol.KEY_TIMED_OUT, false)
    }

    /**
     * 把子进程的输出流灌进内存缓冲。
     *
     * 读流必须独立线程：`waitFor` 与读流串行会死锁——管道缓冲区写满后子进程停住，
     * 而父进程还在等它退出。读流出 `IOException` 属于进程被杀的正常收尾，不算错误。
     */
    private class StreamCollector(private val input: InputStream) {

        private val buffer = ByteArrayOutputStream(INITIAL_BUFFER)
        private val thread = Thread({ pump() }, "supass-exec-stream").apply { isDaemon = true }

        fun start() {
            thread.start()
        }

        private fun pump() {
            val chunk = ByteArray(CHUNK_SIZE)
            try {
                while (true) {
                    val read = input.read(chunk)
                    if (read < 0) break
                    synchronized(buffer) { buffer.write(chunk, 0, read) }
                }
            } catch (_: IOException) {
                // 进程被 kill 时读端会抛，属于正常收尾。
            } finally {
                runCatching { input.close() }
            }
        }

        /** 等读线程收尾；超时也返回已拿到的部分，不丢现场。 */
        fun awaitText(timeoutMs: Long): String {
            runCatching { thread.join(timeoutMs) }
            return synchronized(buffer) { String(buffer.toByteArray(), Charsets.UTF_8) }
        }
    }

    private companion object {
        const val DEFAULT_TIMEOUT_MS = 60_000L
        const val KILL_GRACE_MS = 500L
        const val DRAIN_TIMEOUT_MS = 500L
        const val CHUNK_SIZE = 4096
        const val INITIAL_BUFFER = 4096
        const val LOG_SNIPPET = 120

        /** 与 [ShellResult] 的约定一致：-1 = 进程没跑起来或被 kill。 */
        const val EXIT_NOT_STARTED = -1
        const val TIMEOUT_MARK = "process timed out and was killed"
    }
}

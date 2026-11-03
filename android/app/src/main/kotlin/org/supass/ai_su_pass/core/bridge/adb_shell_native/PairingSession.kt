package org.supass.ai_su_pass.core.bridge.adb_shell_native

import android.os.SystemClock

/**
 * 一次配对会话的可变状态。
 *
 * 两条约束：
 * 1. 只记录「走到哪一步、失败原因是什么」，最终成败由 Dart 依 `finished` + `reason` 判定；
 * 2. 所有可变字段由 [lock] 保护：配对线程写，轮询线程随时读。
 */
internal class PairingSession(val sessionId: String) {

    private val lock = Any()

    /** 会话开始时的开机标识；null 表示读不到，只能靠单调钟兜底。 */
    private val bootIdAtStart: String? = BootIdentity.current()

    private val startedAtMs: Long = SystemClock.elapsedRealtime()

    var stage: PairingStage = PairingStage.WAITING_CODE
        private set

    var reason: String = ""
        private set

    var detail: String = ""
        private set

    var finished: Boolean = false
        private set

    var cancelled: Boolean = false
        private set

    /** 整条配对流程的上限；由发起方按模式给定。 */
    var timeoutMs: Long = DEFAULT_TIMEOUT_MS

    /** 是否已超出会话上限。 */
    val timedOut: Boolean get() = SystemClock.elapsedRealtime() - startedAtMs > timeoutMs

    /**
     * 自会话开始，设备是否重启过。
     *
     * `boot_id` 是精确判据；`elapsedRealtime()` 回退是兜底判据。重启后进程连同
     * 单调钟一起归零，`timedOut` 永远不会成立，只能靠这里说清「不是配对失败」。
     */
    val rebootedSinceStart: Boolean
        get() {
            val startId = bootIdAtStart
            if (startId != null) {
                val nowId = BootIdentity.current()
                if (nowId != null) return nowId != startId
            }
            return SystemClock.elapsedRealtime() < startedAtMs
        }

    fun advance(to: PairingStage) {
        synchronized(lock) {
            if (finished) return
            stage = to
        }
    }

    /** 记录失败并收尾。 */
    fun fail(reason: String, detail: String = "") {
        synchronized(lock) {
            if (finished) return
            this.reason = reason
            this.detail = detail
            this.stage = PairingStage.DONE
            this.finished = true
        }
    }

    /** 正常收尾。 */
    fun finish() {
        synchronized(lock) {
            if (finished) return
            stage = PairingStage.DONE
            finished = true
        }
    }

    fun cancel() {
        synchronized(lock) {
            cancelled = true
        }
    }

    fun snapshot(): PairingSnapshot = synchronized(lock) {
        PairingSnapshot(
            sessionId = sessionId,
            stage = if (finished) PairingStage.DONE else stage,
            reason = reason,
            detail = detail,
            finished = finished,
        )
    }

    private companion object {
        /** 手动模式（地址、端口、配对码都由 Dart 给）的宽松上限。 */
        const val DEFAULT_TIMEOUT_MS = 60_000L
    }
}

/**
 * 读取「这一次开机」的标识。
 *
 * `/proc/sys/kernel/random/boot_id` 由内核在每次开机时重新生成；部分厂商的
 * SELinux 策略会拦住 `proc_sys` 的读取，此时返回 null，由调用方退回单调钟兜底。
 */
internal object BootIdentity {

    private const val BOOT_ID_PATH = "/proc/sys/kernel/random/boot_id"

    fun current(): String? = try {
        java.io.File(BOOT_ID_PATH).readText().trim().ifEmpty { null }
    } catch (_: Throwable) {
        null
    }
}

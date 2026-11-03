package org.supass.ai_su_pass.core.shell

/**
 * shell 通道的健康状态。
 *
 * 与「命令能不能跑」分开：状态是**探测结论**，不产生任何副作用；
 * 只有 [READY] 才值得往下走执行流程。
 */
internal enum class ShellStatus {
    /** 通道已连接，可以执行命令。 */
    READY,

    /** 尚未连接（未配对或设备侧断开）。 */
    NOT_CONNECTED,
}

/**
 * shell 命令通道。
 *
 * 实现方约束：
 * 1. [exec] 必须带超时，超时先杀进程再返回，不允许无限等待；
 * 2. 任何失败都以 [ShellResult] 返回，不抛异常；
 * 3. [status] 与 [uid] **不得执行任何命令**，只能读本地/连接状态。
 */
internal interface ShellChannel {

    /** 通道来源标识，写进日志便于排障（如 `adb`）。 */
    val source: String

    /** 通道健康状态，零副作用。 */
    fun status(): ShellStatus

    /** 当前身份 uid：`2000` = shell，`-1` = 未知/不可用。零副作用。 */
    val uid: Long

    /**
     * 阻塞执行一条命令；调用方负责放到后台线程。
     *
     * @param stdin 补给命令标准输入的字节；为 null 时按「空输入」处理（立即 EOF），
     *   读 stdin 的命令会直接拿到输入结束，而不是一直挂到超时。
     */
    fun exec(
        command: String,
        timeoutMs: Long = DEFAULT_TIMEOUT_MS,
        stdin: ByteArray? = null,
    ): ShellResult

    companion object {
        /** 默认超时：普通只读命令足够，长命令由调用方显式放大。 */
        const val DEFAULT_TIMEOUT_MS = 10_000L
    }
}

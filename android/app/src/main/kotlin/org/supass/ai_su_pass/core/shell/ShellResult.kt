package org.supass.ai_su_pass.core.shell

/**
 * 一次 shell 命令的结构化结果。
 *
 * 刻意不提供 `success` 布尔值：「命令返回 0」和「外部状态真的变了」是两件事，
 * 判定权留给上层，这里只如实记录原始事实。
 */
internal class ShellResult(
    /** 进程退出码；`-1` 表示进程没跑起来或被杀。 */
    val exitCode: Int,
    val stdout: String,
    val stderr: String,
    /** 单调时钟测得的耗时，不受系统改时间影响。 */
    val durationMs: Long,
    /** 是否因超时被强制终止。 */
    val timedOut: Boolean,
)

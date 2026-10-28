package org.supass.ai_su_pass.core.shell

/**
 * 一次 shell 命令的结构化结果。
 *
 * 刻意不提供 `success` 布尔值：提权链里「命令返回 0」和「外部状态真的变了」是两件事，
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
) {
    /** 命令是否正常退出；不代表业务目标达成。 */
    val exitedNormally: Boolean get() = !timedOut && exitCode == 0

    /** 合并输出，供 `grep` 类解析使用。 */
    val output: String get() = if (stderr.isEmpty()) stdout else "$stdout\n$stderr"

    /** 便于把结果原样塞进 `evidence`。 */
    fun toEvidence(prefix: String): Map<String, Any?> = mapOf(
        "$prefix.exitCode" to exitCode,
        "$prefix.durationMs" to durationMs,
        "$prefix.timedOut" to timedOut,
        "$prefix.stdout" to stdout.trim(),
    )
}

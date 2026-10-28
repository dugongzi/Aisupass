package org.supass.ai_su_pass.core.bridge.escalation_native

import android.os.SystemClock

/**
 * 单个阶段的执行结果。
 *
 * 只表达「这一阶段自身发生了什么」，**不含成败结论**：
 * [ok] 为 false 仅代表该阶段抛错或明确失败，最终是否提权成功由 Dart 依据
 * `verify` 阶段的外部证据判定。
 */
internal class StageResult(
    val ok: Boolean,
    val reasons: List<String> = emptyList(),
    val evidence: Map<String, Any?> = emptyMap(),
) {

    companion object {

        /** 阶段正常完成；`evidence` 原样透传给 Dart。 */
        fun ok(vararg evidence: Pair<String, Any?>): StageResult =
            StageResult(ok = true, evidence = mapOf(*evidence))

        /** 阶段失败；必须携带原因码，否则 Dart 只能归入 unknown。 */
        fun failed(reason: String, vararg evidence: Pair<String, Any?>): StageResult =
            StageResult(ok = false, reasons = listOf(reason), evidence = mapOf(*evidence))
    }
}

/**
 * 阶段打点：同时记录墙钟与单调时钟。
 *
 * `RunStep.startedAtMs` 要的是 Unix 毫秒（给页面画时间轴），而耗时必须用单调时钟算，
 * 否则设备改时间会让 `durationMs` 变成负数。两者分开存，避免在调用处混用。
 */
internal class StageTick(
    val stage: EscalationStage,
    val wallMs: Long,
    val elapsedMs: Long,
)

/**
 * 单次运行的会话状态。
 *
 * 三条约束：
 * 1. 只累积证据、不做判定，判定权在 Dart；
 * 2. 所有可变状态由 [lock] 保护，`pollRun` 随时可读、执行线程随时可写；
 * 3. 取消只置位，由链实现在**阶段边界**自行检查——不会打断已进入的危险原语，
 *    这与手册「超时先杀进程组、不原地重试」的要求一致。
 */
internal class EscalationRunSession(
    val runId: String,
    val chain: EscalationChainId,
    /** 整条运行的截止时长，单位毫秒。 */
    private val timeoutMs: Long,
) {

    private val lock = Any()
    private val steps = mutableListOf<RunStep>()
    private val startedAtMs = SystemClock.elapsedRealtime()
    private val cancelled = java.util.concurrent.atomic.AtomicBoolean(false)

    /** 最后一个已记录阶段；尚未开始时为 [EscalationStage.PROBE]。 */
    var phase: EscalationStage = EscalationStage.PROBE
        private set

    /** 是否已收尾；收尾后不再接受新阶段，快照只增不改。 */
    var finished: Boolean = false
        private set

    /** 是否已被外部取消。 */
    val isCancelled: Boolean get() = cancelled.get()

    /** 整条运行已耗时（毫秒）。 */
    val elapsedMs: Long get() = SystemClock.elapsedRealtime() - startedAtMs

    /** 是否已超出整条运行的截止时长。 */
    val timedOut: Boolean get() = elapsedMs > timeoutMs

    /** 阶段开始打点。 */
    fun beginStage(stage: EscalationStage): StageTick = StageTick(
        stage = stage,
        wallMs = System.currentTimeMillis(),
        elapsedMs = SystemClock.elapsedRealtime(),
    )

    /** 记录一个已完成的阶段；运行已收尾时静默丢弃。 */
    fun record(tick: StageTick, result: StageResult) {
        synchronized(lock) {
            if (finished) return
            steps += RunStep(
                stage = tick.stage,
                startedAtMs = tick.wallMs,
                durationMs = SystemClock.elapsedRealtime() - tick.elapsedMs,
                ok = result.ok,
                reasons = result.reasons.toList(),
                evidence = result.evidence.toMap(),
            )
            phase = tick.stage
        }
    }

    /** 置位取消标记；执行线程在下一个阶段边界退出。 */
    fun cancel() {
        cancelled.set(true)
    }

    /** 正常收尾。 */
    fun finish() {
        synchronized(lock) { finished = true }
    }

    /**
     * 合成一个失败阶段并收尾。
     *
     * 用于超时、取消后异常、未知运行等「没有正常阶段产出」的场景；
     * 证据里标记 `synthetic`，提示上层这条不是链自己写的。
     */
    fun finishWith(reason: String, stage: EscalationStage = phase) {
        synchronized(lock) {
            if (finished) return
            steps += RunStep(
                stage = stage,
                startedAtMs = System.currentTimeMillis(),
                durationMs = elapsedMs,
                ok = false,
                reasons = listOf(reason),
                evidence = mapOf("synthetic" to "true"),
            )
            phase = stage
            finished = true
        }
    }

    /** 当前快照；已收尾时阶段统一为 [EscalationStage.DONE] 哨兵。 */
    fun snapshot(): RunSnapshot = synchronized(lock) {
        RunSnapshot(
            runId = runId,
            chain = chain,
            phase = if (finished) EscalationStage.DONE else phase,
            steps = steps.toList(),
            finished = finished,
        )
    }
}

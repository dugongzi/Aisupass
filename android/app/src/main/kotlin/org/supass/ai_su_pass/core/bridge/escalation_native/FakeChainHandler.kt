package org.supass.ai_su_pass.core.bridge.escalation_native

/**
 * 演示链的原生实现。
 *
 * 作用只有一个：**把整条管道跑通**。一旦它跑不通，问题必然在注册表、快照累积或
 * Dart 轮询，而不是某条真实链的环境前提，因此每个阶段刻意保持最小。
 *
 * 约束：不读写任何系统文件、不起子进程、不申请权限，纯内存推进，
 * 满足「零副作用」；`verify` 回填 `targetAchieved = 1` 只是为了让上层判定逻辑
 * 走通成功分支，证据里同时带 `demo = true` 与真实运行区分。
 */
internal class FakeChainHandler : EscalationChainHandler {

    override val chain: EscalationChainId = EscalationChainId.FAKE

    override fun probe(): ChainProbe = ChainProbe(
        chain = chain,
        available = true,
        reasons = emptyList(),
        evidence = mapOf(EVIDENCE_DEMO to "true"),
    )

    override fun execute(session: EscalationRunSession, args: Map<String, Any?>) {
        for (stage in STAGES) {
            // 取消与超时都在阶段边界处理，避免打断已进入的阶段。
            if (session.isCancelled || session.timedOut) break

            val tick = session.beginStage(stage)
            // probe 紧随 startRun，不再额外等待，让首帧快照尽快可见。
            if (stage != EscalationStage.PROBE) sleepQuietly()

            val result = if (stage == EscalationStage.VERIFY) {
                StageResult.ok(
                    TARGET_ACHIEVED_KEY to "1",
                    EVIDENCE_DEMO to "true",
                )
            } else {
                StageResult.ok(EVIDENCE_DEMO to "true")
            }
            session.record(tick, result)
        }
        session.finish()
    }

    /** 忽略中断异常但仍恢复中断标记，避免吞掉取消信号。 */
    private fun sleepQuietly() {
        try {
            Thread.sleep(STEP_INTERVAL_MS)
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
        }
    }

    private companion object {

        /** 与 Dart 侧演示节奏一致，便于肉眼比对时间轴。 */
        const val STEP_INTERVAL_MS = 500L

        /** Dart 侧判定「外部状态已达成」的证据键，必须逐字一致。 */
        const val TARGET_ACHIEVED_KEY = "targetAchieved"

        /** 演示标记，用于在证据里与真实链区分。 */
        const val EVIDENCE_DEMO = "demo"

        /** 演示链的五个阶段，顺序即执行顺序。 */
        val STAGES = listOf(
            EscalationStage.PROBE,
            EscalationStage.PREPARE,
            EscalationStage.EXECUTE,
            EscalationStage.VERIFY,
            EscalationStage.CLEANUP,
        )
    }
}

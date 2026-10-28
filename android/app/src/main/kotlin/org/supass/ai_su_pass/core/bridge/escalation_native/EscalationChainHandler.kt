package org.supass.ai_su_pass.core.bridge.escalation_native

/**
 * 一条提权链在原生侧的唯一入口。
 *
 * 实现方只负责「按五动作走完并如实记录证据」，**不得自行判定成败**：
 * 判定权在 Dart，`verify` 阶段必须回填外部状态证据（键 `targetAchieved`）。
 *
 * 后续各链（kernelModule / payload / kernelExploit / pageCache）都实现本接口，
 * 注册表按 [chain] 装配，互不知道对方存在。
 */
internal interface EscalationChainHandler {

    /** 所属链，用于注册表匹配与探测结果回填。 */
    val chain: EscalationChainId

    /**
     * 只读探测，**必须零副作用**。
     *
     * 不允许 spawn 子进程、写文件或触发任何原语；异常由实现方自行转成原因码
     * （拿不准就回 `platformUnsupported`），不得向外抛。
     */
    fun probe(): ChainProbe

    /**
     * 依次执行 probe / prepare / execute / verify / cleanup。
     *
     * 实现方必须在每个阶段边界检查 [EscalationRunSession.isCancelled]，
     * 并在返回前调用 [EscalationRunSession.finish]；
     * 注册表仍会兜底，保证抛异常也不会让运行卡在未结束态。
     *
     * [args] 由 Dart 侧原样透传，链自行解释，缺失时按「前提不满足」处理。
     */
    fun execute(session: EscalationRunSession, args: Map<String, Any?>)
}

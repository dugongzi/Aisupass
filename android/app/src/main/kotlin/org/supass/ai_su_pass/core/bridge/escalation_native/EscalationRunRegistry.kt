package org.supass.ai_su_pass.core.bridge.escalation_native

import java.util.UUID
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/**
 * 运行注册表：原生侧唯一的运行入口与状态持有者。
 *
 * 职责边界：
 * 1. 只做「受理 / 查状态 / 取消」，不实现任何链逻辑，阶段推进交给
 *    [EscalationChainHandler]；
 * 2. 超时判定放在 [pollRun] 里做，避免为每次运行多开一个看门狗线程——
 *    Dart 侧固定 500ms 轮询，等于天然提供了心跳；
 * 3. 会话只增不改，[pollRun] 永远返回一致快照。
 */
internal class EscalationRunRegistry(
    handlers: List<EscalationChainHandler>,
) {

    private val lock = Any()
    private val sessions = mutableMapOf<String, EscalationRunSession>()
    private val handlers: Map<EscalationChainId, EscalationChainHandler> =
        handlers.associateBy { it.chain }

    /**
     * 每条链跑在自己的线程上：互不阻塞，也不会顶掉 Pigeon 的单线程执行器。
     * 用 daemon 线程保证进程退出时不会因为残留运行卡住。
     */
    private val executor: ExecutorService = Executors.newCachedThreadPool { runnable ->
        Thread(runnable, "escalation-run").apply { isDaemon = true }
    }

    /** 探测单条链；未注册的链按「平台不支持」返回，异常也在此收敛。 */
    fun probe(chain: EscalationChainId): ChainProbe {
        val handler = handlers[chain] ?: return unsupported(chain)
        return try {
            handler.probe()
        } catch (t: Throwable) {
            ChainProbe(
                chain = chain,
                available = false,
                reasons = listOf(EscalationReasons.PROBE_FAILED),
                evidence = mapOf("error" to t.javaClass.simpleName),
            )
        }
    }

    /**
     * 受理一次运行。
     *
     * 只有注册了处理器的链才可能被受理；其余链直接拒绝并回原因码，
     * 让 Dart 侧走「拒绝受理」分支，而不是给一个永远查不到状态的 runId。
     */
    fun startRun(
        chain: EscalationChainId,
        args: Map<String, Any?>,
    ): StartRunResult {
        val handler = handlers[chain] ?: return StartRunResult(
            accepted = false,
            runId = "",
            reasons = listOf(EscalationReasons.PLATFORM_UNSUPPORTED),
        )

        val runId = "run-${UUID.randomUUID()}"
        val session = EscalationRunSession(runId, chain, RUN_TIMEOUT_MS)
        synchronized(lock) {
            sessions[runId] = session
            pruneLocked()
        }

        try {
            executor.execute { executeSafely(handler, session, args) }
        } catch (t: Throwable) {
            // 线程池已关闭：收回会话，避免留下一个永远不推进的运行。
            synchronized(lock) { sessions.remove(runId) }
            return StartRunResult(
                accepted = false,
                runId = "",
                reasons = listOf(EscalationReasons.EXECUTE_FAILED),
            )
        }

        return StartRunResult(accepted = true, runId = runId, reasons = emptyList())
    }

    /** 查询运行快照；未知 runId 返回一个已收尾的失败快照，不抛异常。 */
    fun pollRun(runId: String): RunSnapshot {
        val session = synchronized(lock) { sessions[runId] } ?: return unknownRun(runId)

        // 超时后先置位取消再收尾：链实现在下个阶段边界自行退出。
        if (!session.finished && session.timedOut) {
            session.cancel()
            session.finishWith(EscalationReasons.EXECUTE_TIMEOUT)
        }
        return session.snapshot()
    }

    /** 取消运行；对已结束或未知的运行是幂等空操作。 */
    fun cancelRun(runId: String) {
        synchronized(lock) { sessions[runId] }?.cancel()
    }

    /** 释放全部运行与线程池；由 [EscalationNativeImpl.dispose] 调用。 */
    fun dispose() {
        synchronized(lock) {
            sessions.values.forEach { it.cancel() }
            sessions.clear()
        }
        executor.shutdownNow()
    }

    /** 链实现抛出的任何异常都收敛为「执行失败」，并保证运行能收尾。 */
    private fun executeSafely(
        handler: EscalationChainHandler,
        session: EscalationRunSession,
        args: Map<String, Any?>,
    ) {
        try {
            handler.execute(session, args)
        } catch (t: Throwable) {
            session.finishWith(EscalationReasons.EXECUTE_FAILED)
        } finally {
            session.finish()
        }
    }

    /** 只保留最近的若干条运行，优先淘汰已结束的旧会话。 */
    private fun pruneLocked() {
        if (sessions.size <= MAX_SESSIONS) return
        val finishedIds = sessions
            .filterValues { it.finished }
            .keys
            .toList()
        for (id in finishedIds) {
            if (sessions.size <= MAX_SESSIONS) break
            sessions.remove(id)
        }
    }

    /** 未知运行的兜底快照：标记 `synthetic` 与 `unknownRun`，便于排障。 */
    private fun unknownRun(runId: String): RunSnapshot {
        val session = EscalationRunSession(runId, EscalationChainId.FAKE, RUN_TIMEOUT_MS)
        session.finishWith(EscalationReasons.PROBE_FAILED)
        return session.snapshot().let {
            it.copy(
                steps = it.steps.map { step ->
                    step.copy(evidence = step.evidence + ("unknownRun" to "true"))
                },
            )
        }
    }

    private fun unsupported(chain: EscalationChainId): ChainProbe = ChainProbe(
        chain = chain,
        available = false,
        reasons = listOf(EscalationReasons.PLATFORM_UNSUPPORTED),
        evidence = emptyMap(),
    )

    private companion object {

        /**
         * 整条运行的截止时长。
         *
         * 必须**小于** Dart 侧 `EscalationActionDatasource.runTimeout`（120s），
         * 否则页面会先超时收尾，原生这条 `executeTimeout` 永远回不到用户眼前。
         */
        const val RUN_TIMEOUT_MS = 110_000L

        /** 内存中保留的最大运行数，超出后淘汰已结束的旧会话。 */
        const val MAX_SESSIONS = 32
    }
}

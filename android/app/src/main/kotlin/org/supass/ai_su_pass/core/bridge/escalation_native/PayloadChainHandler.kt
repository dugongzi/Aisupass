package org.supass.ai_su_pass.core.bridge.escalation_native

import org.supass.ai_su_pass.core.shell.ShellChannel
import org.supass.ai_su_pass.core.shell.ShellStatus

/**
 * shell 通道链（L1）—— 全部高权限链的地基。
 *
 * 目标很窄：确认「能不能以 uid 2000 / 0 跑命令，并且文件系统可写」。
 * 这一条不通，`kernelModule`（ksud）、`kernelExploit`（起 helper）、
 * `pageCache`（起进程）都无从谈起，所以它的 `verify` 是后面三条链的准入条件。
 *
 * 验收四条（手册 §2.5）：
 * 1. `id` 输出 uid ∈ {2000, 0}；
 * 2. `getprop` 可读（证明 Binder/属性服务可用）；
 * 3. `/proc/self/status` 的 `Uid` 与 `Seccomp` 可读（证明能看自己内核态信息）；
 * 4. `/data/local/tmp` 可写可读可删（证明有可执行目录的写权限）。
 */
internal class PayloadChainHandler(
    private val shell: ShellChannel,
    /** ADB 点火通道是否活着；只读连接状态，不下发命令。 */
    private val adbReady: () -> Boolean = { false },
) : EscalationChainHandler {

    override val chain: EscalationChainId = EscalationChainId.PAYLOAD

    override fun probe(): ChainProbe {
        // 只读状态，不跑任何命令：零副作用。
        val status = shell.status()
        val uid = shell.uid
        val binderReady = status == ShellStatus.READY && ShellChannel.isPrivileged(uid)
        // Binder 还没推过来、但 ADB 活着 —— 点火就能起来，必须判为可用。
        // 否则「可用性要求 Binder 已就绪」与「点火只能由用户点启动触发」互相锁死，
        // 页面上这条链永远是灰的，用户根本没有机会把特权进程拉起来。
        // 这里只是读连接状态，仍属零副作用；真正的点火发生在 startRun 里。
        val canIgnite = !binderReady && adbReady()
        val available = binderReady || canIgnite
        return ChainProbe(
            chain = chain,
            available = available,
            reasons = if (available) emptyList() else listOf(reasonOf(status)),
            evidence = mapOf(
                "channelSource" to shell.source,
                "channelStatus" to status.name.lowercase(),
                "channelUid" to uid.toString(),
                "needsWarmUp" to canIgnite.toString(),
            ),
        )
    }

    override fun execute(session: EscalationRunSession, args: Map<String, Any?>) {
        // ---- probe：确认通道状态，与 probe() 一致，零副作用 ----
        if (session.isCancelled || session.timedOut) return finish(session)
        val status = shell.status()
        session.record(
            session.beginStage(EscalationStage.PROBE),
            if (status == ShellStatus.READY) {
                StageResult.ok("channelStatus" to status.name.lowercase())
            } else {
                StageResult.failed(reasonOf(status), "channelStatus" to status.name.lowercase())
            },
        )
        if (status != ShellStatus.READY) return finish(session)

        // ---- prepare：记录将要使用的身份，决定后续期望值 ----
        if (session.isCancelled || session.timedOut) return finish(session)
        val channelUid = shell.uid
        session.record(
            session.beginStage(EscalationStage.PREPARE),
            if (ShellChannel.isPrivileged(channelUid)) {
                StageResult.ok(
                    "channelUid" to channelUid.toString(),
                    "identityLevel" to if (channelUid == 0L) "root" else "shell",
                )
            } else {
                StageResult.failed(EscalationReasons.SHELL_UNAVAILABLE, "channelUid" to channelUid.toString())
            },
        )
        if (!ShellChannel.isPrivileged(channelUid)) return finish(session)

        // ---- execute：起一条真实命令，拿回退出码与 uid ----
        if (session.isCancelled || session.timedOut) return finish(session)
        val idResult = shell.exec("id", ID_TIMEOUT_MS)
        val execUid = parseUid(idResult.stdout)
        session.record(
            session.beginStage(EscalationStage.EXECUTE),
            when {
                idResult.timedOut -> StageResult.failed(
                    EscalationReasons.SHELL_TIMEOUT,
                    *idResult.toEvidence("id").toList().toTypedArray(),
                )

                !idResult.exitedNormally -> StageResult.failed(
                    EscalationReasons.SHELL_DENIED,
                    *idResult.toEvidence("id").toList().toTypedArray(),
                )

                execUid == null -> StageResult.failed(
                    EscalationReasons.PROBE_FAILED,
                    *idResult.toEvidence("id").toList().toTypedArray(),
                )

                else -> StageResult.ok(
                    "id.uid" to execUid.toString(),
                    *idResult.toEvidence("id").toList().toTypedArray(),
                )
            },
        )
        if (execUid == null) return finish(session)

        // ---- verify：三条外部状态验证，结果决定 Dart 侧的成败结论 ----
        if (session.isCancelled || session.timedOut) return finish(session)
        val sdk = shell.exec("getprop ro.build.version.sdk", VERIFY_TIMEOUT_MS)
        val procStatus = shell.exec(
            "cat /proc/self/status | grep -E '^(Uid|Seccomp):'",
            VERIFY_TIMEOUT_MS,
        )
        // 写 → 读 → 比对，一步完成；删除留给 cleanup，保证副作用可回滚。
        val tmpWrite = shell.exec(
            "echo ok > $PROBE_FILE && cat $PROBE_FILE",
            VERIFY_TIMEOUT_MS,
        )

        val procUid = parseKeyValue(procStatus.stdout, "Uid")
        val seccomp = parseKeyValue(procStatus.stdout, "Seccomp")
        val tmpOk = tmpWrite.exitedNormally && tmpWrite.stdout.trim() == "ok"
        val achieved = ShellChannel.isPrivileged(execUid) && procUid != null && tmpOk

        val verifyResult = if (achieved) {
            StageResult.ok(
                "targetAchieved" to "1",
                "proc.uid" to (procUid ?: ""),
                "proc.seccomp" to (seccomp ?: ""),
                "tmpWrite" to tmpOk.toString(),
                "getprop.exitCode" to sdk.exitCode.toString(),
                "getprop.sdk" to sdk.stdout.trim().ifEmpty { sdk.stderr.trim() },
            )
        } else {
            // 不臆测失败原因（SELinux / 挂载 noexec / 磁盘满都可能），只如实回「外部状态未达成」。
            StageResult(
                ok = false,
                reasons = listOf(EscalationReasons.VERIFY_FAILED_AT_EXTERNAL),
                evidence = mapOf(
                    "targetAchieved" to "0",
                    "proc.uid" to (procUid ?: ""),
                    "proc.seccomp" to (seccomp ?: ""),
                    "tmpWrite" to tmpOk.toString(),
                    "getprop.exitCode" to sdk.exitCode.toString(),
                ),
            )
        }
        session.record(session.beginStage(EscalationStage.VERIFY), verifyResult)

        // ---- cleanup：删掉探针文件；幂等，失败只记录不阻断收尾 ----
        if (session.isCancelled || session.timedOut) return finish(session)
        val cleanup = shell.exec("rm -f $PROBE_FILE", CLEANUP_TIMEOUT_MS)
        session.record(
            session.beginStage(EscalationStage.CLEANUP),
            if (cleanup.exitedNormally) {
                StageResult.ok("cleanup.removed" to "true")
            } else {
                StageResult.failed(
                    EscalationReasons.CLEANUP_FAILED,
                    *cleanup.toEvidence("cleanup").toList().toTypedArray(),
                )
            },
        )
        finish(session)
    }

    /** 收尾：注册表仍会兜底，这里主动调用让快照立刻可见。 */
    private fun finish(session: EscalationRunSession) {
        session.finish()
    }

    /** 通道状态到原因码；Dart 侧按 `unsupported` / `shellDenied` 分别提示。 */
    private fun reasonOf(status: ShellStatus): String = when (status) {
        ShellStatus.READY -> EscalationReasons.PLATFORM_UNSUPPORTED
        ShellStatus.NOT_CONNECTED -> EscalationReasons.SHELL_UNAVAILABLE
    }

    /** 从 `uid=2000(shell) gid=...` 里取第一个 uid。 */
    private fun parseUid(text: String): Long? =
        UID_PATTERN.find(text)?.groupValues?.getOrNull(1)?.toLongOrNull()

    /**
     * 从 `/proc/self/status` 的 `Key:\tValue` 里取值。
     *
     * `Uid:` 那行是四个数字（real/effective/saved/fs），取第二个即 effective uid。
     */
    private fun parseKeyValue(text: String, key: String): String? {
        val line = text.lineSequence().firstOrNull { it.startsWith("$key:") } ?: return null
        val value = line.substringAfter(':').trim()
        if (key != "Uid") return value.ifEmpty { null }
        return value.split('\t', ' ')
            .filter { it.isNotBlank() }
            .getOrNull(1)
            ?: value.split(' ').firstOrNull()
    }

    private companion object {
        /** id 是纯内存命令，给 10s 已经很宽。 */
        const val ID_TIMEOUT_MS = 10_000L

        /** 三条验证串联，读 /proc 与写文件都在内，给 20s。 */
        const val VERIFY_TIMEOUT_MS = 20_000L

        const val CLEANUP_TIMEOUT_MS = 10_000L

        /** 探针文件放 `/data/local/tmp`：shell 可写、无需额外权限，且不污染应用私有目录。 */
        const val PROBE_FILE = "/data/local/tmp/.aisup_shell_probe"

        val UID_PATTERN = Regex("uid=(\\d+)")
    }
}

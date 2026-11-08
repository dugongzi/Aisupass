package org.supass.ai_su_pass.core.bridge.adb_shell_native

/**
 * 流式执行会话没能开起来时的原因码。
 *
 * 与 [PairingReasons] 同一条规矩：取值必须与 Dart 侧的匹配分支**逐字一致**，
 * 对不上的码只会落到兜底文案，等于把可诊断信息丢掉。
 *
 * 只覆盖「命令没跑起来」这一层。命令跑起来了但退出码非 0，那是命令自己的事，
 * 由 `exitCode` 与 `stderr` 表达，不在这里造原因码。
 */
internal object ExecReasons {
    /** 命令为空串或只有空白。 */
    const val EMPTY_COMMAND = "emptyCommand"

    /** ADB 连接没建立，开不了流。 */
    const val CHANNEL_NOT_READY = "channelNotReady"

    /** 连接在，但开流被对端拒绝或连接恰好断开。 */
    const val STREAM_OPEN_FAILED = "streamOpenFailed"
}

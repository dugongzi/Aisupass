package org.supass.ai_su_pass.core.bridge.adb_shell_native

/**
 * 配对流程的原因码。
 *
 * 取值必须与 Dart 侧 `app_adb_shell_panel.dart` 里原因码到文案的匹配分支
 * **逐字一致**：对不上的码只会落到兜底文案，等于把可诊断信息丢掉。
 */
internal object PairingReasons {
    /** 配对码错误、凭据不可用、通知没弹出来等「本机侧配对没走通」。 */
    const val HOST_PAIRING_FAILED = "hostPairingFailed"

    /** 设备侧拒绝授权（密钥未被信任）。 */
    const val HOST_AUTH_FAILED = "hostAuthFailed"

    /** 配对端口不可达、或建链时连接失败。 */
    const val HOST_DISCONNECTED = "hostDisconnected"

    /** 等码或握手超时。 */
    const val PAIRING_TIMEOUT = "pairingTimeout"

    /** 会话进行中设备重启过。 */
    const val DEVICE_REBOOTED = "deviceRebooted"

    /** 主动取消。 */
    const val CANCELLED = "cancelled"
}

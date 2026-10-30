package org.supass.ai_su_pass.privileged

/**
 * 特权服务与宿主应用之间的 Binder 协议常量。
 *
 * 两侧（`app_process` 起的特权进程、宿主 App 进程）都从这份常量取字面量，
 * 避免一边改名另一边静默不匹配。协议只暴露两个事务：
 * - [CODE_PING]：确认服务活着，顺带回版本、pid、uid；
 * - [CODE_EXEC]：执行一条命令，回结构化结果（退出码 / stdout / stderr / 耗时 / 是否超时）。
 *
 * 刻意不提供「返回成败结论」的事务：退出码与外部状态是两件事，判定权留在链侧。
 */
object SupassProtocol {

    /** Provider authority 后缀；完整值是 `${applicationId}.adbhelper`。 */
    const val AUTHORITY_SUFFIX = ".adbhelper"

    /** Provider 上接收 Binder 的调用方法名。 */
    const val METHOD_SEND_BINDER = "sendBinder"

    /** Bundle 里装载 IBinder 的键。 */
    const val KEY_BINDER = "binder"

    /** Provider 回执：true 表示 Binder 已被宿主接收并登记。 */
    const val KEY_ACK = "ack"

    /**
     * Provider 拒绝时的原因短句（[KEY_ACK] 为 false 时才有值）。
     *
     * 必须有这一项：拒绝发生在宿主进程里，特权进程只拿到一个 false。
     * 不把原因带回来，落盘日志就只能写「被拒了」——等于没说。
     */
    const val KEY_REASON = "reason"

    /** Binder 接口描述符；`enforceInterface` 用它挡住协议错配。 */
    const val DESCRIPTOR = "org.supass.ai_su_pass.privileged.IExec"

    const val CODE_PING = 1
    const val CODE_EXEC = 2

    const val KEY_VERSION = "version"
    const val KEY_PID = "pid"
    const val KEY_UID = "uid"
    const val KEY_EXIT_CODE = "exitCode"
    const val KEY_STDOUT = "stdout"
    const val KEY_STDERR = "stderr"
    const val KEY_DURATION_MS = "durationMs"
    const val KEY_TIMED_OUT = "timedOut"

    /**
     * 协议版本。
     *
     * 两侧不一致时客户端按「服务不可用」重拉，而不是拿旧协议继续调——
     * App 升级后残留的旧进程正是靠这个版本号识别出来的。
     */
    const val VERSION = 1

    /** `app_process --nice-name` 的取值，也是「杀同名旧进程」的依据。 */
    const val NICE_NAME = "supassd"

    /**
     * 特权进程的诊断日志路径。
     *
     * 放在协议里而不是点火器里：点火脚本要往里重定向，特权进程自己也要往里写，
     * 宿主侧还要读回来展示——三处必须是同一个字面量。
     * `/data/local/tmp` 对 shell 可写，是唯一稳妥的落点。
     */
    const val HOST_LOG_PATH = "/data/local/tmp/supass-host.log"

    /** 特权侧日志标签。 */
    const val TAG = "SupassService"
}

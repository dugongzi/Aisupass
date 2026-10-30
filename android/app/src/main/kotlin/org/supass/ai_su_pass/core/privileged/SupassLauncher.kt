package org.supass.ai_su_pass.core.privileged

import org.supass.ai_su_pass.privileged.SupassProtocol
import org.supass.ai_su_pass.privileged.SupassService

/**
 * 点火器：把「一次性 ADB 连接」变成「常驻特权进程」。
 *
 * ADB 只负责点这一次火。进程起来后会把 Binder 推给宿主 Provider，
 * 之后所有 `exec` 都走 Binder —— 无线调试关掉、端口变化都不影响执行。
 *
 * 执行顺序与手册一致，但落地成 shell 脚本而不是 native 可执行文件：
 * 1. 校验 uid ∈ {0, 2000}，不满足立即退出（绝不半启动）；
 * 2. 杀掉同名旧进程，保证单例；
 * 3. 尽力而为地调低 oom 权重（shell 域通常被拒，失败不影响启动）；
 * 4. 能进 init 的挂载命名空间就进，不能就退回直接启动；
 * 5. `setsid` 独立会话 + 断开 stdio，ADB 流关闭时不会把服务一起带走；
 * 6. 用 `CLASSPATH` 环境变量把已安装 APK 交给 `app_process64`，再由它加载入口类；
 * 7. spawn 后原地确认进程没有秒退，秒退则把日志头几行回显到 stdout（唯一可靠通路）。
 *
 * 注意 `app_process` 本身是个按 ABI 挑 32/64 的脚本，这里直接写 `app_process64`。
 */
internal object SupassLauncher {

    /** 拉起失败时的退出码，只用于日志定位，不当成败结论。 */
    const val EXIT_NOT_PRIVILEGED = 10
    const val EXIT_SPAWN_FAILED = 11

    private const val APP_PROCESS = "/system/bin/app_process64"
    private const val CMD_DIR = "/system/bin"
    private const val LAUNCHER_TAG = "supass-launcher"

    /** 进程秒退时回显的日志行数：真正的原因总在最前面几行，取多了会被展示层截断。 */
    private const val LOG_HEAD_LINES = 6

    /**
     * 生成点火命令。
     *
     * @param apkPath 已安装 APK 的绝对路径（`applicationInfo.sourceDir`），
     *   必须指向真实安装路径，否则类加载不到。
     * @param authority 宿主 Provider 的 authority，特权进程用它把 Binder 推回去。
     */
    fun launchCommand(apkPath: String, authority: String): String {
        val niceName = SupassProtocol.NICE_NAME
        val mainClass = SupassService::class.java.name
        val logPath = SupassProtocol.HOST_LOG_PATH
        return buildString {
            appendLine("cd / 2>/dev/null")
            // 1. uid 闸门
            appendLine("__uid=\$(id -u)")
            appendLine(
                "case \"\$__uid\" in 0|2000) ;; *) " +
                    "echo \"$LAUNCHER_TAG: uid=\$__uid not privileged\" >&2; " +
                    "exit $EXIT_NOT_PRIVILEGED;; esac",
            )
            // 2. 单例：旧的同类进程先清掉，否则会出现两个服务抢着推 Binder。
            //    `--nice-name` 设的就是进程 comm，pidof 按它找。
            appendLine("__old=\$(pidof $niceName 2>/dev/null)")
            appendLine("if [ -n \"\$__old\" ]; then kill -9 \$__old 2>/dev/null; fi")
            // 3. 日志落点先探可写性。
            //    不可写时退回 /dev/null 并明说，否则「文件为空」会被误读成
            //    「进程没有输出」，把真正的故障藏起来。
            appendLine("__log=$logPath")
            appendLine(
                ": > \"\$__log\" 2>/dev/null || { " +
                    "echo \"$LAUNCHER_TAG: logNotWritable\"; __log=/dev/null; }",
            )
            appendLine("__wrap=\"\"")
            appendLine("if nsenter -t 1 -m -- true >/dev/null 2>&1; then __wrap=\"nsenter -t 1 -m --\"; fi")
            // 4. 用 CLASSPATH 环境变量，不用 `-Djava.class.path`。
            //    ART 的类加载器读的是 CLASSPATH（`am`、`pm` 这些命令脚本都是这么写的），
            //    `-Djava.class.path` 只是设置同名系统属性，对 FindClass 毫无作用。
            //    之前写错这一处，`app_process` 一进去就找不到 SupassService 直接退出。
            appendLine(
                "CLASSPATH=${quote(apkPath)} setsid \$__wrap $APP_PROCESS " +
                    "$CMD_DIR --nice-name=$niceName ${quote(mainClass)} ${quote(authority)} " +
                    "</dev/null >>\"\$__log\" 2>&1 &",
            )
            appendLine("__pid=\$!")
            // 5. oom 权重：shell 域一般无权调低，失败直接忽略。
            appendLine("if [ -n \"\$__pid\" ]; then echo 0 > /proc/\$__pid/oom_score_adj 2>/dev/null; fi")
            appendLine(
                "if [ -z \"\$__pid\" ]; then " +
                    "echo \"$LAUNCHER_TAG: spawn failed\" >&2; exit $EXIT_SPAWN_FAILED; fi",
            )
            // 必须以换行结尾：通道会在脚本后面直接拼 `; echo __AISUP_EXIT__$?`，
            // 少了这个换行两条命令会粘成一条，标记被 echo 当字符串原样打印，
            // 上层解析不到退出码 → 一律变成 exit=-1 的假失败信号。
            appendLine("echo \"$LAUNCHER_TAG: spawned pid=\$__pid\"")
            // 同时往磁盘日志里落一份。这行的作用不是给人看 pid，而是标记
            // 「重定向确实生效了」：如果日志文件里连这行都没有，说明 `>>` 压根
            // 没写进去（路径不可写 / 被 SELinux 拦），此时文件为空不代表
            // 特权进程没输出，而是我们根本收不到它的输出。
            appendLine(
                "echo \"$LAUNCHER_TAG: spawned pid=\$__pid\" " +
                    ">>${SupassProtocol.HOST_LOG_PATH} 2>/dev/null",
            )
            // 6. 原地确认它到底活下来了没有。
            //    只做一件事：`app_process` 在找不到入口类时会自己安静退出，
            //    上层 5s 后再 pidof 只能拿到「死了」这个结论，拿不到死因。
            //    而这里捕获到的 stdout 是我们唯一确定能收到的通路，所以把
            //    它写下的东西直接回显出来。多花的 0.8s 落在点火这一步，
            //    不影响配对本身的结论。
            appendLine("sleep 0.8")
            appendLine("if [ -z \"\$(pidof $niceName 2>/dev/null)\" ]; then")
            appendLine("  echo \"$LAUNCHER_TAG: died after spawn, host log:\"")
            appendLine(
                "  if [ -s \"\$__log\" ]; then head -n $LOG_HEAD_LINES \"\$__log\"; " +
                    "else echo \"  (empty)\"; fi",
            )
            appendLine("fi")
        }
    }

    /** POSIX 单引号转义：路径里出现 `'` 也不会把整条命令撕开。 */
    private fun quote(value: String): String = "'" + value.replace("'", "'\\''") + "'"
}

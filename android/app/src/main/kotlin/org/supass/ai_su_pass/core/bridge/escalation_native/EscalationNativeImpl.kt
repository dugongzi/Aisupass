package org.supass.ai_su_pass.core.bridge.escalation_native

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import org.supass.ai_su_pass.core.adb.AdbConnectionManager
import org.supass.ai_su_pass.core.adb.AdbShellChannel
import org.supass.ai_su_pass.core.adb.PairingNotification
import org.supass.ai_su_pass.core.shell.BinderShellChannel
import org.supass.ai_su_pass.core.shell.ShellChannel
import org.supass.ai_su_pass.core.shell.ShellStatus
import java.util.UUID
import java.util.concurrent.Executors
import java.util.concurrent.LinkedBlockingQueue
import java.util.concurrent.TimeUnit

/**
 * 提权原生实现：只做线程切换与委托，不承载任何链逻辑。
 *
 * 装配关系：
 * - 执行通道：[BinderShellChannel]（常驻特权进程的 Binder）；ADB 退居幕后，
 *   只负责配对流与点火。`hostStatus` / `warmUpHost` 读的是同一个实例，
 *   保证页面看到的身份与实际执行一致；
 * - 运行状态全部托管给 [EscalationRunRegistry]，这里不保存任何运行会话；
 * - 配对会话单独存 [pairingSessions]：配对不是一条提权链，只是给 `payload` 链铺路。
 *
 * 各方法现状：
 * - `probeAll`：`rootCheck` 只回静态证据（可用性由 Dart 侧 `rootStatusProvider` 判定），
 *   其余链走注册表，未注册即 `platformUnsupported`；
 * - `startRun` / `pollRun` / `cancelRun`：已接注册表，可用链为 `payload` 与 `fake`；
 * - `hostStatus`：反映特权进程 Binder 的存活状态；
 * - `warmUpHost`：未就绪时走一次 ADB 点火，把常驻进程拉起来并等 Binder 推回；
 *   未配对时无法点火，只能靠通知栏走一次配对码流程；
 * - `startPairing` / `pollPairing`：无线调试自配对，两阶段推进
 *   （`PROBE` = 交换配对码，`PREPARE` = mDNS 发现连接端点并建链）。
 *
 * 契约要求：
 * 1. 只回证据与原因码，不返回成败结论；
 * 2. 任何失败都走结构化返回值，不向 Dart 抛异常；
 * 3. 回调统一切回主线程。
 */
class EscalationNativeImpl(private val context: Context) : EscalationNative {

    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    /** 唯一的身份来源：应用内无线调试自配对，不需要用户安装任何外部 App。 */
    private val adb = AdbShellChannel(AdbConnectionManager(context))

    /**
     * 配对码输入通知。
     *
     * 配对码不能在本 App 的界面里输入：切到本 App 会让系统「使用配对码配对设备」
     * 对话框失效、配对码作废。通知栏是 SystemUI 的覆盖窗口，不改变前台 Activity，
     * 只有它能承载「不切屏的输入框」。
     */
    private val pairingNotification = PairingNotification(context)

    /**
     * 执行通道：命令走常驻特权进程的 Binder，不再压在 ADB 连接上。
     *
     * ADB 只保留两个职责：配对流（见 [adb] 的 pairing 方法）与点火
     * （[BinderShellChannel] 内部用 ADB 跑一次 [SupassLauncher]）。
     * 这样用户关掉无线调试后，已起的特权进程仍然能执行命令。
     */
    private val binderShell = BinderShellChannel(adb, context)

    /** 上层唯一认的通道；特权进程起不来且 ADB 也断时，链侧按「不可用」返回。 */
    private val shell: ShellChannel = binderShell

    private val registry = EscalationRunRegistry(
        listOf(
            // adbReady 只读连接状态：Binder 未就绪但 ADB 活着时，本链仍判可用，
            // 真正的点火由 startRun 触发（见下方 warmUp）。
            PayloadChainHandler(shell) { adb.status() == ShellStatus.READY },
            FakeChainHandler(),
        ),
    )

    /** 配对会话表；配对是长动作，跑在独立线程里，轮询只读快照。 */
    private val pairingLock = Any()
    private val pairingSessions = LinkedHashMap<String, PairingJob>()

    override fun probeAll(callback: (Result<List<ChainProbe>>) -> Unit) {
        executor.execute {
            val probes = EscalationChainId.values().map { chain ->
                when (chain) {
                    // rootCheck 不下发任何执行动作，只回静态证据。
                    EscalationChainId.ROOT_CHECK -> RootCheckProbe.probe()
                    // 其余链由注册表分发；未注册即 platformUnsupported。
                    else -> registry.probe(chain)
                }
            }
            mainHandler.post { callback(Result.success(probes)) }
        }
    }

    override fun startRun(
        chain: EscalationChainId,
        args: Map<String, Any?>,
        callback: (Result<StartRunResult>) -> Unit,
    ) {
        executor.execute {
            // 先确保特权进程在跑，再交给注册表执行。
            // payload 链的第一阶段就要求通道 READY，而点火发生在 exec() 内部，
            // 不在这里预热就会死锁：要执行得先就绪，要就绪得先执行。
            // 目前只有 payload 依赖 shell；kernelModule / kernelExploit / pageCache
            // 上线时同属这一类，加进来即可。
            if (chain == EscalationChainId.PAYLOAD) {
                binderShell.warmUp()
            }
            val result = registry.startRun(chain, args)
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun pollRun(runId: String, callback: (Result<RunSnapshot>) -> Unit) {
        executor.execute {
            val snapshot = registry.pollRun(runId)
            mainHandler.post { callback(Result.success(snapshot)) }
        }
    }

    override fun cancelRun(runId: String, callback: (Result<Unit>) -> Unit) {
        // 取消对未知或已结束的运行是幂等空操作，直接回成功。
        registry.cancelRun(runId)
        mainHandler.post { callback(Result.success(Unit)) }
    }

    override fun hostStatus(callback: (Result<HostStatus>) -> Unit) {
        executor.execute {
            val status = shell.status()
            val hostStatus = HostStatus(
                // 特权进程的 Binder 活着才算宿主存活；ADB 连接只用于点火。
                alive = status == ShellStatus.READY,
                // 未就绪时 uid 是 -1，Dart 侧按 0 = 未知处理。
                uid = shell.uid.coerceAtLeast(0L),
                // 真实重拉次数：连续失败 3 次后通道会停手，这个值能解释「为什么不再重试」。
                reconnectAttempts = binderShell.relaunchAttempts,
            )
            mainHandler.post { callback(Result.success(hostStatus)) }
        }
    }

    override fun warmUpHost(callback: (Result<WarmUpResult>) -> Unit) {
        executor.execute {
            // 这里会真的点火：名字叫「预热」，就该把特权进程拉起来。
            // 只读状态的版本会让调用方拿到 true 却仍然没有 Binder，等于谎报。
            val ready = binderShell.warmUp()
            // 失败原因必须一起回给页面：让用户为了知道「为什么没起来」
            // 去翻 logcat，等于没有反馈。
            val result = WarmUpResult(
                ready = ready,
                detail = if (ready) "" else (binderShell.lastFailure ?: ""),
            )
            mainHandler.post { callback(Result.success(result)) }
        }
    }

    override fun shutdownHost(callback: (Result<Boolean>) -> Unit) {
        executor.execute {
            // 只发指令，不等对端真的消失：被杀的就是回复方，事务必然中断。
            // 页面拿到 true 后立刻回查 hostStatus()，那里以 pingBinder() 为准。
            val sent = binderShell.shutdown()
            mainHandler.post { callback(Result.success(sent)) }
        }
    }

    override fun startPairing(
        host: String,
        port: Long,
        code: String,
        callback: (Result<StartRunResult>) -> Unit,
    ) {
        val trimmedHost = host.trim()
        val trimmedCode = code.trim()

        // 三参数全空 = 通知栏模式：配对码在通知里输入，地址与端口由 mDNS 自动发现。
        // 这是默认路径——让用户切回 App 抄 IP 再输码，系统配对对话框会直接失效。
        val notificationMode = trimmedHost.isEmpty() && port == 0L && trimmedCode.isEmpty()
        Log.i(
            TAG,
            "startPairing mode=${if (notificationMode) "notification" else "manual"} " +
                "host='$trimmedHost' port=$port codeLen=${trimmedCode.length}",
        )
        // 半填状态（例如只给码不给地址）是调用方拼错参数，直接拒绝，不要进后台白跑一轮。
        if (!notificationMode &&
            (trimmedHost.isEmpty() || port !in 1L..65535L || trimmedCode.isEmpty())
        ) {
            Log.w(TAG, "startPairing rejected: incomplete manual parameters")
            mainHandler.post {
                callback(
                    Result.success(
                        StartRunResult(
                            accepted = false,
                            runId = "",
                            reasons = listOf(EscalationReasons.HOST_PAIRING_FAILED),
                        ),
                    ),
                )
            }
            return
        }

        val job = PairingJob(
            session = EscalationRunSession(
                runId = "pair-${UUID.randomUUID()}",
                // 配对自身不是提权链，唯一目的是给 `payload` 链铺出 shell，故借用该链标识。
                chain = EscalationChainId.PAYLOAD,
                // 通知模式要等用户去系统设置里操作，窗口必须比手动模式宽得多。
                timeoutMs = if (notificationMode) NOTIFICATION_TIMEOUT_MS else PAIRING_TIMEOUT_MS,
            ),
            mode = if (notificationMode) PairingMode.NOTIFICATION else PairingMode.MANUAL,
            host = trimmedHost,
            port = port.toInt(),
            code = trimmedCode,
        )

        synchronized(pairingLock) {
            if (pairingSessions.size >= MAX_PAIRING_SESSIONS) {
                // 先淘汰已收尾的；全是进行中的话就淘汰最早的那个。
                val victim = pairingSessions.entries.firstOrNull { it.value.session.finished }
                    ?: pairingSessions.entries.firstOrNull()
                victim?.let { pairingSessions.remove(it.key) }
            }
            pairingSessions[job.session.runId] = job
        }

        // 配对 + mDNS 发现最坏要十几秒，不能占用共享的 executor，
        // 否则连 hostStatus 这种只读调用也会被一起堵住。
        Thread(
            {
                if (job.mode == PairingMode.NOTIFICATION) {
                    runNotificationPairing(job)
                } else {
                    runPairing(job)
                }
            },
            PAIRING_THREAD_NAME,
        ).apply {
            isDaemon = true
            start()
        }

        mainHandler.post {
            callback(
                Result.success(
                    StartRunResult(accepted = true, runId = job.session.runId, reasons = emptyList()),
                ),
            )
        }
    }

    override fun pollPairing(sessionId: String, callback: (Result<RunSnapshot>) -> Unit) {
        executor.execute {
            val job = synchronized(pairingLock) { pairingSessions[sessionId] }
            val snapshot = when {
                job == null -> unknownPairingSnapshot(sessionId)
                job.session.timedOut && !job.session.finished -> {
                    // 配对线程可能还卡在 TLS 握手或 mDNS 发现里收不回来；
                    // 这里先给上层一个终态，避免 Dart 无限轮询。
                    Log.w(TAG, "pollPairing: session $sessionId timed out, forcing finish")
                    job.session.finishWith(EscalationReasons.EXECUTE_TIMEOUT)
                    job.session.snapshot()
                }
                else -> job.session.snapshot()
            }
            mainHandler.post { callback(Result.success(snapshot)) }
        }
    }

    /**
     * 通知栏输入模式的配对：先在通知里等用户输入 6 位码，再发现端点、走正常配对。
     *
     * 为什么不直接让 Dart 传码进来：系统的「使用配对码配对设备」对话框属于 Settings，
     * 一旦把本 App 切到前台就会失效、配对码作废。通知栏是 SystemUI 的覆盖窗口，
     * 不改变前台 Activity，是唯一能承载「不切屏输入框」的载体。
     *
     * 失败分支一律先 `record` 再 `finish`，让快照里留得下具体断在哪一步。
     */
    private fun runNotificationPairing(job: PairingJob) {
        val session = job.session
        if (!pairingNotification.show { code -> job.codeQueue.offer(code) }) {
            // 通知权限没给，流程根本开不了头；立刻收尾，别让 Dart 白轮询五分钟。
            Log.w(TAG, "notification pairing aborted: notification not posted")
            session.finishWith(EscalationReasons.HOST_PAIRING_FAILED)
            return
        }
        Log.i(TAG, "notification pairing: notification posted, waiting for code")

        // 发现必须和「等用户输码」并行：`_adb-tls-pairing._tcp` 只在系统配对对话框
        // 打开期间广播，等用户提交完码再开始发现，对话框往往已经关闭、服务已停止广播。
        val discovery = adb.startPairingDiscovery()
        Log.i(TAG, "notification pairing: mdns discovery started in parallel")

        try {
            var foundNotified = false
            val deadline = System.currentTimeMillis() + NOTIFICATION_CODE_WAIT_MS
            while (true) {
                val remaining = deadline - System.currentTimeMillis()
                if (remaining <= 0L) break
                // 分片等待，好让「端点已发现 / 已消失」这些节点能及时反馈到通知栏。
                val code = job.codeQueue.poll(minOf(POLL_SLICE_MS, remaining), TimeUnit.MILLISECONDS)

                // 端点出现时立刻反馈，用户才知道 mDNS 那一路是通的。
                val endpointNow = discovery.endpoint
                if (!foundNotified && endpointNow != null) {
                    foundNotified = true
                    Log.i(TAG, "notification pairing: pairing endpoint found $endpointNow")
                    pairingNotification.markDeviceFound()
                }

                // 配对服务（= 系统「使用配对码配对设备」对话框）消失后，之前发现的端口
                // 立即作废。先把通知切回「请重新打开配对弹窗」，并让「已找到设备」
                // 的提示可以在对话框重开时再次触发。
                if (foundNotified && discovery.endpoint == null) {
                    foundNotified = false
                    Log.w(TAG, "notification pairing: pairing service lost, waiting for dialog to reopen")
                    pairingNotification.markPairingDialogClosed()
                }
                if (code == null) continue

                Log.i(TAG, "notification pairing: code received len=${code.length}")

                // 正常情况下这里立刻能读到端点；给一点宽限是因为用户可能恰好在
                // 对话框刚打开、mDNS 还没解析完时提交。
                val endpoint = discovery.await(ENDPOINT_GRACE_MS)
                if (endpoint == null) {
                    // 端点不存在 = 配对对话框已经关闭：这串码随配对端口一起作废。
                    // 绝不能拿旧端口去握手（只会 ECONNREFUSED，还白白消耗一次码），
                    // 保留输入入口，等用户重开弹窗后输新码。
                    Log.w(
                        TAG,
                        "notification pairing: endpoint gone before pairing, requesting a new code",
                    )
                    job.codeQueue.clear()
                    foundNotified = false
                    pairingNotification.markPairingDialogClosed()
                    continue
                }

                job.host = endpoint.address.hostAddress.orEmpty()
                job.port = endpoint.port
                job.code = code
                Log.i(TAG, "notification pairing: endpoint resolved to ${job.host}:${job.port}")
                runPairing(job)
                return
            }
            Log.w(
                TAG,
                "notification pairing: no code within ${NOTIFICATION_CODE_WAIT_MS}ms, " +
                    "discovery=${discovery.error ?: "stillRunning"}",
            )
            session.finishWith(EscalationReasons.EXECUTE_TIMEOUT)
        } catch (_: InterruptedException) {
            Log.w(TAG, "notification pairing interrupted")
            Thread.currentThread().interrupt()
            session.finishWith(EscalationReasons.EXECUTE_FAILED)
        } finally {
            discovery.close()
            // 无论成败都要撤通知：配对码用过即作废，留着只会让人重复输入。
            Log.i(TAG, "notification pairing finished, dismissing notification")
            pairingNotification.dismiss()
            session.finish()
        }
    }

    /**
     * 配对工作流：`PROBE` 交换配对码 → `PREPARE` 发现连接端点并建链。
     *
     * 只写证据，不判定成败；成功与否由 [AdbShellChannel.status] 及 Dart 侧最终判定。
     * 每个失败分支都先 `record` 再 `finish`，让快照里保留具体是哪一步断的。
     */
    private fun runPairing(job: PairingJob) {
        val session = job.session
        val startedAt = SystemClock.elapsedRealtime()
        Log.i(
            TAG,
            "runPairing begin host='${job.host}' port=${job.port} codeLen=${job.code.length}",
        )
        try {
            val pairTick = session.beginStage(EscalationStage.PROBE)
            if (!adb.prepare()) {
                Log.w(TAG, "runPairing: credentials unavailable")
                session.record(
                    pairTick,
                    StageResult.failed(
                        EscalationReasons.HOST_PAIRING_FAILED,
                        "error" to CREDENTIALS_UNAVAILABLE,
                    ),
                )
                session.finish()
                return
            }
            if (!adb.canReach(job.host, job.port)) {
                // 配对端口不通，基本就是地址抄错或无线调试没开；
                // 先回 disconnected，别让用户白等一次握手超时。
                Log.w(TAG, "runPairing: pairing port unreachable ${job.host}:${job.port}")
                session.record(
                    pairTick,
                    StageResult.failed(
                        EscalationReasons.HOST_DISCONNECTED,
                        "host" to job.host,
                        "port" to job.port,
                    ),
                )
                session.finish()
                return
            }
            Log.i(TAG, "runPairing: pairing port reachable, starting spake2")

            val paired = adb.pair(job.host, job.port, job.code)
            Log.i(
                TAG,
                "runPairing: pair=$paired error=${adb.lastError ?: "-"} " +
                    "elapsed=${SystemClock.elapsedRealtime() - startedAt}ms",
            )
            session.record(
                pairTick,
                if (paired) {
                    StageResult.ok("paired" to "true")
                } else {
                    StageResult.failed(
                        EscalationReasons.HOST_PAIRING_FAILED,
                        "error" to (adb.lastError ?: UNKNOWN_ERROR),
                    )
                },
            )
            if (!paired) {
                session.finish()
                return
            }

            // 配对端口与连接端口不是同一个：配对成功后必须重新发现 `adb-tls-connect` 端点。
            val connectTick = session.beginStage(EscalationStage.PREPARE)
            Log.i(TAG, "runPairing: discovering adb-tls-connect endpoint")
            val connected = adb.connectDiscovered(PAIRING_DISCOVERY_TIMEOUT_MS)
            Log.i(
                TAG,
                "runPairing: connect=$connected error=${adb.lastError ?: "-"} " +
                    "uid=${adb.uid} elapsed=${SystemClock.elapsedRealtime() - startedAt}ms",
            )
            session.record(
                connectTick,
                if (connected) {
                    StageResult.ok(
                        "source" to adb.source,
                        "uid" to adb.uid,
                        "host" to job.host,
                    )
                } else {
                    StageResult.failed(
                        connectFailureReason(),
                        "error" to (adb.lastError ?: UNKNOWN_ERROR),
                    )
                },
            )

            // 配对只负责「建链」这一件事：系统配对成功 + `adb-tls-connect`
            // 建链成功，这里立刻收尾，页面才能秒看到「配对成功」。
            //
            // 点火（拉起常驻特权进程）**必须**放在配对会话之外：它最坏要等
            // 十几秒（adb exec 10s + 等 Binder 5s）。塞在这里有两个后果：
            // ① 期间页面一直停在「等待输入配对码」，用户以为卡住；
            // ② 点火失败会把整场配对判成失败，用户明明配对成功却看到「配对失败」。
            // 点火改由页面在配对成功后单独调用 `warmUpHost` 触发，成败单独展示。
            session.finish()
        } catch (t: Throwable) {
            // 库内部任何未预料的异常都收敛成结构化原因，绝不向 Pigeon 抛。
            Log.e(TAG, "runPairing threw", t)
            session.finishWith(EscalationReasons.HOST_PAIRING_FAILED)
        } finally {
            Log.i(TAG, "runPairing done elapsed=${SystemClock.elapsedRealtime() - startedAt}ms")
            session.finish()
        }
    }

    /** 连接阶段失败时区分「设备拒绝授权」与「网络 / 发现失败」。 */
    private fun connectFailureReason(): String =
        if (adb.lastError == AUTH_FAILED_EXCEPTION) {
            EscalationReasons.HOST_AUTH_FAILED
        } else {
            EscalationReasons.HOST_DISCONNECTED
        }

    /** 查不到的会话（例如进程被重启过）回一个终态快照，避免 Dart 一直轮询。 */
    private fun unknownPairingSnapshot(sessionId: String): RunSnapshot = RunSnapshot(
        runId = sessionId,
        chain = EscalationChainId.PAYLOAD,
        phase = EscalationStage.DONE,
        steps = listOf(
            RunStep(
                stage = EscalationStage.PROBE,
                startedAtMs = System.currentTimeMillis(),
                durationMs = 0L,
                ok = false,
                reasons = listOf(EscalationReasons.PROBE_FAILED),
                evidence = mapOf("synthetic" to "true"),
            ),
        ),
        finished = true,
    )

    /** 释放注册表、断开 ADB 连接并停掉后台线程，由 [org.supass.ai_su_pass.NativeProvider] 调用。 */
    fun dispose() {
        Log.i(TAG, "dispose")
        registry.dispose()
        // 页面已销毁，通知留着也没人收结果，一并撤掉。
        pairingNotification.dismiss()
        // 只断连接，不 close()：close() 会 destroy 掉当前私钥对象。
        adb.disconnect()
        executor.shutdownNow()
    }

    /** 配对输入方式。 */
    private enum class PairingMode {
        /** Dart 已给出地址、端口与配对码（手动抄写）。 */
        MANUAL,

        /** 只等用户在通知栏输入配对码，地址与端口由 mDNS 发现。 */
        NOTIFICATION,
    }

    /** 一次配对请求的可变参数：通知模式下 host/port/code 要等用户输入后才填上。 */
    private class PairingJob(
        val session: EscalationRunSession,
        val mode: PairingMode,
        var host: String,
        var port: Int,
        var code: String,
    ) {
        /** 通知栏回传的配对码；容量 1 即够，重复输入只保留最新一条。 */
        val codeQueue = LinkedBlockingQueue<String>(1)
    }

    private companion object {
        /** logcat 过滤标签；配对链路的每一步都往这里打，出问题直接看这一条。 */
        const val TAG = "AdbEscalation"

        const val PAIRING_THREAD_NAME = "adb-pairing"
        const val MAX_PAIRING_SESSIONS = 8

        /** 整条配对流程上限：可达性 3s + 握手 + mDNS 发现 15s 的宽松余量。 */
        const val PAIRING_TIMEOUT_MS = 60_000L

        /** 通知栏模式下等用户输码的上限：要切到设置里点开配对弹窗，必须给足时间。 */
        const val NOTIFICATION_CODE_WAIT_MS = 5 * 60_000L

        /**
         * 等码期间的分片轮询粒度。
         *
         * 必须分片而不是一次 `poll(5min)`：端点发现是并行的，只有每隔一小段时间
         * 回来看一眼，才能及时把「已找到设备」反馈到通知栏。500ms 既不空转占 CPU，
         * 也足够让用户感知到变化。
         */
        const val POLL_SLICE_MS = 500L

        /** 通知栏模式的会话总上限，必须大于「等码 + 发现 + 握手」，否则会先被轮询判超时。 */
        const val NOTIFICATION_TIMEOUT_MS = NOTIFICATION_CODE_WAIT_MS + 120_000L

        /** mDNS 发现 `adb-tls-connect` 端点的等待上限。 */
        const val PAIRING_DISCOVERY_TIMEOUT_MS = 15_000L

        /**
         * 提交配对码后，等 `adb-tls-pairing` 端点的宽限。
         *
         * 正常情况下发现是并行的、端点早就有了，这里几乎立即返回；留 3 秒只是为了
         * 覆盖「对话框刚开、mDNS 还没解析完」的极短窗口。超过说明对话框已关闭。
         */
        const val ENDPOINT_GRACE_MS = 3_000L

        const val CREDENTIALS_UNAVAILABLE = "credentialsUnavailable"
        const val UNKNOWN_ERROR = "unknown"

        /** libadb 在设备未授权时抛的异常类名，用来把失败归到 `hostAuthFailed`。 */
        const val AUTH_FAILED_EXCEPTION = "AdbAuthenticationFailedException"
    }
}

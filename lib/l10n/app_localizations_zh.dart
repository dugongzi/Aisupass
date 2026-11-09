// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'AiSuPass';

  @override
  String get homeTitle => '首页';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneralSection => '通用';

  @override
  String get settingsAppearanceSection => '外观';

  @override
  String get themeModeTitle => '主题模式';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get themeColorTitle => '主题色';

  @override
  String get aiTitle => 'AI';

  @override
  String get activated => '已激活';

  @override
  String get notActivated => '未激活';

  @override
  String get rootTitle => 'ROOT';

  @override
  String get adbTitle => 'ADB';

  @override
  String get statusDetecting => '检测中';

  @override
  String adbActivatedWithType(String types) {
    return '已激活（$types）';
  }

  @override
  String get adbTypeWifi => '无线';

  @override
  String get adbTypeUsb => '有线';

  @override
  String get listSeparator => '、';

  @override
  String get refreshTooltip => '重新检测';

  @override
  String get deviceInfoTitle => '设备信息';

  @override
  String get deviceInfoCopy => '复制';

  @override
  String get deviceInfoCopied => '已复制到剪贴板';

  @override
  String get deviceInfoUnavailable => '设备信息读取失败';

  @override
  String get deviceOsVersion => '系统版本';

  @override
  String get deviceApiLevel => 'API Level';

  @override
  String get deviceModel => '设备型号';

  @override
  String get deviceCpuAbi => 'CPU 架构';

  @override
  String get deviceKernelVersion => '内核版本';

  @override
  String get deviceSecurityPatch => 'Android 安全更新';

  @override
  String get deviceBaseband => '基带版本';

  @override
  String get deviceBuildNumber => '版本号';

  @override
  String get deviceSotaVersion => 'SOTA 版本';

  @override
  String get deviceSelinux => 'SELinux';

  @override
  String get deviceAppVersion => '应用版本';

  @override
  String get settingsAiSection => 'AI';

  @override
  String get aiConfigEntrySubtitle => '管理模型服务与 API Key';

  @override
  String get aiConfigTitle => 'AI 配置';

  @override
  String get aiConfigNew => '新建配置';

  @override
  String get aiConfigCurrent => '当前';

  @override
  String get aiConfigList => '配置列表';

  @override
  String get aiConfigEmpty => '还没有 AI 配置，点击右上角 + 新建一个';

  @override
  String get aiConfigBuiltin => '内置';

  @override
  String get aiConfigBuiltinHint => '内置服务地址已锁定，填写 API Key 后可刷新获取模型';

  @override
  String get aiConfigGetKey => '获取 Key';

  @override
  String get aiConfigUse => '切换';

  @override
  String get aiConfigSwitched => '已切换配置';

  @override
  String get aiConfigDelete => '删除';

  @override
  String aiConfigDeleteConfirm(String name) {
    return '确定删除配置「$name」吗？';
  }

  @override
  String get aiConfigDeleted => '配置已删除';

  @override
  String get aiConfigEditTitle => '编辑配置';

  @override
  String get aiDelete => '删除';

  @override
  String get aiCancel => '取消';

  @override
  String get aiApiKeyMissing => '未配置 API Key';

  @override
  String get aiModelUnset => '未选择模型';

  @override
  String get aiConnectionSection => '连接服务';

  @override
  String get aiConfigName => '配置名称';

  @override
  String get aiConfigNameHint => '例如：DeepSeek 主力';

  @override
  String get aiBaseUrl => 'API 地址';

  @override
  String get aiBaseUrlHint => 'https://api.deepseek.com/v1';

  @override
  String get aiApiKey => 'API Key';

  @override
  String get aiApiKeyHint => 'sk-...';

  @override
  String get aiApiType => '接口类型';

  @override
  String get aiModelName => '模型';

  @override
  String get aiModelHint => '先获取模型列表';

  @override
  String get aiModelRequired => '请先获取模型列表';

  @override
  String get aiModelPickHint => '请从已获取的模型中选择一个';

  @override
  String get aiModelSelect => '选择模型';

  @override
  String get aiModelSearch => '搜索模型';

  @override
  String get aiModelEmpty => '没有匹配的模型';

  @override
  String get aiModelLoad => '获取模型';

  @override
  String aiModelLoadFailed(String message) {
    return '获取模型失败：$message';
  }

  @override
  String get aiAdvancedSection => '高级设置';

  @override
  String get aiAdvancedHint => '最大输出 Token 与温度；留空沿用服务端默认值';

  @override
  String get aiMaxTokens => '最大输出 Token';

  @override
  String get aiMaxTokensHint => '留空使用默认值';

  @override
  String get aiTemperature => '温度';

  @override
  String get aiTemperatureHint => '0 - 2，留空使用默认值';

  @override
  String get aiConnIdle => '保存前会自动验证连通性';

  @override
  String get aiConnTesting => '正在验证连通性…';

  @override
  String aiConnOk(int count) {
    return '连接正常，可用模型 $count 个';
  }

  @override
  String aiConnFailed(String message) {
    return '连接失败：$message';
  }

  @override
  String get aiSave => '保存';

  @override
  String get aiSaveSuccess => '配置已保存';

  @override
  String aiSaveFailed(String message) {
    return '保存失败：$message';
  }

  @override
  String get aiFieldRequired => '此项不能为空';

  @override
  String get aiInvalidUrl => '请输入以 http:// 或 https:// 开头的地址';

  @override
  String get aiTestTitle => '测试';

  @override
  String get aiTestHint => '发送一条测试消息，流式查看服务端返回。';

  @override
  String get aiTestMessageLabel => '测试消息';

  @override
  String get aiTestMessageDefault => 'Hi';

  @override
  String get aiTestSend => '发送';

  @override
  String get aiTestStateStreaming => '进行中';

  @override
  String get aiTestStateSuccess => '成功';

  @override
  String get aiTestStateFailed => '失败';

  @override
  String get aiTestStateUnknown => '未响应';

  @override
  String get aiTestDuration => '耗时';

  @override
  String get aiTestReply => '回复';

  @override
  String get aiTestError => '错误';

  @override
  String get aiTestRaw => '原始返回';

  @override
  String get aiTestCopy => '复制';

  @override
  String get aiTestCopied => '已复制到剪贴板';

  @override
  String get aiTestNoKey => '请先填写 API Key';

  @override
  String get aiTestNoModel => '请先选择模型';

  @override
  String get aiTestChunks => '段';

  @override
  String get aiTestFirstToken => '首字';

  @override
  String get aiTestNotStreamed => '非流式';

  @override
  String aiErrorAuth(int code) {
    return 'API Key 无效或无权限（HTTP $code）';
  }

  @override
  String get aiErrorNotFound => '接口地址不存在，请检查 API 地址（HTTP 404）';

  @override
  String aiErrorHttp(int code, String message) {
    return '请求失败（HTTP $code）：$message';
  }

  @override
  String aiErrorNetwork(String message) {
    return '网络请求失败：$message';
  }

  @override
  String get chatTitle => '对话';

  @override
  String get chatInputHint => '描述你的设备情况，或直接提问';

  @override
  String get chatSend => '发送';

  @override
  String get chatStop => '停止';

  @override
  String get chatNewSession => '新对话';

  @override
  String get chatReasoning => '思考过程';

  @override
  String get chatThinking => '正在思考…';

  @override
  String get chatThought => '思考完成';

  @override
  String get chatToolRunning => '执行中';

  @override
  String get chatToolSucceeded => '已完成';

  @override
  String get chatToolFailed => '执行失败';

  @override
  String get chatToolArguments => '参数';

  @override
  String get chatToolResult => '结果';

  @override
  String get chatCopied => '已复制到剪贴板';

  @override
  String get chatNoticeToolLimit => '工具调用次数已达上限，请换个问法继续';

  @override
  String get chatNoticeEmptyReply => '模型没有返回内容';

  @override
  String get chatIssueNoConfig => '请先在 AI 配置里完成设置';

  @override
  String get chatEmptyTitle => 'AI 设备助手';

  @override
  String get chatEmptyHint => '描述你的设备情况，我会读取设备信息并回答你的问题';

  @override
  String get chatSuggestionDevice => '分析我的设备环境';

  @override
  String get chatSuggestionRoot => '当前设备是否已 root';

  @override
  String get chatSuggestionPlan => '这台设备的 ADB 状态怎么样';

  @override
  String get chatSessions => '会话';

  @override
  String get chatSessionEmpty => '暂无会话';

  @override
  String get chatGenerating => '正在生成…';

  @override
  String chatSessionReady(String title) {
    return '「$title」已生成完成';
  }

  @override
  String get chatUntitled => '未命名对话';

  @override
  String get chatRename => '重命名';

  @override
  String get chatRenameHint => '输入会话名称';

  @override
  String get chatDeleteSession => '删除会话';

  @override
  String chatDeleteConfirm(String title) {
    return '删除后无法恢复，确定删除「$title」吗？';
  }

  @override
  String get chatJustNow => '刚刚';

  @override
  String chatMinutesAgo(int count) {
    return '$count 分钟前';
  }

  @override
  String chatHoursAgo(int count) {
    return '$count 小时前';
  }

  @override
  String chatDaysAgo(int count) {
    return '$count 天前';
  }

  @override
  String chatToolGroupSummary(int count) {
    return '已执行 $count 个工具';
  }

  @override
  String chatToolMoreLines(int count) {
    return '展开全部 $count 行';
  }

  @override
  String get chatToolCollapse => '收起';

  @override
  String get chatToolReadDevice => '读取设备信息';

  @override
  String get chatToolCheckRoot => '检查 ROOT 状态';

  @override
  String get chatToolCheckAdb => '检查 ADB 状态';

  @override
  String chatThoughtFor(String seconds) {
    return '思考了 ${seconds}s';
  }

  @override
  String chatUsageTokens(int count) {
    return '$count tokens';
  }

  @override
  String chatElapsed(String seconds) {
    return '耗时 ${seconds}s';
  }

  @override
  String get chatActionCopy => '复制';

  @override
  String get chatActionShare => '分享';

  @override
  String get chatActionRegenerate => '重新生成';

  @override
  String get chatShareFailed => '分享失败，请稍后重试';

  @override
  String get aiQuickPanelTitle => 'AI 助手';

  @override
  String get aiQuickChatTitle => 'AI 对话';

  @override
  String get aiQuickChatDesc => '读取设备环境并回答你的问题';

  @override
  String get aiQuickEscalationTitle => '手动提权';

  @override
  String get aiQuickEscalationDesc => '匹配本机内核载荷，手动获取 ROOT';

  @override
  String get escalationTitle => '手动提权';

  @override
  String get escalationTerminalClosed => 'shell 会话已结束，再次输入会自动重连';

  @override
  String escalationShellConnected(int uid) {
    return 'shell 已连接（uid=$uid）';
  }

  @override
  String get escalationShellDisconnected => '未连接，请先在首页完成无线调试配对';

  @override
  String get escalationInvokeFailed => '调用失败';

  @override
  String get escalationTimedOutTag => '（超时）';

  @override
  String get escalationExploitButton => '开始提权';

  @override
  String get escalationExploitStarted => '开始提权…';

  @override
  String get escalationHandoffSection => '移交 root';

  @override
  String get escalationHandoffCurrent => '移交给当前管理器';

  @override
  String escalationHandoffRunning(String manager) {
    return '正在移交给 $manager…';
  }

  @override
  String escalationHandoffManagerMissing(String manager, String package) {
    return '设备上没装 $manager：找不到它的 libksud.so（包名 $package）。请先安装 $manager，再回来重试。';
  }

  @override
  String escalationHandoffFailed(int code) {
    return '移交失败（退出码 $code）。常见原因：管理器版本与内核模块不匹配、授权被拒绝，或管理器正在升级。';
  }

  @override
  String get escalationHandoffFailedNoCode =>
      '移交失败：命令没跑起来，没拿到退出码。检查授权框是否被拒绝，或管理器是否在升级。';

  @override
  String get escalationHandoffReadManagerFailed => '移交失败：读不到已选的管理器';

  @override
  String get escalationHandoffNoManager =>
      '设备上没有可移交的 root 管理器：装好一个带 libksud.so 的管理器，用右上角胶囊选中它再试。';

  @override
  String get escalationMenuTitle => '更多操作';

  @override
  String get escalationMenuPayloadCatalog => '查看载荷清单';

  @override
  String get escalationPayloadCatalogTitle => '载荷清单';

  @override
  String escalationPayloadCatalogCount(int count) {
    return '共 $count 条';
  }

  @override
  String get escalationPayloadCatalogEmpty => '清单里没有载荷条目';

  @override
  String get escalationPayloadCatalogSearch => '搜索机型、厂商或文件名';

  @override
  String get escalationPayloadCatalogNoMatch => '没有匹配的载荷';

  @override
  String get escalationPayloadKernelUnknown => '内核未知';

  @override
  String get escalationPayloadKernelAgnostic => '不限内核';

  @override
  String escalationPayloadManualStarted(String name) {
    return '用 $name 提权…';
  }

  @override
  String get escalationPayloadConfirmTitle => '用这份载荷提权？';

  @override
  String get escalationPayloadConfirmModel => '机型';

  @override
  String get escalationPayloadConfirmVendor => '厂商';

  @override
  String get escalationPayloadConfirmKernel => '内核';

  @override
  String get escalationPayloadConfirmLibrary => '文件';

  @override
  String get escalationPayloadConfirmBody =>
      '会在设备上实际运行该载荷，可能造成系统不稳定或重启。执行前请确认机型与内核版本一致。';

  @override
  String get escalationPayloadConfirmAction => '开始提权';

  @override
  String get escalationMenuClear => '清屏';

  @override
  String get escalationDirtyFragTitle => 'DirtyFrag 提权';

  @override
  String get escalationDirtyFragFieldManager => '管理器';

  @override
  String get escalationDirtyFragFieldKernel => '内核';

  @override
  String get escalationDirtyFragFieldVrDisarm => 'VR 反制';

  @override
  String get escalationDirtyFragFieldVrAuto => '自动解析';

  @override
  String get escalationDirtyFragFieldSoftReboot => '软重启';

  @override
  String get escalationDirtyFragToggleOn => '开';

  @override
  String get escalationDirtyFragToggleOff => '关';

  @override
  String get escalationDirtyFragConfirmAction => '开始';

  @override
  String get escalationDirtyFragConfirmBody =>
      '执行期间会把 SELinux 置为宽容模式，并可能让系统短暂不稳定。重启即可恢复。';

  @override
  String get escalationDirtyFragVrDisarmTitle => 'VR 反制';

  @override
  String get escalationDirtyFragVrDisarmDesc =>
      'vivo 机型需要先拆掉内核侧的 VR 保护；其它机型不要开';

  @override
  String get escalationDirtyFragVrAutoTitle => '自动解析偏移';

  @override
  String get escalationDirtyFragVrAutoDesc => '由内核 BTF 推导函数偏移；非 vivo 机型不需要管';

  @override
  String get escalationDirtyFragSoftRebootTitle => '成功后自动软重启';

  @override
  String get escalationDirtyFragSoftRebootDesc =>
      'root 接管成功后软重启一次，Zygisk / LSPosed 模块随之生效。失败不会重启；与开机自启同开时若管理器无法完成重启，开机后可能反而没有 root';

  @override
  String get escalationDirtyFragVrOffsetLabel => '手动偏移';

  @override
  String get escalationDirtyFragVrOffsetHint => '取值范围 1-256，填错会直接中止在移交之前';

  @override
  String get escalationDirtyFragAlreadyArmed => '本次开机已经注入过，重启后才能再次执行';

  @override
  String escalationDirtyFragKernelUnsupported(String kernel) {
    return '内核 $kernel 不在支持列表内';
  }

  @override
  String get escalationDirtyFragKernelUnsupportedShort => '（不支持）';

  @override
  String get escalationDirtyFragKernelUnknown => '未知';

  @override
  String get escalationDirtyFragNoManager => '先在右上角胶囊里选中一个带 libksud.so 的管理器';

  @override
  String escalationDirtyFragRunning(String manager) {
    return '正在执行 DirtyFrag，目标管理器 $manager…';
  }

  @override
  String escalationDirtyFragSucceeded(String manager) {
    return '内核模块已加载，root 已移交给 $manager';
  }

  @override
  String get escalationDirtyFragNotVulnerable => '这台设备的内核没有该漏洞';

  @override
  String get escalationDirtyFragPatchFailed => '打补丁阶段失败，见上方输出';

  @override
  String get escalationDirtyFragVrFailed => 'VR 反制失败，已在移交前中止';

  @override
  String get escalationDirtyFragBootstrapFailed =>
      '内核模块已加载，但 bootstrap 或 ksud 阶段失败';

  @override
  String get escalationDirtyFragTimedOut => '等待终局标记超时，见上方输出';

  @override
  String escalationDirtyFragNotStarted(String reason) {
    return '原生侧未受理，原因码：$reason';
  }

  @override
  String escalationDirtyFragVrOffsetResolved(String offset) {
    return 'VR 偏移已解析：$offset';
  }

  @override
  String escalationDirtyFragHandoffFollowUp(String manager) {
    return '接管成功，接着把 root 移交给 $manager';
  }

  @override
  String get escalationDirtyFragVrExtractAction => '从镜像/OTA 提取';

  @override
  String escalationDirtyFragVrExtractProgress(String phase, int percent) {
    return '$phase $percent%';
  }

  @override
  String get escalationDirtyFragVrExtractPhaseDownload => '下载';

  @override
  String get escalationDirtyFragVrExtractPhaseUnpack => '解包';

  @override
  String get escalationDirtyFragVrExtractEmpty => '先把本地镜像路径或 OTA 直链填到上面的输入框';

  @override
  String escalationDirtyFragVrExtractFailed(String error) {
    return '提取失败：$error';
  }

  @override
  String get settingsBootAutostartSection => '提权';

  @override
  String get settingsExpertModeTitle => '专家模式';

  @override
  String get settingsExpertModeDesc => '开启后才能配置开机自动执行';

  @override
  String get settingsBootAutostartTitle => '开机自动执行 DirtyFrag';

  @override
  String get settingsBootAutostartTitleLocked => '开机自动执行 DirtyFrag（需先开专家模式）';

  @override
  String get settingsBootAutostartDesc => '重启后自动尝试注入，不用手点。失败会自动关闭这个开关';

  @override
  String get settingsBootAutostartConfirmTitle => '确认开启开机自启？';

  @override
  String get settingsBootAutostartConfirmBody =>
      '开机阶段执行失败可能导致反复重启，届时只能进 recovery 或重刷系统恢复。确认了解后再开启。';

  @override
  String get settingsBootAutostartConfirmAction => '我了解，开启';

  @override
  String get escalationCopy => '复制选区';

  @override
  String get escalationCopied => '已复制选中文本';

  @override
  String get escalationCopyEmpty => '没有选中文本：长按终端选中内容后再复制';

  @override
  String escalationOutputTruncated(int bytes) {
    return '输出过多，最早 $bytes 字节已被丢弃（只保留最新部分）';
  }

  @override
  String escalationExecStartFailed(String reason) {
    return '命令没能启动：$reason';
  }

  @override
  String get escalationExecReasonEmpty => '命令为空';

  @override
  String get escalationExecReasonNotReady => 'shell 通道未连接';

  @override
  String get escalationExecReasonStreamFailed => '开流被拒绝或连接已断开';

  @override
  String get languageTitle => '语言';

  @override
  String get errorTitle => '页面不存在';

  @override
  String errorNotFound(String location) {
    return '没有找到页面：$location';
  }

  @override
  String get errorBuildFailed => '路由构建失败';

  @override
  String get backToHome => '返回首页';

  @override
  String get commonLoadFailed => '加载失败，请稍后重试';

  @override
  String get commonRetry => '重试';

  @override
  String get shellPairingStart => '无线调试配对';

  @override
  String get shellPairingNotice => '点击后在通知栏输入设备显示的配对码，不必切回应用';

  @override
  String get shellPairingWaitingCode => '等待输入配对码…';

  @override
  String get shellPairingPairing => '正在配对…';

  @override
  String get shellPairingConnecting => '配对码已收到，正在建立连接…';

  @override
  String get shellPairingCancel => '取消';

  @override
  String get shellPairingRetry => '重试';

  @override
  String get shellConnected => 'shell 已连接';

  @override
  String shellConnectedUid(int uid) {
    return 'shell 已连接（uid=$uid）';
  }

  @override
  String get shellDisconnected => 'shell 未连接';

  @override
  String get shellCopy => '复制';

  @override
  String get shellCopied => '已复制到剪贴板';

  @override
  String get shellReasonHostAuthFailed => '配对鉴权失败，请重试';

  @override
  String get shellReasonHostDisconnected => '连接已断开';

  @override
  String get shellReasonPairingTimeout => '配对超时，请重试';

  @override
  String get shellReasonDeviceRebooted => '设备重启导致连接中断';

  @override
  String get shellReasonCancelled => '已取消配对';

  @override
  String get shellReasonHostPairingFailed => '配对失败，请重试';

  @override
  String get rootManagerPillTooltip => '选择 root 管理器';

  @override
  String get rootManagerTitle => 'Root 管理器';

  @override
  String get rootManagerCurrent => '当前';

  @override
  String get rootManagerEmpty => '没找到 root 管理器。';

  @override
  String rootManagerSwitched(String manager) {
    return '已切换到 $manager';
  }

  @override
  String rootManagerSaveFailed(String message) {
    return '保存失败：$message';
  }
}

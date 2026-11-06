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
  String get escalationDesc => '手动提权会按当前设备匹配本地内核载荷并尝试提升权限，操作不可逆，请先备份重要数据。';

  @override
  String get escalationEnvTitle => '当前环境';

  @override
  String get escalationSelinuxTitle => 'SELinux';

  @override
  String get escalationCommandLabel => '命令';

  @override
  String get escalationRunButton => '执行';

  @override
  String get escalationRunningButton => '执行中…';

  @override
  String get escalationClearButton => '清空';

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
  String get escalationNativeDirUnavailable =>
      '原生库目录不可用：当前安装没有解压 jniLibs 里的 so（需 extractNativeLibs / useLegacyPackaging 为 true）';

  @override
  String get escalationPresetLibDir => '库目录';

  @override
  String get escalationPresetInject => 'L1 注入';

  @override
  String get escalationPresetChecksum => 'so 校验';

  @override
  String get escalationExploitButton => '开始提权';

  @override
  String get escalationDeviceLabel => '设备';

  @override
  String get escalationCatalogLabel => '清单条目';

  @override
  String get escalationMatchLabel => '命中载荷';

  @override
  String get escalationMatchNone => '当前设备在清单里没有候选';

  @override
  String get escalationMatchLoading => '匹配中…';

  @override
  String get escalationMatchDegraded => '降级命中，可能不可用';

  @override
  String get escalationKernelUnknown => '未知内核';

  @override
  String get escalationHandoffSection => '移交 root';

  @override
  String get escalationHandoffDesc =>
      '提权拿到的是临时 root，重启即失效。把它交给已安装的管理器，由管理器加载内核模块后才会持久。';

  @override
  String get escalationHandoffManagerLabel => '管理器';

  @override
  String get escalationHandoffManagerKernelsu => 'KernelSU';

  @override
  String get escalationHandoffManagerSukisu => 'SukiSU Ultra';

  @override
  String get escalationHandoffButton => '移交给管理器';

  @override
  String escalationHandoffSuccess(String manager) {
    return '已移交给 $manager，请打开 $manager 确认模块已加载。';
  }

  @override
  String escalationHandoffManagerMissing(String manager, String package) {
    return '设备上没装 $manager：找不到它的 libksud.so（包名 $package）。请先安装 $manager，再回来重试。';
  }

  @override
  String get escalationHandoffNoRoot =>
      '当前没有 root：载荷没跑成功，或者临时 root 已经失效。先回到上面执行一次提权，再来移交。';

  @override
  String escalationHandoffFailed(int code) {
    return '移交失败（退出码 $code）。常见原因：管理器版本与内核模块不匹配、授权被拒绝，或管理器正在升级。';
  }

  @override
  String get escalationHandoffFailedNoCode =>
      '移交失败：命令没跑起来，没拿到退出码。检查授权框是否被拒绝，或管理器是否在升级。';

  @override
  String escalationHandoffOpenHome(String manager) {
    return '打开 $manager 下载页';
  }

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
}

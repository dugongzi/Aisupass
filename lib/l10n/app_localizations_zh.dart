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
  String get settingsAboutSection => '关于';

  @override
  String get settingsAboutVersionTitle => '版本';

  @override
  String get settingsAboutWebsiteTitle => '官网';

  @override
  String get updateCheckTitle => '检查更新';

  @override
  String updateCurrentVersion(String version, String buildNumber) {
    return '当前版本 $version（$buildNumber）';
  }

  @override
  String get updateAvailableTitle => '发现新版本';

  @override
  String updateAvailableVersion(String version) {
    return '新版本 $version';
  }

  @override
  String get updateNotesTitle => '更新内容';

  @override
  String get updateNotesFallback => '暂无更新说明';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateLater => '稍后再说';

  @override
  String get updateLatest => '已是最新版本';

  @override
  String get updateCheckFailed => '检查更新失败，请稍后重试';

  @override
  String get updateNotConfigured => '未配置更新接口';

  @override
  String get announcementTitle => '最新公告';

  @override
  String get announcementClose => '知道了';

  @override
  String get announcementTutorial => '获取教程';

  @override
  String get settingsAboutRepoTitle => '开源地址';

  @override
  String get settingsAboutLicenseTitle => '开源协议';

  @override
  String get settingsAboutLicenseSubtitle => 'GNU General Public License v3.0';

  @override
  String get openSourceLicensePageTitle => '开源许可';

  @override
  String get licenseDocProjectTitle => '本项目协议';

  @override
  String get licenseDocThirdPartyTitle => '第三方声明';

  @override
  String get licenseDocApacheTitle => 'Apache-2.0';

  @override
  String get licenseDocGpl2Title => 'GPL-2.0';

  @override
  String get settingsAboutThirdPartyTitle => '第三方开源声明';

  @override
  String get settingsAboutThirdPartySubtitle => '组件来源与许可证';

  @override
  String get openSourceLicenseLoadFailed => '协议文本加载失败';

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
  String get aiReset => '重置';

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
  String get chatNoticeAwaitingUser => '等你在上方完成操作后自动继续';

  @override
  String get chatNoticeEmptyReply => '模型没有返回内容';

  @override
  String get chatIssueNoConfig => '请先在 AI 配置里完成设置';

  @override
  String get chatEmptyTitle => 'AISUPASS';

  @override
  String get chatEmptyHint => '提出你的需求，我会给你最佳提权方案';

  @override
  String get chatSuggestionRom => '帮我找一下本机型的 ROM 包';

  @override
  String get chatSuggestionEscalation => '分析一下本机型的提权方案';

  @override
  String get chatSuggestionSupport => '获取技术支持';

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
  String get chatCodeLabel => '代码';

  @override
  String get chatCodeExpand => '展开全文';

  @override
  String chatCodeLines(int lines) {
    return '$lines 行';
  }

  @override
  String get chatImageLabel => '图片';

  @override
  String get chatToolReadDevice => '读取设备信息';

  @override
  String get chatToolCheckRoot => '检查 ROOT 状态';

  @override
  String get chatToolCheckAdb => '检查 ADB 状态';

  @override
  String get chatToolExecAdbShell => '执行 adb shell 命令';

  @override
  String get chatToolRequestAdbPairing => '请求无线调试配对';

  @override
  String get chatToolReadStellarStatus => '查询 Stellar 服务状态';

  @override
  String get chatToolWebSearch => '联网搜索';

  @override
  String get chatToolOpenInBrowser => '用浏览器打开网页';

  @override
  String get chatToolFetchWebPage => '获取网页源码';

  @override
  String get chatBrowserPanelTitle => '网页';

  @override
  String get chatBrowserOpen => '用浏览器打开';

  @override
  String get chatBrowserOpenInApp => '在应用内打开';

  @override
  String get chatBrowserBack => '后退';

  @override
  String get chatBrowserForward => '前进';

  @override
  String get chatBrowserReload => '刷新';

  @override
  String get chatBrowserHandoffSource => '把页面交给 AI';

  @override
  String get chatBrowserHandoffUrl => '只回传网址';

  @override
  String get chatBrowserHandoffFile => '选择已下载文件';

  @override
  String get chatBrowserDesktopUnsupported => '桌面端没有内置浏览器，请用系统浏览器打开后把文件选回来';

  @override
  String get chatBrowserEmptyUrl => '没有可打开的网址';

  @override
  String get chatBrowserOpenAgain => '再次打开';

  @override
  String get chatBrowserCopyLink => '复制链接';

  @override
  String get chatBrowserLinkCopied => '链接已复制';

  @override
  String get chatBrowserOpenFailed => '无法打开浏览器，可复制链接手动访问';

  @override
  String get chatBrowserLoadFailed => '页面加载失败';

  @override
  String get chatBrowserLoadTimeout =>
      '加载超时：站点可能拒绝内置 WebView，或需要登录、验证后才能访问，可改用系统浏览器';

  @override
  String get chatBrowserRetry => '重试';

  @override
  String chatBrowserLoadingPercent(int percent) {
    return '载入中 $percent%';
  }

  @override
  String get chatAdbPanelTitle => '无线调试连接';

  @override
  String get chatAdbPairingPending => '已打开系统无线调试，完成配对后返回即可';

  @override
  String get chatAdbPairingFailed => '配对未完成';

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
  String get chatPromptTitle => '常用提示词';

  @override
  String get chatPromptLoading => '正在读取提示词…';

  @override
  String get chatPromptEmpty => '还没有常用提示词，点击右上角 + 新建一条';

  @override
  String get chatPromptAdd => '新建提示词';

  @override
  String get chatPromptEdit => '编辑提示词';

  @override
  String get chatPromptInsert => '插入';

  @override
  String get chatPromptDelete => '删除提示词';

  @override
  String chatPromptDeleteConfirm(String title) {
    return '确定删除「$title」吗？';
  }

  @override
  String get chatPromptSaved => '提示词已保存';

  @override
  String get chatPromptDeleted => '提示词已删除';

  @override
  String get chatPromptName => '标题';

  @override
  String get chatPromptNameHint => '例如：分析设备环境';

  @override
  String get chatPromptContent => '内容';

  @override
  String get chatPromptContentHint => '输入要发送给 AI 的提示词';

  @override
  String get chatPromptContentRequired => '提示词内容不能为空';

  @override
  String get chatAttachTitle => '添加附件';

  @override
  String get chatAttachImage => '选择图片';

  @override
  String get chatAttachText => '选择文本文件';

  @override
  String get chatAttachBinary => '选择镜像/压缩包';

  @override
  String chatAttachNoPath(String name) {
    return '无法获取 $name 的本地路径';
  }

  @override
  String get chatAttachUnsupported => '不支持该文件类型';

  @override
  String chatAttachTooLarge(String name) {
    return '文件过大：$name';
  }

  @override
  String get chatAttachFailed => '添加附件失败';

  @override
  String chatAttachLimit(int count) {
    return '单条消息最多添加 $count 个附件';
  }

  @override
  String get chatManualTitle => 'AI 能力手册';

  @override
  String get chatManualSubtitle => '助手在对话中可以调用的本地能力与工具';

  @override
  String get chatManualConfirmHint => '执行类工具在动作前会先征求你的确认；只读工具可直接调用';

  @override
  String get chatToolDesc_get_device_info =>
      '读取机型、系统版本、内核、补丁、基带、ABI 与 SELinux 等设备信息';

  @override
  String get chatToolDesc_get_root_status => '检查当前进程是否已获得 ROOT 权限';

  @override
  String get chatToolDesc_get_adb_status => '检查 USB 与无线调试开关是否打开';

  @override
  String get chatToolDesc_adb_shell_exec =>
      '在已连接的 adb shell（uid 2000）执行一条命令，返回退出码与输出';

  @override
  String get chatToolDesc_adb_pairing_request => '打开无线调试配对面板，引导完成 adb 配对';

  @override
  String get chatToolDesc_stellar_service_status => '读取 Stellar 特权服务的可用状态与运行身份';

  @override
  String get chatToolDesc_web_search => '用 Bing 搜索公开网络，返回标题、链接与摘要';

  @override
  String get chatToolDesc_fetch_web_page => '抓取指定网页的原始源码，同时返回状态码与内容类型';

  @override
  String get chatToolDesc_open_in_browser => '用应用内浏览器打开网页，可回传网址或页面源码';

  @override
  String get chatToolDesc_escalation_get_device_identity => '读取提权需要的设备与内核标识';

  @override
  String get chatToolDesc_escalation_list_payloads => '列出内置提权载荷清单';

  @override
  String get chatToolDesc_escalation_resolve_payload => '按机型与内核匹配合适的提权载荷';

  @override
  String get chatToolDesc_escalation_list_root_managers => '列出设备上可用的 ROOT 管理器';

  @override
  String get chatToolDesc_escalation_get_selected_root_manager =>
      '读取当前选中的 ROOT 管理器';

  @override
  String get chatToolDesc_escalation_run_payload => '执行指定的提权载荷';

  @override
  String get chatToolDesc_escalation_run_payload_by_id => '按编号执行提权载荷';

  @override
  String get chatToolDesc_escalation_handoff_root => '把已取得的 root 移交给指定管理器';

  @override
  String get chatToolDesc_escalation_select_root_manager =>
      '选择后续交接使用的 ROOT 管理器';

  @override
  String get chatToolDesc_ghost_key_preflight =>
      'GhostKey 预检：ADB、内核、配置与原生库是否就绪';

  @override
  String get chatToolDesc_ghost_key_get_run_defaults => '读取 GhostKey 运行默认参数';

  @override
  String get chatToolDesc_ghost_key_save_run_defaults => '保存 GhostKey 运行默认参数';

  @override
  String get chatToolDesc_ghost_key_start => '启动一次 GhostKey 临时 root 流程';

  @override
  String get chatToolDesc_ghost_key_status => '查询 GhostKey 当前执行状态';

  @override
  String get chatToolDesc_ghost_key_cancel => '中止正在进行的 GhostKey 流程';

  @override
  String get chatToolDesc_ghost_lock_preflight =>
      'GhostLock 预检：ADB、uid、seccomp、内核与配置匹配情况';

  @override
  String get chatToolDesc_ghost_lock_start => '启动一次 GhostLock 提权，返回会话 id';

  @override
  String get chatToolDesc_ghost_lock_status => '读取 GhostLock 运行会话的最新快照';

  @override
  String get chatToolDesc_ghost_lock_cancel => '停止读取当前 GhostLock 运行，不终止设备进程';

  @override
  String get chatToolDesc_ghost_lock_list_imported_profiles =>
      '列出已导入的 GhostLock 配置文件';

  @override
  String get chatToolDesc_ghost_lock_list_builtin_releases =>
      '列出内置的 GhostLock 发行版本';

  @override
  String get chatToolDesc_ghost_lock_read_imported_profile => '读取某个已导入配置文件的详情';

  @override
  String get chatToolDesc_ghost_lock_get_probe_progress => '查询配置解析进度';

  @override
  String get chatToolDesc_ghost_lock_list_extracted_images => '列出从镜像包中提取出的分区';

  @override
  String get chatToolDesc_ghost_lock_get_profile_config => '读取当前配置文件的完整字段';

  @override
  String get chatToolDesc_ghost_lock_get_active_source => '读取当前生效的配置来源';

  @override
  String get chatToolDesc_ghost_lock_probe_profile => '解析内核镜像并生成配置档';

  @override
  String get chatToolDesc_ghost_lock_save_profile => '保存当前配置档';

  @override
  String get chatToolDesc_ghost_lock_import_profile_text => '导入一段配置文本作为新配置档';

  @override
  String get chatToolDesc_ghost_lock_rename_imported_profile => '重命名已导入的配置档';

  @override
  String get chatToolDesc_ghost_lock_remove_imported_profile => '删除已导入的配置档';

  @override
  String get chatToolDesc_ghost_lock_export_imported_profile => '导出已导入的配置档文本';

  @override
  String get chatToolDesc_ghost_lock_convert_imported_profile => '转换配置档的格式';

  @override
  String get chatToolDesc_ghost_lock_export_local_file => '把配置档导出为本地文件';

  @override
  String get chatToolDesc_ghost_lock_update_general_fields => '修改配置档的常规字段';

  @override
  String get chatToolDesc_ghost_lock_update_advanced_fields => '修改配置档的高级字段';

  @override
  String get chatToolDesc_ghost_lock_update_route => '修改配置档的路由信息';

  @override
  String get chatToolDesc_ghost_lock_update_fallback => '修改配置档的回退项';

  @override
  String get chatToolDesc_ghost_lock_reset_profile => '把配置档重置为默认值';

  @override
  String get chatToolDesc_ghost_lock_select_source => '选择生效的配置来源';

  @override
  String get chatToolDesc_ghost_lock_render_profile => '渲染并预览配置档';

  @override
  String get chatToolDesc_ghost_lock_export_profile => '导出当前配置档';

  @override
  String get chatToolDesc_ghost_lock_save_modified_profile => '保存修改后的配置档';

  @override
  String get chatToolDesc_ghost_lock_overwrite_profile => '覆盖写入现有配置档';

  @override
  String get chatToolDesc_ghost_lock_begin_edit_session => '开始一次配置编辑会话';

  @override
  String get chatToolDesc_ghost_lock_reload_edit_session => '重新加载编辑会话';

  @override
  String get chatToolDesc_ghost_lock_get_edit_session => '读取编辑会话的当前草稿';

  @override
  String get chatToolDesc_ghost_lock_commit_edit_session => '提交编辑会话中的修改';

  @override
  String get chatToolDesc_ghost_lock_save_edit_session_in_place => '就地保存编辑会话';

  @override
  String get chatToolDesc_ghost_lock_save_edit_session_as_new => '把编辑会话另存为新配置档';

  @override
  String get chatToolDesc_ghost_lock_export_edit_session => '导出编辑会话的内容';

  @override
  String get chatToolDesc_ghost_lock_end_edit_session => '结束编辑会话';

  @override
  String get chatToolDesc_dirty_frag_is_armed => '检查本次开机是否已注入过 DirtyFrag';

  @override
  String get chatToolDesc_dirty_frag_get_run_defaults => '读取 DirtyFrag 运行默认参数';

  @override
  String get chatToolDesc_dirty_frag_get_expert_mode => '查询 DirtyFrag 专家模式是否开启';

  @override
  String get chatToolDesc_dirty_frag_get_boot_autostart =>
      '查询 DirtyFrag 开机自启是否开启';

  @override
  String get chatToolDesc_dirty_frag_get_vr_progress => '查询 VR 偏移推导进度';

  @override
  String get chatToolDesc_dirty_frag_save_run_defaults => '保存 DirtyFrag 运行默认参数';

  @override
  String get chatToolDesc_dirty_frag_set_expert_mode => '开关 DirtyFrag 专家模式';

  @override
  String get chatToolDesc_dirty_frag_set_boot_autostart => '开关 DirtyFrag 开机自启';

  @override
  String get chatToolDesc_dirty_frag_start => '启动 DirtyFrag 提权';

  @override
  String get chatToolDesc_dirty_frag_status => '查询 DirtyFrag 当前状态';

  @override
  String get chatToolDesc_dirty_frag_cancel => '中止 DirtyFrag 运行';

  @override
  String get chatToolDesc_dirty_frag_derive_vr_offset => '从镜像包或 OTA 推导 VR 偏移';

  @override
  String get chatToolDesc_kernel_profile_list_imported => '列出已导入的内核配置文件';

  @override
  String get chatToolDesc_kernel_profile_list_builtin => '列出内置的内核配置文件';

  @override
  String get chatToolDesc_kernel_profile_read_content => '读取内核配置文件的完整内容';

  @override
  String get chatToolDesc_kernel_profile_read_editor => '读取内核配置编辑器的当前内容';

  @override
  String get chatToolDesc_kernel_profile_get_active_selection => '读取当前生效的内核配置';

  @override
  String get chatToolDesc_kernel_profile_import_start => '开始导入并解析内核镜像';

  @override
  String get chatToolDesc_kernel_profile_import_status => '查询内核导入进度';

  @override
  String get chatToolDesc_kernel_profile_import_cancel => '取消内核导入';

  @override
  String get chatToolDesc_kernel_profile_remove => '删除内核配置文件';

  @override
  String get chatToolDesc_kernel_profile_save_editor => '保存编辑器内容';

  @override
  String get chatToolDesc_kernel_profile_save_editor_as => '把编辑器内容另存为新配置';

  @override
  String get chatToolDesc_kernel_profile_render_editor => '渲染并预览编辑器内容';

  @override
  String get chatToolDesc_kernel_profile_select_user_profile => '选择生效的用户配置';

  @override
  String get chatToolDesc_kernel_profile_select_builtin_release => '选择生效的内置发行版';

  @override
  String get chatToolDesc_ota_list_catalog => '列出指定厂商的内置 OTA 包清单';

  @override
  String get chatToolDesc_run_log_list_runs => '按时间倒序列出历史运行日志';

  @override
  String get chatToolDesc_run_log_read_body => '读取某个运行日志的正文';

  @override
  String get chatToolDesc_run_log_export_all => '导出全部运行日志';

  @override
  String get chatToolDesc_run_log_diagnose => '诊断失败的运行日志并给出原因';

  @override
  String get chatToolDesc_run_log_delete => '删除某个运行日志';

  @override
  String get chatToolDesc_run_log_clear_all => '清空全部运行日志，保留正在写入的一份';

  @override
  String get chatToolDesc_local_file_inspect =>
      '在应用进程内检查附件的大小与头部格式，识别 payload、boot、zip 等容器类型';

  @override
  String get chatManualGroupDevice => '设备与环境';

  @override
  String get chatManualGroupDeviceDesc => '读取机型、系统版本、内核、ROOT 状态与 ADB 开关';

  @override
  String get chatManualGroupAdb => 'ADB 调试';

  @override
  String get chatManualGroupAdbDesc => '执行 adb shell 命令，发起无线调试配对';

  @override
  String get chatManualGroupStellar => 'Stellar 特权服务';

  @override
  String get chatManualGroupStellarDesc => '查询 Stellar 特权服务的可用状态与身份';

  @override
  String get chatManualGroupWeb => '网络与浏览';

  @override
  String get chatManualGroupWebDesc => '联网搜索、抓取网页源码、用内置浏览器打开页面';

  @override
  String get chatManualGroupEscalation => '手动提权';

  @override
  String get chatManualGroupEscalationDesc => '匹配内核载荷并执行提权，把 root 移交给指定管理器';

  @override
  String get chatManualGroupGhostKey => 'GhostKey 提权';

  @override
  String get chatManualGroupGhostKeyDesc => '预检并执行 GhostKey 临时 root 流程';

  @override
  String get chatManualGroupGhostLock => 'GhostLock 提权';

  @override
  String get chatManualGroupGhostLockDesc => '预检并执行 GhostLock 提权流程';

  @override
  String get chatManualGroupGhostLockProfile => 'GhostLock 配置';

  @override
  String get chatManualGroupGhostLockProfileDesc =>
      '读取、编辑、解析、导入导出 GhostLock 配置档';

  @override
  String get chatManualGroupDirtyFrag => 'DirtyFrag 提权';

  @override
  String get chatManualGroupDirtyFragDesc => '内核漏洞利用、VR 解除与偏移推导';

  @override
  String get chatManualGroupKernel => '内核配置';

  @override
  String get chatManualGroupKernelDesc => '导入解析内核镜像，管理配置文件并选择生效项';

  @override
  String get chatManualGroupOta => 'OTA 素材';

  @override
  String get chatManualGroupOtaDesc => '查询历史 OTA 清单，作为内核镜像来源';

  @override
  String get chatManualGroupRunLog => '运行日志';

  @override
  String get chatManualGroupRunLogDesc => '读取、诊断、导出与清理提权运行日志';

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
  String get escalationTerminalTitle => '终端';

  @override
  String get escalationTerminalEntry => '打开终端';

  @override
  String get escalationToolSection => '提权方式';

  @override
  String get escalationKernelSection => '内核配置';

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
  String get escalationExploitStarted => '自动匹配载荷提权…';

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
    return '设备上没装 $manager：找不到它自带的 ksud（包名 $package）。请先安装 $manager，再回来重试。';
  }

  @override
  String get escalationHandoffNoSu => '设备上没有 su，先跑提权拿到临时 root 再移交。';

  @override
  String escalationHandoffFailed(int code) {
    return '移交失败（退出码 $code）';
  }

  @override
  String get escalationHandoffFailedNoCode => '移交失败：命令没跑起来，没拿到退出码。';

  @override
  String get escalationHandoffReadManagerFailed => '移交失败：读不到已选的管理器';

  @override
  String get escalationHandoffNoManager =>
      '设备上没有可移交的 root 管理器：装好一个自带 ksud 的管理器，用右上角胶囊选中它再试。';

  @override
  String get escalationMenuTitle => '更多操作';

  @override
  String get escalationPayloadRootTitle => '载荷提权';

  @override
  String get escalationPayloadAutoMatch => '自动匹配当前设备';

  @override
  String get escalationPayloadAutoMatchDesc => '按机型与内核自动挑一条';

  @override
  String get escalationPayloadImport => '导入自定义载荷';

  @override
  String get escalationPayloadImportTitle => '导入自定义载荷';

  @override
  String get escalationPayloadImportPickFile => '选择载荷文件';

  @override
  String get escalationPayloadImportName => '显示名称';

  @override
  String get escalationPayloadImportNameHint => '留空则用文件名';

  @override
  String get escalationPayloadImportMode => '运行方式';

  @override
  String get escalationPayloadImportModeHelper => '助手加载';

  @override
  String get escalationPayloadImportModeStandalone => '直接执行';

  @override
  String get escalationPayloadImportModeHelperDesc => '适用于 .so 载荷，由内置执行助手加载运行';

  @override
  String get escalationPayloadImportModeStandaloneDesc =>
      '适用于自带入口的可执行文件，附加参数后直接运行';

  @override
  String get escalationPayloadImportArguments => '启动参数';

  @override
  String get escalationPayloadImportArgumentsHint => '可留空';

  @override
  String get escalationPayloadImportConfirm => '导入';

  @override
  String get escalationPayloadImportNeedFile => '请先选择载荷文件';

  @override
  String get escalationPayloadImportFileMissing => '本机文件不存在';

  @override
  String get escalationPayloadImportFileEmpty => '文件为空';

  @override
  String get escalationPayloadImportPushFailed => '推送到设备失败';

  @override
  String get escalationPayloadDelete => '删除';

  @override
  String get escalationPayloadDeleteConfirmTitle => '删除自定义载荷？';

  @override
  String escalationPayloadDeleteConfirmBody(String name) {
    return '将从设备上删掉「$name」的文件，并从列表里移除。';
  }

  @override
  String get escalationPayloadDeleteFailed => '删除失败';

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
  String get escalationPayloadNoCandidate => '当前设备在载荷清单里没有候选';

  @override
  String get escalationPayloadLibraryDirUnavailable =>
      '原生库目录不可用：so 没有解压到 nativeLibraryDir';

  @override
  String get escalationPayloadHelperMissing => '执行助手缺失或不可执行';

  @override
  String get escalationPayloadFileMissing => '载荷文件缺失';

  @override
  String get escalationPayloadArgumentsUnresolved => '载荷参数无法在设备上补齐';

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
  String get escalationDirtyFragVrDisarmDesc => '仅 vivo 机型需要，先移除内核侧 VR 保护';

  @override
  String get escalationDirtyFragVrAutoTitle => '自动解析偏移';

  @override
  String get escalationDirtyFragVrAutoDesc => '从内核 BTF 推导偏移，仅在 VR 反制开启时可用';

  @override
  String get escalationDirtyFragSoftRebootTitle => '成功后自动软重启';

  @override
  String get escalationDirtyFragSoftRebootDesc =>
      '成功后重启一次，让模块生效；与开机自启同开时，重启失败可能导致开机无 root';

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
  String get escalationDirtyFragNoManager => '先在右上角胶囊里选中一个自带 ksud 的管理器';

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
    return '原生侧未受理：$reason';
  }

  @override
  String escalationDirtyFragVrOffsetResolved(String offset) {
    return 'VR 偏移已解析：$offset';
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
  String get escalationGhostKeyTitle => 'GhostKey 提权';

  @override
  String escalationGhostKeyRunning(String manager) {
    return '开始 GhostKey 提权$manager';
  }

  @override
  String get escalationGhostKeyNoAdb => 'adb 未连接';

  @override
  String escalationGhostKeySucceeded(String manager) {
    return 'GhostKey 完成，临时 root 已就绪$manager';
  }

  @override
  String get escalationGhostKeyDegraded => 'GhostKey 完成，但线性映射置信度偏低';

  @override
  String get escalationGhostKeyCalibFailed => 'KASLR slide 校准失败';

  @override
  String get escalationGhostKeyPageOffsetFailed => '线性映射基址校准失败';

  @override
  String get escalationGhostKeyInjectFailed => '注入失败：rootd 未就绪';

  @override
  String get escalationGhostKeyVerifyFailed => '临时 root 通道校验失败';

  @override
  String get escalationGhostKeyKsuFailed => '临时 root 已就绪，移交给管理器失败';

  @override
  String get escalationGhostKeyTimedOut => 'GhostKey 超时';

  @override
  String escalationGhostKeyNotStarted(String reason) {
    return 'GhostKey 未启动：$reason';
  }

  @override
  String get escalationGhostKeyReasonAlreadyRunning => '已有任务在运行';

  @override
  String get escalationGhostKeyReasonNoAdb => 'ADB 未连接';

  @override
  String get escalationGhostKeyReasonNotShell => 'shell 身份不是 2000';

  @override
  String get escalationGhostKeyReasonSeccomp => 'shell 带 seccomp 过滤';

  @override
  String get escalationGhostKeyReasonMissingBinary => '载荷文件缺失';

  @override
  String get escalationGhostKeyReasonNoProfile => '当前内核版本没有对应 profile';

  @override
  String get escalationGhostKeyReasonBadRequest => '请求参数不合法';

  @override
  String escalationReasonWithCode(String label, String code) {
    return '$label（$code）';
  }

  @override
  String get escalationDirtyFragReasonAlreadyArmed => '已有驻留标记';

  @override
  String get escalationDirtyFragReasonBusy => '有任务正在运行';

  @override
  String get escalationDirtyFragReasonNoIpSec => '系统没有 IpSec 服务';

  @override
  String get escalationDirtyFragReasonMissingBinary => '管理器或载荷文件缺失';

  @override
  String get escalationDirtyFragReasonStagingFailed => '落位或启动失败';

  @override
  String get escalationDirtyFragReasonBadRequest => '请求参数不合法';

  @override
  String get escalationGhostKeyFailed => 'GhostKey 失败';

  @override
  String get escalationGhostKeyConfirmTitle => '确认 GhostKey 提权';

  @override
  String get escalationGhostKeyConfirmRisk =>
      '该操作会校准内核映射并注入 rootd，过程中设备可能短暂不可用。';

  @override
  String get escalationGhostKeyConfirmRun => '开始提权';

  @override
  String get escalationGhostKeyFieldManager => '管理器';

  @override
  String get escalationGhostKeyFieldRelease => '内核版本';

  @override
  String get escalationGhostKeyFieldShellUid => 'shell uid';

  @override
  String get escalationGhostKeyFieldSeccomp => 'seccomp';

  @override
  String get escalationGhostKeyFieldProfile => 'profile 命中';

  @override
  String get escalationGhostKeyFieldFallback => '接受降级偏移';

  @override
  String get escalationGhostKeyValueUnknown => '未知';

  @override
  String get escalationGhostKeyValueNone => '未选择';

  @override
  String get escalationGhostKeyValueYes => '是';

  @override
  String get escalationGhostKeyValueNo => '否';

  @override
  String get escalationGhostKeyToggleOn => '开';

  @override
  String get escalationGhostKeyToggleOff => '关';

  @override
  String get escalationGhostKeyProgressTitle => '进度';

  @override
  String escalationGhostKeyDurationSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get escalationGhostKeyStageCalibAName => 'KASLR slide 校准';

  @override
  String get escalationGhostKeyStageCalibBName => '线性映射校准';

  @override
  String get escalationGhostKeyStageInjectName => '注入 rootd';

  @override
  String get escalationGhostKeyStageVerifyName => '校验临时 root';

  @override
  String get escalationGhostKeyStageKsuName => '移交给管理器';

  @override
  String get escalationGhostKeyStageCalibAHint => '定位内核基址';

  @override
  String get escalationGhostKeyStageCalibBHint => '校准线性映射';

  @override
  String get escalationGhostKeyStageInjectHint => '注入并启动 rootd';

  @override
  String get escalationGhostKeyStageVerifyHint => '校验 root 通道';

  @override
  String get escalationGhostKeyStageKsuHint => '正在移交给管理器';

  @override
  String get escalationGhostLockTitle => 'GhostLock 提权';

  @override
  String get escalationGhostLockFieldManager => '管理器';

  @override
  String get escalationGhostLockFieldRelease => '内核';

  @override
  String get escalationGhostLockFieldProfile => '内核表';

  @override
  String get escalationGhostLockFieldRoute => '路由';

  @override
  String get escalationGhostLockFieldSeccomp => 'Seccomp';

  @override
  String get escalationGhostLockFieldKsud => 'ksud';

  @override
  String get escalationGhostLockValueYes => '有';

  @override
  String get escalationGhostLockValueNo => '无';

  @override
  String get escalationGhostLockValueNone => '无';

  @override
  String get escalationGhostLockValueUnknown => '未知';

  @override
  String get escalationGhostLockSafeModeTitle => '安全模式';

  @override
  String get escalationGhostLockSafeModeDesc =>
      '执行前给 /data/adb/modules 下的模块打 disable';

  @override
  String get escalationGhostLockConfirmRun => '开始';

  @override
  String get escalationGhostLockConfirmRisk =>
      '执行期间会把 SELinux 置为宽容模式，失败时可能停在宽容状态。重启即可恢复。';

  @override
  String get escalationGhostLockNoAdb => '无线调试未连接，先在设置里配对';

  @override
  String get escalationGhostLockMissingBinary =>
      '安装包内缺少 libghostlock.so，重新安装应用';

  @override
  String escalationGhostLockNoProfile(String release) {
    return '内核表里没有 $release 这一型，也不做近似匹配';
  }

  @override
  String escalationGhostLockProfileInvalid(String reason) {
    return '内核表解析失败：$reason';
  }

  @override
  String escalationGhostLockProfileMismatch(String profile, String device) {
    return '选中的内核表声明内核为 $profile，当前设备是 $device，两者不一致，不会套用';
  }

  @override
  String escalationGhostLockProfileMissing(String name) {
    return '选中的文档 $name 不存在，可能已被删除或重命名';
  }

  @override
  String get escalationGhostLockSeccompFiltered =>
      '当前 shell 带有 seccomp 过滤，这条链路无法清掉它';

  @override
  String escalationGhostLockRunning(String manager) {
    return '正在执行 GhostLock$manager…';
  }

  @override
  String escalationGhostLockSucceeded(String manager) {
    return '内核模块已加载，已交由$manager接管';
  }

  @override
  String get escalationGhostLockAlreadyRooted => '内核模块本次开机已接管，未重复执行';

  @override
  String get escalationGhostLockTempRootOnly => '拿到临时 root，但内核模块尚未加载';

  @override
  String get escalationGhostLockSeccompBlocked =>
      '临时的 root 子进程仍带 seccomp 过滤，内核模块无法加载';

  @override
  String get escalationGhostLockKsuFailed => '内核模块加载失败，见上方 ksud 输出';

  @override
  String get escalationGhostLockW1Failed => '关闭 SELinux 失败，见上方输出';

  @override
  String get escalationGhostLockW2Failed => '写凭据阶段失败，见上方输出';

  @override
  String get escalationGhostLockW3Failed => '清 seccomp 阶段失败，见上方输出';

  @override
  String get escalationGhostLockReleaseMismatch => '内核表与设备内核不一致，原生已退出';

  @override
  String get escalationGhostLockDirtyRace => '竞争进入脏状态，原生已自行停止进程';

  @override
  String get escalationGhostLockTimedOut => '等待终局信号超时，已停止读取；设备侧可能仍在执行';

  @override
  String escalationGhostLockNotStarted(String reason) {
    return '原生侧未受理，原因码：$reason';
  }

  @override
  String get escalationGhostLockFailed => '未拿到可识别的终局标记，见上方输出';

  @override
  String escalationGhostLockFailureCode(String code) {
    return '原生诊断：$code';
  }

  @override
  String get escalationGhostLockFailureDeviceDisconnected =>
      '与设备的连接中断（多半是设备重启了），已停止跟踪；设备恢复后重试';

  @override
  String get escalationGhostLockFailureLaunch => '原生进程没能拉起，见上方 shell 输出';

  @override
  String get escalationGhostLockFailureProfileWrite =>
      '内核表写入设备临时目录失败，请确认无线调试仍然可用';

  @override
  String get escalationGhostLockFailureNotStarted => '原生进程启动后没有任何输出，已停止跟踪';

  @override
  String get escalationGhostLockStop => '停止读取';

  @override
  String get escalationGhostLockProfileEdit => '编辑内核表';

  @override
  String get escalationGhostLockProfileTabGeneral => '通用';

  @override
  String get escalationGhostLockProfileTabRoute => '路由';

  @override
  String get escalationGhostLockProfileTabAdvanced => '高级';

  @override
  String get escalationGhostLockProfileNotProvided => '未提供';

  @override
  String get escalationGhostLockProfileInvalidField => '该值不满足偏移规则';

  @override
  String get escalationGhostLockProfileOverridden => '已修改';

  @override
  String get escalationGhostLockProfileWriteBack => '保存';

  @override
  String get escalationGhostLockProfileWrittenBack => '已写入当前文件';

  @override
  String get escalationGhostLockProfileWriteFailed => '写入失败';

  @override
  String get escalationGhostLockProfileRejected => '这个值会让配置无法解析，已回滚';

  @override
  String get escalationGhostLockProfileSaved => '已保存';

  @override
  String escalationGhostLockProfileSavedAsNew(String name) {
    return '已另存为 $name';
  }

  @override
  String get escalationGhostLockProfileExport => '导出为文件';

  @override
  String get escalationGhostLockProfileSaveAs => '另存为我的配置';

  @override
  String get escalationGhostLockProfileRouteAuto => '按 profile 声明';

  @override
  String get escalationGhostLockProfileRouteLabel => '路由';

  @override
  String get escalationGhostLockProfileRouteCurrent => '当前生效';

  @override
  String get escalationGhostLockProfileFallbackLabel => '回退';

  @override
  String get escalationGhostLockProfileFallbackNone => '关闭回退';

  @override
  String get escalationGhostLockProfileFallbackDeclared => '跟随配置声明';

  @override
  String get escalationGhostLockProfileNoProfile => '这个内核没有可编辑的 profile';

  @override
  String get escalationGhostLockProfileNoWritableDoc =>
      '没有可写回的目标文档，请先用「另存为我的配置」创建一份';

  @override
  String get escalationGhostLockProfileSourceLabel => '生效来源';

  @override
  String get escalationGhostLockProfileSourceDevice => '设备内置表';

  @override
  String get escalationGhostLockProfileSourceBuiltin => '内置表';

  @override
  String get escalationGhostLockProfileSourceUser => '我的配置';

  @override
  String escalationGhostLockProfileOverriddenCount(int count) {
    return '已修改 $count 项';
  }

  @override
  String get escalationGhostLockProfileTabGeneralHint =>
      '执行参数。改完离开输入框即生效，下次运行 GhostLock 用新值；不需要另外保存。';

  @override
  String get escalationGhostLockProfileTabRouteHint =>
      '选择注入路径。点选立即生效；三条路由的几何常量不同，切换后高级页的字段会跟着变。';

  @override
  String get escalationGhostLockProfileRouteGeometryHint =>
      '每条路由的几何常量（如 waiter_shift、compact_waiter、waiter_off）只在从镜像生成该路由时才会写入。切到一份表里没生成过的路由，这些字段会是空值，运行时可能拿不到参数。要换路由，建议重新解析镜像并在解析时指定路由。';

  @override
  String get escalationGhostLockProfileTabAdvancedHint =>
      '结构与偏移字段。改动立即生效；未提供的字段显示为空，填值后才会写入。';

  @override
  String get escalationGhostLockProfileApplied => '已应用';

  @override
  String get escalationGhostLockProfileWriteBackHint => '生效配置写回本地；文档直接覆盖';

  @override
  String get escalationGhostLockProfileWriteBackDisabled => '内置表不可改写，请用「另存为」';

  @override
  String get escalationGhostLockProfileSaveAsHint => '存成一份新的用户文档，原文件不动';

  @override
  String get escalationGhostLockProfileExportHint => '导出 conf 到系统文件';

  @override
  String get escalationGhostLockProfileSelectSearch => '按 release 过滤';

  @override
  String get escalationGhostLockProfileSelectTemplates => '参考模板';

  @override
  String get escalationGhostLockImportTitle => '导入内核表';

  @override
  String escalationGhostLockImportFailed(String reason) {
    return '提取失败：$reason';
  }

  @override
  String get escalationGhostLockImportOverwrite => '已有同内核的条目，覆盖吗？';

  @override
  String get escalationGhostLockImportOverwriteAction => '覆盖';

  @override
  String escalationGhostLockImportDone(String release) {
    return '已生成 $release 的内核表';
  }

  @override
  String get escalationGhostLockImportedEmpty => '还没有导入任何内核表';

  @override
  String get escalationGhostLockImportedRemove => '删除';

  @override
  String get escalationGhostLockImportedParseError => '文件无法解析';

  @override
  String get escalationGhostLockImportedRename => '重命名';

  @override
  String get escalationGhostLockImportedRenameHint => '新文件名';

  @override
  String get escalationGhostLockImportedExport => '导出';

  @override
  String get escalationGhostLockImportedEdit => '编辑';

  @override
  String get escalationGhostLockImportedExported => '已导出';

  @override
  String get escalationGhostLockMoreActions => '更多操作';

  @override
  String get escalationGhostLockImportText =>
      '导入现成配置（conf / hocon / json / txt，可多选）';

  @override
  String get escalationGhostLockImportUnsupported =>
      '没有可导入的文件：仅支持 conf / hocon / json / txt，且需为 UTF-8 文本';

  @override
  String get settingsGhostKeySection => 'GhostKey';

  @override
  String get settingsGhostKeyAcceptFallbackTitle => '接受降级偏移';

  @override
  String get settingsGhostKeyAcceptFallbackDesc => '线性映射置信度偏低时继续注入，不中止';

  @override
  String get settingsBootAutostartSection => '提权';

  @override
  String get settingsExpertModeTitle => '专家模式';

  @override
  String get settingsExpertModeDesc => '开启后显示自动执行与运行参数';

  @override
  String get settingsBootAutostartTitle => '开机自动执行 DirtyFrag';

  @override
  String get settingsBootAutostartTitleLocked => '开机自动执行 DirtyFrag（需先开专家模式）';

  @override
  String get settingsBootAutostartDesc => '开机时自动执行一次，失败会自动关闭';

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
  String get shellPairingNotice =>
      '如果通知栏无法输入配对码，请到「设置 → 通用 → 配对码输入位置」切换为「小窗输入」';

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
  String get settingsShellPairingModeTitle => '配对码输入位置';

  @override
  String get settingsShellPairingModeDesc =>
      '通知栏弹不出输入框的机型（如小米）可改为小窗/分屏后，在卡片里输入配对码';

  @override
  String get shellPairingModeNotification => '通知栏';

  @override
  String get shellPairingModeCard => '小窗输入';

  @override
  String get shellPairingCodeHint => '六位配对码';

  @override
  String get shellPairingCodeSubmit => '配对';

  @override
  String get shellPairingCardHint =>
      '先在系统里点「使用配对码配对设备」，再把六位码填到这里；建议分屏或小窗，切走应用会让码失效';

  @override
  String get shellPairingOpenDebugSettings => '打开无线调试设置';

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
  String get shellReasonEndpointNotFound =>
      '没找到配对服务：请先在系统里打开「使用配对码配对设备」弹窗，再重新输入配对码';

  @override
  String get shellReasonPairingTimeout => '配对超时，请重试';

  @override
  String get shellReasonDeviceRebooted => '设备重启导致连接中断';

  @override
  String get shellReasonCancelled => '已取消配对';

  @override
  String get shellReasonHostPairingFailed => '配对失败，请重试';

  @override
  String get settingsCommandChannelTitle => '命令通道';

  @override
  String get settingsCommandChannelDesc => 'AI 工具执行命令时使用的链路，可在此切换';

  @override
  String get commandChannelAdb => '无线 ADB';

  @override
  String get commandChannelStellar => 'Stellar';

  @override
  String get stellarCardTitle => 'Stellar';

  @override
  String stellarStatusReady(int uid) {
    return '服务已就绪（uid=$uid）';
  }

  @override
  String get stellarStatusNotReady => '服务尚未就绪';

  @override
  String get stellarNotReadyHint =>
      'Stellar 特权服务尚未就绪，这一通道暂时无法执行命令；可在「设置 → 通用 → 命令通道」切换。';

  @override
  String get stellarStartService => '启动服务';

  @override
  String get stellarLaunching => '正在启动服务…';

  @override
  String get stellarLaunchNoRunner => '自动连接无线调试没有成功，服务没能启动。请确认「无线调试」已开启后重试。';

  @override
  String get stellarLaunchLauncherMissing => '安装包内缺少启动文件，无法启动服务。';

  @override
  String get stellarLaunchNotAnswering => '服务已发出启动请求，但没有在预期时间内响应。';

  @override
  String get stellarLaunchAwaitingCode => '填入无线调试的六位配对码后会自动连接并启动服务。';

  @override
  String get stellarStopService => '断开服务';

  @override
  String get stellarStopping => '正在停止服务…';

  @override
  String get stellarStopFailed => '服务没有响应断开请求，可能仍在运行。';

  @override
  String get escalationTerminalNeedsAdb => '没连上无线调试。';

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

  @override
  String get kernelProfileTitle => '内核表';

  @override
  String get kernelProfileEntrySubtitle => '为 GhostKey 与 GhostLock 生成内核参数';

  @override
  String get kernelProfilePageDesc =>
      '本机内核不在内置表里时，用本机的 boot.img 或 OTA 生成 profile。生成的 profile 只保存在本应用私有目录。';

  @override
  String get kernelProfileTabGhostKey => 'GhostKey 已导入';

  @override
  String get kernelProfileTabGhostKeyBuiltin => 'GhostKey 内置';

  @override
  String get kernelProfileTabGhostLock => 'GhostLock 已导入';

  @override
  String get kernelProfileTabGhostLockBuiltin => 'GhostLock 内置';

  @override
  String get kernelProfileImportAction => '选择镜像（img / bin / zip）';

  @override
  String get kernelProfileImportChangeFile => '更换镜像';

  @override
  String get kernelProfileImportAttachXbl => 'xbl_config.img（可选）';

  @override
  String get kernelProfileImportAttachUefi => 'uefi.img（可选）';

  @override
  String get kernelProfileImportAttachVendorBoot => 'vendor_boot.img（可选）';

  @override
  String get kernelProfileImportPhysLabel => '物理装载基址（可选）';

  @override
  String get kernelProfileImportPhysHint => '0x80000000';

  @override
  String get kernelProfileAdvancedTitle => '高级解析选项';

  @override
  String get kernelProfileAdvancedHint => '一般不用改；改后需重新解析';

  @override
  String get kernelProfileImportKallsyms => 'kallsyms 文件';

  @override
  String get kernelProfileImportIomem => 'iomem 文件';

  @override
  String get kernelProfileImportRoute => '路由';

  @override
  String get kernelProfileImportRouteAuto => '自动推荐';

  @override
  String get kernelProfileImportAllowMissing => '缺失符号按可选处理（输出 0）';

  @override
  String get kernelProfileImportNoDisasm => '跳过反汇编推导（更快，精度下降）';

  @override
  String get kernelProfileImportUrlHint => 'OTA 链接（HTTP/HTTPS）';

  @override
  String get kernelProfileImportParseAction => '解析内核';

  @override
  String get kernelProfileImportNeedInput => '先选一个镜像或填一个链接';

  @override
  String get kernelProfileImportUnsupportedImage =>
      '不支持的文件：仅接受 img / bin / zip 镜像或 OTA 包';

  @override
  String get kernelProfileImportEmptyFile => '文件为空或无法读取';

  @override
  String get kernelProfileImportInsecureHint => '跳过证书校验（直链自签时用）';

  @override
  String get kernelProfileProbeReady => '解析完成';

  @override
  String get kernelProfileProbeRouteIncomplete => '路由几何不完整，这条配置跑不到写入：';

  @override
  String get kernelProfileProbeRouteIncompleteHint =>
      '提权第一阶段只会试一次，缺字段会被直接拒绝。补上缺失字段，或在「路由」页换一条本表声明齐全的路由。';

  @override
  String kernelProfileProbeWarnings(int count) {
    return '$count 条提示';
  }

  @override
  String get kernelProfileProbeWarningsTitle => '解析提示';

  @override
  String get kernelProfileProbePhys => 'kernel_phys_load';

  @override
  String get kernelProfileProbePhysMissing => '未取到';

  @override
  String get kernelProfileProbePhysUnsetHint =>
      '未取到时写 null，运行时按 SoC 型号回退到内置常量；若运行报地址错误，再补附 xbl_config.img 或手填物理基址。';

  @override
  String get kernelProfileAttachTitle => '可选附件';

  @override
  String get kernelProfileAttachHint => '用于补 kernel_phys_load，一般不用管';

  @override
  String get kernelProfileAttachAttachedCount => '已附加镜像，重新解析后生效';

  @override
  String get kernelProfileAttachAutoHint =>
      '包内的 xbl_config、uefi、vendor_boot 由提取器按需解出；实际解出了哪些见结果里的「包内分区」。';

  @override
  String get kernelProfileAttachVendorBootHint =>
      '仅 MediaTek 机型需要，用于补 DRAM 基址。';

  @override
  String get kernelProfileAttachPick => '选择';

  @override
  String get kernelProfileAttachReplace => '更换';

  @override
  String get kernelProfileProbePayloadParts => '包内分区';

  @override
  String get kernelProfileProbeAnalysis => '内核审查报告';

  @override
  String get kernelProfileProbeAnalysisTitle => '内核审查报告';

  @override
  String get kernelProfileImportTargetGhostLock => 'GhostLock';

  @override
  String get kernelProfileImportTargetGhostKey => 'GhostKey';

  @override
  String get kernelProfileInputSourceLocal => '本地镜像';

  @override
  String get kernelProfileInputSourceUrl => 'OTA 直链';

  @override
  String kernelProfileWriteToTarget(String table) {
    return '写入 $table';
  }

  @override
  String kernelProfileProbeFailed(String reason) {
    return '解析失败：$reason';
  }

  @override
  String get kernelProfileBtfHint => '需要带 BTF 调试信息的内核，第三方 ROM 或老机型可能取不到结构偏移';

  @override
  String get kernelProfilePasteExample => '粘贴示例';

  @override
  String get kernelProfileWhyBtfTitle => '为什么需要 BTF？';

  @override
  String get kernelProfileWhyBtfBody =>
      '生成的 profile 靠 struct cred 各字段的字节偏移来伪造凭据，而这些偏移随内核版本变化，不能写死。\n\n内核镜像若带 BTF（编译开关 CONFIG_DEBUG_INFO_BTF），就能直接从镜像读出 task_struct、cred 的真实布局；没有 BTF 就取不到 task_cred、task_struct_size、cred_uid，profile 生成不了。\n\n另外链接必须支持 HTTP Range（分段下载），否则无法只取 boot 分区。厂商原厂 OTA 和 Pixel 等 GKI 机型一般两者都满足。';

  @override
  String get kernelProfileDialogClose => '知道了';

  @override
  String get otaCatalogBrowseAction => '内置 ROM';

  @override
  String get otaCatalogTitle => '内置 ROM 清单';

  @override
  String get otaCatalogSearchHint => '搜索机型或版本号';

  @override
  String get otaCatalogPickHint => '点任意版本，把直链填进上面的输入框';

  @override
  String get otaCatalogEmpty => '没有匹配的机型或版本';

  @override
  String otaCatalogVersionCount(int count) {
    return '$count 个版本';
  }

  @override
  String get otaCatalogBrandGoogle => 'Google';

  @override
  String get otaCatalogBrandRealme => 'realme';

  @override
  String get kernelProfileDetailTitle => '内核参数详情';

  @override
  String get kernelProfileDetailOverview => '基本信息';

  @override
  String get kernelProfileDetailOffsets => '结构偏移';

  @override
  String get kernelProfileDetailSymbolOffsets => '符号偏移';

  @override
  String get kernelProfileDetailSchema => '表版本';

  @override
  String get kernelProfileDetailKernelMajor => '内核主版本';

  @override
  String get kernelProfileDetailRaw => '原始配置';

  @override
  String get kernelProfileDetailVulnType => '漏洞类型';

  @override
  String get kernelProfileDetailPageOffset => '页偏移';

  @override
  String get kernelProfileDetailSource => '导入来源';

  @override
  String get kernelProfileDetailCopy => '复制';

  @override
  String get kernelProfileDetailCopied => '已复制原始配置';

  @override
  String get kernelProfileDetailEmpty => '读取不到内容，文件可能已被删除';

  @override
  String get kernelProfileEditAction => '编辑';

  @override
  String get kernelProfileEditTitle => '编辑内核参数';

  @override
  String get kernelProfileEditBasicSection => '基础偏移';

  @override
  String get kernelProfileEditAdvancedSection => '高级布局';

  @override
  String get kernelProfileEditInputHint => '支持 0x 十六进制或十进制，64 位地址按无符号展示';

  @override
  String get kernelProfileEditReleaseLabel => '内核 release（只读）';

  @override
  String get kernelProfileEditReleaseHint =>
      'release 是 uname -r 的精确匹配键，修改会导致不再生效';

  @override
  String get kernelProfileEditSource => '导入来源';

  @override
  String get kernelProfileEditWriteBack => '写回我的配置';

  @override
  String get kernelProfileEditWriteBackHint => '覆盖当前用户文档';

  @override
  String get kernelProfileEditSaveAs => '另存为我的配置';

  @override
  String get kernelProfileEditSaveAsHint => '存成一份新的用户文档，原文件不动';

  @override
  String get kernelProfileEditExport => '导出为文件';

  @override
  String get kernelProfileEditExportHint => '把编辑结果导出为本地 .conf';

  @override
  String get kernelProfileEditDocument => '文档';

  @override
  String get kernelProfileEditSaveFailed => '保存失败';

  @override
  String kernelProfileEditSavedAs(String name) {
    return '已另存为 $name';
  }

  @override
  String get kernelProfileActiveBadge => '生效中';

  @override
  String get kernelProfileSetActive => '设为生效';

  @override
  String get kernelProfileClearActive => '取消指定';

  @override
  String get kernelProfileActivated => '已设为生效';

  @override
  String get kernelProfileClearedActive => '已恢复自动匹配';

  @override
  String get kernelProfileEditSaved => '已保存';

  @override
  String get kernelProfileEditNoChange => '没有需要保存的改动';

  @override
  String get kernelProfileEditInvalidField => '存在无效数值';

  @override
  String kernelProfileEditInvalidFields(String fields) {
    return '无效数值：$fields';
  }

  @override
  String get kernelProfileEditExportFailed => '导出失败';

  @override
  String get kernelProfileEditNotEditable => '该内核表不是用户导入文档，不能编辑';

  @override
  String get kernelProfilePhaseLocate => '定位 OTA 包';

  @override
  String get kernelProfilePhaseRead => '下载镜像';

  @override
  String kernelProfileBytesProgress(String done, String total) {
    return '$done / $total';
  }

  @override
  String get kernelProfilePhaseParse => '解析内核';

  @override
  String get kernelProfilePhaseSave => '写入 profile';

  @override
  String get kernelProfilePhaseDone => '完成';

  @override
  String kernelProfileImportSuccess(String release) {
    return '已生成 profile：$release';
  }

  @override
  String get kernelProfileImportFailed => '导入失败';

  @override
  String get kernelProfileErrorCopy => '复制错误信息';

  @override
  String get kernelProfileErrorCopied => '已复制错误信息';

  @override
  String kernelProfileMissingFields(String fields) {
    return '缺少必填字段：$fields';
  }

  @override
  String get kernelProfileImportedSection => '内核表';

  @override
  String get kernelProfileImportedEmpty => '还没有导入过 profile';

  @override
  String get kernelProfileBuiltinEmpty => '内置表为空';

  @override
  String get kernelProfileDeviceKernel => '设备内核';

  @override
  String get kernelProfileEditParams => '编辑参数';

  @override
  String get kernelProfileMyProfilesTitle => '我的配置';

  @override
  String get kernelProfileBuiltinTitle => '内置表';

  @override
  String get kernelProfileBuiltinHint => '随应用打包，只读';

  @override
  String get kernelProfileTemplateHint => '空白骨架，只用于查看字段结构，不能直接生效';

  @override
  String get kernelProfileMatchesDevice => '与本机内核一致';

  @override
  String kernelProfileShowMore(int count) {
    return '显示更多（还剩 $count 项）';
  }

  @override
  String get kernelProfileStepPick => '选择内核表';

  @override
  String get kernelProfileStepReview => '确认来源';

  @override
  String get kernelProfileStepApply => '应用生效';

  @override
  String get kernelProfileStepNext => '下一步';

  @override
  String get kernelProfileStepBack => '上一步';

  @override
  String get kernelProfileApplyAction => '应用生效';

  @override
  String get kernelProfileApplied => '已切换生效内核表';

  @override
  String get kernelProfileApplyNotEffective => '所选内核表与设备内核不一致，本次不会生效';

  @override
  String get kernelProfileEditorNotEditable => '这个内核没有可编辑的 profile';

  @override
  String get kernelProfilePickAgain => '再选一份';

  @override
  String get kernelProfileEditAfterApply => '去调参数';

  @override
  String get kernelProfileEditAfterApplyHint => '参数只能在生效后编辑：先完成这一步，再进编辑器改值。';

  @override
  String get kernelProfilePickHint => '选一份要生效的内核表；标「生效中」的是当前正在用的那份。';

  @override
  String get kernelProfileKeySelectHint =>
      '点左侧圆点切换生效的内核表；未指定时取最近导入的同 release 文档。';

  @override
  String get kernelProfileReviewHint => '确认下面的来源。应用后编辑器改的就是这一份。';

  @override
  String get kernelProfileDeclaredKernel => '配置声明的内核';

  @override
  String get kernelProfileReviewMatch => '与设备内核一致，可以运行';

  @override
  String get kernelProfileReviewMismatch => '与设备内核不一致，运行会被拒绝';

  @override
  String get kernelProfileGhostKeyEntry => 'GhostKey 内核表';

  @override
  String get kernelProfileGhostLockEntry => 'GhostLock 内核表';

  @override
  String get kernelProfileImportEntry => '导入内核表';

  @override
  String get kernelImageExport => '导出镜像';

  @override
  String kernelImageExportCount(int count) {
    return '导出镜像（$count）';
  }

  @override
  String get kernelImageExportHint => '把解析时解出的镜像保存到手机「下载」目录，便于重复使用或备份。';

  @override
  String get kernelImageExportEmpty => '没有可导出的镜像';

  @override
  String kernelImageExportSaved(String name) {
    return '已保存 $name';
  }

  @override
  String get kernelImageExportFailed => '导出失败';

  @override
  String get kernelProfileRemove => '删除';

  @override
  String get kernelProfileRemoveConfirmTitle => '删除这份 profile？';

  @override
  String kernelProfileRemoveConfirmBody(String release) {
    return '$release 将被删除。本机若没有其它匹配的 profile，需要重新导入。';
  }

  @override
  String get kernelProfileErrorEmptyPath => '没有拿到文件路径';

  @override
  String get kernelProfileErrorNotFound => '文件不存在或不可读';

  @override
  String get kernelProfileErrorTooLarge => '文件过大，无法解析';

  @override
  String get kernelProfileErrorNotBootImage => '这不是一个 boot.img';

  @override
  String get kernelProfileErrorDecode => '解压内核失败';

  @override
  String get kernelProfileErrorIncomplete => '解析结果不完整，未保存';

  @override
  String get kernelProfileErrorIo => '读写文件失败';

  @override
  String get kernelProfileErrorNoBtf => '这个 ROM 的内核不含 BTF 调试信息，无法推导结构偏移';

  @override
  String get kernelProfileErrorBadUrl => '链接无效，需要 HTTP 或 HTTPS 地址';

  @override
  String get kernelProfileErrorDownload => '下载或解包 OTA 失败';

  @override
  String kernelProfileErrorDetail(String detail) {
    return '详情：$detail';
  }

  @override
  String get kernelProfileErrorOom => '内存不足，解析中断';

  @override
  String get kernelProfileErrorUnknown => '未知错误';

  @override
  String get ghostKeyRunResultRunning => '进行中';

  @override
  String get ghostKeyRunResultSuccess => '成功';

  @override
  String get ghostKeyRunResultFailed => '失败';

  @override
  String get ghostKeyRunResultStopped => '已停止';

  @override
  String get ghostKeyRunResultInterrupted => '中断';

  @override
  String ghostKeyDurationSeconds(int seconds) {
    return '$seconds秒';
  }

  @override
  String ghostKeyDurationMinutesSeconds(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String get ghostKeyRunLogTitle => '运行记录';

  @override
  String get ghostKeyRunLogEntrySubtitle => '查看历史运行明细与失败诊断';

  @override
  String ghostKeyRunLogCount(int count) {
    return '共 $count 次 · 最新在最上';
  }

  @override
  String get ghostKeyRunLogEmpty => '暂无运行记录';

  @override
  String get ghostKeyRunLogExportAll => '导出全部';

  @override
  String get ghostKeyRunLogExportAllFileName => 'run-logs-all.log';

  @override
  String get ghostKeyRunLogClearAll => '清空全部记录';

  @override
  String get ghostKeyRunLogCleared => '运行记录已清空';

  @override
  String ghostKeyRunLogDetailTitle(int runId) {
    return '运行 #$runId';
  }

  @override
  String get ghostKeyRunLogCopy => '复制';

  @override
  String get ghostKeyRunLogCopied => '已复制到剪贴板';

  @override
  String get ghostKeyRunLogSaveAs => '另存为';

  @override
  String get ghostKeyRunLogSaved => '已保存';

  @override
  String get ghostKeyRunLogDeleteThis => '删除这一次记录';

  @override
  String ghostKeyRunLogDiagTitlePrefix(String title) {
    return '诊断: $title';
  }

  @override
  String ghostKeyRunLogDiagCausePrefix(String cause) {
    return '可能原因: $cause';
  }

  @override
  String ghostKeyRunLogDiagSuggestionPrefix(String suggestion) {
    return '建议: $suggestion';
  }

  @override
  String get ghostKeyDiagCalibANoSlideCandidateTitle =>
      'KASLR 偏移解算失败：候选地址里找不到可信的内核基址';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause1 =>
      '内核刚完成 OTA / 刚重启，运行时布局与 profile 假设不符';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause2 =>
      '导入的 profile 与当前内核版本不匹配（boot.img 版本对不上）';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause3 =>
      '设备后台负载异常，k_itimer 采样被污染';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateCause4 =>
      'tracefs 采样窗口未抓到任何 k_itimer 记录（SELinux 拦截 / Shizuku 权限不足 / 后台负载过低）';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion1 => '重启设备后重试一次';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion2 =>
      '确认 profile 对应当前内核版本（设备信息条上的内核版本）';

  @override
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion3 =>
      '若连续失败，请保存运行日志以便排查';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsTitle =>
      'KASLR 偏移解算失败：多尺寸探针没采到任何 k_itimer 分配记录';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause1 =>
      'tracefs 的 kmem_cache_alloc 事件没被打开（被 SELinux 拦截，或 Shizuku 授权 / 挂载异常）';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause2 =>
      '本机 k_itimer 结构体尺寸不在候选集 0x108 / 0x100 / 0x110 / 0x118 内，所有尺寸都没匹配到记录';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsCause3 =>
      '采样窗口内系统负载过低，定时器调用点未被充分触发';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion1 =>
      '确认 Shizuku 已授权且 tracefs 可写（设置 → 开发者选项）';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion2 =>
      '重启设备后重试，让采样在单次开机内完成';

  @override
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion3 =>
      '仍失败请保存运行日志（含 [calib_a] 与 arm_kmem_cache_alloc 行）以便排查';

  @override
  String get ghostKeyDiagCalibATracefsUnusableTitle =>
      'tracefs 不可用：内核追踪事件挂载/读取失败';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause1 =>
      'SELinux 策略拦截了 tracefs 写入';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause2 =>
      'Shizuku 授权异常（未启动或权限被回收）';

  @override
  String get ghostKeyDiagCalibATracefsUnusableCause3 => '部分 ROM 精简了 tracefs 节点';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion1 =>
      '确认 Shizuku 正在运行且已给本应用授权';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion2 =>
      '检查开发者选项中 USB 调试（无线调试）是否可用';

  @override
  String get ghostKeyDiagCalibATracefsUnusableSuggestion3 =>
      '重启 Shizuku 后重试；仍失败请保存日志排查';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsTitle =>
      '页偏移解算失败：校准 A 得出的基址与实际不符';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsCause1 =>
      '校准 A 的 KASLR slide 不准（上游错误，先解决校准 A）';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsCause2 => '两次校准之间内核内存布局发生变化';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion1 =>
      '重启设备让两次校准在同一次开机状态内完成';

  @override
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion2 =>
      '重跑完整流水线（不要单独跳过校准步骤）';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesTitle =>
      '采样不足：触发样本太少，无法解算页偏移';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesCause1 =>
      '系统后台负载过低，定时器调用点未被充分触发';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesCause2 => '设备刚冷启动，运行时服务还没起来';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion1 =>
      '让设备处于轻度使用状态（如播放音乐）后再重试';

  @override
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion2 =>
      '直接多跑一次，样本量通常第二次更充分';

  @override
  String get ghostKeyDiagInjectResidualProcessTitle =>
      '存在上一轮残留进程：残留进程还钉着已释放的页，继续注入会导致内核崩溃';

  @override
  String get ghostKeyDiagInjectResidualProcessCause1 =>
      '上一轮提权未走完清理步骤（中途强退 / 断电）';

  @override
  String get ghostKeyDiagInjectResidualProcessSuggestion1 =>
      '必须重启设备后再试（杀掉残留进程不解决问题）';

  @override
  String get ghostKeyDiagInjectRootdNotReadyTitle =>
      '漏洞已触发但 root 通道未建立：rootd 超时未就绪';

  @override
  String get ghostKeyDiagInjectRootdNotReadyCause1 =>
      '设备内核对该漏洞打了部分回移植补丁，UAF 窗口不稳定';

  @override
  String get ghostKeyDiagInjectRootdNotReadyCause2 => '系统负载导致竞态时序偏差';

  @override
  String get ghostKeyDiagInjectRootdNotReadySuggestion1 => '重启设备后再试 1~2 次';

  @override
  String get ghostKeyDiagInjectRootdNotReadySuggestion2 =>
      '若每次都在同一位置超时，内核可能已修复，请记录机型与内核版本以便反馈';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingTitle =>
      '内核偏移表未加载：注入缺少 profile 数据';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingCause1 =>
      '未导入 / 导入了损坏的 profile 文件';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingCause2 =>
      'profile 与当前内核不匹配被引擎拒绝';

  @override
  String get ghostKeyDiagInjectOffsetTableMissingSuggestion1 =>
      '重新导入对应内核版本的 profile（boot.img 提取）';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedTitle =>
      'task_struct 地址泄漏失败：扫描窗口内没有匹配到 task_struct 的 slab 分配记录';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause1 =>
      'task_struct 缓存尺寸与 BTF 的 sizeof(task_struct) 不一致：缓存由 kmem_cache_create_usercopy(\"task_struct\", arch_task_struct_size, 0x40, ...) 创建，arch_task_struct_size 是运行时变量，厂商可用 android_arch_task_struct_size= 在其上追加（最多 0x400）';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause2 =>
      'kmem_cache_alloc 事件未被打开（tracefs 不可写 / SELinux 拒绝）';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedCause3 =>
      'fork 落在未被读取的 CPU 上（按实际核数扫描，理论上不会）';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion1 => '重启设备后再试一次';

  @override
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion2 =>
      '日志里 [task] raw=0 说明是事件没开；raw>0 但 hits=0 则是尺寸窗口不对，请把 [task] sizes= 那行保存下来以便排查';

  @override
  String get ghostKeyDiagVerifyFailedTitle => '临时 root 验证失败：提权通道建立后 su 校验未通过';

  @override
  String get ghostKeyDiagVerifyFailedCause1 => '注入阶段的凭据改写不完整（上游竞态部分成功）';

  @override
  String get ghostKeyDiagVerifyFailedCause2 => '验证子进程被 SELinux 或系统策略拦截';

  @override
  String get ghostKeyDiagVerifyFailedSuggestion1 => '重启设备后重试完整流水线';

  @override
  String get ghostKeyDiagVerifyFailedSuggestion2 =>
      '检查 SELinux 状态（设置 → 开发者选项），不强制改 Permissive';

  @override
  String get ghostKeyDiagKsuAlreadyLiveTitle => '内核模块已驻留：旧模块仍在内存，late-load 被跳过';

  @override
  String get ghostKeyDiagKsuAlreadyLiveCause1 => '上一次提权注入的内核模块还活着';

  @override
  String get ghostKeyDiagKsuAlreadyLiveSuggestion1 => '重启设备后再跑一次，管理器才能看到新接管';

  @override
  String get ghostKeyDiagKsuAlreadyLiveSuggestion2 =>
      '若只是想用 root，无需重跑——当前已是临时 root 状态';

  @override
  String get ghostKeyDiagKsuModuleAbsentTitle =>
      'KSU late-load 失败：模块没有出现在 /proc/modules';

  @override
  String get ghostKeyDiagKsuModuleAbsentCause1 =>
      '设备上的 root 管理器 / ksud 版本过旧，KMI 不匹配';

  @override
  String get ghostKeyDiagKsuModuleAbsentCause2 => '模块加载路径被内核限制';

  @override
  String get ghostKeyDiagKsuModuleAbsentSuggestion1 => '更新设备上的 root 管理器到最新版';

  @override
  String get ghostKeyDiagKsuModuleAbsentSuggestion2 => '重试一次；连续失败请保存日志并注明管理器版本';

  @override
  String get ghostKeyDiagKsuKsudMissingTitle =>
      '找不到 ksud：选中的 root 管理器里没有可用的 ksud';

  @override
  String get ghostKeyDiagKsuKsudMissingCause1 => 'root 管理器未安装，或右上角胶囊里没有选中它';

  @override
  String get ghostKeyDiagKsuKsudMissingCause2 => '该管理器的 ksud 与当前架构不兼容，或它的库已损坏';

  @override
  String get ghostKeyDiagKsuKsudMissingSuggestion1 =>
      '先安装一个 root 管理器并在右上角胶囊里选中它，再重跑流水线';

  @override
  String get ghostKeyDiagHostShizukuUnavailableTitle =>
      'Shizuku 环境异常：宿主进程无法启动提权流水线';

  @override
  String get ghostKeyDiagHostShizukuUnavailableCause1 =>
      'Shizuku 服务未启动（未开无线调试或 adb 未连接）';

  @override
  String get ghostKeyDiagHostShizukuUnavailableCause2 => '用户拒绝了本应用的 Shizuku 授权';

  @override
  String get ghostKeyDiagHostShizukuUnavailableSuggestion1 =>
      '打开 Shizuku 应用并确保服务运行（无线调试 / adb 两种方式均可）';

  @override
  String get ghostKeyDiagHostShizukuUnavailableSuggestion2 => '在本应用内重新发起授权并允许';

  @override
  String get ghostKeyDiagFallbackExit2Title =>
      '流水线终止（exit=2）：KASLR 偏移解算失败，且未命中任何已知细分模式';

  @override
  String get ghostKeyDiagFallbackExit2Cause1 =>
      '校准 A 未能从 k_itimer 采样解出可信内核基址（最常见的失败点）';

  @override
  String get ghostKeyDiagFallbackExit2Cause2 =>
      '当前内核布局与所选 profile 不符（刚 OTA/重启、或 profile 版本对不上，导致 timer_link/cred_link 偏移错误）';

  @override
  String get ghostKeyDiagFallbackExit2Cause3 =>
      'tracefs 采样被环境异常打断（SELinux 拦截 / Shizuku 授权失效 / 系统负载异常）';

  @override
  String get ghostKeyDiagFallbackExit2Cause4 =>
      '或本次失败属于尚未被归因器覆盖的新变体（退出码为 2 但日志串未被规则捕获）';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion1 =>
      '重启设备后重试一次——KASLR 每次开机都不同，重跑通常可解';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion2 =>
      '确认运行的是最新构建（1.1.5），且 profile 由本机 boot.img 提取、release 精确匹配当前内核';

  @override
  String get ghostKeyDiagFallbackExit2Suggestion3 =>
      '不要只靠重试：请把「运行日志」页完整内容（尤其含 [calib_a] / [calib_b] 的行）保存下来，便于定位内核适配问题';

  @override
  String ghostKeyDiagFallbackGenericTitle(int exit) {
    return '流水线终止（exit=$exit）：未命中已知失败模式';
  }

  @override
  String get ghostKeyDiagFallbackGenericCause1 => '时序敏感的竞态窗口未命中，或环境临时异常';

  @override
  String get ghostKeyDiagFallbackGenericSuggestion1 =>
      '不要只靠重试：请把「运行日志」页完整内容复制保存，便于定位内核适配问题';

  @override
  String get ghostKeyDiagFallbackGenericSuggestion2 =>
      '连续失败请重启设备后再试；仍失败请保存运行日志以便排查';

  @override
  String get settingsFollowAuthorSection => '关注作者';

  @override
  String get settingsCreatorPlatformsTitle => '作者平台';

  @override
  String get settingsTutorialTitle => '使用教程';

  @override
  String get settingsTutorialSubtitle => '在作者各平台查看教程视频';

  @override
  String get settingsCommunityGroupTitle => '交流群';

  @override
  String get settingsCommunityGroupSubtitle => '加入交流群获取帮助';

  @override
  String get settingsCreatorPlatformsIntro => '选择一个平台，继续关注作者的最新内容与动态。';

  @override
  String get settingsWechatTitle => '微信公众号';

  @override
  String get settingsFeatureWishTitle => '功能许愿';

  @override
  String get settingsFeatureWishSubtitle => '打赏支持作者，许愿新功能';

  @override
  String get featureWishDialogDesc => '扫码打赏支持作者，再到 GitHub 提交你的功能想法。';

  @override
  String get featureWishIssueButton => '提交功能 Issue';

  @override
  String get featureWishNetworkTip => '请使用合理的网络环境打开';

  @override
  String get platformFacebook => 'Facebook';

  @override
  String get platformTiktok => 'TikTok';

  @override
  String get platformDouyin => '抖音';

  @override
  String get platformBilibili => '哔哩哔哩';

  @override
  String get platformYoutube => 'YouTube';
}

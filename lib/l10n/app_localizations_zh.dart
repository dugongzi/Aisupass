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
  String get aiConfigEdit => '编辑';

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
  String get aiQuickStart => '快速开始';

  @override
  String get aiQuickStartHint => '选择服务商可自动填写地址与接口类型';

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
  String get aiQuickPanelTitle => 'AI 提权助手';

  @override
  String get aiQuickPanelSubtitle => '选择一种方式开始获取最高权限';

  @override
  String get aiQuickEscalateTitle => 'AI 提权';

  @override
  String get aiQuickEscalateDesc => '智能分析设备环境，自动生成并执行提权方案';

  @override
  String get manualQuickEscalateTitle => '手动提权';

  @override
  String get manualQuickEscalateDesc => '自定义命令与脚本，逐步掌控提权流程';

  @override
  String get manualQuickEscalateComingSoon => '手动提权功能开发中';

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
}

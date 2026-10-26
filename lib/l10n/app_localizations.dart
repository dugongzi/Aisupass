import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// 应用名称
  ///
  /// In zh, this message translates to:
  /// **'AiSuPass'**
  String get appName;

  /// 首页
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get homeTitle;

  /// 设置
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// 设置页分组标题-通用
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get settingsGeneralSection;

  /// 设置页分组标题-外观
  ///
  /// In zh, this message translates to:
  /// **'外观'**
  String get settingsAppearanceSection;

  /// 设置项-主题模式
  ///
  /// In zh, this message translates to:
  /// **'主题模式'**
  String get themeModeTitle;

  /// 主题模式-跟随系统
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get themeModeSystem;

  /// 主题模式-浅色
  ///
  /// In zh, this message translates to:
  /// **'浅色'**
  String get themeModeLight;

  /// 主题模式-深色
  ///
  /// In zh, this message translates to:
  /// **'深色'**
  String get themeModeDark;

  /// 设置项-主题色
  ///
  /// In zh, this message translates to:
  /// **'主题色'**
  String get themeColorTitle;

  /// AI 激活卡片标题
  ///
  /// In zh, this message translates to:
  /// **'AI'**
  String get aiTitle;

  /// 激活状态
  ///
  /// In zh, this message translates to:
  /// **'已激活'**
  String get activated;

  /// 未激活状态
  ///
  /// In zh, this message translates to:
  /// **'未激活'**
  String get notActivated;

  /// 首页-ROOT 状态卡片标题
  ///
  /// In zh, this message translates to:
  /// **'ROOT'**
  String get rootTitle;

  /// 首页-ADB 状态卡片标题
  ///
  /// In zh, this message translates to:
  /// **'ADB'**
  String get adbTitle;

  /// 状态卡片-正在检测
  ///
  /// In zh, this message translates to:
  /// **'检测中'**
  String get statusDetecting;

  /// ADB 状态-已激活，括号内为实际开启的调试类型
  ///
  /// In zh, this message translates to:
  /// **'已激活（{types}）'**
  String adbActivatedWithType(String types);

  /// ADB 调试类型-无线调试
  ///
  /// In zh, this message translates to:
  /// **'无线'**
  String get adbTypeWifi;

  /// ADB 调试类型-有线（USB）调试
  ///
  /// In zh, this message translates to:
  /// **'有线'**
  String get adbTypeUsb;

  /// 多个并列项之间的分隔符
  ///
  /// In zh, this message translates to:
  /// **'、'**
  String get listSeparator;

  /// 状态卡片刷新按钮的提示文案
  ///
  /// In zh, this message translates to:
  /// **'重新检测'**
  String get refreshTooltip;

  /// 首页-设备信息卡片标题
  ///
  /// In zh, this message translates to:
  /// **'设备信息'**
  String get deviceInfoTitle;

  /// 设备信息卡片-复制按钮提示
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get deviceInfoCopy;

  /// 设备信息卡片-复制成功提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get deviceInfoCopied;

  /// 设备信息卡片-读取失败提示
  ///
  /// In zh, this message translates to:
  /// **'设备信息读取失败'**
  String get deviceInfoUnavailable;

  /// 设备信息-系统版本
  ///
  /// In zh, this message translates to:
  /// **'系统版本'**
  String get deviceOsVersion;

  /// 设备信息-API 级别
  ///
  /// In zh, this message translates to:
  /// **'API Level'**
  String get deviceApiLevel;

  /// 设备信息-设备型号
  ///
  /// In zh, this message translates to:
  /// **'设备型号'**
  String get deviceModel;

  /// 设备信息-CPU 架构
  ///
  /// In zh, this message translates to:
  /// **'CPU 架构'**
  String get deviceCpuAbi;

  /// 设备信息-内核版本
  ///
  /// In zh, this message translates to:
  /// **'内核版本'**
  String get deviceKernelVersion;

  /// 设备信息-Android 安全补丁日期
  ///
  /// In zh, this message translates to:
  /// **'Android 安全更新'**
  String get deviceSecurityPatch;

  /// 设备信息-基带版本
  ///
  /// In zh, this message translates to:
  /// **'基带版本'**
  String get deviceBaseband;

  /// 设备信息-系统版本号
  ///
  /// In zh, this message translates to:
  /// **'版本号'**
  String get deviceBuildNumber;

  /// 设备信息-SOTA 版本
  ///
  /// In zh, this message translates to:
  /// **'SOTA 版本'**
  String get deviceSotaVersion;

  /// 设备信息-SELinux 状态
  ///
  /// In zh, this message translates to:
  /// **'SELinux'**
  String get deviceSelinux;

  /// 设备信息-应用版本
  ///
  /// In zh, this message translates to:
  /// **'应用版本'**
  String get deviceAppVersion;

  /// 设置页分组标题-AI
  ///
  /// In zh, this message translates to:
  /// **'AI'**
  String get settingsAiSection;

  /// 设置页-AI 配置入口副标题
  ///
  /// In zh, this message translates to:
  /// **'管理模型服务与 API Key'**
  String get aiConfigEntrySubtitle;

  /// AI 配置列表页标题
  ///
  /// In zh, this message translates to:
  /// **'AI 配置'**
  String get aiConfigTitle;

  /// 新建 AI 配置
  ///
  /// In zh, this message translates to:
  /// **'新建配置'**
  String get aiConfigNew;

  /// 当前启用中的配置标记
  ///
  /// In zh, this message translates to:
  /// **'当前'**
  String get aiConfigCurrent;

  /// AI 配置列表分组标题
  ///
  /// In zh, this message translates to:
  /// **'配置列表'**
  String get aiConfigList;

  /// AI 配置列表为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'还没有 AI 配置，点击右上角 + 新建一个'**
  String get aiConfigEmpty;

  /// 内置服务配置的标记
  ///
  /// In zh, this message translates to:
  /// **'内置'**
  String get aiConfigBuiltin;

  /// 内置配置编辑页的说明
  ///
  /// In zh, this message translates to:
  /// **'内置服务地址已锁定，填写 API Key 后可刷新获取模型'**
  String get aiConfigBuiltinHint;

  /// 跳转到内置服务站点获取 API Key
  ///
  /// In zh, this message translates to:
  /// **'获取 Key'**
  String get aiConfigGetKey;

  /// 切换到该 AI 配置
  ///
  /// In zh, this message translates to:
  /// **'切换'**
  String get aiConfigUse;

  /// 切换 AI 配置成功提示
  ///
  /// In zh, this message translates to:
  /// **'已切换配置'**
  String get aiConfigSwitched;

  /// 删除 AI 配置
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get aiConfigDelete;

  /// 删除 AI 配置的确认文案
  ///
  /// In zh, this message translates to:
  /// **'确定删除配置「{name}」吗？'**
  String aiConfigDeleteConfirm(String name);

  /// AI 配置删除成功
  ///
  /// In zh, this message translates to:
  /// **'配置已删除'**
  String get aiConfigDeleted;

  /// AI 配置编辑页标题
  ///
  /// In zh, this message translates to:
  /// **'编辑配置'**
  String get aiConfigEditTitle;

  /// 通用删除按钮
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get aiDelete;

  /// 通用取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get aiCancel;

  /// AI 配置缺少 API Key 的提示
  ///
  /// In zh, this message translates to:
  /// **'未配置 API Key'**
  String get aiApiKeyMissing;

  /// AI 配置尚未选择模型
  ///
  /// In zh, this message translates to:
  /// **'未选择模型'**
  String get aiModelUnset;

  /// AI 配置编辑页-连接服务分组
  ///
  /// In zh, this message translates to:
  /// **'连接服务'**
  String get aiConnectionSection;

  /// AI 配置名称
  ///
  /// In zh, this message translates to:
  /// **'配置名称'**
  String get aiConfigName;

  /// AI 配置名称示例
  ///
  /// In zh, this message translates to:
  /// **'例如：DeepSeek 主力'**
  String get aiConfigNameHint;

  /// AI 服务地址
  ///
  /// In zh, this message translates to:
  /// **'API 地址'**
  String get aiBaseUrl;

  /// AI 服务地址示例
  ///
  /// In zh, this message translates to:
  /// **'https://api.deepseek.com/v1'**
  String get aiBaseUrlHint;

  /// AI 服务密钥
  ///
  /// In zh, this message translates to:
  /// **'API Key'**
  String get aiApiKey;

  /// AI 服务密钥示例
  ///
  /// In zh, this message translates to:
  /// **'sk-...'**
  String get aiApiKeyHint;

  /// AI 接口协议类型
  ///
  /// In zh, this message translates to:
  /// **'接口类型'**
  String get aiApiType;

  /// AI 模型
  ///
  /// In zh, this message translates to:
  /// **'模型'**
  String get aiModelName;

  /// 尚未获取模型时的占位文案
  ///
  /// In zh, this message translates to:
  /// **'先获取模型列表'**
  String get aiModelHint;

  /// 未获取模型就点击选择器时的提示
  ///
  /// In zh, this message translates to:
  /// **'请先获取模型列表'**
  String get aiModelRequired;

  /// 已获取模型但尚未选择时的提示
  ///
  /// In zh, this message translates to:
  /// **'请从已获取的模型中选择一个'**
  String get aiModelPickHint;

  /// 模型选择弹层标题
  ///
  /// In zh, this message translates to:
  /// **'选择模型'**
  String get aiModelSelect;

  /// 模型搜索框提示
  ///
  /// In zh, this message translates to:
  /// **'搜索模型'**
  String get aiModelSearch;

  /// 模型搜索结果为空
  ///
  /// In zh, this message translates to:
  /// **'没有匹配的模型'**
  String get aiModelEmpty;

  /// 拉取模型列表按钮
  ///
  /// In zh, this message translates to:
  /// **'获取模型'**
  String get aiModelLoad;

  /// 拉取模型列表失败
  ///
  /// In zh, this message translates to:
  /// **'获取模型失败：{message}'**
  String aiModelLoadFailed(String message);

  /// AI 配置编辑页-高级设置
  ///
  /// In zh, this message translates to:
  /// **'高级设置'**
  String get aiAdvancedSection;

  /// 高级设置折叠时的说明
  ///
  /// In zh, this message translates to:
  /// **'最大输出 Token 与温度；留空沿用服务端默认值'**
  String get aiAdvancedHint;

  /// 最大输出 Token
  ///
  /// In zh, this message translates to:
  /// **'最大输出 Token'**
  String get aiMaxTokens;

  /// 最大输出 Token 占位
  ///
  /// In zh, this message translates to:
  /// **'留空使用默认值'**
  String get aiMaxTokensHint;

  /// 采样温度
  ///
  /// In zh, this message translates to:
  /// **'温度'**
  String get aiTemperature;

  /// 采样温度占位
  ///
  /// In zh, this message translates to:
  /// **'0 - 2，留空使用默认值'**
  String get aiTemperatureHint;

  /// 编辑页底部-未检测状态
  ///
  /// In zh, this message translates to:
  /// **'保存前会自动验证连通性'**
  String get aiConnIdle;

  /// 编辑页底部-检测中
  ///
  /// In zh, this message translates to:
  /// **'正在验证连通性…'**
  String get aiConnTesting;

  /// 编辑页底部-检测成功
  ///
  /// In zh, this message translates to:
  /// **'连接正常，可用模型 {count} 个'**
  String aiConnOk(int count);

  /// 编辑页底部-检测失败
  ///
  /// In zh, this message translates to:
  /// **'连接失败：{message}'**
  String aiConnFailed(String message);

  /// 保存 AI 配置
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get aiSave;

  /// AI 配置保存成功
  ///
  /// In zh, this message translates to:
  /// **'配置已保存'**
  String get aiSaveSuccess;

  /// AI 配置保存失败
  ///
  /// In zh, this message translates to:
  /// **'保存失败：{message}'**
  String aiSaveFailed(String message);

  /// 表单必填校验
  ///
  /// In zh, this message translates to:
  /// **'此项不能为空'**
  String get aiFieldRequired;

  /// API 地址格式校验
  ///
  /// In zh, this message translates to:
  /// **'请输入以 http:// 或 https:// 开头的地址'**
  String get aiInvalidUrl;

  /// AI 配置测试窗口标题
  ///
  /// In zh, this message translates to:
  /// **'测试'**
  String get aiTestTitle;

  /// 测试窗口说明
  ///
  /// In zh, this message translates to:
  /// **'发送一条测试消息，流式查看服务端返回。'**
  String get aiTestHint;

  /// 测试消息输入框标题
  ///
  /// In zh, this message translates to:
  /// **'测试消息'**
  String get aiTestMessageLabel;

  /// 测试消息默认内容
  ///
  /// In zh, this message translates to:
  /// **'Hi'**
  String get aiTestMessageDefault;

  /// 发送测试消息
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get aiTestSend;

  /// 测试请求正在接收返回
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get aiTestStateStreaming;

  /// 测试请求成功
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get aiTestStateSuccess;

  /// 测试请求失败
  ///
  /// In zh, this message translates to:
  /// **'失败'**
  String get aiTestStateFailed;

  /// 没有拿到 HTTP 状态码
  ///
  /// In zh, this message translates to:
  /// **'未响应'**
  String get aiTestStateUnknown;

  /// 请求耗时标签
  ///
  /// In zh, this message translates to:
  /// **'耗时'**
  String get aiTestDuration;

  /// 从返回中解析出的回复
  ///
  /// In zh, this message translates to:
  /// **'回复'**
  String get aiTestReply;

  /// 测试失败的标签
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get aiTestError;

  /// 服务端原始返回内容
  ///
  /// In zh, this message translates to:
  /// **'原始返回'**
  String get aiTestRaw;

  /// 复制原始返回
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get aiTestCopy;

  /// 复制成功提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get aiTestCopied;

  /// 测试前缺少 API Key
  ///
  /// In zh, this message translates to:
  /// **'请先填写 API Key'**
  String get aiTestNoKey;

  /// 测试前缺少模型
  ///
  /// In zh, this message translates to:
  /// **'请先选择模型'**
  String get aiTestNoModel;

  /// 流式收到的分片数量单位
  ///
  /// In zh, this message translates to:
  /// **'段'**
  String get aiTestChunks;

  /// 首段内容到达耗时标签
  ///
  /// In zh, this message translates to:
  /// **'首字'**
  String get aiTestFirstToken;

  /// 服务端未按流式返回
  ///
  /// In zh, this message translates to:
  /// **'非流式'**
  String get aiTestNotStreamed;

  /// 模型目录请求-鉴权失败
  ///
  /// In zh, this message translates to:
  /// **'API Key 无效或无权限（HTTP {code}）'**
  String aiErrorAuth(int code);

  /// 模型目录请求-地址不存在
  ///
  /// In zh, this message translates to:
  /// **'接口地址不存在，请检查 API 地址（HTTP 404）'**
  String get aiErrorNotFound;

  /// 模型目录请求-其他 HTTP 错误
  ///
  /// In zh, this message translates to:
  /// **'请求失败（HTTP {code}）：{message}'**
  String aiErrorHttp(int code, String message);

  /// 模型目录请求-网络异常
  ///
  /// In zh, this message translates to:
  /// **'网络请求失败：{message}'**
  String aiErrorNetwork(String message);

  /// AI 对话页标题
  ///
  /// In zh, this message translates to:
  /// **'对话'**
  String get chatTitle;

  /// 对话输入框占位文案
  ///
  /// In zh, this message translates to:
  /// **'描述你的设备情况，或直接提问'**
  String get chatInputHint;

  /// 发送按钮
  ///
  /// In zh, this message translates to:
  /// **'发送'**
  String get chatSend;

  /// 流式接收时的停止按钮
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get chatStop;

  /// 清空当前会话
  ///
  /// In zh, this message translates to:
  /// **'新对话'**
  String get chatNewSession;

  /// 思考过程卡片标题
  ///
  /// In zh, this message translates to:
  /// **'思考过程'**
  String get chatReasoning;

  /// 思考尚未结束时卡片标题
  ///
  /// In zh, this message translates to:
  /// **'正在思考…'**
  String get chatThinking;

  /// 思考结束后的卡片标题
  ///
  /// In zh, this message translates to:
  /// **'思考完成'**
  String get chatThought;

  /// 工具调用执行中的状态
  ///
  /// In zh, this message translates to:
  /// **'执行中'**
  String get chatToolRunning;

  /// 工具调用成功的状态
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get chatToolSucceeded;

  /// 工具调用失败的状态
  ///
  /// In zh, this message translates to:
  /// **'执行失败'**
  String get chatToolFailed;

  /// 工具调用参数小节标题
  ///
  /// In zh, this message translates to:
  /// **'参数'**
  String get chatToolArguments;

  /// 工具调用结果小节标题
  ///
  /// In zh, this message translates to:
  /// **'结果'**
  String get chatToolResult;

  /// 复制成功提示
  ///
  /// In zh, this message translates to:
  /// **'已复制'**
  String get chatCopied;

  /// 工具调用轮次超限提示
  ///
  /// In zh, this message translates to:
  /// **'工具调用次数已达上限，请换个问法继续'**
  String get chatNoticeToolLimit;

  /// 模型返回空内容提示
  ///
  /// In zh, this message translates to:
  /// **'模型没有返回内容'**
  String get chatNoticeEmptyReply;

  /// 未取到 AI 配置时的提示
  ///
  /// In zh, this message translates to:
  /// **'请先在 AI 配置里完成设置'**
  String get chatIssueNoConfig;

  /// 空会话引导标题
  ///
  /// In zh, this message translates to:
  /// **'AI 提权助手'**
  String get chatEmptyTitle;

  /// 空会话引导说明
  ///
  /// In zh, this message translates to:
  /// **'描述你的设备情况，我会读取设备信息并给出提权方案'**
  String get chatEmptyHint;

  /// 空会话建议提问-设备环境
  ///
  /// In zh, this message translates to:
  /// **'分析我的设备环境'**
  String get chatSuggestionDevice;

  /// 空会话建议提问-root 状态
  ///
  /// In zh, this message translates to:
  /// **'当前设备是否已 root'**
  String get chatSuggestionRoot;

  /// 空会话建议提问-提权方案
  ///
  /// In zh, this message translates to:
  /// **'推荐一条可用的提权方案'**
  String get chatSuggestionPlan;

  /// 底栏圆球快捷面板标题
  ///
  /// In zh, this message translates to:
  /// **'AI 提权助手'**
  String get aiQuickPanelTitle;

  /// 底栏圆球快捷面板副标题
  ///
  /// In zh, this message translates to:
  /// **'选择一种方式开始获取最高权限'**
  String get aiQuickPanelSubtitle;

  /// 快捷面板-AI 提权入口
  ///
  /// In zh, this message translates to:
  /// **'AI 提权'**
  String get aiQuickEscalateTitle;

  /// 快捷面板-AI 提权入口说明
  ///
  /// In zh, this message translates to:
  /// **'智能分析设备环境，自动生成并执行提权方案'**
  String get aiQuickEscalateDesc;

  /// 快捷面板-手动提权入口
  ///
  /// In zh, this message translates to:
  /// **'手动提权'**
  String get manualQuickEscalateTitle;

  /// 快捷面板-手动提权入口说明
  ///
  /// In zh, this message translates to:
  /// **'利用目前已知的提权方案进行提权'**
  String get manualQuickEscalateDesc;

  /// 点击手动提权时的占位提示
  ///
  /// In zh, this message translates to:
  /// **'手动提权功能开发中'**
  String get manualQuickEscalateComingSoon;

  /// 设置项-语言（语言名称本身在组件内硬编码，不走 l10n）
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get languageTitle;

  /// 错误页标题
  ///
  /// In zh, this message translates to:
  /// **'页面不存在'**
  String get errorTitle;

  /// 路由未匹配时的提示
  ///
  /// In zh, this message translates to:
  /// **'没有找到页面：{location}'**
  String errorNotFound(String location);

  /// 路由构建异常时的提示
  ///
  /// In zh, this message translates to:
  /// **'路由构建失败'**
  String get errorBuildFailed;

  /// 错误页返回首页按钮
  ///
  /// In zh, this message translates to:
  /// **'返回首页'**
  String get backToHome;

  /// 通用加载失败提示
  ///
  /// In zh, this message translates to:
  /// **'加载失败，请稍后重试'**
  String get commonLoadFailed;

  /// 通用重试按钮
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get commonRetry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

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

  /// 复制回答后的提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
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
  /// **'AI 设备助手'**
  String get chatEmptyTitle;

  /// 空会话引导说明
  ///
  /// In zh, this message translates to:
  /// **'描述你的设备情况，我会读取设备信息并回答你的问题'**
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

  /// 空会话建议提问-ADB 状态
  ///
  /// In zh, this message translates to:
  /// **'这台设备的 ADB 状态怎么样'**
  String get chatSuggestionPlan;

  /// 会话列表标题
  ///
  /// In zh, this message translates to:
  /// **'会话'**
  String get chatSessions;

  /// 会话列表空态
  ///
  /// In zh, this message translates to:
  /// **'暂无会话'**
  String get chatSessionEmpty;

  /// 会话列表里正在接收流的会话状态
  ///
  /// In zh, this message translates to:
  /// **'正在生成…'**
  String get chatGenerating;

  /// 后台会话生成完成后的提示
  ///
  /// In zh, this message translates to:
  /// **'「{title}」已生成完成'**
  String chatSessionReady(String title);

  /// 会话没有标题时的占位名
  ///
  /// In zh, this message translates to:
  /// **'未命名对话'**
  String get chatUntitled;

  /// 重命名会话
  ///
  /// In zh, this message translates to:
  /// **'重命名'**
  String get chatRename;

  /// 重命名会话输入框占位文案
  ///
  /// In zh, this message translates to:
  /// **'输入会话名称'**
  String get chatRenameHint;

  /// 删除会话菜单项
  ///
  /// In zh, this message translates to:
  /// **'删除会话'**
  String get chatDeleteSession;

  /// 删除会话的确认文案
  ///
  /// In zh, this message translates to:
  /// **'删除后无法恢复，确定删除「{title}」吗？'**
  String chatDeleteConfirm(String title);

  /// 会话时间的相对描述-刚刚
  ///
  /// In zh, this message translates to:
  /// **'刚刚'**
  String get chatJustNow;

  /// 会话时间的相对描述-分钟
  ///
  /// In zh, this message translates to:
  /// **'{count} 分钟前'**
  String chatMinutesAgo(int count);

  /// 会话时间的相对描述-小时
  ///
  /// In zh, this message translates to:
  /// **'{count} 小时前'**
  String chatHoursAgo(int count);

  /// 会话时间的相对描述-天
  ///
  /// In zh, this message translates to:
  /// **'{count} 天前'**
  String chatDaysAgo(int count);

  /// 同一轮多个工具合并后的摘要行
  ///
  /// In zh, this message translates to:
  /// **'已执行 {count} 个工具'**
  String chatToolGroupSummary(int count);

  /// 工具结果过长时的展开提示
  ///
  /// In zh, this message translates to:
  /// **'展开全部 {count} 行'**
  String chatToolMoreLines(int count);

  /// 工具结果展开后的收起提示
  ///
  /// In zh, this message translates to:
  /// **'收起'**
  String get chatToolCollapse;

  /// 工具动作名-get_device_info
  ///
  /// In zh, this message translates to:
  /// **'读取设备信息'**
  String get chatToolReadDevice;

  /// 工具动作名-get_root_status
  ///
  /// In zh, this message translates to:
  /// **'检查 ROOT 状态'**
  String get chatToolCheckRoot;

  /// 工具动作名-get_adb_status
  ///
  /// In zh, this message translates to:
  /// **'检查 ADB 状态'**
  String get chatToolCheckAdb;

  /// 思考过程耗时摘要
  ///
  /// In zh, this message translates to:
  /// **'思考了 {seconds}s'**
  String chatThoughtFor(String seconds);

  /// 回答末尾的 token 消耗统计
  ///
  /// In zh, this message translates to:
  /// **'{count} tokens'**
  String chatUsageTokens(int count);

  /// 回答末尾的总耗时
  ///
  /// In zh, this message translates to:
  /// **'耗时 {seconds}s'**
  String chatElapsed(String seconds);

  /// 回答末尾操作-复制
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get chatActionCopy;

  /// 回答末尾操作-分享
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get chatActionShare;

  /// 回答末尾操作-重新生成
  ///
  /// In zh, this message translates to:
  /// **'重新生成'**
  String get chatActionRegenerate;

  /// 调用系统分享失败时的提示
  ///
  /// In zh, this message translates to:
  /// **'分享失败，请稍后重试'**
  String get chatShareFailed;

  /// 底栏圆球快捷面板标题
  ///
  /// In zh, this message translates to:
  /// **'AI 助手'**
  String get aiQuickPanelTitle;

  /// 快捷面板-AI 对话入口
  ///
  /// In zh, this message translates to:
  /// **'AI 对话'**
  String get aiQuickChatTitle;

  /// 快捷面板-AI 对话入口说明
  ///
  /// In zh, this message translates to:
  /// **'读取设备环境并回答你的问题'**
  String get aiQuickChatDesc;

  /// 快捷面板-手动提权入口
  ///
  /// In zh, this message translates to:
  /// **'手动提权'**
  String get aiQuickEscalationTitle;

  /// 快捷面板-手动提权入口说明
  ///
  /// In zh, this message translates to:
  /// **'匹配本机内核载荷，手动获取 ROOT'**
  String get aiQuickEscalationDesc;

  /// 手动提权页标题
  ///
  /// In zh, this message translates to:
  /// **'手动提权'**
  String get escalationTitle;

  /// 手动提权页顶部说明
  ///
  /// In zh, this message translates to:
  /// **'手动提权会按当前设备匹配本地内核载荷并尝试提升权限，操作不可逆，请先备份重要数据。'**
  String get escalationDesc;

  /// 手动提权页-环境信息小标题
  ///
  /// In zh, this message translates to:
  /// **'当前环境'**
  String get escalationEnvTitle;

  /// 手动提权页-SELinux 状态行
  ///
  /// In zh, this message translates to:
  /// **'SELinux'**
  String get escalationSelinuxTitle;

  /// 手动提权页-命令输入框标题
  ///
  /// In zh, this message translates to:
  /// **'命令'**
  String get escalationCommandLabel;

  /// 手动提权页-执行按钮
  ///
  /// In zh, this message translates to:
  /// **'执行'**
  String get escalationRunButton;

  /// 手动提权页-执行中按钮态
  ///
  /// In zh, this message translates to:
  /// **'执行中…'**
  String get escalationRunningButton;

  /// 手动提权页-清空按钮
  ///
  /// In zh, this message translates to:
  /// **'清空'**
  String get escalationClearButton;

  /// 手动提权页-已连接状态行
  ///
  /// In zh, this message translates to:
  /// **'shell 已连接（uid={uid}）'**
  String escalationShellConnected(int uid);

  /// 手动提权页-未连接状态行
  ///
  /// In zh, this message translates to:
  /// **'未连接，请先在首页完成无线调试配对'**
  String get escalationShellDisconnected;

  /// 手动提权页-调用失败标题
  ///
  /// In zh, this message translates to:
  /// **'调用失败'**
  String get escalationInvokeFailed;

  /// 手动提权页-结果行的超时后缀
  ///
  /// In zh, this message translates to:
  /// **'（超时）'**
  String get escalationTimedOutTag;

  /// 手动提权页-原生库目录缺失提示
  ///
  /// In zh, this message translates to:
  /// **'原生库目录不可用：当前安装没有解压 jniLibs 里的 so（需 extractNativeLibs / useLegacyPackaging 为 true）'**
  String get escalationNativeDirUnavailable;

  /// 手动提权页-预置命令：列出原生库目录
  ///
  /// In zh, this message translates to:
  /// **'库目录'**
  String get escalationPresetLibDir;

  /// 手动提权页-预置命令：LD_PRELOAD 注入验证
  ///
  /// In zh, this message translates to:
  /// **'L1 注入'**
  String get escalationPresetInject;

  /// 手动提权页-预置命令：so 校验和
  ///
  /// In zh, this message translates to:
  /// **'so 校验'**
  String get escalationPresetChecksum;

  /// 手动提权页-自动匹配并执行载荷提权的按钮
  ///
  /// In zh, this message translates to:
  /// **'开始提权'**
  String get escalationExploitButton;

  /// 手动提权页-匹配摘要：设备行标签
  ///
  /// In zh, this message translates to:
  /// **'设备'**
  String get escalationDeviceLabel;

  /// 手动提权页-匹配摘要：条目总数行标签
  ///
  /// In zh, this message translates to:
  /// **'清单条目'**
  String get escalationCatalogLabel;

  /// 手动提权页-匹配摘要：命中载荷行标签
  ///
  /// In zh, this message translates to:
  /// **'命中载荷'**
  String get escalationMatchLabel;

  /// 手动提权页-匹配摘要：无候选提示
  ///
  /// In zh, this message translates to:
  /// **'当前设备在清单里没有候选'**
  String get escalationMatchNone;

  /// 手动提权页-匹配摘要：加载态文案
  ///
  /// In zh, this message translates to:
  /// **'匹配中…'**
  String get escalationMatchLoading;

  /// 手动提权页-匹配摘要：同机型/同厂商兜底命中的警告
  ///
  /// In zh, this message translates to:
  /// **'降级命中，可能不可用'**
  String get escalationMatchDegraded;

  /// 手动提权页-匹配摘要：内核版本读不出来时的占位
  ///
  /// In zh, this message translates to:
  /// **'未知内核'**
  String get escalationKernelUnknown;

  /// 手动提权页-移交区标题
  ///
  /// In zh, this message translates to:
  /// **'移交 root'**
  String get escalationHandoffSection;

  /// 手动提权页-移交区说明：为什么必须移交
  ///
  /// In zh, this message translates to:
  /// **'提权拿到的是临时 root，重启即失效。把它交给已安装的管理器，由管理器加载内核模块后才会持久。'**
  String get escalationHandoffDesc;

  /// 手动提权页-移交区：管理器选择标签
  ///
  /// In zh, this message translates to:
  /// **'管理器'**
  String get escalationHandoffManagerLabel;

  /// 手动提权页-移交区：KernelSU 系管理器选项
  ///
  /// In zh, this message translates to:
  /// **'KernelSU'**
  String get escalationHandoffManagerKernelsu;

  /// 手动提权页-移交区：SukiSU Ultra 管理器选项
  ///
  /// In zh, this message translates to:
  /// **'SukiSU Ultra'**
  String get escalationHandoffManagerSukisu;

  /// 手动提权页-移交区的执行按钮
  ///
  /// In zh, this message translates to:
  /// **'移交给管理器'**
  String get escalationHandoffButton;

  /// 手动提权页-移交成功：告诉用户下一步去哪确认
  ///
  /// In zh, this message translates to:
  /// **'已移交给 {manager}，请打开 {manager} 确认模块已加载。'**
  String escalationHandoffSuccess(String manager);

  /// 手动提权页-管理器没装：给出包名与安装出路
  ///
  /// In zh, this message translates to:
  /// **'设备上没装 {manager}：找不到它的 libksud.so（包名 {package}）。请先安装 {manager}，再回来重试。'**
  String escalationHandoffManagerMissing(String manager, String package);

  /// 手动提权页-移交时没有 root
  ///
  /// In zh, this message translates to:
  /// **'当前没有 root：载荷没跑成功，或者临时 root 已经失效。先回到上面执行一次提权，再来移交。'**
  String get escalationHandoffNoRoot;

  /// 手动提权页-移交失败：带上退出码
  ///
  /// In zh, this message translates to:
  /// **'移交失败（退出码 {code}）。常见原因：管理器版本与内核模块不匹配、授权被拒绝，或管理器正在升级。'**
  String escalationHandoffFailed(int code);

  /// 手动提权页-移交失败但没有退出码
  ///
  /// In zh, this message translates to:
  /// **'移交失败：命令没跑起来，没拿到退出码。检查授权框是否被拒绝，或管理器是否在升级。'**
  String get escalationHandoffFailedNoCode;

  /// 手动提权页-管理器没装时给出的下载页按钮
  ///
  /// In zh, this message translates to:
  /// **'打开 {manager} 下载页'**
  String escalationHandoffOpenHome(String manager);

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

  /// 首页 ADB 卡片-shell 未连接时的配对按钮
  ///
  /// In zh, this message translates to:
  /// **'无线调试配对'**
  String get shellPairingStart;

  /// 首页 ADB 卡片-配对说明
  ///
  /// In zh, this message translates to:
  /// **'点击后在通知栏输入设备显示的配对码，不必切回应用'**
  String get shellPairingNotice;

  /// 首页 ADB 卡片-等待通知栏输入配对码
  ///
  /// In zh, this message translates to:
  /// **'等待输入配对码…'**
  String get shellPairingWaitingCode;

  /// 首页 ADB 卡片-正在与设备配对
  ///
  /// In zh, this message translates to:
  /// **'正在配对…'**
  String get shellPairingPairing;

  /// 首页 ADB 卡片-配对成功、正在连接调试端口
  ///
  /// In zh, this message translates to:
  /// **'配对码已收到，正在建立连接…'**
  String get shellPairingConnecting;

  /// 首页 ADB 卡片-取消配对按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get shellPairingCancel;

  /// 首页 ADB 卡片-配对失败后的重试按钮
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get shellPairingRetry;

  /// 首页 ADB 卡片-shell 已连接但没有 uid 时的状态
  ///
  /// In zh, this message translates to:
  /// **'shell 已连接'**
  String get shellConnected;

  /// 首页 ADB 卡片-shell 已连接时的状态
  ///
  /// In zh, this message translates to:
  /// **'shell 已连接（uid={uid}）'**
  String shellConnectedUid(int uid);

  /// 首页 ADB 卡片-shell 未连接状态
  ///
  /// In zh, this message translates to:
  /// **'shell 未连接'**
  String get shellDisconnected;

  /// 首页 ADB 卡片-复制失败原因按钮的提示
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get shellCopy;

  /// 首页 ADB 卡片-复制成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get shellCopied;

  /// 原因码-hostAuthFailed
  ///
  /// In zh, this message translates to:
  /// **'配对鉴权失败，请重试'**
  String get shellReasonHostAuthFailed;

  /// 原因码-hostDisconnected
  ///
  /// In zh, this message translates to:
  /// **'连接已断开'**
  String get shellReasonHostDisconnected;

  /// 原因码-pairingTimeout
  ///
  /// In zh, this message translates to:
  /// **'配对超时，请重试'**
  String get shellReasonPairingTimeout;

  /// 原因码-deviceRebooted
  ///
  /// In zh, this message translates to:
  /// **'设备重启导致连接中断'**
  String get shellReasonDeviceRebooted;

  /// 原因码-cancelled
  ///
  /// In zh, this message translates to:
  /// **'已取消配对'**
  String get shellReasonCancelled;

  /// 原因码-hostPairingFailed 兜底
  ///
  /// In zh, this message translates to:
  /// **'配对失败，请重试'**
  String get shellReasonHostPairingFailed;
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

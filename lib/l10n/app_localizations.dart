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

  /// 提权页标题
  ///
  /// In zh, this message translates to:
  /// **'提权'**
  String get escalationTitle;

  /// 提权页副标题
  ///
  /// In zh, this message translates to:
  /// **'探测设备能力并执行提权链'**
  String get escalationSubtitle;

  /// 提权页-设备信息分区标题
  ///
  /// In zh, this message translates to:
  /// **'设备信息'**
  String get escalationSectionDevice;

  /// 提权页-连接分区标题
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get escalationSectionConnection;

  /// 提权页-能力矩阵分区标题
  ///
  /// In zh, this message translates to:
  /// **'能力矩阵'**
  String get escalationSectionChains;

  /// 提权页-执行时间线分区标题
  ///
  /// In zh, this message translates to:
  /// **'执行时间线'**
  String get escalationSectionTimeline;

  /// 能力矩阵-链可用
  ///
  /// In zh, this message translates to:
  /// **'可用'**
  String get escalationAvailable;

  /// 能力矩阵-链不可用
  ///
  /// In zh, this message translates to:
  /// **'不可用'**
  String get escalationUnavailable;

  /// 提权页主按钮
  ///
  /// In zh, this message translates to:
  /// **'开始提权'**
  String get escalationStart;

  /// 提权页取消按钮
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get escalationCancel;

  /// 提权页重试按钮
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get escalationRetry;

  /// 无可用链时的提示
  ///
  /// In zh, this message translates to:
  /// **'当前设备没有可用的提权链'**
  String get escalationNoAvailableChain;

  /// 非 Android 平台的提示
  ///
  /// In zh, this message translates to:
  /// **'当前平台不支持提权'**
  String get escalationPlatformUnsupported;

  /// 二次确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'确认执行提权？'**
  String get escalationConfirmTitle;

  /// 二次确认弹窗正文
  ///
  /// In zh, this message translates to:
  /// **'该操作可能修改系统状态，失败后存在遗留风险。'**
  String get escalationConfirmBody;

  /// 链危险等级-低
  ///
  /// In zh, this message translates to:
  /// **'低风险'**
  String get escalationDangerLow;

  /// 链危险等级-中
  ///
  /// In zh, this message translates to:
  /// **'中风险'**
  String get escalationDangerMedium;

  /// 链危险等级-高
  ///
  /// In zh, this message translates to:
  /// **'高风险'**
  String get escalationDangerHigh;

  /// 遗留状态告警横幅
  ///
  /// In zh, this message translates to:
  /// **'检测到上次运行未清理干净，建议先处理遗留状态'**
  String get escalationResidualWarning;

  /// 宿主连接中提示
  ///
  /// In zh, this message translates to:
  /// **'正在连接提权宿主…'**
  String get escalationHostConnecting;

  /// 宿主未连接提示
  ///
  /// In zh, this message translates to:
  /// **'提权宿主未连接'**
  String get escalationHostDisconnected;

  /// 提权页-通知栏配对入口按钮
  ///
  /// In zh, this message translates to:
  /// **'无线调试配对'**
  String get escalationPairingStart;

  /// 提权页-通知栏配对说明
  ///
  /// In zh, this message translates to:
  /// **'配对码在下拉通知栏里输入，不要切换应用；切屏会让系统的配对弹窗失效。'**
  String get escalationPairingNotice;

  /// 提权页-通知栏配对进行中提示
  ///
  /// In zh, this message translates to:
  /// **'等待通知栏输入配对码…'**
  String get escalationPairingWaiting;

  /// 提权页-配对码已交换成功、正在连接调试端口
  ///
  /// In zh, this message translates to:
  /// **'配对码已收到，正在建立调试连接…'**
  String get escalationPairingConnecting;

  /// 提权页-配对会话成功结论
  ///
  /// In zh, this message translates to:
  /// **'配对成功，特权进程已就绪'**
  String get escalationPairingSucceeded;

  /// 提权页-配对会话失败结论
  ///
  /// In zh, this message translates to:
  /// **'配对失败'**
  String get escalationPairingFailed;

  /// 提权页-配对成功且点火进行中的结论
  ///
  /// In zh, this message translates to:
  /// **'配对成功，正在启动特权进程…'**
  String get escalationIgniteStarting;

  /// 提权页-点火进行中的主按钮文案
  ///
  /// In zh, this message translates to:
  /// **'正在启动特权进程…'**
  String get escalationIgniteRunning;

  /// 提权页-点火失败后的重试按钮
  ///
  /// In zh, this message translates to:
  /// **'重试启动特权进程'**
  String get escalationIgniteRetry;

  /// 提权页-配对成功但点火失败的结论
  ///
  /// In zh, this message translates to:
  /// **'配对成功，但特权进程未启动'**
  String get escalationIgniteFailed;

  /// 提权页-空闲态状态行：特权进程已就绪
  ///
  /// In zh, this message translates to:
  /// **'宿主已就绪（uid=2000）'**
  String get escalationHostReady;

  /// 提权页-空闲态状态行：特权进程未启动
  ///
  /// In zh, this message translates to:
  /// **'宿主未启动，配对成功后会自动拉起'**
  String get escalationHostNotStarted;

  /// 提权页-已就绪时提供的断开入口按钮
  ///
  /// In zh, this message translates to:
  /// **'断开宿主'**
  String get escalationHostDisconnect;

  /// 提权页-断开请求发出后按钮上的过渡文案
  ///
  /// In zh, this message translates to:
  /// **'正在断开…'**
  String get escalationHostDisconnecting;

  /// 提权页-断开按钮下方的说明
  ///
  /// In zh, this message translates to:
  /// **'断开后特权进程会退出，需要重新配对才能再拉起'**
  String get escalationHostDisconnectHint;

  /// 提权页-运行中状态行前缀
  ///
  /// In zh, this message translates to:
  /// **'执行中'**
  String get escalationRunning;

  /// 提权页-失败阶段的具体原因标签
  ///
  /// In zh, this message translates to:
  /// **'失败原因'**
  String get escalationFailureDetail;

  /// 提权页-复制失败原因按钮的提示
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get escalationCopy;

  /// 提权页-复制失败原因成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get escalationCopied;

  /// 导出执行记录按钮
  ///
  /// In zh, this message translates to:
  /// **'导出记录'**
  String get escalationExportRecord;

  /// 无可导出记录提示
  ///
  /// In zh, this message translates to:
  /// **'暂无可导出的记录'**
  String get escalationExportEmpty;

  /// 执行记录为空提示
  ///
  /// In zh, this message translates to:
  /// **'暂无执行记录'**
  String get escalationRecordEmpty;

  /// 提权链名称-shellChannel
  ///
  /// In zh, this message translates to:
  /// **'L1 通道自检'**
  String get escalationChainShellChannelName;

  /// 提权链说明-shellChannel
  ///
  /// In zh, this message translates to:
  /// **'验证能否以 shell(2000) 执行命令并写盘，不涉及提权'**
  String get escalationChainShellChannelDesc;

  /// 提权链名称-kernelModule
  ///
  /// In zh, this message translates to:
  /// **'内核模块'**
  String get escalationChainKernelModuleName;

  /// 提权链说明-kernelModule
  ///
  /// In zh, this message translates to:
  /// **'通过加载内核模块获得提权'**
  String get escalationChainKernelModuleDesc;

  /// 提权链名称-payload
  ///
  /// In zh, this message translates to:
  /// **'载荷链'**
  String get escalationChainPayloadName;

  /// 提权链说明-payload
  ///
  /// In zh, this message translates to:
  /// **'使用本地载荷完成提权'**
  String get escalationChainPayloadDesc;

  /// 提权链名称-kernelExploit
  ///
  /// In zh, this message translates to:
  /// **'内核漏洞'**
  String get escalationChainKernelExploitName;

  /// 提权链说明-kernelExploit
  ///
  /// In zh, this message translates to:
  /// **'利用内核漏洞获得临时提权'**
  String get escalationChainKernelExploitDesc;

  /// 提权链名称-pageCache
  ///
  /// In zh, this message translates to:
  /// **'PageCache'**
  String get escalationChainPageCacheName;

  /// 提权链说明-pageCache
  ///
  /// In zh, this message translates to:
  /// **'通过 PageCache 写入获得提权'**
  String get escalationChainPageCacheDesc;

  /// 执行阶段-probe
  ///
  /// In zh, this message translates to:
  /// **'探测'**
  String get escalationStageProbe;

  /// 执行阶段-prepare
  ///
  /// In zh, this message translates to:
  /// **'准备'**
  String get escalationStagePrepare;

  /// 执行阶段-execute
  ///
  /// In zh, this message translates to:
  /// **'执行'**
  String get escalationStageExecute;

  /// 执行阶段-verify
  ///
  /// In zh, this message translates to:
  /// **'校验'**
  String get escalationStageVerify;

  /// 执行阶段-cleanup
  ///
  /// In zh, this message translates to:
  /// **'清理'**
  String get escalationStageCleanup;

  /// 执行结果-success
  ///
  /// In zh, this message translates to:
  /// **'提权成功'**
  String get escalationOutcomeSuccess;

  /// 执行结果-partial
  ///
  /// In zh, this message translates to:
  /// **'部分成功'**
  String get escalationOutcomePartial;

  /// 执行结果-failed
  ///
  /// In zh, this message translates to:
  /// **'提权失败'**
  String get escalationOutcomeFailed;

  /// 执行结果-unsafe
  ///
  /// In zh, this message translates to:
  /// **'存在风险'**
  String get escalationOutcomeUnsafe;

  /// 执行结果-unsupported
  ///
  /// In zh, this message translates to:
  /// **'不支持'**
  String get escalationOutcomeUnsupported;

  /// 执行结果-notStarted
  ///
  /// In zh, this message translates to:
  /// **'未开始'**
  String get escalationOutcomeNotStarted;

  /// 设备信息-Android SDK 版本
  ///
  /// In zh, this message translates to:
  /// **'Android SDK'**
  String get escalationDeviceSdk;

  /// 设备信息-CPU 架构
  ///
  /// In zh, this message translates to:
  /// **'架构'**
  String get escalationDeviceAbi;

  /// 设备信息-内核版本
  ///
  /// In zh, this message translates to:
  /// **'内核版本'**
  String get escalationDeviceKernel;

  /// 设备信息-SELinux 状态
  ///
  /// In zh, this message translates to:
  /// **'SELinux'**
  String get escalationDeviceSelinux;

  /// 设备信息-厂商
  ///
  /// In zh, this message translates to:
  /// **'厂商'**
  String get escalationDeviceManufacturer;

  /// 设备信息-机型
  ///
  /// In zh, this message translates to:
  /// **'机型'**
  String get escalationDeviceModel;

  /// 原因码-platformUnsupported
  ///
  /// In zh, this message translates to:
  /// **'当前平台不支持该提权链'**
  String get escalationReasonPlatformUnsupported;

  /// 原因码-androidTooOld
  ///
  /// In zh, this message translates to:
  /// **'系统版本过低'**
  String get escalationReasonAndroidTooOld;

  /// 原因码-deviceNotSupported
  ///
  /// In zh, this message translates to:
  /// **'设备不在支持列表内'**
  String get escalationReasonDeviceNotSupported;

  /// 原因码-probeTimeout
  ///
  /// In zh, this message translates to:
  /// **'探测超时'**
  String get escalationReasonProbeTimeout;

  /// 原因码-probeFailed
  ///
  /// In zh, this message translates to:
  /// **'探测失败'**
  String get escalationReasonProbeFailed;

  /// 原因码-noRootBinary
  ///
  /// In zh, this message translates to:
  /// **'未找到 su 可执行文件'**
  String get escalationReasonNoRootBinary;

  /// 原因码-noSelinuxContext
  ///
  /// In zh, this message translates to:
  /// **'缺少可用的 SELinux 上下文'**
  String get escalationReasonNoSelinuxContext;

  /// 原因码-selinuxEnforcing
  ///
  /// In zh, this message translates to:
  /// **'SELinux 处于强制模式'**
  String get escalationReasonSelinuxEnforcing;

  /// 原因码-shellUnavailable
  ///
  /// In zh, this message translates to:
  /// **'Shell 不可用'**
  String get escalationReasonShellUnavailable;

  /// 原因码-shellDenied
  ///
  /// In zh, this message translates to:
  /// **'Shell 执行被拒绝'**
  String get escalationReasonShellDenied;

  /// 原因码-shellTimeout
  ///
  /// In zh, this message translates to:
  /// **'Shell 执行超时'**
  String get escalationReasonShellTimeout;

  /// 原因码-payloadMissing
  ///
  /// In zh, this message translates to:
  /// **'载荷文件缺失'**
  String get escalationReasonPayloadMissing;

  /// 原因码-payloadMismatch
  ///
  /// In zh, this message translates to:
  /// **'载荷与设备不匹配'**
  String get escalationReasonPayloadMismatch;

  /// 原因码-catalogCorrupted
  ///
  /// In zh, this message translates to:
  /// **'资产目录损坏'**
  String get escalationReasonCatalogCorrupted;

  /// 原因码-kernelNotSupported
  ///
  /// In zh, this message translates to:
  /// **'内核不支持'**
  String get escalationReasonKernelNotSupported;

  /// 原因码-kernelModuleLoadFailed
  ///
  /// In zh, this message translates to:
  /// **'内核模块加载失败'**
  String get escalationReasonKernelModuleLoadFailed;

  /// 原因码-kernelVersionMismatch
  ///
  /// In zh, this message translates to:
  /// **'内核版本不匹配'**
  String get escalationReasonKernelVersionMismatch;

  /// 原因码-executeTimeout
  ///
  /// In zh, this message translates to:
  /// **'执行超时'**
  String get escalationReasonExecuteTimeout;

  /// 原因码-executeFailed
  ///
  /// In zh, this message translates to:
  /// **'执行失败'**
  String get escalationReasonExecuteFailed;

  /// 原因码-verifyFailedAtExternal
  ///
  /// In zh, this message translates to:
  /// **'外部状态校验未通过'**
  String get escalationReasonVerifyFailedAtExternal;

  /// 原因码-verifyTimeout
  ///
  /// In zh, this message translates to:
  /// **'校验超时'**
  String get escalationReasonVerifyTimeout;

  /// 原因码-cleanupFailed
  ///
  /// In zh, this message translates to:
  /// **'清理失败'**
  String get escalationReasonCleanupFailed;

  /// 原因码-enforceRestoreFailed
  ///
  /// In zh, this message translates to:
  /// **'SELinux 状态恢复失败'**
  String get escalationReasonEnforceRestoreFailed;

  /// 原因码-residualLeft
  ///
  /// In zh, this message translates to:
  /// **'存在遗留状态'**
  String get escalationReasonResidualLeft;

  /// 原因码-hostDisconnected
  ///
  /// In zh, this message translates to:
  /// **'提权宿主未连接'**
  String get escalationReasonHostDisconnected;

  /// 原因码-hostAuthFailed
  ///
  /// In zh, this message translates to:
  /// **'提权宿主鉴权失败'**
  String get escalationReasonHostAuthFailed;

  /// 原因码-hostPairingFailed
  ///
  /// In zh, this message translates to:
  /// **'提权宿主配对失败'**
  String get escalationReasonHostPairingFailed;

  /// 原因码-unknown 兜底
  ///
  /// In zh, this message translates to:
  /// **'未知原因'**
  String get escalationReasonUnknown;
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

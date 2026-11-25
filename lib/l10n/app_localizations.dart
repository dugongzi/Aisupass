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

  /// 设置页分组标题-关于
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get settingsAboutSection;

  /// 设置页关于分组-当前版本号
  ///
  /// In zh, this message translates to:
  /// **'版本'**
  String get settingsAboutVersionTitle;

  /// 设置页关于分组-官网入口
  ///
  /// In zh, this message translates to:
  /// **'官网'**
  String get settingsAboutWebsiteTitle;

  /// 设置页关于分组-检查更新入口
  ///
  /// In zh, this message translates to:
  /// **'检查更新'**
  String get updateCheckTitle;

  /// 检查更新入口副标题
  ///
  /// In zh, this message translates to:
  /// **'当前版本 {version}（{buildNumber}）'**
  String updateCurrentVersion(String version, String buildNumber);

  /// 更新弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'发现新版本'**
  String get updateAvailableTitle;

  /// 更新弹窗里展示的远端版本号
  ///
  /// In zh, this message translates to:
  /// **'新版本 {version}'**
  String updateAvailableVersion(String version);

  /// 更新弹窗里更新说明的小标题
  ///
  /// In zh, this message translates to:
  /// **'更新内容'**
  String get updateNotesTitle;

  /// 接口未提供更新说明时的占位文本
  ///
  /// In zh, this message translates to:
  /// **'暂无更新说明'**
  String get updateNotesFallback;

  /// 更新弹窗的主按钮
  ///
  /// In zh, this message translates to:
  /// **'立即更新'**
  String get updateNow;

  /// 更新弹窗的次按钮；强制更新时不显示
  ///
  /// In zh, this message translates to:
  /// **'稍后再说'**
  String get updateLater;

  /// 手动检查更新且无新版本时的提示
  ///
  /// In zh, this message translates to:
  /// **'已是最新版本'**
  String get updateLatest;

  /// 检查更新失败的提示
  ///
  /// In zh, this message translates to:
  /// **'检查更新失败，请稍后重试'**
  String get updateCheckFailed;

  /// 更新接口地址为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'未配置更新接口'**
  String get updateNotConfigured;

  /// 启动公告弹层的标题
  ///
  /// In zh, this message translates to:
  /// **'最新公告'**
  String get announcementTitle;

  /// 关闭公告弹层的按钮
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get announcementClose;

  /// 公告弹层中跳转交流群的按钮
  ///
  /// In zh, this message translates to:
  /// **'获取教程'**
  String get announcementTutorial;

  /// 设置页关于分组-源码仓库入口
  ///
  /// In zh, this message translates to:
  /// **'开源地址'**
  String get settingsAboutRepoTitle;

  /// 设置页关于分组-协议全文入口
  ///
  /// In zh, this message translates to:
  /// **'开源协议'**
  String get settingsAboutLicenseTitle;

  /// 设置页关于分组-协议名称副标题
  ///
  /// In zh, this message translates to:
  /// **'GNU General Public License v3.0'**
  String get settingsAboutLicenseSubtitle;

  /// 协议全文页标题
  ///
  /// In zh, this message translates to:
  /// **'开源许可'**
  String get openSourceLicensePageTitle;

  /// 协议页切换条-本项目 GPL-3.0
  ///
  /// In zh, this message translates to:
  /// **'本项目协议'**
  String get licenseDocProjectTitle;

  /// 协议页切换条-第三方组件声明
  ///
  /// In zh, this message translates to:
  /// **'第三方声明'**
  String get licenseDocThirdPartyTitle;

  /// 协议页切换条-Apache 2.0 全文
  ///
  /// In zh, this message translates to:
  /// **'Apache-2.0'**
  String get licenseDocApacheTitle;

  /// 协议页切换条-GPL 2.0 全文
  ///
  /// In zh, this message translates to:
  /// **'GPL-2.0'**
  String get licenseDocGpl2Title;

  /// 设置页关于分组-第三方声明入口
  ///
  /// In zh, this message translates to:
  /// **'第三方开源声明'**
  String get settingsAboutThirdPartyTitle;

  /// 设置页关于分组-第三方声明副标题
  ///
  /// In zh, this message translates to:
  /// **'组件来源与许可证'**
  String get settingsAboutThirdPartySubtitle;

  /// 协议全文读取失败提示
  ///
  /// In zh, this message translates to:
  /// **'协议文本加载失败'**
  String get openSourceLicenseLoadFailed;

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

  /// 通用重置按钮
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get aiReset;

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

  /// 工具渲染了需要用户操作的组件，本轮挂起
  ///
  /// In zh, this message translates to:
  /// **'等你在上方完成操作后自动继续'**
  String get chatNoticeAwaitingUser;

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
  /// **'AISUPASS'**
  String get chatEmptyTitle;

  /// 空会话引导说明
  ///
  /// In zh, this message translates to:
  /// **'提出你的需求，我会给你最佳提权方案'**
  String get chatEmptyHint;

  /// 空会话建议提问-查找本机型 ROM 包
  ///
  /// In zh, this message translates to:
  /// **'帮我找一下本机型的 ROM 包'**
  String get chatSuggestionRom;

  /// 空会话建议提问-分析提权方案
  ///
  /// In zh, this message translates to:
  /// **'分析一下本机型的提权方案'**
  String get chatSuggestionEscalation;

  /// 空会话建议按钮-跳转交流群
  ///
  /// In zh, this message translates to:
  /// **'获取技术支持'**
  String get chatSuggestionSupport;

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

  /// 围栏代码块未标注语言时的标签
  ///
  /// In zh, this message translates to:
  /// **'代码'**
  String get chatCodeLabel;

  /// 用户气泡-长代码块展开
  ///
  /// In zh, this message translates to:
  /// **'展开全文'**
  String get chatCodeExpand;

  /// 用户气泡-代码块行数
  ///
  /// In zh, this message translates to:
  /// **'{lines} 行'**
  String chatCodeLines(int lines);

  /// Markdown 图片缺失替代文本时的占位说明
  ///
  /// In zh, this message translates to:
  /// **'图片'**
  String get chatImageLabel;

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

  /// 工具动作名-adb_shell_exec
  ///
  /// In zh, this message translates to:
  /// **'执行 adb shell 命令'**
  String get chatToolExecAdbShell;

  /// 工具动作名-adb_pairing_request
  ///
  /// In zh, this message translates to:
  /// **'请求无线调试配对'**
  String get chatToolRequestAdbPairing;

  /// 工具动作名-stellar_service_status
  ///
  /// In zh, this message translates to:
  /// **'查询 Stellar 服务状态'**
  String get chatToolReadStellarStatus;

  /// 工具动作名-web_search
  ///
  /// In zh, this message translates to:
  /// **'联网搜索'**
  String get chatToolWebSearch;

  /// 工具动作名-open_in_browser
  ///
  /// In zh, this message translates to:
  /// **'用浏览器打开网页'**
  String get chatToolOpenInBrowser;

  /// 工具动作名-fetch_web_page
  ///
  /// In zh, this message translates to:
  /// **'获取网页源码'**
  String get chatToolFetchWebPage;

  /// 对话内网页卡片-取不到域名时的标题
  ///
  /// In zh, this message translates to:
  /// **'网页'**
  String get chatBrowserPanelTitle;

  /// 对话内网页卡片-打开按钮
  ///
  /// In zh, this message translates to:
  /// **'用浏览器打开'**
  String get chatBrowserOpen;

  /// 对话内网页卡片-用内置浏览器打开
  ///
  /// In zh, this message translates to:
  /// **'在应用内打开'**
  String get chatBrowserOpenInApp;

  /// 内置浏览器-后退
  ///
  /// In zh, this message translates to:
  /// **'后退'**
  String get chatBrowserBack;

  /// 内置浏览器-前进
  ///
  /// In zh, this message translates to:
  /// **'前进'**
  String get chatBrowserForward;

  /// 内置浏览器-刷新
  ///
  /// In zh, this message translates to:
  /// **'刷新'**
  String get chatBrowserReload;

  /// 内置浏览器-回传当前页面源码
  ///
  /// In zh, this message translates to:
  /// **'把页面交给 AI'**
  String get chatBrowserHandoffSource;

  /// 内置浏览器-只回传当前 URL
  ///
  /// In zh, this message translates to:
  /// **'只回传网址'**
  String get chatBrowserHandoffUrl;

  /// 内置浏览器-选择本地已下载的固件文件
  ///
  /// In zh, this message translates to:
  /// **'选择已下载文件'**
  String get chatBrowserHandoffFile;

  /// 内置浏览器-桌面端不支持
  ///
  /// In zh, this message translates to:
  /// **'桌面端没有内置浏览器，请用系统浏览器打开后把文件选回来'**
  String get chatBrowserDesktopUnsupported;

  /// 内置浏览器-缺少起始地址
  ///
  /// In zh, this message translates to:
  /// **'没有可打开的网址'**
  String get chatBrowserEmptyUrl;

  /// 对话内网页卡片-已打开过之后的按钮
  ///
  /// In zh, this message translates to:
  /// **'再次打开'**
  String get chatBrowserOpenAgain;

  /// 对话内网页卡片-复制链接按钮
  ///
  /// In zh, this message translates to:
  /// **'复制链接'**
  String get chatBrowserCopyLink;

  /// 对话内网页卡片-复制成功
  ///
  /// In zh, this message translates to:
  /// **'链接已复制'**
  String get chatBrowserLinkCopied;

  /// 对话内网页卡片-拉起浏览器失败
  ///
  /// In zh, this message translates to:
  /// **'无法打开浏览器，可复制链接手动访问'**
  String get chatBrowserOpenFailed;

  /// 内置浏览器-主文档加载失败
  ///
  /// In zh, this message translates to:
  /// **'页面加载失败'**
  String get chatBrowserLoadFailed;

  /// 内置浏览器-加载超时提示
  ///
  /// In zh, this message translates to:
  /// **'加载超时：站点可能拒绝内置 WebView，或需要登录、验证后才能访问，可改用系统浏览器'**
  String get chatBrowserLoadTimeout;

  /// 内置浏览器-重新加载按钮
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get chatBrowserRetry;

  /// 内置浏览器-标题栏进度
  ///
  /// In zh, this message translates to:
  /// **'载入中 {percent}%'**
  String chatBrowserLoadingPercent(int percent);

  /// 对话内 ADB 连接组件标题
  ///
  /// In zh, this message translates to:
  /// **'无线调试连接'**
  String get chatAdbPanelTitle;

  /// 对话内 ADB 组件-已发起配对并挂起
  ///
  /// In zh, this message translates to:
  /// **'已打开系统无线调试，完成配对后返回即可'**
  String get chatAdbPairingPending;

  /// 对话内 ADB 组件-配对失败
  ///
  /// In zh, this message translates to:
  /// **'配对未完成'**
  String get chatAdbPairingFailed;

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

  /// 输入栏提示词库入口与弹层标题
  ///
  /// In zh, this message translates to:
  /// **'常用提示词'**
  String get chatPromptTitle;

  /// 提示词库首次读盘中的占位文案
  ///
  /// In zh, this message translates to:
  /// **'正在读取提示词…'**
  String get chatPromptLoading;

  /// 提示词库为空时的引导文案
  ///
  /// In zh, this message translates to:
  /// **'还没有常用提示词，点击右上角 + 新建一条'**
  String get chatPromptEmpty;

  /// 提示词库-新建按钮与弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'新建提示词'**
  String get chatPromptAdd;

  /// 提示词库-编辑菜单项与弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'编辑提示词'**
  String get chatPromptEdit;

  /// 提示词库-把提示词插入输入框
  ///
  /// In zh, this message translates to:
  /// **'插入'**
  String get chatPromptInsert;

  /// 提示词库-删除菜单项与确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'删除提示词'**
  String get chatPromptDelete;

  /// 提示词库-删除确认文案
  ///
  /// In zh, this message translates to:
  /// **'确定删除「{title}」吗？'**
  String chatPromptDeleteConfirm(String title);

  /// 提示词保存成功提示
  ///
  /// In zh, this message translates to:
  /// **'提示词已保存'**
  String get chatPromptSaved;

  /// 提示词删除成功提示
  ///
  /// In zh, this message translates to:
  /// **'提示词已删除'**
  String get chatPromptDeleted;

  /// 提示词编辑器-标题字段
  ///
  /// In zh, this message translates to:
  /// **'标题'**
  String get chatPromptName;

  /// 提示词编辑器-标题占位文案
  ///
  /// In zh, this message translates to:
  /// **'例如：分析设备环境'**
  String get chatPromptNameHint;

  /// 提示词编辑器-内容字段
  ///
  /// In zh, this message translates to:
  /// **'内容'**
  String get chatPromptContent;

  /// 提示词编辑器-内容占位文案
  ///
  /// In zh, this message translates to:
  /// **'输入要发送给 AI 的提示词'**
  String get chatPromptContentHint;

  /// 提示词编辑器-内容为空的校验提示
  ///
  /// In zh, this message translates to:
  /// **'提示词内容不能为空'**
  String get chatPromptContentRequired;

  /// 输入栏附件按钮提示
  ///
  /// In zh, this message translates to:
  /// **'添加附件'**
  String get chatAttachTitle;

  /// 附件选择弹层-图片入口
  ///
  /// In zh, this message translates to:
  /// **'选择图片'**
  String get chatAttachImage;

  /// 附件选择弹层-文本文件入口
  ///
  /// In zh, this message translates to:
  /// **'选择文本文件'**
  String get chatAttachText;

  /// 附件选择弹层-镜像与压缩包入口
  ///
  /// In zh, this message translates to:
  /// **'选择镜像/压缩包'**
  String get chatAttachBinary;

  /// 选中文件拿不到真实路径时的提示
  ///
  /// In zh, this message translates to:
  /// **'无法获取 {name} 的本地路径'**
  String chatAttachNoPath(String name);

  /// 选中文件类型不在允许列表时的提示
  ///
  /// In zh, this message translates to:
  /// **'不支持该文件类型'**
  String get chatAttachUnsupported;

  /// 附件超过大小上限时的提示
  ///
  /// In zh, this message translates to:
  /// **'文件过大：{name}'**
  String chatAttachTooLarge(String name);

  /// 附件复制或读取失败时的提示
  ///
  /// In zh, this message translates to:
  /// **'添加附件失败'**
  String get chatAttachFailed;

  /// 附件数量达到上限时的提示
  ///
  /// In zh, this message translates to:
  /// **'单条消息最多添加 {count} 个附件'**
  String chatAttachLimit(int count);

  /// 对话页手册入口与弹层标题
  ///
  /// In zh, this message translates to:
  /// **'AI 能力手册'**
  String get chatManualTitle;

  /// 手册弹层副标题
  ///
  /// In zh, this message translates to:
  /// **'助手在对话中可以调用的本地能力与工具'**
  String get chatManualSubtitle;

  /// 手册底部关于工具确认机制的说明
  ///
  /// In zh, this message translates to:
  /// **'执行类工具在动作前会先征求你的确认；只读工具可直接调用'**
  String get chatManualConfirmHint;

  /// No description provided for @chatToolDesc_get_device_info.
  ///
  /// In zh, this message translates to:
  /// **'读取机型、系统版本、内核、补丁、基带、ABI 与 SELinux 等设备信息'**
  String get chatToolDesc_get_device_info;

  /// No description provided for @chatToolDesc_get_root_status.
  ///
  /// In zh, this message translates to:
  /// **'检查当前进程是否已获得 ROOT 权限'**
  String get chatToolDesc_get_root_status;

  /// No description provided for @chatToolDesc_get_adb_status.
  ///
  /// In zh, this message translates to:
  /// **'检查 USB 与无线调试开关是否打开'**
  String get chatToolDesc_get_adb_status;

  /// No description provided for @chatToolDesc_adb_shell_exec.
  ///
  /// In zh, this message translates to:
  /// **'在已连接的 adb shell（uid 2000）执行一条命令，返回退出码与输出'**
  String get chatToolDesc_adb_shell_exec;

  /// No description provided for @chatToolDesc_adb_pairing_request.
  ///
  /// In zh, this message translates to:
  /// **'打开无线调试配对面板，引导完成 adb 配对'**
  String get chatToolDesc_adb_pairing_request;

  /// No description provided for @chatToolDesc_stellar_service_status.
  ///
  /// In zh, this message translates to:
  /// **'读取 Stellar 特权服务的可用状态与运行身份'**
  String get chatToolDesc_stellar_service_status;

  /// No description provided for @chatToolDesc_web_search.
  ///
  /// In zh, this message translates to:
  /// **'用 Bing 搜索公开网络，返回标题、链接与摘要'**
  String get chatToolDesc_web_search;

  /// No description provided for @chatToolDesc_fetch_web_page.
  ///
  /// In zh, this message translates to:
  /// **'抓取指定网页的原始源码，同时返回状态码与内容类型'**
  String get chatToolDesc_fetch_web_page;

  /// No description provided for @chatToolDesc_open_in_browser.
  ///
  /// In zh, this message translates to:
  /// **'用应用内浏览器打开网页，可回传网址或页面源码'**
  String get chatToolDesc_open_in_browser;

  /// No description provided for @chatToolDesc_escalation_get_device_identity.
  ///
  /// In zh, this message translates to:
  /// **'读取提权需要的设备与内核标识'**
  String get chatToolDesc_escalation_get_device_identity;

  /// No description provided for @chatToolDesc_escalation_list_payloads.
  ///
  /// In zh, this message translates to:
  /// **'列出内置提权载荷清单'**
  String get chatToolDesc_escalation_list_payloads;

  /// No description provided for @chatToolDesc_escalation_resolve_payload.
  ///
  /// In zh, this message translates to:
  /// **'按机型与内核匹配合适的提权载荷'**
  String get chatToolDesc_escalation_resolve_payload;

  /// No description provided for @chatToolDesc_escalation_list_root_managers.
  ///
  /// In zh, this message translates to:
  /// **'列出设备上可用的 ROOT 管理器'**
  String get chatToolDesc_escalation_list_root_managers;

  /// No description provided for @chatToolDesc_escalation_get_selected_root_manager.
  ///
  /// In zh, this message translates to:
  /// **'读取当前选中的 ROOT 管理器'**
  String get chatToolDesc_escalation_get_selected_root_manager;

  /// No description provided for @chatToolDesc_escalation_run_payload.
  ///
  /// In zh, this message translates to:
  /// **'执行指定的提权载荷'**
  String get chatToolDesc_escalation_run_payload;

  /// No description provided for @chatToolDesc_escalation_run_payload_by_id.
  ///
  /// In zh, this message translates to:
  /// **'按编号执行提权载荷'**
  String get chatToolDesc_escalation_run_payload_by_id;

  /// No description provided for @chatToolDesc_escalation_handoff_root.
  ///
  /// In zh, this message translates to:
  /// **'把已取得的 root 移交给指定管理器'**
  String get chatToolDesc_escalation_handoff_root;

  /// No description provided for @chatToolDesc_escalation_select_root_manager.
  ///
  /// In zh, this message translates to:
  /// **'选择后续交接使用的 ROOT 管理器'**
  String get chatToolDesc_escalation_select_root_manager;

  /// No description provided for @chatToolDesc_ghost_key_preflight.
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 预检：ADB、内核、配置与原生库是否就绪'**
  String get chatToolDesc_ghost_key_preflight;

  /// No description provided for @chatToolDesc_ghost_key_get_run_defaults.
  ///
  /// In zh, this message translates to:
  /// **'读取 GhostKey 运行默认参数'**
  String get chatToolDesc_ghost_key_get_run_defaults;

  /// No description provided for @chatToolDesc_ghost_key_save_run_defaults.
  ///
  /// In zh, this message translates to:
  /// **'保存 GhostKey 运行默认参数'**
  String get chatToolDesc_ghost_key_save_run_defaults;

  /// No description provided for @chatToolDesc_ghost_key_start.
  ///
  /// In zh, this message translates to:
  /// **'启动一次 GhostKey 临时 root 流程'**
  String get chatToolDesc_ghost_key_start;

  /// No description provided for @chatToolDesc_ghost_key_status.
  ///
  /// In zh, this message translates to:
  /// **'查询 GhostKey 当前执行状态'**
  String get chatToolDesc_ghost_key_status;

  /// No description provided for @chatToolDesc_ghost_key_cancel.
  ///
  /// In zh, this message translates to:
  /// **'中止正在进行的 GhostKey 流程'**
  String get chatToolDesc_ghost_key_cancel;

  /// No description provided for @chatToolDesc_ghost_lock_preflight.
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 预检：ADB、uid、seccomp、内核与配置匹配情况'**
  String get chatToolDesc_ghost_lock_preflight;

  /// No description provided for @chatToolDesc_ghost_lock_start.
  ///
  /// In zh, this message translates to:
  /// **'启动一次 GhostLock 提权，返回会话 id'**
  String get chatToolDesc_ghost_lock_start;

  /// No description provided for @chatToolDesc_ghost_lock_status.
  ///
  /// In zh, this message translates to:
  /// **'读取 GhostLock 运行会话的最新快照'**
  String get chatToolDesc_ghost_lock_status;

  /// No description provided for @chatToolDesc_ghost_lock_cancel.
  ///
  /// In zh, this message translates to:
  /// **'停止读取当前 GhostLock 运行，不终止设备进程'**
  String get chatToolDesc_ghost_lock_cancel;

  /// No description provided for @chatToolDesc_ghost_lock_list_imported_profiles.
  ///
  /// In zh, this message translates to:
  /// **'列出已导入的 GhostLock 配置文件'**
  String get chatToolDesc_ghost_lock_list_imported_profiles;

  /// No description provided for @chatToolDesc_ghost_lock_list_builtin_releases.
  ///
  /// In zh, this message translates to:
  /// **'列出内置的 GhostLock 发行版本'**
  String get chatToolDesc_ghost_lock_list_builtin_releases;

  /// No description provided for @chatToolDesc_ghost_lock_read_imported_profile.
  ///
  /// In zh, this message translates to:
  /// **'读取某个已导入配置文件的详情'**
  String get chatToolDesc_ghost_lock_read_imported_profile;

  /// No description provided for @chatToolDesc_ghost_lock_get_probe_progress.
  ///
  /// In zh, this message translates to:
  /// **'查询配置解析进度'**
  String get chatToolDesc_ghost_lock_get_probe_progress;

  /// No description provided for @chatToolDesc_ghost_lock_list_extracted_images.
  ///
  /// In zh, this message translates to:
  /// **'列出从镜像包中提取出的分区'**
  String get chatToolDesc_ghost_lock_list_extracted_images;

  /// No description provided for @chatToolDesc_ghost_lock_get_profile_config.
  ///
  /// In zh, this message translates to:
  /// **'读取当前配置文件的完整字段'**
  String get chatToolDesc_ghost_lock_get_profile_config;

  /// No description provided for @chatToolDesc_ghost_lock_get_active_source.
  ///
  /// In zh, this message translates to:
  /// **'读取当前生效的配置来源'**
  String get chatToolDesc_ghost_lock_get_active_source;

  /// No description provided for @chatToolDesc_ghost_lock_probe_profile.
  ///
  /// In zh, this message translates to:
  /// **'解析内核镜像并生成配置档'**
  String get chatToolDesc_ghost_lock_probe_profile;

  /// No description provided for @chatToolDesc_ghost_lock_save_profile.
  ///
  /// In zh, this message translates to:
  /// **'保存当前配置档'**
  String get chatToolDesc_ghost_lock_save_profile;

  /// No description provided for @chatToolDesc_ghost_lock_import_profile_text.
  ///
  /// In zh, this message translates to:
  /// **'导入一段配置文本作为新配置档'**
  String get chatToolDesc_ghost_lock_import_profile_text;

  /// No description provided for @chatToolDesc_ghost_lock_rename_imported_profile.
  ///
  /// In zh, this message translates to:
  /// **'重命名已导入的配置档'**
  String get chatToolDesc_ghost_lock_rename_imported_profile;

  /// No description provided for @chatToolDesc_ghost_lock_remove_imported_profile.
  ///
  /// In zh, this message translates to:
  /// **'删除已导入的配置档'**
  String get chatToolDesc_ghost_lock_remove_imported_profile;

  /// No description provided for @chatToolDesc_ghost_lock_export_imported_profile.
  ///
  /// In zh, this message translates to:
  /// **'导出已导入的配置档文本'**
  String get chatToolDesc_ghost_lock_export_imported_profile;

  /// No description provided for @chatToolDesc_ghost_lock_convert_imported_profile.
  ///
  /// In zh, this message translates to:
  /// **'转换配置档的格式'**
  String get chatToolDesc_ghost_lock_convert_imported_profile;

  /// No description provided for @chatToolDesc_ghost_lock_export_local_file.
  ///
  /// In zh, this message translates to:
  /// **'把配置档导出为本地文件'**
  String get chatToolDesc_ghost_lock_export_local_file;

  /// No description provided for @chatToolDesc_ghost_lock_update_general_fields.
  ///
  /// In zh, this message translates to:
  /// **'修改配置档的常规字段'**
  String get chatToolDesc_ghost_lock_update_general_fields;

  /// No description provided for @chatToolDesc_ghost_lock_update_advanced_fields.
  ///
  /// In zh, this message translates to:
  /// **'修改配置档的高级字段'**
  String get chatToolDesc_ghost_lock_update_advanced_fields;

  /// No description provided for @chatToolDesc_ghost_lock_update_route.
  ///
  /// In zh, this message translates to:
  /// **'修改配置档的路由信息'**
  String get chatToolDesc_ghost_lock_update_route;

  /// No description provided for @chatToolDesc_ghost_lock_update_fallback.
  ///
  /// In zh, this message translates to:
  /// **'修改配置档的回退项'**
  String get chatToolDesc_ghost_lock_update_fallback;

  /// No description provided for @chatToolDesc_ghost_lock_reset_profile.
  ///
  /// In zh, this message translates to:
  /// **'把配置档重置为默认值'**
  String get chatToolDesc_ghost_lock_reset_profile;

  /// No description provided for @chatToolDesc_ghost_lock_select_source.
  ///
  /// In zh, this message translates to:
  /// **'选择生效的配置来源'**
  String get chatToolDesc_ghost_lock_select_source;

  /// No description provided for @chatToolDesc_ghost_lock_render_profile.
  ///
  /// In zh, this message translates to:
  /// **'渲染并预览配置档'**
  String get chatToolDesc_ghost_lock_render_profile;

  /// No description provided for @chatToolDesc_ghost_lock_export_profile.
  ///
  /// In zh, this message translates to:
  /// **'导出当前配置档'**
  String get chatToolDesc_ghost_lock_export_profile;

  /// No description provided for @chatToolDesc_ghost_lock_save_modified_profile.
  ///
  /// In zh, this message translates to:
  /// **'保存修改后的配置档'**
  String get chatToolDesc_ghost_lock_save_modified_profile;

  /// No description provided for @chatToolDesc_ghost_lock_overwrite_profile.
  ///
  /// In zh, this message translates to:
  /// **'覆盖写入现有配置档'**
  String get chatToolDesc_ghost_lock_overwrite_profile;

  /// No description provided for @chatToolDesc_ghost_lock_begin_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'开始一次配置编辑会话'**
  String get chatToolDesc_ghost_lock_begin_edit_session;

  /// No description provided for @chatToolDesc_ghost_lock_reload_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'重新加载编辑会话'**
  String get chatToolDesc_ghost_lock_reload_edit_session;

  /// No description provided for @chatToolDesc_ghost_lock_get_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'读取编辑会话的当前草稿'**
  String get chatToolDesc_ghost_lock_get_edit_session;

  /// No description provided for @chatToolDesc_ghost_lock_commit_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'提交编辑会话中的修改'**
  String get chatToolDesc_ghost_lock_commit_edit_session;

  /// No description provided for @chatToolDesc_ghost_lock_save_edit_session_in_place.
  ///
  /// In zh, this message translates to:
  /// **'就地保存编辑会话'**
  String get chatToolDesc_ghost_lock_save_edit_session_in_place;

  /// No description provided for @chatToolDesc_ghost_lock_save_edit_session_as_new.
  ///
  /// In zh, this message translates to:
  /// **'把编辑会话另存为新配置档'**
  String get chatToolDesc_ghost_lock_save_edit_session_as_new;

  /// No description provided for @chatToolDesc_ghost_lock_export_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'导出编辑会话的内容'**
  String get chatToolDesc_ghost_lock_export_edit_session;

  /// No description provided for @chatToolDesc_ghost_lock_end_edit_session.
  ///
  /// In zh, this message translates to:
  /// **'结束编辑会话'**
  String get chatToolDesc_ghost_lock_end_edit_session;

  /// No description provided for @chatToolDesc_dirty_frag_is_armed.
  ///
  /// In zh, this message translates to:
  /// **'检查本次开机是否已注入过 DirtyFrag'**
  String get chatToolDesc_dirty_frag_is_armed;

  /// No description provided for @chatToolDesc_dirty_frag_get_run_defaults.
  ///
  /// In zh, this message translates to:
  /// **'读取 DirtyFrag 运行默认参数'**
  String get chatToolDesc_dirty_frag_get_run_defaults;

  /// No description provided for @chatToolDesc_dirty_frag_get_expert_mode.
  ///
  /// In zh, this message translates to:
  /// **'查询 DirtyFrag 专家模式是否开启'**
  String get chatToolDesc_dirty_frag_get_expert_mode;

  /// No description provided for @chatToolDesc_dirty_frag_get_boot_autostart.
  ///
  /// In zh, this message translates to:
  /// **'查询 DirtyFrag 开机自启是否开启'**
  String get chatToolDesc_dirty_frag_get_boot_autostart;

  /// No description provided for @chatToolDesc_dirty_frag_get_vr_progress.
  ///
  /// In zh, this message translates to:
  /// **'查询 VR 偏移推导进度'**
  String get chatToolDesc_dirty_frag_get_vr_progress;

  /// No description provided for @chatToolDesc_dirty_frag_save_run_defaults.
  ///
  /// In zh, this message translates to:
  /// **'保存 DirtyFrag 运行默认参数'**
  String get chatToolDesc_dirty_frag_save_run_defaults;

  /// No description provided for @chatToolDesc_dirty_frag_set_expert_mode.
  ///
  /// In zh, this message translates to:
  /// **'开关 DirtyFrag 专家模式'**
  String get chatToolDesc_dirty_frag_set_expert_mode;

  /// No description provided for @chatToolDesc_dirty_frag_set_boot_autostart.
  ///
  /// In zh, this message translates to:
  /// **'开关 DirtyFrag 开机自启'**
  String get chatToolDesc_dirty_frag_set_boot_autostart;

  /// No description provided for @chatToolDesc_dirty_frag_start.
  ///
  /// In zh, this message translates to:
  /// **'启动 DirtyFrag 提权'**
  String get chatToolDesc_dirty_frag_start;

  /// No description provided for @chatToolDesc_dirty_frag_status.
  ///
  /// In zh, this message translates to:
  /// **'查询 DirtyFrag 当前状态'**
  String get chatToolDesc_dirty_frag_status;

  /// No description provided for @chatToolDesc_dirty_frag_cancel.
  ///
  /// In zh, this message translates to:
  /// **'中止 DirtyFrag 运行'**
  String get chatToolDesc_dirty_frag_cancel;

  /// No description provided for @chatToolDesc_dirty_frag_derive_vr_offset.
  ///
  /// In zh, this message translates to:
  /// **'从镜像包或 OTA 推导 VR 偏移'**
  String get chatToolDesc_dirty_frag_derive_vr_offset;

  /// No description provided for @chatToolDesc_kernel_profile_list_imported.
  ///
  /// In zh, this message translates to:
  /// **'列出已导入的内核配置文件'**
  String get chatToolDesc_kernel_profile_list_imported;

  /// No description provided for @chatToolDesc_kernel_profile_list_builtin.
  ///
  /// In zh, this message translates to:
  /// **'列出内置的内核配置文件'**
  String get chatToolDesc_kernel_profile_list_builtin;

  /// No description provided for @chatToolDesc_kernel_profile_read_content.
  ///
  /// In zh, this message translates to:
  /// **'读取内核配置文件的完整内容'**
  String get chatToolDesc_kernel_profile_read_content;

  /// No description provided for @chatToolDesc_kernel_profile_read_editor.
  ///
  /// In zh, this message translates to:
  /// **'读取内核配置编辑器的当前内容'**
  String get chatToolDesc_kernel_profile_read_editor;

  /// No description provided for @chatToolDesc_kernel_profile_get_active_selection.
  ///
  /// In zh, this message translates to:
  /// **'读取当前生效的内核配置'**
  String get chatToolDesc_kernel_profile_get_active_selection;

  /// No description provided for @chatToolDesc_kernel_profile_import_start.
  ///
  /// In zh, this message translates to:
  /// **'开始导入并解析内核镜像'**
  String get chatToolDesc_kernel_profile_import_start;

  /// No description provided for @chatToolDesc_kernel_profile_import_status.
  ///
  /// In zh, this message translates to:
  /// **'查询内核导入进度'**
  String get chatToolDesc_kernel_profile_import_status;

  /// No description provided for @chatToolDesc_kernel_profile_import_cancel.
  ///
  /// In zh, this message translates to:
  /// **'取消内核导入'**
  String get chatToolDesc_kernel_profile_import_cancel;

  /// No description provided for @chatToolDesc_kernel_profile_remove.
  ///
  /// In zh, this message translates to:
  /// **'删除内核配置文件'**
  String get chatToolDesc_kernel_profile_remove;

  /// No description provided for @chatToolDesc_kernel_profile_save_editor.
  ///
  /// In zh, this message translates to:
  /// **'保存编辑器内容'**
  String get chatToolDesc_kernel_profile_save_editor;

  /// No description provided for @chatToolDesc_kernel_profile_save_editor_as.
  ///
  /// In zh, this message translates to:
  /// **'把编辑器内容另存为新配置'**
  String get chatToolDesc_kernel_profile_save_editor_as;

  /// No description provided for @chatToolDesc_kernel_profile_render_editor.
  ///
  /// In zh, this message translates to:
  /// **'渲染并预览编辑器内容'**
  String get chatToolDesc_kernel_profile_render_editor;

  /// No description provided for @chatToolDesc_kernel_profile_select_user_profile.
  ///
  /// In zh, this message translates to:
  /// **'选择生效的用户配置'**
  String get chatToolDesc_kernel_profile_select_user_profile;

  /// No description provided for @chatToolDesc_kernel_profile_select_builtin_release.
  ///
  /// In zh, this message translates to:
  /// **'选择生效的内置发行版'**
  String get chatToolDesc_kernel_profile_select_builtin_release;

  /// No description provided for @chatToolDesc_ota_list_catalog.
  ///
  /// In zh, this message translates to:
  /// **'列出指定厂商的内置 OTA 包清单'**
  String get chatToolDesc_ota_list_catalog;

  /// No description provided for @chatToolDesc_run_log_list_runs.
  ///
  /// In zh, this message translates to:
  /// **'按时间倒序列出历史运行日志'**
  String get chatToolDesc_run_log_list_runs;

  /// No description provided for @chatToolDesc_run_log_read_body.
  ///
  /// In zh, this message translates to:
  /// **'读取某个运行日志的正文'**
  String get chatToolDesc_run_log_read_body;

  /// No description provided for @chatToolDesc_run_log_export_all.
  ///
  /// In zh, this message translates to:
  /// **'导出全部运行日志'**
  String get chatToolDesc_run_log_export_all;

  /// No description provided for @chatToolDesc_run_log_diagnose.
  ///
  /// In zh, this message translates to:
  /// **'诊断失败的运行日志并给出原因'**
  String get chatToolDesc_run_log_diagnose;

  /// No description provided for @chatToolDesc_run_log_delete.
  ///
  /// In zh, this message translates to:
  /// **'删除某个运行日志'**
  String get chatToolDesc_run_log_delete;

  /// No description provided for @chatToolDesc_run_log_clear_all.
  ///
  /// In zh, this message translates to:
  /// **'清空全部运行日志，保留正在写入的一份'**
  String get chatToolDesc_run_log_clear_all;

  /// No description provided for @chatToolDesc_local_file_inspect.
  ///
  /// In zh, this message translates to:
  /// **'在应用进程内检查附件的大小与头部格式，识别 payload、boot、zip 等容器类型'**
  String get chatToolDesc_local_file_inspect;

  /// 手册能力分组-设备信息
  ///
  /// In zh, this message translates to:
  /// **'设备与环境'**
  String get chatManualGroupDevice;

  /// 手册能力分组说明-设备信息
  ///
  /// In zh, this message translates to:
  /// **'读取机型、系统版本、内核、ROOT 状态与 ADB 开关'**
  String get chatManualGroupDeviceDesc;

  /// 手册能力分组-ADB
  ///
  /// In zh, this message translates to:
  /// **'ADB 调试'**
  String get chatManualGroupAdb;

  /// 手册能力分组说明-ADB
  ///
  /// In zh, this message translates to:
  /// **'执行 adb shell 命令，发起无线调试配对'**
  String get chatManualGroupAdbDesc;

  /// 手册能力分组-Stellar 特权服务
  ///
  /// In zh, this message translates to:
  /// **'Stellar 特权服务'**
  String get chatManualGroupStellar;

  /// 手册能力分组说明-Stellar 特权服务
  ///
  /// In zh, this message translates to:
  /// **'查询 Stellar 特权服务的可用状态与身份'**
  String get chatManualGroupStellarDesc;

  /// 手册能力分组-网络
  ///
  /// In zh, this message translates to:
  /// **'网络与浏览'**
  String get chatManualGroupWeb;

  /// 手册能力分组说明-网络
  ///
  /// In zh, this message translates to:
  /// **'联网搜索、抓取网页源码、用内置浏览器打开页面'**
  String get chatManualGroupWebDesc;

  /// 手册能力分组-手动提权
  ///
  /// In zh, this message translates to:
  /// **'手动提权'**
  String get chatManualGroupEscalation;

  /// 手册能力分组说明-手动提权
  ///
  /// In zh, this message translates to:
  /// **'匹配内核载荷并执行提权，把 root 移交给指定管理器'**
  String get chatManualGroupEscalationDesc;

  /// 手册能力分组-GhostKey
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 提权'**
  String get chatManualGroupGhostKey;

  /// 手册能力分组说明-GhostKey
  ///
  /// In zh, this message translates to:
  /// **'预检并执行 GhostKey 临时 root 流程'**
  String get chatManualGroupGhostKeyDesc;

  /// 手册能力分组-GhostLock 提权
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 提权'**
  String get chatManualGroupGhostLock;

  /// 手册能力分组说明-GhostLock 提权
  ///
  /// In zh, this message translates to:
  /// **'预检并执行 GhostLock 提权流程'**
  String get chatManualGroupGhostLockDesc;

  /// 手册能力分组-GhostLock 配置档
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 配置'**
  String get chatManualGroupGhostLockProfile;

  /// 手册能力分组说明-GhostLock 配置档
  ///
  /// In zh, this message translates to:
  /// **'读取、编辑、解析、导入导出 GhostLock 配置档'**
  String get chatManualGroupGhostLockProfileDesc;

  /// 手册能力分组-DirtyFrag
  ///
  /// In zh, this message translates to:
  /// **'DirtyFrag 提权'**
  String get chatManualGroupDirtyFrag;

  /// 手册能力分组说明-DirtyFrag
  ///
  /// In zh, this message translates to:
  /// **'内核漏洞利用、VR 解除与偏移推导'**
  String get chatManualGroupDirtyFragDesc;

  /// 手册能力分组-内核配置
  ///
  /// In zh, this message translates to:
  /// **'内核配置'**
  String get chatManualGroupKernel;

  /// 手册能力分组说明-内核配置
  ///
  /// In zh, this message translates to:
  /// **'导入解析内核镜像，管理配置文件并选择生效项'**
  String get chatManualGroupKernelDesc;

  /// 手册能力分组-OTA 清单
  ///
  /// In zh, this message translates to:
  /// **'OTA 素材'**
  String get chatManualGroupOta;

  /// 手册能力分组说明-OTA 清单
  ///
  /// In zh, this message translates to:
  /// **'查询历史 OTA 清单，作为内核镜像来源'**
  String get chatManualGroupOtaDesc;

  /// 手册能力分组-运行日志
  ///
  /// In zh, this message translates to:
  /// **'运行日志'**
  String get chatManualGroupRunLog;

  /// 手册能力分组说明-运行日志
  ///
  /// In zh, this message translates to:
  /// **'读取、诊断、导出与清理提权运行日志'**
  String get chatManualGroupRunLogDesc;

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

  /// 手动提权页拆出的终端独立页标题
  ///
  /// In zh, this message translates to:
  /// **'终端'**
  String get escalationTerminalTitle;

  /// 手动提权页右上角进入终端页的按钮提示
  ///
  /// In zh, this message translates to:
  /// **'打开终端'**
  String get escalationTerminalEntry;

  /// 手动提权页-提权操作分组标题
  ///
  /// In zh, this message translates to:
  /// **'提权方式'**
  String get escalationToolSection;

  /// 手动提权页-终端：常驻 shell 正常退出后的说明行
  ///
  /// In zh, this message translates to:
  /// **'shell 会话已结束，再次输入会自动重连'**
  String get escalationTerminalClosed;

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

  /// 手动提权页-菜单里的提权项：按机型与内核自动匹配一条预制载荷
  ///
  /// In zh, this message translates to:
  /// **'自动匹配载荷提权'**
  String get escalationExploitButton;

  /// 手动提权页-终端：提权已发起
  ///
  /// In zh, this message translates to:
  /// **'自动匹配载荷提权…'**
  String get escalationExploitStarted;

  /// 手动提权页-菜单里的移交分组标题
  ///
  /// In zh, this message translates to:
  /// **'移交 root'**
  String get escalationHandoffSection;

  /// 手动提权页-移交区：移交给标题栏胶囊选定的管理器
  ///
  /// In zh, this message translates to:
  /// **'移交给当前管理器'**
  String get escalationHandoffCurrent;

  /// 手动提权页-终端：移交已发起，等待结果
  ///
  /// In zh, this message translates to:
  /// **'正在移交给 {manager}…'**
  String escalationHandoffRunning(String manager);

  /// 手动提权页-管理器没装：给出包名与安装出路
  ///
  /// In zh, this message translates to:
  /// **'设备上没装 {manager}：找不到它的 libksud.so（包名 {package}）。请先安装 {manager}，再回来重试。'**
  String escalationHandoffManagerMissing(String manager, String package);

  /// 手动提权页-移交时设备没有 su
  ///
  /// In zh, this message translates to:
  /// **'设备上没有 su，先跑提权拿到临时 root 再移交。'**
  String get escalationHandoffNoSu;

  /// 手动提权页-移交失败：带上退出码
  ///
  /// In zh, this message translates to:
  /// **'移交失败（退出码 {code}）'**
  String escalationHandoffFailed(int code);

  /// 手动提权页-移交失败但没有退出码
  ///
  /// In zh, this message translates to:
  /// **'移交失败：命令没跑起来，没拿到退出码。'**
  String get escalationHandoffFailedNoCode;

  /// 手动提权页-移交前读取管理器选择失败
  ///
  /// In zh, this message translates to:
  /// **'移交失败：读不到已选的管理器'**
  String get escalationHandoffReadManagerFailed;

  /// 手动提权页-扫描结果为空时移交不可用
  ///
  /// In zh, this message translates to:
  /// **'设备上没有可移交的 root 管理器：装好一个带 libksud.so 的管理器，用右上角胶囊选中它再试。'**
  String get escalationHandoffNoManager;

  /// 手动提权页-底部左侧菜单按钮的提示文案
  ///
  /// In zh, this message translates to:
  /// **'更多操作'**
  String get escalationMenuTitle;

  /// 手动提权页-菜单里的查看载荷清单项
  ///
  /// In zh, this message translates to:
  /// **'查看载荷清单'**
  String get escalationMenuPayloadCatalog;

  /// 手动提权页-载荷清单弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'载荷清单'**
  String get escalationPayloadCatalogTitle;

  /// 手动提权页-载荷清单弹窗的条数
  ///
  /// In zh, this message translates to:
  /// **'共 {count} 条'**
  String escalationPayloadCatalogCount(int count);

  /// 手动提权页-载荷清单弹窗的空态
  ///
  /// In zh, this message translates to:
  /// **'清单里没有载荷条目'**
  String get escalationPayloadCatalogEmpty;

  /// 手动提权页-载荷清单弹窗的搜索框提示
  ///
  /// In zh, this message translates to:
  /// **'搜索机型、厂商或文件名'**
  String get escalationPayloadCatalogSearch;

  /// 手动提权页-载荷清单弹窗搜索无结果
  ///
  /// In zh, this message translates to:
  /// **'没有匹配的载荷'**
  String get escalationPayloadCatalogNoMatch;

  /// 手动提权页-载荷条目标记：内核版本未知
  ///
  /// In zh, this message translates to:
  /// **'内核未知'**
  String get escalationPayloadKernelUnknown;

  /// 手动提权页-载荷条目标记：不限内核版本
  ///
  /// In zh, this message translates to:
  /// **'不限内核'**
  String get escalationPayloadKernelAgnostic;

  /// 手动提权页-终端：开始执行手工指定的载荷
  ///
  /// In zh, this message translates to:
  /// **'用 {name} 提权…'**
  String escalationPayloadManualStarted(String name);

  /// 手动提权页-手工指定载荷的二次确认标题
  ///
  /// In zh, this message translates to:
  /// **'用这份载荷提权？'**
  String get escalationPayloadConfirmTitle;

  /// 手动提权页-二次确认里的字段名
  ///
  /// In zh, this message translates to:
  /// **'机型'**
  String get escalationPayloadConfirmModel;

  /// 手动提权页-二次确认里的字段名
  ///
  /// In zh, this message translates to:
  /// **'厂商'**
  String get escalationPayloadConfirmVendor;

  /// 手动提权页-二次确认里的字段名
  ///
  /// In zh, this message translates to:
  /// **'内核'**
  String get escalationPayloadConfirmKernel;

  /// 手动提权页-二次确认里的字段名
  ///
  /// In zh, this message translates to:
  /// **'文件'**
  String get escalationPayloadConfirmLibrary;

  /// 手动提权页-二次确认里的风险提示
  ///
  /// In zh, this message translates to:
  /// **'会在设备上实际运行该载荷，可能造成系统不稳定或重启。执行前请确认机型与内核版本一致。'**
  String get escalationPayloadConfirmBody;

  /// 手动提权页-二次确认的确认按钮
  ///
  /// In zh, this message translates to:
  /// **'开始提权'**
  String get escalationPayloadConfirmAction;

  /// 手动提权页-终端：自动匹配没有命中任何载荷
  ///
  /// In zh, this message translates to:
  /// **'当前设备在载荷清单里没有候选'**
  String get escalationPayloadNoCandidate;

  /// 手动提权页-终端：取不到原生库目录
  ///
  /// In zh, this message translates to:
  /// **'原生库目录不可用：so 没有解压到 nativeLibraryDir'**
  String get escalationPayloadLibraryDirUnavailable;

  /// 手动提权页-终端：助手 so 不存在
  ///
  /// In zh, this message translates to:
  /// **'执行助手缺失或不可执行'**
  String get escalationPayloadHelperMissing;

  /// 手动提权页-终端：载荷 so 不存在
  ///
  /// In zh, this message translates to:
  /// **'载荷文件缺失'**
  String get escalationPayloadFileMissing;

  /// 手动提权页-终端：独立载荷的命令占位符补不齐
  ///
  /// In zh, this message translates to:
  /// **'载荷参数无法在设备上补齐'**
  String get escalationPayloadArgumentsUnresolved;

  /// 手动提权页-菜单里的清屏项
  ///
  /// In zh, this message translates to:
  /// **'清屏'**
  String get escalationMenuClear;

  /// 终端的菜单项与确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'DirtyFrag 提权'**
  String get escalationDirtyFragTitle;

  /// 确认弹窗里的管理器字段标签
  ///
  /// In zh, this message translates to:
  /// **'管理器'**
  String get escalationDirtyFragFieldManager;

  /// 确认弹窗里的内核版本字段标签
  ///
  /// In zh, this message translates to:
  /// **'内核'**
  String get escalationDirtyFragFieldKernel;

  /// 确认弹窗里 VR 反制的只读标签，值用开/关
  ///
  /// In zh, this message translates to:
  /// **'VR 反制'**
  String get escalationDirtyFragFieldVrDisarm;

  /// 确认弹窗里自动解析的只读标签，值用开/关
  ///
  /// In zh, this message translates to:
  /// **'自动解析'**
  String get escalationDirtyFragFieldVrAuto;

  /// 确认弹窗里软重启的只读标签，值用开/关
  ///
  /// In zh, this message translates to:
  /// **'软重启'**
  String get escalationDirtyFragFieldSoftReboot;

  /// 确认弹窗里开关项的「开」
  ///
  /// In zh, this message translates to:
  /// **'开'**
  String get escalationDirtyFragToggleOn;

  /// 确认弹窗里开关项的「关」
  ///
  /// In zh, this message translates to:
  /// **'关'**
  String get escalationDirtyFragToggleOff;

  /// 确认弹窗的主按钮
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get escalationDirtyFragConfirmAction;

  /// 确认弹窗底部的风险说明
  ///
  /// In zh, this message translates to:
  /// **'执行期间会把 SELinux 置为宽容模式，并可能让系统短暂不稳定。重启即可恢复。'**
  String get escalationDirtyFragConfirmBody;

  /// 设置页 VR 反制开关的标题
  ///
  /// In zh, this message translates to:
  /// **'VR 反制'**
  String get escalationDirtyFragVrDisarmTitle;

  /// 设置页 VR 反制开关的说明
  ///
  /// In zh, this message translates to:
  /// **'仅 vivo 机型需要，先移除内核侧 VR 保护'**
  String get escalationDirtyFragVrDisarmDesc;

  /// 设置页自动解析开关的标题
  ///
  /// In zh, this message translates to:
  /// **'自动解析偏移'**
  String get escalationDirtyFragVrAutoTitle;

  /// 设置页自动解析开关的说明
  ///
  /// In zh, this message translates to:
  /// **'从内核 BTF 推导偏移，仅在 VR 反制开启时可用'**
  String get escalationDirtyFragVrAutoDesc;

  /// 设置页软重启开关的标题
  ///
  /// In zh, this message translates to:
  /// **'成功后自动软重启'**
  String get escalationDirtyFragSoftRebootTitle;

  /// 设置页软重启开关的说明
  ///
  /// In zh, this message translates to:
  /// **'成功后重启一次，让模块生效；与开机自启同开时，重启失败可能导致开机无 root'**
  String get escalationDirtyFragSoftRebootDesc;

  /// 手动偏移输入框的标签
  ///
  /// In zh, this message translates to:
  /// **'手动偏移'**
  String get escalationDirtyFragVrOffsetLabel;

  /// 手动偏移输入框下方的提示
  ///
  /// In zh, this message translates to:
  /// **'取值范围 1-256，填错会直接中止在移交之前'**
  String get escalationDirtyFragVrOffsetHint;

  /// 前置检查发现本次开机已注入时的提示
  ///
  /// In zh, this message translates to:
  /// **'本次开机已经注入过，重启后才能再次执行'**
  String get escalationDirtyFragAlreadyArmed;

  /// 内核版本不在支持列表时的提示
  ///
  /// In zh, this message translates to:
  /// **'内核 {kernel} 不在支持列表内'**
  String escalationDirtyFragKernelUnsupported(String kernel);

  /// 确认弹窗里内核版本后面的短标记
  ///
  /// In zh, this message translates to:
  /// **'（不支持）'**
  String get escalationDirtyFragKernelUnsupportedShort;

  /// 读不到内核版本时的替代文字
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get escalationDirtyFragKernelUnknown;

  /// 没有选中管理器时的提示
  ///
  /// In zh, this message translates to:
  /// **'先在右上角胶囊里选中一个带 libksud.so 的管理器'**
  String get escalationDirtyFragNoManager;

  /// 开始执行时写进终端的那一行
  ///
  /// In zh, this message translates to:
  /// **'正在执行 DirtyFrag，目标管理器 {manager}…'**
  String escalationDirtyFragRunning(String manager);

  /// 全链路成功时的结论
  ///
  /// In zh, this message translates to:
  /// **'内核模块已加载，root 已移交给 {manager}'**
  String escalationDirtyFragSucceeded(String manager);

  /// 内核不可利用时的结论
  ///
  /// In zh, this message translates to:
  /// **'这台设备的内核没有该漏洞'**
  String get escalationDirtyFragNotVulnerable;

  /// 打补丁阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'打补丁阶段失败，见上方输出'**
  String get escalationDirtyFragPatchFailed;

  /// VR 反制阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'VR 反制失败，已在移交前中止'**
  String get escalationDirtyFragVrFailed;

  /// 内核侧就位但后续阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'内核模块已加载，但 bootstrap 或 ksud 阶段失败'**
  String get escalationDirtyFragBootstrapFailed;

  /// 超时时的结论
  ///
  /// In zh, this message translates to:
  /// **'等待终局标记超时，见上方输出'**
  String get escalationDirtyFragTimedOut;

  /// 原生拒绝受理时的结论；reason 是「文案（码）」
  ///
  /// In zh, this message translates to:
  /// **'原生侧未受理：{reason}'**
  String escalationDirtyFragNotStarted(String reason);

  /// 自动解析出偏移时的提示
  ///
  /// In zh, this message translates to:
  /// **'VR 偏移已解析：{offset}'**
  String escalationDirtyFragVrOffsetResolved(String offset);

  /// 确认弹窗里手动偏移下方的提取按钮
  ///
  /// In zh, this message translates to:
  /// **'从镜像/OTA 提取'**
  String get escalationDirtyFragVrExtractAction;

  /// 提取进度行；phase 由两条阶段文案传入，percent 是整数
  ///
  /// In zh, this message translates to:
  /// **'{phase} {percent}%'**
  String escalationDirtyFragVrExtractProgress(String phase, int percent);

  /// 进度阶段：下载 boot 分区
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get escalationDirtyFragVrExtractPhaseDownload;

  /// 进度阶段：解包镜像
  ///
  /// In zh, this message translates to:
  /// **'解包'**
  String get escalationDirtyFragVrExtractPhaseUnpack;

  /// 输入框为空就点提取时的提示
  ///
  /// In zh, this message translates to:
  /// **'先把本地镜像路径或 OTA 直链填到上面的输入框'**
  String get escalationDirtyFragVrExtractEmpty;

  /// 提取失败提示；error 是原生侧原文，不做翻译
  ///
  /// In zh, this message translates to:
  /// **'提取失败：{error}'**
  String escalationDirtyFragVrExtractFailed(String error);

  /// 提权菜单里的 GhostKey 菜单项
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 提权'**
  String get escalationGhostKeyTitle;

  /// GhostKey 开跑提示；manager 为空时是空串
  ///
  /// In zh, this message translates to:
  /// **'开始 GhostKey 提权{manager}'**
  String escalationGhostKeyRunning(String manager);

  /// GhostKey 前置检查：adb 未连接
  ///
  /// In zh, this message translates to:
  /// **'adb 未连接'**
  String get escalationGhostKeyNoAdb;

  /// GhostKey 成功的结论行；manager 为空时是空串
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 完成，临时 root 已就绪{manager}'**
  String escalationGhostKeySucceeded(String manager);

  /// GhostKey 降级成功的结论行
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 完成，但线性映射置信度偏低'**
  String get escalationGhostKeyDegraded;

  /// GhostKey calib_a 失败
  ///
  /// In zh, this message translates to:
  /// **'KASLR slide 校准失败'**
  String get escalationGhostKeyCalibFailed;

  /// GhostKey calib_b 失败
  ///
  /// In zh, this message translates to:
  /// **'线性映射基址校准失败'**
  String get escalationGhostKeyPageOffsetFailed;

  /// GhostKey 注入阶段失败
  ///
  /// In zh, this message translates to:
  /// **'注入失败：rootd 未就绪'**
  String get escalationGhostKeyInjectFailed;

  /// GhostKey verify 阶段失败
  ///
  /// In zh, this message translates to:
  /// **'临时 root 通道校验失败'**
  String get escalationGhostKeyVerifyFailed;

  /// GhostKey 成功但 KSU 阶段失败
  ///
  /// In zh, this message translates to:
  /// **'临时 root 已就绪，KernelSU 接管失败'**
  String get escalationGhostKeyKsuFailed;

  /// GhostKey 会话超时或被取消
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 超时'**
  String get escalationGhostKeyTimedOut;

  /// GhostKey 被原生拒绝受理；reason 是原因码
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 未启动：{reason}'**
  String escalationGhostKeyNotStarted(String reason);

  /// 原因码 alreadyRunning
  ///
  /// In zh, this message translates to:
  /// **'已有任务在运行'**
  String get escalationGhostKeyReasonAlreadyRunning;

  /// 原因码 noAdb
  ///
  /// In zh, this message translates to:
  /// **'ADB 未连接'**
  String get escalationGhostKeyReasonNoAdb;

  /// 原因码 notShell
  ///
  /// In zh, this message translates to:
  /// **'shell 身份不是 2000'**
  String get escalationGhostKeyReasonNotShell;

  /// 原因码 seccompFiltered
  ///
  /// In zh, this message translates to:
  /// **'shell 带 seccomp 过滤'**
  String get escalationGhostKeyReasonSeccomp;

  /// 原因码 missingBinary
  ///
  /// In zh, this message translates to:
  /// **'载荷文件缺失'**
  String get escalationGhostKeyReasonMissingBinary;

  /// 原因码 noProfile
  ///
  /// In zh, this message translates to:
  /// **'当前内核版本没有对应 profile'**
  String get escalationGhostKeyReasonNoProfile;

  /// 原因码 badRequest
  ///
  /// In zh, this message translates to:
  /// **'请求参数不合法'**
  String get escalationGhostKeyReasonBadRequest;

  /// 原因码展示：可读文案后保留原始码，便于对照原生日志
  ///
  /// In zh, this message translates to:
  /// **'{label}（{code}）'**
  String escalationReasonWithCode(String label, String code);

  /// 原因码 alreadyArmed
  ///
  /// In zh, this message translates to:
  /// **'已有驻留标记'**
  String get escalationDirtyFragReasonAlreadyArmed;

  /// 原因码 busy
  ///
  /// In zh, this message translates to:
  /// **'有任务正在运行'**
  String get escalationDirtyFragReasonBusy;

  /// 原因码 noIpSec
  ///
  /// In zh, this message translates to:
  /// **'系统没有 IpSec 服务'**
  String get escalationDirtyFragReasonNoIpSec;

  /// 原因码 missingBinary
  ///
  /// In zh, this message translates to:
  /// **'管理器或载荷文件缺失'**
  String get escalationDirtyFragReasonMissingBinary;

  /// 原因码 stagingFailed
  ///
  /// In zh, this message translates to:
  /// **'落位或启动失败'**
  String get escalationDirtyFragReasonStagingFailed;

  /// 原因码 badRequest
  ///
  /// In zh, this message translates to:
  /// **'请求参数不合法'**
  String get escalationDirtyFragReasonBadRequest;

  /// GhostKey 兜底失败结论
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 失败'**
  String get escalationGhostKeyFailed;

  /// GhostKey 确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'确认 GhostKey 提权'**
  String get escalationGhostKeyConfirmTitle;

  /// GhostKey 确认弹窗的风险提示
  ///
  /// In zh, this message translates to:
  /// **'该操作会校准内核映射并注入 rootd，过程中设备可能短暂不可用。'**
  String get escalationGhostKeyConfirmRisk;

  /// GhostKey 确认弹窗的确认按钮
  ///
  /// In zh, this message translates to:
  /// **'开始提权'**
  String get escalationGhostKeyConfirmRun;

  /// GhostKey 确认弹窗：管理器字段
  ///
  /// In zh, this message translates to:
  /// **'管理器'**
  String get escalationGhostKeyFieldManager;

  /// GhostKey 确认弹窗：内核版本字段
  ///
  /// In zh, this message translates to:
  /// **'内核版本'**
  String get escalationGhostKeyFieldRelease;

  /// GhostKey 确认弹窗：shell uid 字段
  ///
  /// In zh, this message translates to:
  /// **'shell uid'**
  String get escalationGhostKeyFieldShellUid;

  /// GhostKey 确认弹窗：seccomp 字段
  ///
  /// In zh, this message translates to:
  /// **'seccomp'**
  String get escalationGhostKeyFieldSeccomp;

  /// GhostKey 确认弹窗：profile 命中字段
  ///
  /// In zh, this message translates to:
  /// **'profile 命中'**
  String get escalationGhostKeyFieldProfile;

  /// GhostKey 确认弹窗：是否接管 KSU
  ///
  /// In zh, this message translates to:
  /// **'接管 KSU'**
  String get escalationGhostKeyFieldRunKsu;

  /// GhostKey 确认弹窗：是否接受 fallback
  ///
  /// In zh, this message translates to:
  /// **'接受降级偏移'**
  String get escalationGhostKeyFieldFallback;

  /// GhostKey 弹窗：取不到的值
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get escalationGhostKeyValueUnknown;

  /// GhostKey 弹窗：未选择管理器
  ///
  /// In zh, this message translates to:
  /// **'未选择'**
  String get escalationGhostKeyValueNone;

  /// GhostKey 弹窗：布尔值「是」
  ///
  /// In zh, this message translates to:
  /// **'是'**
  String get escalationGhostKeyValueYes;

  /// GhostKey 弹窗：布尔值「否」
  ///
  /// In zh, this message translates to:
  /// **'否'**
  String get escalationGhostKeyValueNo;

  /// GhostKey 弹窗：开关为开
  ///
  /// In zh, this message translates to:
  /// **'开'**
  String get escalationGhostKeyToggleOn;

  /// GhostKey 弹窗：开关为关
  ///
  /// In zh, this message translates to:
  /// **'关'**
  String get escalationGhostKeyToggleOff;

  /// GhostKey 进度面板标题
  ///
  /// In zh, this message translates to:
  /// **'进度'**
  String get escalationGhostKeyProgressTitle;

  /// GhostKey 阶段耗时；seconds 是已格式化的一位小数
  ///
  /// In zh, this message translates to:
  /// **'{seconds} s'**
  String escalationGhostKeyDurationSeconds(String seconds);

  /// 阶段名：calib_a
  ///
  /// In zh, this message translates to:
  /// **'KASLR slide 校准'**
  String get escalationGhostKeyStageCalibAName;

  /// 阶段名：calib_b
  ///
  /// In zh, this message translates to:
  /// **'线性映射校准'**
  String get escalationGhostKeyStageCalibBName;

  /// 阶段名：inject
  ///
  /// In zh, this message translates to:
  /// **'注入 rootd'**
  String get escalationGhostKeyStageInjectName;

  /// 阶段名：verify
  ///
  /// In zh, this message translates to:
  /// **'校验临时 root'**
  String get escalationGhostKeyStageVerifyName;

  /// 阶段名：ksu
  ///
  /// In zh, this message translates to:
  /// **'接管 KernelSU'**
  String get escalationGhostKeyStageKsuName;

  /// 阶段进行中提示：calib_a
  ///
  /// In zh, this message translates to:
  /// **'定位内核基址'**
  String get escalationGhostKeyStageCalibAHint;

  /// 阶段进行中提示：calib_b
  ///
  /// In zh, this message translates to:
  /// **'校准线性映射'**
  String get escalationGhostKeyStageCalibBHint;

  /// 阶段进行中提示：inject
  ///
  /// In zh, this message translates to:
  /// **'注入并启动 rootd'**
  String get escalationGhostKeyStageInjectHint;

  /// 阶段进行中提示：verify
  ///
  /// In zh, this message translates to:
  /// **'校验 root 通道'**
  String get escalationGhostKeyStageVerifyHint;

  /// 阶段进行中提示：ksu
  ///
  /// In zh, this message translates to:
  /// **'移交 KernelSU'**
  String get escalationGhostKeyStageKsuHint;

  /// 菜单项与确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 提权'**
  String get escalationGhostLockTitle;

  /// 确认弹窗里的管理器字段标签
  ///
  /// In zh, this message translates to:
  /// **'管理器'**
  String get escalationGhostLockFieldManager;

  /// 确认弹窗里的内核 release 字段标签
  ///
  /// In zh, this message translates to:
  /// **'内核'**
  String get escalationGhostLockFieldRelease;

  /// 确认弹窗里的内核表命中字段标签，值用有/无
  ///
  /// In zh, this message translates to:
  /// **'内核表'**
  String get escalationGhostLockFieldProfile;

  /// 确认弹窗里的竞争路由字段标签
  ///
  /// In zh, this message translates to:
  /// **'路由'**
  String get escalationGhostLockFieldRoute;

  /// 确认弹窗里的 seccomp 字段标签，值是原始数字
  ///
  /// In zh, this message translates to:
  /// **'Seccomp'**
  String get escalationGhostLockFieldSeccomp;

  /// 确认弹窗里的 ksud 路径字段标签
  ///
  /// In zh, this message translates to:
  /// **'ksud'**
  String get escalationGhostLockFieldKsud;

  /// 字段值：存在
  ///
  /// In zh, this message translates to:
  /// **'有'**
  String get escalationGhostLockValueYes;

  /// 字段值：不存在
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get escalationGhostLockValueNo;

  /// 字段值：未选中或为空
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get escalationGhostLockValueNone;

  /// 包内没有 ksud、将由所选管理器提供时的字段值
  ///
  /// In zh, this message translates to:
  /// **'由所选管理器提供'**
  String get escalationGhostLockKsudFromManager;

  /// 读不到信息时的替代文字
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get escalationGhostLockValueUnknown;

  /// 确认弹窗里安全模式开关的标题
  ///
  /// In zh, this message translates to:
  /// **'安全模式'**
  String get escalationGhostLockSafeModeTitle;

  /// 确认弹窗里安全模式开关的说明
  ///
  /// In zh, this message translates to:
  /// **'执行前给 /data/adb/modules 下的模块打 disable'**
  String get escalationGhostLockSafeModeDesc;

  /// 确认弹窗的主按钮
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get escalationGhostLockConfirmRun;

  /// 确认弹窗底部的风险说明
  ///
  /// In zh, this message translates to:
  /// **'执行期间会把 SELinux 置为宽容模式，失败时可能停在宽容状态。重启即可恢复。'**
  String get escalationGhostLockConfirmRisk;

  /// 自检发现 ADB 未连接时的提示
  ///
  /// In zh, this message translates to:
  /// **'无线调试未连接，先在设置里配对'**
  String get escalationGhostLockNoAdb;

  /// 自检发现原生二进制缺失时的提示
  ///
  /// In zh, this message translates to:
  /// **'安装包内缺少 libghostlock.so，重新安装应用'**
  String get escalationGhostLockMissingBinary;

  /// 自检发现内核表未命中时的提示
  ///
  /// In zh, this message translates to:
  /// **'内核表里没有 {release} 这一型，也不做近似匹配'**
  String escalationGhostLockNoProfile(String release);

  /// 内核表编码失败时的提示；reason 是技术诊断码，不翻译
  ///
  /// In zh, this message translates to:
  /// **'内核表解析失败：{reason}'**
  String escalationGhostLockProfileInvalid(String reason);

  /// 选中的 profile 与设备内核 release 不一致
  ///
  /// In zh, this message translates to:
  /// **'选中的内核表声明内核为 {profile}，当前设备是 {device}，两者不一致，不会套用'**
  String escalationGhostLockProfileMismatch(String profile, String device);

  /// 生效来源指向的文档不存在
  ///
  /// In zh, this message translates to:
  /// **'选中的文档 {name} 不存在，可能已被删除或重命名'**
  String escalationGhostLockProfileMissing(String name);

  /// 自检发现 seccomp 非 0 时的提示
  ///
  /// In zh, this message translates to:
  /// **'当前 shell 带有 seccomp 过滤，这条链路无法清掉它'**
  String get escalationGhostLockSeccompFiltered;

  /// 开始执行时写进终端的那一行；manager 为空时只有前半个空格
  ///
  /// In zh, this message translates to:
  /// **'正在执行 GhostLock{manager}…'**
  String escalationGhostLockRunning(String manager);

  /// 全链路成功时的结论
  ///
  /// In zh, this message translates to:
  /// **'内核模块已加载，KernelSU 已接管{manager}'**
  String escalationGhostLockSucceeded(String manager);

  /// 原生因 KernelSU 已加载而提前结束时显示的结论
  ///
  /// In zh, this message translates to:
  /// **'KernelSU 本次开机已接管，未重复执行'**
  String get escalationGhostLockAlreadyRooted;

  /// 只拿到临时 root 时的结论
  ///
  /// In zh, this message translates to:
  /// **'拿到临时 root，但 KernelSU 模块尚未加载'**
  String get escalationGhostLockTempRootOnly;

  /// W3 未清掉 seccomp 时的结论
  ///
  /// In zh, this message translates to:
  /// **'临时的 root 子进程仍带 seccomp 过滤，KernelSU 无法加载'**
  String get escalationGhostLockSeccompBlocked;

  /// ksud late-load 失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'KernelSU 模块加载失败，见上方 ksud 输出'**
  String get escalationGhostLockKsuFailed;

  /// W1 阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'关闭 SELinux 失败，见上方输出'**
  String get escalationGhostLockW1Failed;

  /// W2 阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'写凭据阶段失败，见上方输出'**
  String get escalationGhostLockW2Failed;

  /// W3 阶段失败时的结论
  ///
  /// In zh, this message translates to:
  /// **'清 seccomp 阶段失败，见上方输出'**
  String get escalationGhostLockW3Failed;

  /// profile release 与 uname -r 不一致时的结论
  ///
  /// In zh, this message translates to:
  /// **'内核表与设备内核不一致，原生已退出'**
  String get escalationGhostLockReleaseMismatch;

  /// 出现 terminal dirty race 时的结论
  ///
  /// In zh, this message translates to:
  /// **'竞争进入脏状态，原生已自行停止进程'**
  String get escalationGhostLockDirtyRace;

  /// 超时或取消时的结论
  ///
  /// In zh, this message translates to:
  /// **'等待终局信号超时，已停止读取；设备侧可能仍在执行'**
  String get escalationGhostLockTimedOut;

  /// 原生拒绝受理时的结论；reason 是技术标识，不做翻译
  ///
  /// In zh, this message translates to:
  /// **'原生侧未受理，原因码：{reason}'**
  String escalationGhostLockNotStarted(String reason);

  /// 有输出但无结论时的兜底
  ///
  /// In zh, this message translates to:
  /// **'未拿到可识别的终局标记，见上方输出'**
  String get escalationGhostLockFailed;

  /// 原生异常/本侧诊断码；code 是技术标识，不做翻译
  ///
  /// In zh, this message translates to:
  /// **'原生诊断：{code}'**
  String escalationGhostLockFailureCode(String code);

  /// 运行中 ADB 通道掉线或设备重启
  ///
  /// In zh, this message translates to:
  /// **'与设备的连接中断（多半是设备重启了），已停止跟踪；设备恢复后重试'**
  String get escalationGhostLockFailureDeviceDisconnected;

  /// 启动命令本身失败
  ///
  /// In zh, this message translates to:
  /// **'原生进程没能拉起，见上方 shell 输出'**
  String get escalationGhostLockFailureLaunch;

  /// profile.bin 写盘失败
  ///
  /// In zh, this message translates to:
  /// **'内核表写入设备临时目录失败，请确认无线调试仍然可用'**
  String get escalationGhostLockFailureProfileWrite;

  /// 原生进程没有产生日志
  ///
  /// In zh, this message translates to:
  /// **'原生进程启动后没有任何输出，已停止跟踪'**
  String get escalationGhostLockFailureNotStarted;

  /// 运行中底栏的停止按钮；只停止本侧读取
  ///
  /// In zh, this message translates to:
  /// **'停止读取'**
  String get escalationGhostLockStop;

  /// 确认弹窗与编辑器页标题里打开编辑器的按钮
  ///
  /// In zh, this message translates to:
  /// **'编辑内核表'**
  String get escalationGhostLockProfileEdit;

  /// 编辑器通用参数页签
  ///
  /// In zh, this message translates to:
  /// **'通用'**
  String get escalationGhostLockProfileTabGeneral;

  /// 编辑器路由页签
  ///
  /// In zh, this message translates to:
  /// **'路由'**
  String get escalationGhostLockProfileTabRoute;

  /// 编辑器高级字段页签
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get escalationGhostLockProfileTabAdvanced;

  /// 字段在 profile 里没有值时的输入框提示
  ///
  /// In zh, this message translates to:
  /// **'未提供'**
  String get escalationGhostLockProfileNotProvided;

  /// 字段被校验判为违规时的提示
  ///
  /// In zh, this message translates to:
  /// **'该值不满足偏移规则'**
  String get escalationGhostLockProfileInvalidField;

  /// 字段被本地 override 的标记
  ///
  /// In zh, this message translates to:
  /// **'已修改'**
  String get escalationGhostLockProfileOverridden;

  /// 把本次编辑保存到对应目标
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get escalationGhostLockProfileWriteBack;

  /// 写回成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已写入当前文件'**
  String get escalationGhostLockProfileWrittenBack;

  /// 导出或写回失败时的提示
  ///
  /// In zh, this message translates to:
  /// **'写入失败'**
  String get escalationGhostLockProfileWriteFailed;

  /// 原生拒绝写入 override 时的提示
  ///
  /// In zh, this message translates to:
  /// **'这个值会让配置无法解析，已回滚'**
  String get escalationGhostLockProfileRejected;

  /// 编辑会话保存成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get escalationGhostLockProfileSaved;

  /// 内置/设备态保存后生成的文档名
  ///
  /// In zh, this message translates to:
  /// **'已另存为 {name}'**
  String escalationGhostLockProfileSavedAsNew(String name);

  /// 把当前生效配置导出为 conf
  ///
  /// In zh, this message translates to:
  /// **'导出为文件'**
  String get escalationGhostLockProfileExport;

  /// 把当前生效配置存成一份用户文档
  ///
  /// In zh, this message translates to:
  /// **'另存为我的配置'**
  String get escalationGhostLockProfileSaveAs;

  /// 路由选择里的默认项
  ///
  /// In zh, this message translates to:
  /// **'按 profile 声明'**
  String get escalationGhostLockProfileRouteAuto;

  /// 编辑器路由页的分组标题
  ///
  /// In zh, this message translates to:
  /// **'路由'**
  String get escalationGhostLockProfileRouteLabel;

  /// 路由页顶部显示合并后的实际 route 与 fallback
  ///
  /// In zh, this message translates to:
  /// **'当前生效'**
  String get escalationGhostLockProfileRouteCurrent;

  /// 编辑器路由页 fallback 分组的标题
  ///
  /// In zh, this message translates to:
  /// **'回退'**
  String get escalationGhostLockProfileFallbackLabel;

  /// fallback 选择里的 none
  ///
  /// In zh, this message translates to:
  /// **'关闭回退'**
  String get escalationGhostLockProfileFallbackNone;

  /// 移除 fallback override，回到 profile 自己声明的值
  ///
  /// In zh, this message translates to:
  /// **'跟随配置声明'**
  String get escalationGhostLockProfileFallbackDeclared;

  /// loadProfile 返回 hasProfile=false 时的提示
  ///
  /// In zh, this message translates to:
  /// **'这个内核没有可编辑的 profile'**
  String get escalationGhostLockProfileNoProfile;

  /// 保存到当前文件时找不到任何可写回的用户文档
  ///
  /// In zh, this message translates to:
  /// **'没有可写回的目标文档，请先用「另存为我的配置」创建一份'**
  String get escalationGhostLockProfileNoWritableDoc;

  /// 编辑器顶部状态条的标签：当前用的是哪份内核表
  ///
  /// In zh, this message translates to:
  /// **'生效来源'**
  String get escalationGhostLockProfileSourceLabel;

  /// 未指定内置表时，跟随设备自身 release
  ///
  /// In zh, this message translates to:
  /// **'设备内置表'**
  String get escalationGhostLockProfileSourceDevice;

  /// 指定了内置表中的某一份
  ///
  /// In zh, this message translates to:
  /// **'内置表'**
  String get escalationGhostLockProfileSourceBuiltin;

  /// 生效来源叠加了用户导入文档
  ///
  /// In zh, this message translates to:
  /// **'我的配置'**
  String get escalationGhostLockProfileSourceUser;

  /// 顶部状态条显示本地 override 的条目数
  ///
  /// In zh, this message translates to:
  /// **'已修改 {count} 项'**
  String escalationGhostLockProfileOverriddenCount(int count);

  /// 通用页签顶部的说明
  ///
  /// In zh, this message translates to:
  /// **'执行参数。改完离开输入框即生效，下次运行 GhostLock 用新值；不需要另外保存。'**
  String get escalationGhostLockProfileTabGeneralHint;

  /// 路由页签顶部的说明
  ///
  /// In zh, this message translates to:
  /// **'选择注入路径。点选立即生效；三条路由的几何常量不同，切换后高级页的字段会跟着变。'**
  String get escalationGhostLockProfileTabRouteHint;

  /// 路由页签里说明「切换路由后几何常量可能缺失」
  ///
  /// In zh, this message translates to:
  /// **'每条路由的几何常量（如 waiter_shift、compact_waiter、waiter_off）只在从镜像生成该路由时才会写入。切到一份表里没生成过的路由，这些字段会是空值，运行时可能拿不到参数。要换路由，建议重新解析镜像并在解析时指定路由。'**
  String get escalationGhostLockProfileRouteGeometryHint;

  /// 高级页签顶部的说明
  ///
  /// In zh, this message translates to:
  /// **'结构与偏移字段。改动立即生效；未提供的字段显示为空，填值后才会写入。'**
  String get escalationGhostLockProfileTabAdvancedHint;

  /// 单个字段提交成功后的轻提示
  ///
  /// In zh, this message translates to:
  /// **'已应用'**
  String get escalationGhostLockProfileApplied;

  /// 保存菜单里「保存」的副说明
  ///
  /// In zh, this message translates to:
  /// **'生效配置写回本地；文档直接覆盖'**
  String get escalationGhostLockProfileWriteBackHint;

  /// 内置/设备态下「保存」置灰时的说明
  ///
  /// In zh, this message translates to:
  /// **'内置表不可改写，请用「另存为」'**
  String get escalationGhostLockProfileWriteBackDisabled;

  /// 保存菜单里「另存为我的配置」的副说明
  ///
  /// In zh, this message translates to:
  /// **'存成一份新的用户文档，原文件不动'**
  String get escalationGhostLockProfileSaveAsHint;

  /// 保存菜单里「导出为文件」的副说明
  ///
  /// In zh, this message translates to:
  /// **'导出 conf 到系统文件'**
  String get escalationGhostLockProfileExportHint;

  /// 内置内核表列表的过滤框提示
  ///
  /// In zh, this message translates to:
  /// **'按 release 过滤'**
  String get escalationGhostLockProfileSelectSearch;

  /// 内置列表里 -template 文件的分组标题
  ///
  /// In zh, this message translates to:
  /// **'参考模板'**
  String get escalationGhostLockProfileSelectTemplates;

  /// 导入页标题
  ///
  /// In zh, this message translates to:
  /// **'导入内核表'**
  String get escalationGhostLockImportTitle;

  /// 提取失败提示；reason 是技术诊断码，不翻译
  ///
  /// In zh, this message translates to:
  /// **'提取失败：{reason}'**
  String escalationGhostLockImportFailed(String reason);

  /// 同名 release 已存在时的确认提示
  ///
  /// In zh, this message translates to:
  /// **'已有同内核的条目，覆盖吗？'**
  String get escalationGhostLockImportOverwrite;

  /// 覆盖确认弹窗的主按钮
  ///
  /// In zh, this message translates to:
  /// **'覆盖'**
  String get escalationGhostLockImportOverwriteAction;

  /// 提取成功提示
  ///
  /// In zh, this message translates to:
  /// **'已生成 {release} 的内核表'**
  String escalationGhostLockImportDone(String release);

  /// 已导入列表为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'还没有导入任何内核表'**
  String get escalationGhostLockImportedEmpty;

  /// 已导入条目的删除按钮
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get escalationGhostLockImportedRemove;

  /// 已导入条目的解析失败标记
  ///
  /// In zh, this message translates to:
  /// **'文件无法解析'**
  String get escalationGhostLockImportedParseError;

  /// 已导入条目的重命名操作
  ///
  /// In zh, this message translates to:
  /// **'重命名'**
  String get escalationGhostLockImportedRename;

  /// 重命名输入框的提示
  ///
  /// In zh, this message translates to:
  /// **'新文件名'**
  String get escalationGhostLockImportedRenameHint;

  /// 已导入条目的导出操作
  ///
  /// In zh, this message translates to:
  /// **'导出'**
  String get escalationGhostLockImportedExport;

  /// 进入该内核表的编辑器
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get escalationGhostLockImportedEdit;

  /// 导出成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已导出'**
  String get escalationGhostLockImportedExported;

  /// 已导入条目右侧的更多操作菜单
  ///
  /// In zh, this message translates to:
  /// **'更多操作'**
  String get escalationGhostLockMoreActions;

  /// 直接导入一份已有的 HOCON / JSON 内核表；支持连同 include 依赖一起多选
  ///
  /// In zh, this message translates to:
  /// **'导入现成配置（conf / hocon / json / txt，可多选）'**
  String get escalationGhostLockImportText;

  /// 多选导入时全部文件都被类型或编码校验挡下
  ///
  /// In zh, this message translates to:
  /// **'没有可导入的文件：仅支持 conf / hocon / json / txt，且需为 UTF-8 文本'**
  String get escalationGhostLockImportUnsupported;

  /// 设置页 GhostKey 分组的小标题
  ///
  /// In zh, this message translates to:
  /// **'GhostKey'**
  String get settingsGhostKeySection;

  /// 设置页：是否在末段接管 KernelSU
  ///
  /// In zh, this message translates to:
  /// **'接管 KernelSU'**
  String get settingsGhostKeyRunKsuTitle;

  /// 设置页：接管 KernelSU 的说明
  ///
  /// In zh, this message translates to:
  /// **'提权完成后自动把内核能力移交给 KernelSU'**
  String get settingsGhostKeyRunKsuDesc;

  /// 设置页：是否接受 calib_b 的 fallback
  ///
  /// In zh, this message translates to:
  /// **'接受降级偏移'**
  String get settingsGhostKeyAcceptFallbackTitle;

  /// 设置页：接受降级偏移的说明
  ///
  /// In zh, this message translates to:
  /// **'线性映射置信度偏低时继续注入，不中止'**
  String get settingsGhostKeyAcceptFallbackDesc;

  /// 设置页这一组的小标题
  ///
  /// In zh, this message translates to:
  /// **'提权'**
  String get settingsBootAutostartSection;

  /// 专家模式开关的标题
  ///
  /// In zh, this message translates to:
  /// **'专家模式'**
  String get settingsExpertModeTitle;

  /// 专家模式开关的说明
  ///
  /// In zh, this message translates to:
  /// **'开启后显示自动执行与运行参数'**
  String get settingsExpertModeDesc;

  /// 开机自启开关的标题（专家模式已开）
  ///
  /// In zh, this message translates to:
  /// **'开机自动执行 DirtyFrag'**
  String get settingsBootAutostartTitle;

  /// 开机自启开关的标题（专家模式未开）
  ///
  /// In zh, this message translates to:
  /// **'开机自动执行 DirtyFrag（需先开专家模式）'**
  String get settingsBootAutostartTitleLocked;

  /// 开机自启开关的说明
  ///
  /// In zh, this message translates to:
  /// **'开机时自动执行一次，失败会自动关闭'**
  String get settingsBootAutostartDesc;

  /// 开启开机自启前的确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'确认开启开机自启？'**
  String get settingsBootAutostartConfirmTitle;

  /// 开启开机自启前的确认弹窗正文
  ///
  /// In zh, this message translates to:
  /// **'开机阶段执行失败可能导致反复重启，届时只能进 recovery 或重刷系统恢复。确认了解后再开启。'**
  String get settingsBootAutostartConfirmBody;

  /// 开启开机自启确认弹窗的主按钮
  ///
  /// In zh, this message translates to:
  /// **'我了解，开启'**
  String get settingsBootAutostartConfirmAction;

  /// 手动提权页-底栏复制键：按钮名与读屏文案
  ///
  /// In zh, this message translates to:
  /// **'复制选区'**
  String get escalationCopy;

  /// 手动提权页-复制成功后的终端提示
  ///
  /// In zh, this message translates to:
  /// **'已复制选中文本'**
  String get escalationCopied;

  /// 手动提权页-没有选区时按复制键的提示
  ///
  /// In zh, this message translates to:
  /// **'没有选中文本：长按终端选中内容后再复制'**
  String get escalationCopyEmpty;

  /// 手动提权页-终端：消费不及时导致输出被截断
  ///
  /// In zh, this message translates to:
  /// **'输出过多，最早 {bytes} 字节已被丢弃（只保留最新部分）'**
  String escalationOutputTruncated(int bytes);

  /// 手动提权页-终端：流式会话被拒
  ///
  /// In zh, this message translates to:
  /// **'命令没能启动：{reason}'**
  String escalationExecStartFailed(String reason);

  /// 手动提权页-原因码 emptyCommand
  ///
  /// In zh, this message translates to:
  /// **'命令为空'**
  String get escalationExecReasonEmpty;

  /// 手动提权页-原因码 channelNotReady
  ///
  /// In zh, this message translates to:
  /// **'shell 通道未连接'**
  String get escalationExecReasonNotReady;

  /// 手动提权页-原因码 streamOpenFailed
  ///
  /// In zh, this message translates to:
  /// **'开流被拒绝或连接已断开'**
  String get escalationExecReasonStreamFailed;

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

  /// 首页 ADB 卡片-通知栏输入的兜底提示
  ///
  /// In zh, this message translates to:
  /// **'如果通知栏无法输入配对码，请到「设置 → 通用 → 配对码输入位置」切换为「小窗输入」'**
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

  /// 设置项-无线调试配对码输入位置标题
  ///
  /// In zh, this message translates to:
  /// **'配对码输入位置'**
  String get settingsShellPairingModeTitle;

  /// 设置项-无线调试配对码输入位置说明
  ///
  /// In zh, this message translates to:
  /// **'通知栏弹不出输入框的机型（如小米）可改为小窗/分屏后，在卡片里输入配对码'**
  String get settingsShellPairingModeDesc;

  /// 配对码输入位置-通知栏
  ///
  /// In zh, this message translates to:
  /// **'通知栏'**
  String get shellPairingModeNotification;

  /// 配对码输入位置-小窗/分屏后在卡片内输入
  ///
  /// In zh, this message translates to:
  /// **'小窗输入'**
  String get shellPairingModeCard;

  /// 卡片内配对码输入框的占位提示
  ///
  /// In zh, this message translates to:
  /// **'六位配对码'**
  String get shellPairingCodeHint;

  /// 卡片内配对码提交按钮
  ///
  /// In zh, this message translates to:
  /// **'配对'**
  String get shellPairingCodeSubmit;

  /// 卡片输入模式的说明
  ///
  /// In zh, this message translates to:
  /// **'先在系统里点「使用配对码配对设备」，再把六位码填到这里；建议分屏或小窗，切走应用会让码失效'**
  String get shellPairingCardHint;

  /// 卡片输入模式-跳转系统无线调试页的入口
  ///
  /// In zh, this message translates to:
  /// **'打开无线调试设置'**
  String get shellPairingOpenDebugSettings;

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

  /// 原因码-pairingEndpointNotFound
  ///
  /// In zh, this message translates to:
  /// **'没找到配对服务：请先在系统里打开「使用配对码配对设备」弹窗，再重新输入配对码'**
  String get shellReasonEndpointNotFound;

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

  /// 设置页-命令通道切换项的标题
  ///
  /// In zh, this message translates to:
  /// **'命令通道'**
  String get settingsCommandChannelTitle;

  /// 设置页-命令通道切换项的说明
  ///
  /// In zh, this message translates to:
  /// **'AI 工具执行命令时使用的链路，可在此切换'**
  String get settingsCommandChannelDesc;

  /// 命令通道名称-无线 ADB
  ///
  /// In zh, this message translates to:
  /// **'无线 ADB'**
  String get commandChannelAdb;

  /// 命令通道名称-Stellar
  ///
  /// In zh, this message translates to:
  /// **'Stellar'**
  String get commandChannelStellar;

  /// 首页 Stellar 通道卡片的标题
  ///
  /// In zh, this message translates to:
  /// **'Stellar'**
  String get stellarCardTitle;

  /// 首页 Stellar 卡片-服务可用时的状态；uid 是服务身份
  ///
  /// In zh, this message translates to:
  /// **'服务已就绪（uid={uid}）'**
  String stellarStatusReady(int uid);

  /// 首页 Stellar 卡片-服务不可用时的状态
  ///
  /// In zh, this message translates to:
  /// **'服务尚未就绪'**
  String get stellarStatusNotReady;

  /// 首页 Stellar 卡片-服务不可用时的说明与下一步
  ///
  /// In zh, this message translates to:
  /// **'Stellar 特权服务尚未就绪，这一通道暂时无法执行命令；可在「设置 → 通用 → 命令通道」切换。'**
  String get stellarNotReadyHint;

  /// 首页 Stellar 卡片-拉起特权服务的按钮
  ///
  /// In zh, this message translates to:
  /// **'启动服务'**
  String get stellarStartService;

  /// 首页 Stellar 卡片-拉起进行中的状态
  ///
  /// In zh, this message translates to:
  /// **'正在启动服务…'**
  String get stellarLaunching;

  /// 拉起失败-自动连接执行通道失败
  ///
  /// In zh, this message translates to:
  /// **'自动连接无线调试没有成功，服务没能启动。请确认「无线调试」已开启后重试。'**
  String get stellarLaunchNoRunner;

  /// 拉起失败-APK 里没有引导文件
  ///
  /// In zh, this message translates to:
  /// **'安装包内缺少启动文件，无法启动服务。'**
  String get stellarLaunchLauncherMissing;

  /// 拉起失败-服务未在等待时间内应答
  ///
  /// In zh, this message translates to:
  /// **'服务已发出启动请求，但没有在预期时间内响应。'**
  String get stellarLaunchNotAnswering;

  /// 拉起前-小窗输入模式下等待用户填配对码
  ///
  /// In zh, this message translates to:
  /// **'填入无线调试的六位配对码后会自动连接并启动服务。'**
  String get stellarLaunchAwaitingCode;

  /// 首页 Stellar 卡片-服务已就绪时断开服务的按钮
  ///
  /// In zh, this message translates to:
  /// **'断开服务'**
  String get stellarStopService;

  /// 首页 Stellar 卡片-断开进行中的状态
  ///
  /// In zh, this message translates to:
  /// **'正在停止服务…'**
  String get stellarStopping;

  /// 断开失败-服务未确认退出或端口仍在应答
  ///
  /// In zh, this message translates to:
  /// **'服务没有响应断开请求，可能仍在运行。'**
  String get stellarStopFailed;

  /// 手动提权页-无线 ADB 未连接时终端上方的一行提示
  ///
  /// In zh, this message translates to:
  /// **'没连上无线调试。'**
  String get escalationTerminalNeedsAdb;

  /// 首页标题栏右侧胶囊：点击弹出管理器选择
  ///
  /// In zh, this message translates to:
  /// **'选择 root 管理器'**
  String get rootManagerPillTooltip;

  /// 管理器选择弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'Root 管理器'**
  String get rootManagerTitle;

  /// 管理器列表里标记已选中的第一个
  ///
  /// In zh, this message translates to:
  /// **'当前'**
  String get rootManagerCurrent;

  /// 管理器选择弹窗的扫描空态
  ///
  /// In zh, this message translates to:
  /// **'没找到 root 管理器。'**
  String get rootManagerEmpty;

  /// 切换管理器后的轻提示
  ///
  /// In zh, this message translates to:
  /// **'已切换到 {manager}'**
  String rootManagerSwitched(String manager);

  /// 管理器选择落盘失败
  ///
  /// In zh, this message translates to:
  /// **'保存失败：{message}'**
  String rootManagerSaveFailed(String message);

  /// 内核表页面与设置入口的标题；覆盖 GhostKey 与 GhostLock 两个漏洞
  ///
  /// In zh, this message translates to:
  /// **'内核表'**
  String get kernelProfileTitle;

  /// 设置页内核表入口的副标题
  ///
  /// In zh, this message translates to:
  /// **'为 GhostKey 与 GhostLock 生成内核参数'**
  String get kernelProfileEntrySubtitle;

  /// 内核表页面在 GhostKey 页签下的说明文字
  ///
  /// In zh, this message translates to:
  /// **'本机内核不在内置表里时，用本机的 boot.img 或 OTA 生成 profile。生成的 profile 只保存在本应用私有目录。'**
  String get kernelProfilePageDesc;

  /// 内核表页面的 GhostKey 已导入页签标签
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 已导入'**
  String get kernelProfileTabGhostKey;

  /// 内核表页面的 GhostKey 内置页签标签
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 内置'**
  String get kernelProfileTabGhostKeyBuiltin;

  /// 内核表页面的 GhostLock 已导入页签标签
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 已导入'**
  String get kernelProfileTabGhostLock;

  /// 内核表页面的 GhostLock 内置页签标签
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 内置'**
  String get kernelProfileTabGhostLockBuiltin;

  /// 选择镜像或 OTA 包的按钮
  ///
  /// In zh, this message translates to:
  /// **'选择镜像（img / bin / zip）'**
  String get kernelProfileImportAction;

  /// 已选镜像后，选择按钮改为更换
  ///
  /// In zh, this message translates to:
  /// **'更换镜像'**
  String get kernelProfileImportChangeFile;

  /// 可选的 xbl_config 镜像选择按钮
  ///
  /// In zh, this message translates to:
  /// **'xbl_config.img（可选）'**
  String get kernelProfileImportAttachXbl;

  /// 可选的 uefi 镜像选择按钮
  ///
  /// In zh, this message translates to:
  /// **'uefi.img（可选）'**
  String get kernelProfileImportAttachUefi;

  /// 可选的 vendor_boot 镜像选择按钮，MTK 设备用
  ///
  /// In zh, this message translates to:
  /// **'vendor_boot.img（可选）'**
  String get kernelProfileImportAttachVendorBoot;

  /// 手动指定 kernel_phys_load 的输入框标题
  ///
  /// In zh, this message translates to:
  /// **'物理装载基址（可选）'**
  String get kernelProfileImportPhysLabel;

  /// 物理装载基址输入框的示例
  ///
  /// In zh, this message translates to:
  /// **'0x80000000'**
  String get kernelProfileImportPhysHint;

  /// 导入面板里高级选项区的标题
  ///
  /// In zh, this message translates to:
  /// **'高级解析选项'**
  String get kernelProfileAdvancedTitle;

  /// 高级选项区收起时的说明
  ///
  /// In zh, this message translates to:
  /// **'一般不用改；改后需重新解析'**
  String get kernelProfileAdvancedHint;

  /// 选择外部 kallsyms 文本文件的按钮
  ///
  /// In zh, this message translates to:
  /// **'kallsyms 文件'**
  String get kernelProfileImportKallsyms;

  /// 选择外部 /proc/iomem 文本文件的按钮
  ///
  /// In zh, this message translates to:
  /// **'iomem 文件'**
  String get kernelProfileImportIomem;

  /// 强制路由选择区的标题
  ///
  /// In zh, this message translates to:
  /// **'路由'**
  String get kernelProfileImportRoute;

  /// 路由选择里的自动选项
  ///
  /// In zh, this message translates to:
  /// **'自动推荐'**
  String get kernelProfileImportRouteAuto;

  /// 对应上游 --allow_missing 的开关
  ///
  /// In zh, this message translates to:
  /// **'缺失符号按可选处理（输出 0）'**
  String get kernelProfileImportAllowMissing;

  /// 对应上游 --no_disasm 的开关
  ///
  /// In zh, this message translates to:
  /// **'跳过反汇编推导（更快，精度下降）'**
  String get kernelProfileImportNoDisasm;

  /// OTA 链接输入框的提示文字
  ///
  /// In zh, this message translates to:
  /// **'OTA 链接（HTTP/HTTPS）'**
  String get kernelProfileImportUrlHint;

  /// 按当前输入解析内核表，只出结果不落盘
  ///
  /// In zh, this message translates to:
  /// **'解析内核'**
  String get kernelProfileImportParseAction;

  /// 解析前未提供输入源时的提示
  ///
  /// In zh, this message translates to:
  /// **'先选一个镜像或填一个链接'**
  String get kernelProfileImportNeedInput;

  /// 选择器挡不住非镜像文件时按扩展名拒绝
  ///
  /// In zh, this message translates to:
  /// **'不支持的文件：仅接受 img / bin / zip 镜像或 OTA 包'**
  String get kernelProfileImportUnsupportedImage;

  /// 选中的本地文件长度为 0 或读取失败
  ///
  /// In zh, this message translates to:
  /// **'文件为空或无法读取'**
  String get kernelProfileImportEmptyFile;

  /// 解析直链时的 TLS 选项说明
  ///
  /// In zh, this message translates to:
  /// **'跳过证书校验（直链自签时用）'**
  String get kernelProfileImportInsecureHint;

  /// 解析成功卡片的状态标题
  ///
  /// In zh, this message translates to:
  /// **'解析完成'**
  String get kernelProfileProbeReady;

  /// 解析结果里路由几何缺失时的告警标题
  ///
  /// In zh, this message translates to:
  /// **'路由几何不完整，这条配置跑不到写入：'**
  String get kernelProfileProbeRouteIncomplete;

  /// 路由几何缺失时给的处理建议
  ///
  /// In zh, this message translates to:
  /// **'提权第一阶段只会试一次，缺字段会被直接拒绝。补上缺失字段，或在「路由」页换一条本表声明齐全的路由。'**
  String get kernelProfileProbeRouteIncompleteHint;

  /// 解析结果里的告警条数
  ///
  /// In zh, this message translates to:
  /// **'{count} 条提示'**
  String kernelProfileProbeWarnings(int count);

  /// 告警明细弹窗的标题
  ///
  /// In zh, this message translates to:
  /// **'解析提示'**
  String get kernelProfileProbeWarningsTitle;

  /// 物理装载基址这一行的键名
  ///
  /// In zh, this message translates to:
  /// **'kernel_phys_load'**
  String get kernelProfileProbePhys;

  /// 物理装载基址未取到时的值
  ///
  /// In zh, this message translates to:
  /// **'未取到'**
  String get kernelProfileProbePhysMissing;

  /// 物理装载基址未取到时的处理说明
  ///
  /// In zh, this message translates to:
  /// **'未取到时写 null，运行时按 SoC 型号回退到内置常量；若运行报地址错误，再补附 xbl_config.img 或手填物理基址。'**
  String get kernelProfileProbePhysUnsetHint;

  /// 导入面板里的附件区标题
  ///
  /// In zh, this message translates to:
  /// **'可选附件'**
  String get kernelProfileAttachTitle;

  /// 附件区收起且未附加文件时的说明
  ///
  /// In zh, this message translates to:
  /// **'用于补 kernel_phys_load，一般不用管'**
  String get kernelProfileAttachHint;

  /// 附件区收起但已附加文件时的说明
  ///
  /// In zh, this message translates to:
  /// **'已附加镜像，重新解析后生效'**
  String get kernelProfileAttachAttachedCount;

  /// 直链/压缩包输入时，说明相关分区由包内自动解出，结果以解析卡片为准
  ///
  /// In zh, this message translates to:
  /// **'包内的 xbl_config、uefi、vendor_boot 由提取器按需解出；实际解出了哪些见结果里的「包内分区」。'**
  String get kernelProfileAttachAutoHint;

  /// 说明 vendor_boot 为何要手动附加
  ///
  /// In zh, this message translates to:
  /// **'仅 MediaTek 机型需要，用于补 DRAM 基址。'**
  String get kernelProfileAttachVendorBootHint;

  /// 附件行右侧的操作文字：尚未选择
  ///
  /// In zh, this message translates to:
  /// **'选择'**
  String get kernelProfileAttachPick;

  /// 附件行右侧的操作文字：已选择
  ///
  /// In zh, this message translates to:
  /// **'更换'**
  String get kernelProfileAttachReplace;

  /// 解析结果里「从包内解出了哪些分区」的标签
  ///
  /// In zh, this message translates to:
  /// **'包内分区'**
  String get kernelProfileProbePayloadParts;

  /// 打开审查报告的按钮文字
  ///
  /// In zh, this message translates to:
  /// **'内核审查报告'**
  String get kernelProfileProbeAnalysis;

  /// 审查报告弹窗的标题
  ///
  /// In zh, this message translates to:
  /// **'内核审查报告'**
  String get kernelProfileProbeAnalysisTitle;

  /// 导入目标开关的短标签，避免撑满分段按钮
  ///
  /// In zh, this message translates to:
  /// **'GhostLock'**
  String get kernelProfileImportTargetGhostLock;

  /// 导入目标开关的短标签，避免撑满分段按钮
  ///
  /// In zh, this message translates to:
  /// **'GhostKey'**
  String get kernelProfileImportTargetGhostKey;

  /// 输入来源切换：本地镜像文件
  ///
  /// In zh, this message translates to:
  /// **'本地镜像'**
  String get kernelProfileInputSourceLocal;

  /// 输入来源切换：OTA 直链
  ///
  /// In zh, this message translates to:
  /// **'OTA 直链'**
  String get kernelProfileInputSourceUrl;

  /// 解析完成后底部主按钮；table 是目标内核表名
  ///
  /// In zh, this message translates to:
  /// **'写入 {table}'**
  String kernelProfileWriteToTarget(String table);

  /// 解析失败的提示；reason 是技术诊断串
  ///
  /// In zh, this message translates to:
  /// **'解析失败：{reason}'**
  String kernelProfileProbeFailed(String reason);

  /// OTA 链接输入框下方的提示：必须导入带 BTF 的内核镜像
  ///
  /// In zh, this message translates to:
  /// **'需要带 BTF 调试信息的内核，第三方 ROM 或老机型可能取不到结构偏移'**
  String get kernelProfileBtfHint;

  /// 把已知可用的示例 OTA 链接填进输入框
  ///
  /// In zh, this message translates to:
  /// **'粘贴示例'**
  String get kernelProfilePasteExample;

  /// BTF 说明弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'为什么需要 BTF？'**
  String get kernelProfileWhyBtfTitle;

  /// BTF 说明弹窗正文：解释原理与链接要求
  ///
  /// In zh, this message translates to:
  /// **'生成的 profile 靠 struct cred 各字段的字节偏移来伪造凭据，而这些偏移随内核版本变化，不能写死。\n\n内核镜像若带 BTF（编译开关 CONFIG_DEBUG_INFO_BTF），就能直接从镜像读出 task_struct、cred 的真实布局；没有 BTF 就取不到 task_cred、task_struct_size、cred_uid，profile 生成不了。\n\n另外链接必须支持 HTTP Range（分段下载），否则无法只取 boot 分区。厂商原厂 OTA 和 Pixel 等 GKI 机型一般两者都满足。'**
  String get kernelProfileWhyBtfBody;

  /// 说明弹窗的关闭按钮
  ///
  /// In zh, this message translates to:
  /// **'知道了'**
  String get kernelProfileDialogClose;

  /// 打开内置 OTA 清单弹窗的按钮
  ///
  /// In zh, this message translates to:
  /// **'内置 ROM'**
  String get otaCatalogBrowseAction;

  /// 内置 OTA 清单弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'内置 ROM 清单'**
  String get otaCatalogTitle;

  /// 内置 OTA 清单的搜索框提示
  ///
  /// In zh, this message translates to:
  /// **'搜索机型或版本号'**
  String get otaCatalogSearchHint;

  /// 内置 OTA 清单的使用说明
  ///
  /// In zh, this message translates to:
  /// **'点任意版本，把直链填进上面的输入框'**
  String get otaCatalogPickHint;

  /// 内置 OTA 清单搜索无结果
  ///
  /// In zh, this message translates to:
  /// **'没有匹配的机型或版本'**
  String get otaCatalogEmpty;

  /// 机型分组右侧的版本数量
  ///
  /// In zh, this message translates to:
  /// **'{count} 个版本'**
  String otaCatalogVersionCount(int count);

  /// 内置 OTA 清单的 Google 品牌标签
  ///
  /// In zh, this message translates to:
  /// **'Google'**
  String get otaCatalogBrandGoogle;

  /// 内置 OTA 清单的 realme 品牌标签
  ///
  /// In zh, this message translates to:
  /// **'realme'**
  String get otaCatalogBrandRealme;

  /// 已导入 profile 详情弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'内核参数详情'**
  String get kernelProfileDetailTitle;

  /// 详情弹窗的概览分区标题
  ///
  /// In zh, this message translates to:
  /// **'基本信息'**
  String get kernelProfileDetailOverview;

  /// 详情弹窗的偏移量分区标题
  ///
  /// In zh, this message translates to:
  /// **'结构偏移'**
  String get kernelProfileDetailOffsets;

  /// GhostLock 详情弹窗里 offset.* 符号偏移的分区标题
  ///
  /// In zh, this message translates to:
  /// **'符号偏移'**
  String get kernelProfileDetailSymbolOffsets;

  /// GhostLock 详情弹窗的 schema_version 字段名
  ///
  /// In zh, this message translates to:
  /// **'表版本'**
  String get kernelProfileDetailSchema;

  /// GhostLock 详情弹窗的 kernel_major 字段名
  ///
  /// In zh, this message translates to:
  /// **'内核主版本'**
  String get kernelProfileDetailKernelMajor;

  /// 详情弹窗的原始 HOCON 分区标题
  ///
  /// In zh, this message translates to:
  /// **'原始配置'**
  String get kernelProfileDetailRaw;

  /// 概览里的漏洞类型字段名
  ///
  /// In zh, this message translates to:
  /// **'漏洞类型'**
  String get kernelProfileDetailVulnType;

  /// 概览里的内核页偏移字段名
  ///
  /// In zh, this message translates to:
  /// **'页偏移'**
  String get kernelProfileDetailPageOffset;

  /// 概览里的导入来源字段名
  ///
  /// In zh, this message translates to:
  /// **'导入来源'**
  String get kernelProfileDetailSource;

  /// 复制原始配置的按钮
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get kernelProfileDetailCopy;

  /// 复制成功后的提示
  ///
  /// In zh, this message translates to:
  /// **'已复制原始配置'**
  String get kernelProfileDetailCopied;

  /// profile 文件读不到时的提示
  ///
  /// In zh, this message translates to:
  /// **'读取不到内容，文件可能已被删除'**
  String get kernelProfileDetailEmpty;

  /// 详情弹窗底部的编辑入口按钮
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get kernelProfileEditAction;

  /// GhostKey 内核表字段编辑页标题
  ///
  /// In zh, this message translates to:
  /// **'编辑内核参数'**
  String get kernelProfileEditTitle;

  /// 编辑页的基础偏移分组标题
  ///
  /// In zh, this message translates to:
  /// **'基础偏移'**
  String get kernelProfileEditBasicSection;

  /// 编辑页的高级布局分组标题
  ///
  /// In zh, this message translates to:
  /// **'高级布局'**
  String get kernelProfileEditAdvancedSection;

  /// 编辑页顶部的数值输入说明
  ///
  /// In zh, this message translates to:
  /// **'支持 0x 十六进制或十进制，64 位地址按无符号展示'**
  String get kernelProfileEditInputHint;

  /// 编辑页顶部只读 release 字段名
  ///
  /// In zh, this message translates to:
  /// **'内核 release（只读）'**
  String get kernelProfileEditReleaseLabel;

  /// 编辑页说明 release 不可修改的原因
  ///
  /// In zh, this message translates to:
  /// **'release 是 uname -r 的精确匹配键，修改会导致不再生效'**
  String get kernelProfileEditReleaseHint;

  /// 编辑页顶部导入来源标签
  ///
  /// In zh, this message translates to:
  /// **'导入来源'**
  String get kernelProfileEditSource;

  /// 保存菜单：覆盖当前用户文档
  ///
  /// In zh, this message translates to:
  /// **'写回我的配置'**
  String get kernelProfileEditWriteBack;

  /// 写回动作的副标题
  ///
  /// In zh, this message translates to:
  /// **'覆盖当前用户文档'**
  String get kernelProfileEditWriteBackHint;

  /// 保存菜单：把编辑结果另存为一份新的用户文档
  ///
  /// In zh, this message translates to:
  /// **'另存为我的配置'**
  String get kernelProfileEditSaveAs;

  /// 另存为动作的副标题
  ///
  /// In zh, this message translates to:
  /// **'存成一份新的用户文档，原文件不动'**
  String get kernelProfileEditSaveAsHint;

  /// 保存菜单：把编辑结果导出为本地文件
  ///
  /// In zh, this message translates to:
  /// **'导出为文件'**
  String get kernelProfileEditExport;

  /// 导出动作的副标题
  ///
  /// In zh, this message translates to:
  /// **'把编辑结果导出为本地 .conf'**
  String get kernelProfileEditExportHint;

  /// 编辑页顶部文档名标签
  ///
  /// In zh, this message translates to:
  /// **'文档'**
  String get kernelProfileEditDocument;

  /// 另存为新文档失败提示
  ///
  /// In zh, this message translates to:
  /// **'保存失败'**
  String get kernelProfileEditSaveFailed;

  /// 另存为新文档成功提示；name 是文档名
  ///
  /// In zh, this message translates to:
  /// **'已另存为 {name}'**
  String kernelProfileEditSavedAs(String name);

  /// 用户显式选中生效时行内的徽标
  ///
  /// In zh, this message translates to:
  /// **'生效中'**
  String get kernelProfileActiveBadge;

  /// 详情弹窗里指定该配置生效
  ///
  /// In zh, this message translates to:
  /// **'设为生效'**
  String get kernelProfileSetActive;

  /// 详情弹窗里取消该配置的显式选择
  ///
  /// In zh, this message translates to:
  /// **'取消指定'**
  String get kernelProfileClearActive;

  /// 设为生效成功的提示
  ///
  /// In zh, this message translates to:
  /// **'已设为生效'**
  String get kernelProfileActivated;

  /// 取消指定生效后的提示
  ///
  /// In zh, this message translates to:
  /// **'已恢复自动匹配'**
  String get kernelProfileClearedActive;

  /// 写回成功提示
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get kernelProfileEditSaved;

  /// 保存时草稿与原文一致的提示
  ///
  /// In zh, this message translates to:
  /// **'没有需要保存的改动'**
  String get kernelProfileEditNoChange;

  /// 原生返回 invalidField 错误码时的文案
  ///
  /// In zh, this message translates to:
  /// **'存在无效数值'**
  String get kernelProfileEditInvalidField;

  /// 编辑页保存前的本地校验提示；fields 是字段路径列表
  ///
  /// In zh, this message translates to:
  /// **'无效数值：{fields}'**
  String kernelProfileEditInvalidFields(String fields);

  /// 导出编辑结果失败提示
  ///
  /// In zh, this message translates to:
  /// **'导出失败'**
  String get kernelProfileEditExportFailed;

  /// 编辑页找不到用户文档时的提示
  ///
  /// In zh, this message translates to:
  /// **'该内核表不是用户导入文档，不能编辑'**
  String get kernelProfileEditNotEditable;

  /// 导入阶段 0：连接服务器并定位 payload.bin
  ///
  /// In zh, this message translates to:
  /// **'定位 OTA 包'**
  String get kernelProfilePhaseLocate;

  /// 导入阶段 1：读取本地镜像或从链接下载分区数据
  ///
  /// In zh, this message translates to:
  /// **'下载镜像'**
  String get kernelProfilePhaseRead;

  /// 下载相位的字节进度
  ///
  /// In zh, this message translates to:
  /// **'{done} / {total}'**
  String kernelProfileBytesProgress(String done, String total);

  /// 导入阶段 2：解析内核
  ///
  /// In zh, this message translates to:
  /// **'解析内核'**
  String get kernelProfilePhaseParse;

  /// 导入阶段 3：写入 profile
  ///
  /// In zh, this message translates to:
  /// **'写入 profile'**
  String get kernelProfilePhaseSave;

  /// 导入阶段 4：全部结束
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get kernelProfilePhaseDone;

  /// 导入成功提示；release 是内核版本串，不翻译
  ///
  /// In zh, this message translates to:
  /// **'已生成 profile：{release}'**
  String kernelProfileImportSuccess(String release);

  /// 导入失败的标题
  ///
  /// In zh, this message translates to:
  /// **'导入失败'**
  String get kernelProfileImportFailed;

  /// 解析/导入错误旁的复制按钮提示
  ///
  /// In zh, this message translates to:
  /// **'复制错误信息'**
  String get kernelProfileErrorCopy;

  /// 复制错误信息成功的提示
  ///
  /// In zh, this message translates to:
  /// **'已复制错误信息'**
  String get kernelProfileErrorCopied;

  /// 导入结果缺字段提示；fields 是字段路径列表
  ///
  /// In zh, this message translates to:
  /// **'缺少必填字段：{fields}'**
  String kernelProfileMissingFields(String fields);

  /// 页签分区的小标题
  ///
  /// In zh, this message translates to:
  /// **'内核表'**
  String get kernelProfileImportedSection;

  /// 已导入 profile 列表的空态
  ///
  /// In zh, this message translates to:
  /// **'还没有导入过 profile'**
  String get kernelProfileImportedEmpty;

  /// 内置 profile 列表的空态
  ///
  /// In zh, this message translates to:
  /// **'内置表为空'**
  String get kernelProfileBuiltinEmpty;

  /// 向导里设备 uname -r 的标签
  ///
  /// In zh, this message translates to:
  /// **'设备内核'**
  String get kernelProfileDeviceKernel;

  /// 进入内核表参数编辑器的按钮
  ///
  /// In zh, this message translates to:
  /// **'编辑参数'**
  String get kernelProfileEditParams;

  /// 内核表向导里的已导入文档分组标题
  ///
  /// In zh, this message translates to:
  /// **'我的配置'**
  String get kernelProfileMyProfilesTitle;

  /// 随应用打包的内置内核表分区标题
  ///
  /// In zh, this message translates to:
  /// **'内置表'**
  String get kernelProfileBuiltinTitle;

  /// 内置表分区说明
  ///
  /// In zh, this message translates to:
  /// **'随应用打包，只读'**
  String get kernelProfileBuiltinHint;

  /// 参考模板分区的说明
  ///
  /// In zh, this message translates to:
  /// **'空白骨架，只用于查看字段结构，不能直接生效'**
  String get kernelProfileTemplateHint;

  /// 内置表里与设备内核同名的那一行副标题
  ///
  /// In zh, this message translates to:
  /// **'与本机内核一致'**
  String get kernelProfileMatchesDevice;

  /// 内置表分批展开的按钮
  ///
  /// In zh, this message translates to:
  /// **'显示更多（还剩 {count} 项）'**
  String kernelProfileShowMore(int count);

  /// 向导第一步名称
  ///
  /// In zh, this message translates to:
  /// **'选择内核表'**
  String get kernelProfileStepPick;

  /// 向导第二步名称
  ///
  /// In zh, this message translates to:
  /// **'确认来源'**
  String get kernelProfileStepReview;

  /// 向导第三步名称
  ///
  /// In zh, this message translates to:
  /// **'应用生效'**
  String get kernelProfileStepApply;

  /// 向导的下一步按钮
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get kernelProfileStepNext;

  /// 向导的上一步按钮
  ///
  /// In zh, this message translates to:
  /// **'上一步'**
  String get kernelProfileStepBack;

  /// 向导最后一步的确认按钮
  ///
  /// In zh, this message translates to:
  /// **'应用生效'**
  String get kernelProfileApplyAction;

  /// 应用成功后的标题与提示
  ///
  /// In zh, this message translates to:
  /// **'已切换生效内核表'**
  String get kernelProfileApplied;

  /// 应用后原生解析为空时的提示
  ///
  /// In zh, this message translates to:
  /// **'所选内核表与设备内核不一致，本次不会生效'**
  String get kernelProfileApplyNotEffective;

  /// 编辑会话解析为空时的正文
  ///
  /// In zh, this message translates to:
  /// **'这个内核没有可编辑的 profile'**
  String get kernelProfileEditorNotEditable;

  /// 应用完成后回到第一步
  ///
  /// In zh, this message translates to:
  /// **'再选一份'**
  String get kernelProfilePickAgain;

  /// 应用完成后进入参数编辑器
  ///
  /// In zh, this message translates to:
  /// **'去调参数'**
  String get kernelProfileEditAfterApply;

  /// 确认页里说明为什么不能马上编辑参数
  ///
  /// In zh, this message translates to:
  /// **'参数只能在生效后编辑：先完成这一步，再进编辑器改值。'**
  String get kernelProfileEditAfterApplyHint;

  /// 第一步的说明
  ///
  /// In zh, this message translates to:
  /// **'选一份要生效的内核表；标「生效中」的是当前正在用的那份。'**
  String get kernelProfilePickHint;

  /// GhostKey 我的配置页的选择说明
  ///
  /// In zh, this message translates to:
  /// **'点左侧圆点切换生效的内核表；未指定时取最近导入的同 release 文档。'**
  String get kernelProfileKeySelectHint;

  /// 第二步的说明
  ///
  /// In zh, this message translates to:
  /// **'确认下面的来源。应用后编辑器改的就是这一份。'**
  String get kernelProfileReviewHint;

  /// 确认页里被选配置自己声明的 release
  ///
  /// In zh, this message translates to:
  /// **'配置声明的内核'**
  String get kernelProfileDeclaredKernel;

  /// 配置声明的内核与设备一致
  ///
  /// In zh, this message translates to:
  /// **'与设备内核一致，可以运行'**
  String get kernelProfileReviewMatch;

  /// 配置声明的内核与设备不一致
  ///
  /// In zh, this message translates to:
  /// **'与设备内核不一致，运行会被拒绝'**
  String get kernelProfileReviewMismatch;

  /// GhostKey 内核表的页签标题
  ///
  /// In zh, this message translates to:
  /// **'GhostKey 内核表'**
  String get kernelProfileGhostKeyEntry;

  /// GhostLock 内核表的页签标题
  ///
  /// In zh, this message translates to:
  /// **'GhostLock 内核表'**
  String get kernelProfileGhostLockEntry;

  /// 打开导入弹层的按钮与标题
  ///
  /// In zh, this message translates to:
  /// **'导入内核表'**
  String get kernelProfileImportEntry;

  /// 打开镜像导出弹层的按钮与标题
  ///
  /// In zh, this message translates to:
  /// **'导出镜像'**
  String get kernelImageExport;

  /// 导出入口上的数量；count 是镜像个数
  ///
  /// In zh, this message translates to:
  /// **'导出镜像（{count}）'**
  String kernelImageExportCount(int count);

  /// 镜像导出弹层的说明
  ///
  /// In zh, this message translates to:
  /// **'把解析时解出的镜像保存到手机「下载」目录，便于重复使用或备份。'**
  String get kernelImageExportHint;

  /// 没有任何可导出镜像时的提示
  ///
  /// In zh, this message translates to:
  /// **'没有可导出的镜像'**
  String get kernelImageExportEmpty;

  /// 镜像导出成功提示；name 是文件名
  ///
  /// In zh, this message translates to:
  /// **'已保存 {name}'**
  String kernelImageExportSaved(String name);

  /// 镜像导出失败提示
  ///
  /// In zh, this message translates to:
  /// **'导出失败'**
  String get kernelImageExportFailed;

  /// 删除 profile 的按钮与提示
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get kernelProfileRemove;

  /// 删除 profile 的确认弹窗标题
  ///
  /// In zh, this message translates to:
  /// **'删除这份 profile？'**
  String get kernelProfileRemoveConfirmTitle;

  /// 删除 profile 的确认弹窗正文；release 不翻译
  ///
  /// In zh, this message translates to:
  /// **'{release} 将被删除。本机若没有其它匹配的 profile，需要重新导入。'**
  String kernelProfileRemoveConfirmBody(String release);

  /// 导入错误：路径为空
  ///
  /// In zh, this message translates to:
  /// **'没有拿到文件路径'**
  String get kernelProfileErrorEmptyPath;

  /// 导入错误：文件不存在
  ///
  /// In zh, this message translates to:
  /// **'文件不存在或不可读'**
  String get kernelProfileErrorNotFound;

  /// 导入错误：文件超过上限
  ///
  /// In zh, this message translates to:
  /// **'文件过大，无法解析'**
  String get kernelProfileErrorTooLarge;

  /// 导入错误：魔数不符
  ///
  /// In zh, this message translates to:
  /// **'这不是一个 boot.img'**
  String get kernelProfileErrorNotBootImage;

  /// 导入错误：内核解码失败
  ///
  /// In zh, this message translates to:
  /// **'解压内核失败'**
  String get kernelProfileErrorDecode;

  /// 导入错误：必填字段缺失
  ///
  /// In zh, this message translates to:
  /// **'解析结果不完整，未保存'**
  String get kernelProfileErrorIncomplete;

  /// 导入错误：文件读写失败
  ///
  /// In zh, this message translates to:
  /// **'读写文件失败'**
  String get kernelProfileErrorIo;

  /// 导入错误：内核镜像里没有 BTF 段，通常是 ROM 编译时未开启 CONFIG_DEBUG_INFO_BTF
  ///
  /// In zh, this message translates to:
  /// **'这个 ROM 的内核不含 BTF 调试信息，无法推导结构偏移'**
  String get kernelProfileErrorNoBtf;

  /// 导入错误：OTA 链接不是 HTTP/HTTPS
  ///
  /// In zh, this message translates to:
  /// **'链接无效，需要 HTTP 或 HTTPS 地址'**
  String get kernelProfileErrorBadUrl;

  /// 导入错误：远端下载或 payload 解包失败
  ///
  /// In zh, this message translates to:
  /// **'下载或解包 OTA 失败'**
  String get kernelProfileErrorDownload;

  /// 导入错误追加的原始错误详情；detail 是原生侧异常类名与消息，不翻译
  ///
  /// In zh, this message translates to:
  /// **'详情：{detail}'**
  String kernelProfileErrorDetail(String detail);

  /// 导入错误：内存不足
  ///
  /// In zh, this message translates to:
  /// **'内存不足，解析中断'**
  String get kernelProfileErrorOom;

  /// 导入错误：未归类的异常
  ///
  /// In zh, this message translates to:
  /// **'未知错误'**
  String get kernelProfileErrorUnknown;

  /// 运行记录结果标签：进行中
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get ghostKeyRunResultRunning;

  /// 运行记录结果标签：成功
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get ghostKeyRunResultSuccess;

  /// 运行记录结果标签：失败
  ///
  /// In zh, this message translates to:
  /// **'失败'**
  String get ghostKeyRunResultFailed;

  /// 运行记录结果标签：已停止
  ///
  /// In zh, this message translates to:
  /// **'已停止'**
  String get ghostKeyRunResultStopped;

  /// 运行记录结果标签：中断
  ///
  /// In zh, this message translates to:
  /// **'中断'**
  String get ghostKeyRunResultInterrupted;

  /// 时长格式：秒；seconds 是整数
  ///
  /// In zh, this message translates to:
  /// **'{seconds}秒'**
  String ghostKeyDurationSeconds(int seconds);

  /// 时长格式：分秒；minutes 与 seconds 都是整数
  ///
  /// In zh, this message translates to:
  /// **'{minutes}分{seconds}秒'**
  String ghostKeyDurationMinutesSeconds(int minutes, int seconds);

  /// 运行记录页面与设置入口的标题
  ///
  /// In zh, this message translates to:
  /// **'运行记录'**
  String get ghostKeyRunLogTitle;

  /// 设置页运行记录入口的副标题
  ///
  /// In zh, this message translates to:
  /// **'查看历史运行明细与失败诊断'**
  String get ghostKeyRunLogEntrySubtitle;

  /// 运行记录列表首行的条数；count 是整数
  ///
  /// In zh, this message translates to:
  /// **'共 {count} 次 · 最新在最上'**
  String ghostKeyRunLogCount(int count);

  /// 运行记录列表的空态
  ///
  /// In zh, this message translates to:
  /// **'暂无运行记录'**
  String get ghostKeyRunLogEmpty;

  /// 导出全部运行记录
  ///
  /// In zh, this message translates to:
  /// **'导出全部'**
  String get ghostKeyRunLogExportAll;

  /// 导出全部时的默认文件名
  ///
  /// In zh, this message translates to:
  /// **'run-logs-all.log'**
  String get ghostKeyRunLogExportAllFileName;

  /// 清空全部运行记录
  ///
  /// In zh, this message translates to:
  /// **'清空全部记录'**
  String get ghostKeyRunLogClearAll;

  /// 清空后的轻提示
  ///
  /// In zh, this message translates to:
  /// **'运行记录已清空'**
  String get ghostKeyRunLogCleared;

  /// 详情页标题；runId 是整数
  ///
  /// In zh, this message translates to:
  /// **'运行 #{runId}'**
  String ghostKeyRunLogDetailTitle(int runId);

  /// 复制日志正文
  ///
  /// In zh, this message translates to:
  /// **'复制'**
  String get ghostKeyRunLogCopy;

  /// 复制成功的轻提示
  ///
  /// In zh, this message translates to:
  /// **'已复制到剪贴板'**
  String get ghostKeyRunLogCopied;

  /// 另存为按钮与对话框标题
  ///
  /// In zh, this message translates to:
  /// **'另存为'**
  String get ghostKeyRunLogSaveAs;

  /// 另存为成功的轻提示
  ///
  /// In zh, this message translates to:
  /// **'已保存'**
  String get ghostKeyRunLogSaved;

  /// 删除单条运行记录
  ///
  /// In zh, this message translates to:
  /// **'删除这一次记录'**
  String get ghostKeyRunLogDeleteThis;

  /// 失败诊断块：标题行前缀
  ///
  /// In zh, this message translates to:
  /// **'诊断: {title}'**
  String ghostKeyRunLogDiagTitlePrefix(String title);

  /// 失败诊断块：可能原因行前缀
  ///
  /// In zh, this message translates to:
  /// **'可能原因: {cause}'**
  String ghostKeyRunLogDiagCausePrefix(String cause);

  /// 失败诊断块：建议行前缀
  ///
  /// In zh, this message translates to:
  /// **'建议: {suggestion}'**
  String ghostKeyRunLogDiagSuggestionPrefix(String suggestion);

  /// 失败归因规则 CalibANoSlideCandidate 的标题
  ///
  /// In zh, this message translates to:
  /// **'KASLR 偏移解算失败：候选地址里找不到可信的内核基址'**
  String get ghostKeyDiagCalibANoSlideCandidateTitle;

  /// 失败归因规则 CalibANoSlideCandidate 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'内核刚完成 OTA / 刚重启，运行时布局与 profile 假设不符'**
  String get ghostKeyDiagCalibANoSlideCandidateCause1;

  /// 失败归因规则 CalibANoSlideCandidate 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'导入的 profile 与当前内核版本不匹配（boot.img 版本对不上）'**
  String get ghostKeyDiagCalibANoSlideCandidateCause2;

  /// 失败归因规则 CalibANoSlideCandidate 的原因 3
  ///
  /// In zh, this message translates to:
  /// **'设备后台负载异常，k_itimer 采样被污染'**
  String get ghostKeyDiagCalibANoSlideCandidateCause3;

  /// 失败归因规则 CalibANoSlideCandidate 的原因 4
  ///
  /// In zh, this message translates to:
  /// **'tracefs 采样窗口未抓到任何 k_itimer 记录（SELinux 拦截 / Shizuku 权限不足 / 后台负载过低）'**
  String get ghostKeyDiagCalibANoSlideCandidateCause4;

  /// 失败归因规则 CalibANoSlideCandidate 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后重试一次'**
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion1;

  /// 失败归因规则 CalibANoSlideCandidate 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'确认 profile 对应当前内核版本（设备信息条上的内核版本）'**
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion2;

  /// 失败归因规则 CalibANoSlideCandidate 的建议 3
  ///
  /// In zh, this message translates to:
  /// **'若连续失败，请保存运行日志以便排查'**
  String get ghostKeyDiagCalibANoSlideCandidateSuggestion3;

  /// 失败归因规则 CalibANoKitimerRecords 的标题
  ///
  /// In zh, this message translates to:
  /// **'KASLR 偏移解算失败：多尺寸探针没采到任何 k_itimer 分配记录'**
  String get ghostKeyDiagCalibANoKitimerRecordsTitle;

  /// 失败归因规则 CalibANoKitimerRecords 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'tracefs 的 kmem_cache_alloc 事件没被打开（被 SELinux 拦截，或 Shizuku 授权 / 挂载异常）'**
  String get ghostKeyDiagCalibANoKitimerRecordsCause1;

  /// 失败归因规则 CalibANoKitimerRecords 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'本机 k_itimer 结构体尺寸不在候选集 0x108 / 0x100 / 0x110 / 0x118 内，所有尺寸都没匹配到记录'**
  String get ghostKeyDiagCalibANoKitimerRecordsCause2;

  /// 失败归因规则 CalibANoKitimerRecords 的原因 3
  ///
  /// In zh, this message translates to:
  /// **'采样窗口内系统负载过低，定时器调用点未被充分触发'**
  String get ghostKeyDiagCalibANoKitimerRecordsCause3;

  /// 失败归因规则 CalibANoKitimerRecords 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'确认 Shizuku 已授权且 tracefs 可写（设置 → 开发者选项）'**
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion1;

  /// 失败归因规则 CalibANoKitimerRecords 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'重启设备后重试，让采样在单次开机内完成'**
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion2;

  /// 失败归因规则 CalibANoKitimerRecords 的建议 3
  ///
  /// In zh, this message translates to:
  /// **'仍失败请保存运行日志（含 [calib_a] 与 arm_kmem_cache_alloc 行）以便排查'**
  String get ghostKeyDiagCalibANoKitimerRecordsSuggestion3;

  /// 失败归因规则 CalibATracefsUnusable 的标题
  ///
  /// In zh, this message translates to:
  /// **'tracefs 不可用：内核追踪事件挂载/读取失败'**
  String get ghostKeyDiagCalibATracefsUnusableTitle;

  /// 失败归因规则 CalibATracefsUnusable 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'SELinux 策略拦截了 tracefs 写入'**
  String get ghostKeyDiagCalibATracefsUnusableCause1;

  /// 失败归因规则 CalibATracefsUnusable 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'Shizuku 授权异常（未启动或权限被回收）'**
  String get ghostKeyDiagCalibATracefsUnusableCause2;

  /// 失败归因规则 CalibATracefsUnusable 的原因 3
  ///
  /// In zh, this message translates to:
  /// **'部分 ROM 精简了 tracefs 节点'**
  String get ghostKeyDiagCalibATracefsUnusableCause3;

  /// 失败归因规则 CalibATracefsUnusable 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'确认 Shizuku 正在运行且已给本应用授权'**
  String get ghostKeyDiagCalibATracefsUnusableSuggestion1;

  /// 失败归因规则 CalibATracefsUnusable 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'检查开发者选项中 USB 调试（无线调试）是否可用'**
  String get ghostKeyDiagCalibATracefsUnusableSuggestion2;

  /// 失败归因规则 CalibATracefsUnusable 的建议 3
  ///
  /// In zh, this message translates to:
  /// **'重启 Shizuku 后重试；仍失败请保存日志排查'**
  String get ghostKeyDiagCalibATracefsUnusableSuggestion3;

  /// 失败归因规则 CalibBNoMatchingRecords 的标题
  ///
  /// In zh, this message translates to:
  /// **'页偏移解算失败：校准 A 得出的基址与实际不符'**
  String get ghostKeyDiagCalibBNoMatchingRecordsTitle;

  /// 失败归因规则 CalibBNoMatchingRecords 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'校准 A 的 KASLR slide 不准（上游错误，先解决校准 A）'**
  String get ghostKeyDiagCalibBNoMatchingRecordsCause1;

  /// 失败归因规则 CalibBNoMatchingRecords 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'两次校准之间内核内存布局发生变化'**
  String get ghostKeyDiagCalibBNoMatchingRecordsCause2;

  /// 失败归因规则 CalibBNoMatchingRecords 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备让两次校准在同一次开机状态内完成'**
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion1;

  /// 失败归因规则 CalibBNoMatchingRecords 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'重跑完整流水线（不要单独跳过校准步骤）'**
  String get ghostKeyDiagCalibBNoMatchingRecordsSuggestion2;

  /// 失败归因规则 CalibBInsufficientSamples 的标题
  ///
  /// In zh, this message translates to:
  /// **'采样不足：触发样本太少，无法解算页偏移'**
  String get ghostKeyDiagCalibBInsufficientSamplesTitle;

  /// 失败归因规则 CalibBInsufficientSamples 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'系统后台负载过低，定时器调用点未被充分触发'**
  String get ghostKeyDiagCalibBInsufficientSamplesCause1;

  /// 失败归因规则 CalibBInsufficientSamples 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'设备刚冷启动，运行时服务还没起来'**
  String get ghostKeyDiagCalibBInsufficientSamplesCause2;

  /// 失败归因规则 CalibBInsufficientSamples 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'让设备处于轻度使用状态（如播放音乐）后再重试'**
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion1;

  /// 失败归因规则 CalibBInsufficientSamples 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'直接多跑一次，样本量通常第二次更充分'**
  String get ghostKeyDiagCalibBInsufficientSamplesSuggestion2;

  /// 失败归因规则 InjectResidualProcess 的标题
  ///
  /// In zh, this message translates to:
  /// **'存在上一轮残留进程：残留进程还钉着已释放的页，继续注入会导致内核崩溃'**
  String get ghostKeyDiagInjectResidualProcessTitle;

  /// 失败归因规则 InjectResidualProcess 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'上一轮提权未走完清理步骤（中途强退 / 断电）'**
  String get ghostKeyDiagInjectResidualProcessCause1;

  /// 失败归因规则 InjectResidualProcess 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'必须重启设备后再试（杀掉残留进程不解决问题）'**
  String get ghostKeyDiagInjectResidualProcessSuggestion1;

  /// 失败归因规则 InjectRootdNotReady 的标题
  ///
  /// In zh, this message translates to:
  /// **'漏洞已触发但 root 通道未建立：rootd 超时未就绪'**
  String get ghostKeyDiagInjectRootdNotReadyTitle;

  /// 失败归因规则 InjectRootdNotReady 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'设备内核对该漏洞打了部分回移植补丁，UAF 窗口不稳定'**
  String get ghostKeyDiagInjectRootdNotReadyCause1;

  /// 失败归因规则 InjectRootdNotReady 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'系统负载导致竞态时序偏差'**
  String get ghostKeyDiagInjectRootdNotReadyCause2;

  /// 失败归因规则 InjectRootdNotReady 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后再试 1~2 次'**
  String get ghostKeyDiagInjectRootdNotReadySuggestion1;

  /// 失败归因规则 InjectRootdNotReady 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'若每次都在同一位置超时，内核可能已修复，请记录机型与内核版本以便反馈'**
  String get ghostKeyDiagInjectRootdNotReadySuggestion2;

  /// 失败归因规则 InjectOffsetTableMissing 的标题
  ///
  /// In zh, this message translates to:
  /// **'内核偏移表未加载：注入缺少 profile 数据'**
  String get ghostKeyDiagInjectOffsetTableMissingTitle;

  /// 失败归因规则 InjectOffsetTableMissing 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'未导入 / 导入了损坏的 profile 文件'**
  String get ghostKeyDiagInjectOffsetTableMissingCause1;

  /// 失败归因规则 InjectOffsetTableMissing 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'profile 与当前内核不匹配被引擎拒绝'**
  String get ghostKeyDiagInjectOffsetTableMissingCause2;

  /// 失败归因规则 InjectOffsetTableMissing 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重新导入对应内核版本的 profile（boot.img 提取）'**
  String get ghostKeyDiagInjectOffsetTableMissingSuggestion1;

  /// 失败归因规则 InjectTaskLeakFailed 的标题
  ///
  /// In zh, this message translates to:
  /// **'task_struct 地址泄漏失败：扫描窗口内没有匹配到 task_struct 的 slab 分配记录'**
  String get ghostKeyDiagInjectTaskLeakFailedTitle;

  /// 失败归因规则 InjectTaskLeakFailed 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'task_struct 缓存尺寸与 BTF 的 sizeof(task_struct) 不一致：缓存由 kmem_cache_create_usercopy(\"task_struct\", arch_task_struct_size, 0x40, ...) 创建，arch_task_struct_size 是运行时变量，厂商可用 android_arch_task_struct_size= 在其上追加（最多 0x400）'**
  String get ghostKeyDiagInjectTaskLeakFailedCause1;

  /// 失败归因规则 InjectTaskLeakFailed 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'kmem_cache_alloc 事件未被打开（tracefs 不可写 / SELinux 拒绝）'**
  String get ghostKeyDiagInjectTaskLeakFailedCause2;

  /// 失败归因规则 InjectTaskLeakFailed 的原因 3
  ///
  /// In zh, this message translates to:
  /// **'fork 落在未被读取的 CPU 上（按实际核数扫描，理论上不会）'**
  String get ghostKeyDiagInjectTaskLeakFailedCause3;

  /// 失败归因规则 InjectTaskLeakFailed 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后再试一次'**
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion1;

  /// 失败归因规则 InjectTaskLeakFailed 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'日志里 [task] raw=0 说明是事件没开；raw>0 但 hits=0 则是尺寸窗口不对，请把 [task] sizes= 那行保存下来以便排查'**
  String get ghostKeyDiagInjectTaskLeakFailedSuggestion2;

  /// 失败归因规则 VerifyFailed 的标题
  ///
  /// In zh, this message translates to:
  /// **'临时 root 验证失败：提权通道建立后 su 校验未通过'**
  String get ghostKeyDiagVerifyFailedTitle;

  /// 失败归因规则 VerifyFailed 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'注入阶段的凭据改写不完整（上游竞态部分成功）'**
  String get ghostKeyDiagVerifyFailedCause1;

  /// 失败归因规则 VerifyFailed 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'验证子进程被 SELinux 或系统策略拦截'**
  String get ghostKeyDiagVerifyFailedCause2;

  /// 失败归因规则 VerifyFailed 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后重试完整流水线'**
  String get ghostKeyDiagVerifyFailedSuggestion1;

  /// 失败归因规则 VerifyFailed 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'检查 SELinux 状态（设置 → 开发者选项），不强制改 Permissive'**
  String get ghostKeyDiagVerifyFailedSuggestion2;

  /// 失败归因规则 KsuAlreadyLive 的标题
  ///
  /// In zh, this message translates to:
  /// **'KernelSU 模块已驻留：旧模块仍在内存，late-load 被跳过'**
  String get ghostKeyDiagKsuAlreadyLiveTitle;

  /// 失败归因规则 KsuAlreadyLive 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'上一次提权注入的 kernelsu 模块还活着'**
  String get ghostKeyDiagKsuAlreadyLiveCause1;

  /// 失败归因规则 KsuAlreadyLive 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后再跑一次，管理器才能看到新接管'**
  String get ghostKeyDiagKsuAlreadyLiveSuggestion1;

  /// 失败归因规则 KsuAlreadyLive 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'若只是想用 root，无需重跑——当前已是临时 root 状态'**
  String get ghostKeyDiagKsuAlreadyLiveSuggestion2;

  /// 失败归因规则 KsuModuleAbsent 的标题
  ///
  /// In zh, this message translates to:
  /// **'KSU late-load 失败：模块没有出现在 /proc/modules'**
  String get ghostKeyDiagKsuModuleAbsentTitle;

  /// 失败归因规则 KsuModuleAbsent 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'设备上的 KernelSU 管理器 / ksud 版本过旧，KMI 不匹配'**
  String get ghostKeyDiagKsuModuleAbsentCause1;

  /// 失败归因规则 KsuModuleAbsent 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'模块加载路径被内核限制'**
  String get ghostKeyDiagKsuModuleAbsentCause2;

  /// 失败归因规则 KsuModuleAbsent 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'更新设备上的 KernelSU 管理器到最新版'**
  String get ghostKeyDiagKsuModuleAbsentSuggestion1;

  /// 失败归因规则 KsuModuleAbsent 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'重试一次；连续失败请保存日志并注明管理器版本'**
  String get ghostKeyDiagKsuModuleAbsentSuggestion2;

  /// 失败归因规则 KsuKsudMissing 的标题
  ///
  /// In zh, this message translates to:
  /// **'找不到 ksud：设备上未安装 KernelSU 管理器且内置兜底失效'**
  String get ghostKeyDiagKsuKsudMissingTitle;

  /// 失败归因规则 KsuKsudMissing 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'KernelSU 管理器未安装'**
  String get ghostKeyDiagKsuKsudMissingCause1;

  /// 失败归因规则 KsuKsudMissing 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'内置兜底 ksud 与当前架构 / KMI 不兼容'**
  String get ghostKeyDiagKsuKsudMissingCause2;

  /// 失败归因规则 KsuKsudMissing 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'先安装 KernelSU 官方管理器，再重跑流水线'**
  String get ghostKeyDiagKsuKsudMissingSuggestion1;

  /// 失败归因规则 HostShizukuUnavailable 的标题
  ///
  /// In zh, this message translates to:
  /// **'Shizuku 环境异常：宿主进程无法启动提权流水线'**
  String get ghostKeyDiagHostShizukuUnavailableTitle;

  /// 失败归因规则 HostShizukuUnavailable 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'Shizuku 服务未启动（未开无线调试或 adb 未连接）'**
  String get ghostKeyDiagHostShizukuUnavailableCause1;

  /// 失败归因规则 HostShizukuUnavailable 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'用户拒绝了本应用的 Shizuku 授权'**
  String get ghostKeyDiagHostShizukuUnavailableCause2;

  /// 失败归因规则 HostShizukuUnavailable 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'打开 Shizuku 应用并确保服务运行（无线调试 / adb 两种方式均可）'**
  String get ghostKeyDiagHostShizukuUnavailableSuggestion1;

  /// 失败归因规则 HostShizukuUnavailable 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'在本应用内重新发起授权并允许'**
  String get ghostKeyDiagHostShizukuUnavailableSuggestion2;

  /// 失败归因规则 FallbackExit2 的标题
  ///
  /// In zh, this message translates to:
  /// **'流水线终止（exit=2）：KASLR 偏移解算失败，且未命中任何已知细分模式'**
  String get ghostKeyDiagFallbackExit2Title;

  /// 失败归因规则 FallbackExit2 的原因 1
  ///
  /// In zh, this message translates to:
  /// **'校准 A 未能从 k_itimer 采样解出可信内核基址（最常见的失败点）'**
  String get ghostKeyDiagFallbackExit2Cause1;

  /// 失败归因规则 FallbackExit2 的原因 2
  ///
  /// In zh, this message translates to:
  /// **'当前内核布局与所选 profile 不符（刚 OTA/重启、或 profile 版本对不上，导致 timer_link/cred_link 偏移错误）'**
  String get ghostKeyDiagFallbackExit2Cause2;

  /// 失败归因规则 FallbackExit2 的原因 3
  ///
  /// In zh, this message translates to:
  /// **'tracefs 采样被环境异常打断（SELinux 拦截 / Shizuku 授权失效 / 系统负载异常）'**
  String get ghostKeyDiagFallbackExit2Cause3;

  /// 失败归因规则 FallbackExit2 的原因 4
  ///
  /// In zh, this message translates to:
  /// **'或本次失败属于尚未被归因器覆盖的新变体（退出码为 2 但日志串未被规则捕获）'**
  String get ghostKeyDiagFallbackExit2Cause4;

  /// 失败归因规则 FallbackExit2 的建议 1
  ///
  /// In zh, this message translates to:
  /// **'重启设备后重试一次——KASLR 每次开机都不同，重跑通常可解'**
  String get ghostKeyDiagFallbackExit2Suggestion1;

  /// 失败归因规则 FallbackExit2 的建议 2
  ///
  /// In zh, this message translates to:
  /// **'确认运行的是最新构建（1.1.5），且 profile 由本机 boot.img 提取、release 精确匹配当前内核'**
  String get ghostKeyDiagFallbackExit2Suggestion2;

  /// 失败归因规则 FallbackExit2 的建议 3
  ///
  /// In zh, this message translates to:
  /// **'不要只靠重试：请把「运行日志」页完整内容（尤其含 [calib_a] / [calib_b] 的行）保存下来，便于定位内核适配问题'**
  String get ghostKeyDiagFallbackExit2Suggestion3;

  /// 失败归因兜底规则的标题；exit 是整数退出码
  ///
  /// In zh, this message translates to:
  /// **'流水线终止（exit={exit}）：未命中已知失败模式'**
  String ghostKeyDiagFallbackGenericTitle(int exit);

  /// 失败归因兜底规则的原因 1
  ///
  /// In zh, this message translates to:
  /// **'时序敏感的竞态窗口未命中，或环境临时异常'**
  String get ghostKeyDiagFallbackGenericCause1;

  /// 失败归因兜底规则的建议 1
  ///
  /// In zh, this message translates to:
  /// **'不要只靠重试：请把「运行日志」页完整内容复制保存，便于定位内核适配问题'**
  String get ghostKeyDiagFallbackGenericSuggestion1;

  /// 失败归因兜底规则的建议 2
  ///
  /// In zh, this message translates to:
  /// **'连续失败请重启设备后再试；仍失败请保存运行日志以便排查'**
  String get ghostKeyDiagFallbackGenericSuggestion2;

  /// 设置页分组标题-关注作者
  ///
  /// In zh, this message translates to:
  /// **'关注作者'**
  String get settingsFollowAuthorSection;

  /// 设置页关注作者分组-作者各大平台入口
  ///
  /// In zh, this message translates to:
  /// **'作者平台'**
  String get settingsCreatorPlatformsTitle;

  /// 设置页关注作者分组-使用教程入口
  ///
  /// In zh, this message translates to:
  /// **'使用教程'**
  String get settingsTutorialTitle;

  /// 设置页关注作者分组-使用教程副标题
  ///
  /// In zh, this message translates to:
  /// **'在作者各平台查看教程视频'**
  String get settingsTutorialSubtitle;

  /// 设置页关注作者分组-交流群入口
  ///
  /// In zh, this message translates to:
  /// **'交流群'**
  String get settingsCommunityGroupTitle;

  /// 设置页关注作者分组-交流群副标题
  ///
  /// In zh, this message translates to:
  /// **'加入交流群获取帮助'**
  String get settingsCommunityGroupSubtitle;

  /// 作者平台弹窗的说明文字
  ///
  /// In zh, this message translates to:
  /// **'选择一个平台，继续关注作者的最新内容与动态。'**
  String get settingsCreatorPlatformsIntro;

  /// 设置页关注作者分组-微信公众号入口
  ///
  /// In zh, this message translates to:
  /// **'微信公众号'**
  String get settingsWechatTitle;

  /// 设置页通用分组-功能许愿入口
  ///
  /// In zh, this message translates to:
  /// **'功能许愿'**
  String get settingsFeatureWishTitle;

  /// 设置页通用分组-功能许愿副标题
  ///
  /// In zh, this message translates to:
  /// **'打赏支持作者，许愿新功能'**
  String get settingsFeatureWishSubtitle;

  /// 功能许愿弹窗说明
  ///
  /// In zh, this message translates to:
  /// **'扫码打赏支持作者，再到 GitHub 提交你的功能想法。'**
  String get featureWishDialogDesc;

  /// 功能许愿弹窗-跳转 GitHub Issue 按钮
  ///
  /// In zh, this message translates to:
  /// **'提交功能 Issue'**
  String get featureWishIssueButton;

  /// 功能许愿弹窗-网络环境提示
  ///
  /// In zh, this message translates to:
  /// **'请使用合理的网络环境打开'**
  String get featureWishNetworkTip;

  /// 作者平台名称-Facebook
  ///
  /// In zh, this message translates to:
  /// **'Facebook'**
  String get platformFacebook;

  /// 作者平台名称-TikTok
  ///
  /// In zh, this message translates to:
  /// **'TikTok'**
  String get platformTiktok;

  /// 作者平台名称-抖音
  ///
  /// In zh, this message translates to:
  /// **'抖音'**
  String get platformDouyin;

  /// 作者平台名称-哔哩哔哩
  ///
  /// In zh, this message translates to:
  /// **'哔哩哔哩'**
  String get platformBilibili;

  /// 作者平台名称-YouTube
  ///
  /// In zh, this message translates to:
  /// **'YouTube'**
  String get platformYoutube;
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

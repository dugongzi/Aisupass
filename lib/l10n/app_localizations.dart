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

  /// AI 配置页标题
  ///
  /// In zh, this message translates to:
  /// **'AI 设置'**
  String get aiSettingTitle;

  /// AI 对话页标题
  ///
  /// In zh, this message translates to:
  /// **'对话'**
  String get chatTitle;

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

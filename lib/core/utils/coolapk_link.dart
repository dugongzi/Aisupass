import 'package:url_launcher/url_launcher.dart';

/// 酷安动态地址与跳转。
class CoolapkLink {
  CoolapkLink._();

  /// 网页地址，未安装酷安时使用。
  static String web(String feedId) => 'https://www.coolapk.com/feed/$feedId';

  /// App 深链，已安装酷安时直接打开 App 内的帖子。
  static String app(String feedId) => 'coolmarket://feed/$feedId';

  /// 优先跳酷安 App，未安装或打开失败时退回网页。
  ///
  /// 返回是否成功唤起外部应用。
  static Future<bool> openFeed(String feedId) async {
    final String id = feedId.trim();
    if (id.isEmpty) return false;

    final Uri? appUri = Uri.tryParse(app(id));
    if (appUri != null && await _launch(appUri)) return true;

    final Uri? webUri = Uri.tryParse(web(id));
    if (webUri != null && await _launch(webUri)) return true;
    return false;
  }

  /// 打开任意下载地址；返回是否成功。
  static Future<bool> openUrl(String url) async {
    final Uri? uri = Uri.tryParse(url.trim());
    if (uri == null) return false;
    return _launch(uri);
  }

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Object {
      // 未安装对应 App 时平台会抛异常，交给调用方回退。
      return false;
    }
  }
}

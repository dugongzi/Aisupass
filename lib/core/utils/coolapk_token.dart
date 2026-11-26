import 'dart:convert';
import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:crypto/crypto.dart';

// 酷安 Token V3 离线签名。密码表取自酷安 16.6.5 客户端，与 X-App-Code
// (2610162) 绑定：换版本编码必须同步换表。表按字节偏移切片，不可换行。

const String _appId = 'com.coolapk.market';
const int _appCode = 2610162;
const String _appVersion = '16.6.5';
const String _appChannel = 'coolapk';
const String _deviceModel = '23113RKC6C';
const String _deviceBuild = 'AQ3A.250226.002';

/// 与机型、版本配套的 UA；任一段不一致会让部分接口直接 404。
const String _userAgent =
    'Dalvik/2.1.0 (Linux; U; Android 16; $_deviceModel '
    'Build/$_deviceBuild) (#Build; Redmi; $_deviceModel; '
    '$_deviceBuild; 16) '
    '+CoolMarket/$_appVersion-$_appCode-universal';

/// 游客设备码里的 android_id。用固定值：设备指纹频繁变化会被风控判为异常，
/// 只读接口也不校验它的真实性。
const String _guestAndroidId = 'a1b2c3d4e5f60718';

const String _standardAlphabet =
    'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
const String _bcryptAlphabet =
    './ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

/// 官方密码表（整体 base64 后的二进制切片表）。
const String _authBlobBase64 =
    'VFRCVU9GUXNRMEVsTFVNa1dERWpRU0VzVXlFbUxETkFVeTFEUEZZdUl5MGlNVU01SXpCVUpGY3RNeWtoTVVRMUpTMURPU1V4TXpoUUxWTXdWMDBzSXloU01UUXNXVEZEUkZFd1EwUlZNU1FrVVMwaktTTXRKRGhZTFZRa1VqRXpLU1FzTTBCVkxUUXdVaTAwTlNNc00yQlhMVk1sSkMxRE5GbE5MQ1EwV1RFekxTUXhRMEVoTEVNbElqRXpLRmN3TXowbExpTkVWekVqUFNZdU5Ea2tMRk13Vml4VEtGa3RRemhYTEZNc1dDNGpMU1l0VTJCVFRUQTBMRkV1TXpoVExqTWhJakZETUZNc0kwQlZMQ1FrVUN3ekpTSXNJekJTTUVNOFVDeEVMU0l0STJCUUxVUW9VeTBqTEZNc0l5VWtNRlF3VmswdFJDeFlNVE1sSkM0ME5TRXdVMFJRTEZNaElpMGtOU013VTJCUUxqTmdVeXdqT0ZFc05DeFRMRU13V0N4VUxTRXRJeVJUTEROQkl5MDBKRlpOTVVNc1VEQkVKRmd0TkMwa0xEUWtXQzFETUZNeFJDa2pMVk0wVml4VE1GZ3hJeTBtTFZNeEpTMHpKRlF4TTJCUUxTUTRXVEJETUZNdUkwVWhUU3d6UEZndFJEQlJNRE5FVVMwak9GWXVKRGtsTVNRMFV6QXpOU013UkRra01UTWtWU3hVTUZRdFJDeFlNVE5GSXl4RUxGWXNJelVoTGlRMFYwMHhOQ3hWTENNMFZ5NHpKRlV4TkN4VExGUTRWeTRqWUZZeEpEVWpMVU13VXpGRFBGSXNNMEVsTERNc1ZEQTBPU011TkNrbUxFUWtWaXhFTVNKTkxUTW9VaXd6TEZjdFUwUlFMaVF3VlRGREpTVXdVeWtqTVVNaEl5MHpJU1VzSTBFak1UTXdVUzFVTkZjeFJERWxMVVF0SlM0a05GSXNJemhaVFRCVFlGRXdReVJZTFNNbElTNDBMRmdzVkRSWkxVUW9XVEJEUUZZdFJDeFdMak5FVkRCRE1Ga3RORFVsTEZRNFZTMVVKRmd3TXpSV0xEUTRVVTB3UXkwbUxVUTRXUzFUTVNNc1V5VWlNVU5BVVN4VUxGWXVJMFJVTGlNc1dERkVMRk14STJCUUxWTTBXUzRrT0Zjd00wUlhMVk1vV0MwaktGRXhMQ00wVml4VE5GQXRSRFJXTFVRbEpDMVRKRkF3TkN4Z1lB';

final Uint8List _authBlob = base64Decode(_authBlobBase64);

/// 生成游客设备码。
///
/// 原文 9 段：`android_id; ; ; ; 厂商; 品牌; 机型; Build;`，
/// 标准 base64 后整串字符逆序，再去掉 `=` 填充。
String coolapkGuestDeviceCode() => _encodeDeviceCode(
  '$_guestAndroidId; ; ; ; Xiaomi; Xiaomi; $_deviceModel; $_deviceBuild; ',
);

/// 组装酷安请求头，含设备码与现算的 `X-App-Token` 签名。
///
/// 签名与时间戳绑定，必须在每次请求前重新生成，不能复用。
/// [cookie] 非空时附带登录态；游客态传空串即可。
/// [captchaValidate] 是过完易盾验证拿到的票据，按 `validate` Cookie 发出。
Map<String, String> coolapkHeaders({
  required String deviceCode,
  String cookie = '',
  String captchaValidate = '',
}) => <String, String>{
  'User-Agent': _userAgent,
  'X-Requested-With': 'XMLHttpRequest',
  'X-App-Id': _appId,
  'X-App-Version': _appVersion,
  'X-App-Code': '$_appCode',
  'X-App-Supported': '$_appCode',
  'X-App-Channel': _appChannel,
  'X-App-Mode': 'universal',
  'X-App-Device': deviceCode,
  'X-App-Token': _token(deviceCode),
  'X-Api-Version': '16',
  'X-Sdk-Int': '36',
  'X-Sdk-Locale': 'zh-CN',
  'X-Dark-Mode': '0',
  'Accept': 'application/json',
  if (_composeCookie(cookie, captchaValidate).isNotEmpty)
    'Cookie': _composeCookie(cookie, captchaValidate),
};

/// 拼 Cookie 头：登录 Cookie 在前，验证码票据以 `validate` 追加。
///
/// 票据里可能含 `+` `/` `=` 等字符，按 Cookie 规范做 URL 编码。
String _composeCookie(String cookie, String captchaValidate) {
  final String base = cookie.trim();
  final String token = captchaValidate.trim();
  if (token.isEmpty) return base;
  final String pair = 'validate=${Uri.encodeComponent(token)}';
  return base.isEmpty ? pair : '$base; $pair';
}

String _encodeDeviceCode(String raw) =>
    base64Encode(utf8.encode(raw))
        .split('')
        .reversed
        .join()
        .replaceAll('=', '');

/// 生成当前时间可用的 Token；遇到非法盐最多向前探测 15 秒。
String _token(String deviceCode) {
  final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  Object? lastError;
  for (int offset = 0; offset <= 15; offset++) {
    try {
      return _tokenAt(deviceCode, timestamp + offset);
    } on FormatException catch (error) {
      lastError = error;
    }
  }
  throw StateError('failed to generate coolapk token: $lastError');
}

/// 生成指定时间戳的 Token；盐里出现 bcrypt 不认的字符时抛 [FormatException]。
///
/// 盐由标准 base64 生成、却要按 bcrypt 字母表解释，因此可能出现 `+`，
/// 这时只能换下一秒重试，由调用方 [_token] 负责。
String _tokenAt(String deviceCode, int timestamp) {
  final int index = ((timestamp + _appCode) % 100) * 4 + 0x80;
  final Uint8List chunk = _authBlob.sublist(index, index + 0x80);
  final String segment = utf8.decode(
    base64Decode(ascii.decode(chunk)),
    allowMalformed: true,
  );

  final String plain =
      '$_appId&$segment&${_md5Hex(deviceCode)}&$timestamp&$_appCode';
  final String password = _md5Hex(base64Encode(utf8.encode(plain)));

  final String saltSource = base64Encode(
    utf8.encode('${timestamp.toRadixString(16)}/${_md5Hex(plain)}'),
  ).replaceAll(RegExp(r'=+$'), '');
  final String salt22 = _shiftLastChar(saltSource.substring(0, 22), -5);
  for (final int code in salt22.codeUnits) {
    if (!_bcryptAlphabet.contains(String.fromCharCode(code))) {
      throw FormatException('salt contains a non-bcrypt char: $salt22');
    }
  }

  // 先用 $2b$ 让 bcrypt 包接受，再改写成服务端要求的 $2y$ 形式。
  final String hashed = BCrypt.hashpw(password, '\$2b\$04\$$salt22');
  final String crypt = '\$2y\$04\$${hashed.substring(7)}';
  return 'v3${base64Encode(utf8.encode(crypt)).replaceAll(RegExp(r'=+$'), '')}';
}

String _md5Hex(String input) => md5.convert(utf8.encode(input)).toString();

/// 把 base64 串最后一个字符在标准字母表里平移。
String _shiftLastChar(String value, int shift) {
  final int index = _standardAlphabet.indexOf(value[value.length - 1]);
  final int shifted = (index + shift) % _standardAlphabet.length;
  return '${value.substring(0, value.length - 1)}'
      '${_standardAlphabet[shifted]}';
}

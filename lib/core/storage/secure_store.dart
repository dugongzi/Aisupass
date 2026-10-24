import 'package:Aisupass/core/storage/json_codec.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 基于系统安全存储的键值存储，用于 API Key、Token 等敏感数据。
///
/// 各平台后端：Android Keystore、iOS/macOS Keychain、Windows DPAPI、
/// Linux libsecret、Web WebCrypto。与 [KeyValueStore] 分开，
/// 避免把普通配置误写进加密存储（性能差且容量受限）。
///
/// 底层各平台只接受字符串：String 原样存取，其他类型按 JSON 编码，
/// 所以同一个键的读写必须使用相同的泛型 T。
class SecureStore {
  SecureStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  /// 读取指定键的值，键不存在时返回 [defaultValue]。
  ///
  /// String 未传 [defaultValue] 时返回 `''`；其他类型没有天然兜底值，
  /// 未传 [defaultValue] 会抛 [StateError]。
  Future<T> read<T>(
    String key, {
    T? defaultValue,
    JsonDecoder<T>? fromJson,
  }) async {
    final String? raw = await _storage.read(key: key);
    if (raw != null) return decodeJsonValue<T>(raw, fromJson: fromJson);
    if (defaultValue != null) return defaultValue;
    if (T == String) return '' as T;
    throw StateError('键 "$key" 不存在，且 $T 没有兜底值，请传入 defaultValue');
  }

  /// 写入指定键的值，非 String 类型按 JSON 编码。
  Future<void> write<T>(String key, T value) async {
    await _storage.write(key: key, value: encodeJsonValue<T>(value));
  }

  Future<bool> containsKey(String key) => _storage.containsKey(key: key);

  Future<Map<String, String>> readAll() => _storage.readAll();

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}

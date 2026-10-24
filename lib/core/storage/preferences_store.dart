import 'package:Aisupass/core/storage/json_codec.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 基于 shared_preferences 的通用键值存储，用于配置项等非敏感数据。
///
/// 使用 [SharedPreferencesAsync]：Android 走 DataStore，其余平台走各自原生实现，
/// 全程异步且不在内存里保留同步缓存，避免多 isolate 下的数据不一致。
///
/// 原生类型直接落到平台存储；其他类型统一按 JSON 字符串存放，
/// 因此同一个键的读写必须使用相同的泛型 T，否则取到的会是原始 JSON 文本。
class PreferencesStore implements KeyValueStore {
  PreferencesStore({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  Future<T> read<T>(String key, {T? defaultValue, JsonDecoder<T>? fromJson}) async {
    if (_isNative<T>()) {
      final Object? raw = await _readNative<T>(key);
      return raw != null ? raw as T : (defaultValue ?? _fallback<T>());
    }

    final String? raw = await _preferences.getString(key);
    if (raw == null) {
      if (defaultValue != null) return defaultValue;
      throw StateError('键 "$key" 不存在，且 $T 没有兜底值，请传入 defaultValue');
    }

    return decodeJsonValue<T>(raw, fromJson: fromJson);
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (T == String) return _preferences.setString(key, value as String);
    if (T == bool) return _preferences.setBool(key, value as bool);
    if (T == int) return _preferences.setInt(key, value as int);
    if (T == double) return _preferences.setDouble(key, value as double);
    if (T == List<String>) {
      return _preferences.setStringList(key, value as List<String>);
    }
    await _preferences.setString(key, encodeJsonValue<T>(value));
  }

  @override
  Future<bool> containsKey(String key) => _preferences.containsKey(key);

  @override
  Future<Set<String>> keys() => _preferences.getKeys();

  @override
  Future<void> remove(String key) async {
    await _preferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await _preferences.clear();
  }

  bool _isNative<T>() =>
      T == String || T == bool || T == int || T == double || T == List<String>;

  Future<Object?> _readNative<T>(String key) {
    if (T == String) return _preferences.getString(key);
    if (T == bool) return _preferences.getBool(key);
    if (T == int) return _preferences.getInt(key);
    if (T == double) return _preferences.getDouble(key);
    return _preferences.getStringList(key);
  }

  /// 键不存在且调用方未提供 defaultValue 时的类型兜底值。
  T _fallback<T>() {
    if (T == String) return '' as T;
    if (T == bool) return false as T;
    if (T == int) return -1 as T;
    if (T == double) return -1.0 as T;
    if (T == List<String>) return const <String>[] as T;
    throw UnsupportedError('KeyValueStore 不支持的类型：$T');
  }
}

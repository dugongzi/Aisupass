import 'package:Aisupass/core/storage/json_codec.dart';

/// 跨平台键值存储的统一异步接口。
///
/// 所有读写都返回 [Future]，调用方不得依赖任何同步取值。
/// 存储格式由泛型 T 决定：
/// - 原生类型 String / bool / int / double / List&lt;String&gt; 直接交给平台存储；
/// - 其余类型（自定义对象、Map、List&lt;int&gt; 等）序列化成 JSON 字符串存放，
///   写入时走 `toJson()`，读取时用 [JsonDecoder] 还原。
///
/// 读取不返回可空类型：键不存在时优先返回 [defaultValue]，
/// 原生类型未提供时返回兜底值（String -> `''`，bool -> `false`，
/// int -> `-1`，double -> `-1.0`，List&lt;String&gt; -> `const []`）。
/// 对象类型没有天然兜底值，必须显式传 [defaultValue]。
/// 需要区分“未设置”和“设置为空值”时，用 [containsKey]。
abstract interface class KeyValueStore {
  /// 读取指定键的值。
  ///
  /// 非原生类型必须提供 [fromJson]，例如
  /// `read<User>('user', fromJson: (json) => User.fromJson(json as Map<String, dynamic>))`。
  Future<T> read<T>(String key, {T? defaultValue, JsonDecoder<T>? fromJson});

  /// 写入指定键的值。
  ///
  /// 非原生类型按 JSON 编码，因此对象需要有 `toJson()`（freezed / json_serializable 自动生成）。
  Future<void> write<T>(String key, T value);

  Future<bool> containsKey(String key);

  /// 返回当前存储中的全部键，用于调试或整体重置前的快照。
  Future<Set<String>> keys();

  Future<void> remove(String key);

  Future<void> clear();
}

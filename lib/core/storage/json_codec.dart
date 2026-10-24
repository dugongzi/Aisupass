import 'dart:convert';

/// 反序列化函数：把 [jsonDecode] 的结果还原成 T。
typedef JsonDecoder<T> = T Function(Object? json);

/// 把值转成存储用的字符串：String 原样返回，其他类型按 JSON 编码。
///
/// 编码走 `jsonEncode`，对象需要有 `toJson()`（freezed / json_serializable 自动生成）。
String encodeJsonValue<T>(T value) =>
    T == String ? value as String : jsonEncode(value);

/// 把存储的字符串还原成 T：String 原样返回，其他类型按 JSON 解码。
///
/// 提供 [fromJson] 时由它负责构造对象；否则尝试直接按 T 转型，
/// 其中基础集合（List&lt;String&gt; / List&lt;int&gt; / List&lt;double&gt; /
/// List&lt;bool&gt; / List&lt;Map&lt;String, dynamic&gt;&gt;）会逐元素转换，
/// 因为 [jsonDecode] 返回的是 `List&lt;dynamic&gt;`。
T decodeJsonValue<T>(String raw, {JsonDecoder<T>? fromJson}) {
  if (T == String) return raw as T;

  final Object? json = jsonDecode(raw);
  if (fromJson != null) return fromJson(json);

  if (json is List) {
    if (T == List<String>) return json.cast<String>() as T;
    if (T == List<int>) return json.cast<int>() as T;
    if (T == List<double>) return json.cast<double>() as T;
    if (T == List<bool>) return json.cast<bool>() as T;
    if (T == List<Map<String, dynamic>>) {
      return json.cast<Map<String, dynamic>>() as T;
    }
  }
  return json as T;
}

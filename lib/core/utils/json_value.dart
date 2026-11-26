/// `@JsonKey(fromJson:)` 用的通用字段适配器。
///
/// 社区类接口的数值字段常以字符串返回（如 `"likenum": "0"`），集合字段可能混入
/// 空值，标签字段带 `#` 包裹。这里集中做类型收敛，避免各 DTO 重复写私有函数。
library;

/// 数值字段宽松取值：int / num / 数字字符串，其余返回 [fallback]。
int intFromJson(Object? value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim()) ?? fallback;
  return fallback;
}

/// 字符串数组字段：过滤非字符串与空串，非 List 一律返回空集合。
List<String> stringListFromJson(Object? value) => <String>[
  if (value is List)
    for (final dynamic item in value)
      if (item is String && item.isNotEmpty) item,
];

/// 字符串字段宽松取值：数字等标量转成字符串，`null` 返回空串。
///
/// 社区接口的 id 常在不同接口里混用 int 与 String，统一收敛为 String。
String stringFromJson(Object? value) => value?.toString().trim() ?? '';

/// 布尔字段宽松取值：`1` / `"1"` / `"true"` 视为真，其余为假。
bool boolFromJson(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final String text = value.trim().toLowerCase();
    return text == '1' || text == 'true';
  }
  return false;
}

/// 井号标签串：按逗号拆开、去掉 `#` 后以 [separator] 拼接。
///
/// 例：`#HyperOS4#,#玩机技巧#` → `HyperOS4 玩机技巧`。
String hashTagsFromJson(Object? value, {String separator = ' '}) => <String>[
  for (final String part in (value ?? '').toString().split(','))
    if (part.trim().replaceAll('#', '').isNotEmpty)
      part.trim().replaceAll('#', ''),
].join(separator);

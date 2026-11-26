/// AI 工具参数 Schema 与取值辅助。
///
/// 统一从这里构造，避免每个工具各写一份 JSON Schema 文本。
const Map<String, dynamic> noArgsSchema = <String, dynamic>{
  'type': 'object',
  'properties': <String, dynamic>{},
  'additionalProperties': false,
};

/// 构造对象型参数 Schema。
Map<String, dynamic> objectSchema({
  Map<String, dynamic> properties = const <String, dynamic>{},
  List<String> required = const <String>[],
}) => <String, dynamic>{
  'type': 'object',
  'properties': properties,
  if (required.isNotEmpty) 'required': required,
  'additionalProperties': false,
};

/// 构造字符串型属性。
Map<String, dynamic> stringProperty({
  String description = '',
  List<String> allowedValues = const <String>[],
}) => <String, dynamic>{
  'type': 'string',
  if (description.isNotEmpty) 'description': description,
  if (allowedValues.isNotEmpty) 'enum': allowedValues,
};

/// 构造布尔型属性。
Map<String, dynamic> boolProperty({String description = ''}) =>
    <String, dynamic>{
      'type': 'boolean',
      if (description.isNotEmpty) 'description': description,
    };

/// 构造整数型属性，可选上下界。
Map<String, dynamic> intProperty({
  String description = '',
  int? minimum,
  int? maximum,
}) => <String, dynamic>{
  'type': 'integer',
  if (description.isNotEmpty) 'description': description,
  'minimum': ?minimum,
  'maximum': ?maximum,
};

/// 构造「字符串键 → 整数」的映射属性。
Map<String, dynamic> intMapProperty({String description = ''}) =>
    <String, dynamic>{
      'type': 'object',
      'additionalProperties': <String, dynamic>{'type': 'integer'},
      if (description.isNotEmpty) 'description': description,
    };

/// 构造「字符串键 → 字符串」的映射属性。
Map<String, dynamic> stringMapProperty({String description = ''}) =>
    <String, dynamic>{
      'type': 'object',
      'additionalProperties': <String, dynamic>{'type': 'string'},
      if (description.isNotEmpty) 'description': description,
    };

/// 构造「字符串数组」属性。
Map<String, dynamic> stringListProperty({
  String description = '',
  int? minItems,
  int? maxItems,
}) => <String, dynamic>{
  'type': 'array',
  'items': <String, dynamic>{'type': 'string'},
  if (description.isNotEmpty) 'description': description,
  'minItems': ?minItems,
  'maxItems': ?maxItems,
};

/// 必填字符串；缺失或非字符串直接抛错，让工具卡片显示失败原因。
String requireString(Map<String, dynamic> arguments, String key) {
  final Object? value = arguments[key];
  if (value is String && value.isNotEmpty) return value;
  throw ArgumentError('Missing required string argument: $key');
}

/// 可选字符串。
String stringArg(
  Map<String, dynamic> arguments,
  String key, {
  String fallback = '',
}) {
  final Object? value = arguments[key];
  return value is String ? value : fallback;
}

/// 可选布尔。
bool boolArg(
  Map<String, dynamic> arguments,
  String key, {
  required bool fallback,
}) {
  final Object? value = arguments[key];
  return value is bool ? value : fallback;
}

/// 可选整数；显式传 `null` 时返回 null。
int? intArg(Map<String, dynamic> arguments, String key, {int? fallback}) {
  final Object? value = arguments[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  return fallback;
}

/// 必填整数。
int requireInt(Map<String, dynamic> arguments, String key) {
  final int? value = intArg(arguments, key);
  if (value != null) return value;
  throw ArgumentError('Missing required integer argument: $key');
}

/// 必填字符串数组；缺失、类型不符或过滤后为空时抛错。
List<String> requireStringList(Map<String, dynamic> arguments, String key) {
  final Object? value = arguments[key];
  if (value is! List) {
    throw ArgumentError('Missing required string list argument: $key');
  }
  final List<String> items = <String>[
    for (final Object? item in value)
      if (item is String && item.trim().isNotEmpty) item.trim(),
  ];
  if (items.isEmpty) {
    throw ArgumentError('Empty required string list argument: $key');
  }
  return items;
}

/// 整数映射（点分路径 -> 值）。
Map<String, int> intMapArg(Map<String, dynamic> arguments, String key) {
  final Object? value = arguments[key];
  if (value is! Map) {
    throw ArgumentError('Missing required integer map argument: $key');
  }
  return <String, int>{
    for (final MapEntry<dynamic, dynamic> entry in value.entries)
      if (entry.value is num) '${entry.key}': (entry.value as num).toInt(),
  };
}

/// 字符串映射（点分路径 -> 值）。
Map<String, String> stringMapArg(Map<String, dynamic> arguments, String key) {
  final Object? value = arguments[key];
  if (value is! Map) {
    throw ArgumentError('Missing required string map argument: $key');
  }
  return <String, String>{
    for (final MapEntry<dynamic, dynamic> entry in value.entries)
      if (entry.value is String) '${entry.key}': entry.value as String,
  };
}

/// 受限字符串取值；不在允许集合内抛错。
String oneOfArg(
  Map<String, dynamic> arguments,
  String key,
  List<String> allow,
) {
  final String value = requireString(arguments, key);
  if (!allow.contains(value)) {
    throw ArgumentError(
      'Invalid value for $key: $value, expected one of ${allow.join(', ')}',
    );
  }
  return value;
}

/// 枚举名解析；未知值抛错，避免静默回落到错误分支。
T enumArg<T extends Enum>(
  Map<String, dynamic> arguments,
  String key,
  List<T> values,
) {
  final String name = requireString(arguments, key);
  for (final T value in values) {
    if (value.name == name) return value;
  }
  throw ArgumentError(
    'Invalid value for $key: $name, expected one of '
    '${values.map((T item) => item.name).join(', ')}',
  );
}

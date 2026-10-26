import 'package:meta/meta.dart';

/// 工具执行函数，入参为模型给出的 JSON 参数。
typedef ChatToolExecutor =
    Future<String> Function(Map<String, dynamic> arguments);

/// 提供给模型的本地工具定义。
@immutable
class ChatToolDefinition {
  const ChatToolDefinition({
    required this.name,
    required this.description,
    required this.parameters,
    required this.execute,
  });

  final String name;
  final String description;

  /// JSON Schema 形式的参数定义。
  final Map<String, dynamic> parameters;
  final ChatToolExecutor execute;
}

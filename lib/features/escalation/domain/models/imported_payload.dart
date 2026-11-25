import 'package:Aisupass/features/escalation/domain/models/payload.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'imported_payload.freezed.dart';

/// 用户导入的自定义载荷。
///
/// 与包内 catalog 条目共用 [Payload] 作为展示与执行模型，差别只有两点：文件
/// 不在 `nativeLibraryDir` 下（导入时推到设备固定目录），以及运行方式由导入
/// 时选定。
@freezed
abstract class ImportedPayload with _$ImportedPayload {
  const ImportedPayload._();

  const factory ImportedPayload({
    /// 列表里显示的名字，默认取文件名。
    required String displayName,

    /// 载荷在设备上的绝对路径。
    required String devicePath,

    /// `true` = 直接执行（可执行 ELF）；`false` = 交给包内助手加载（`.so`）。
    required bool standalone,

    /// 直接执行时附加的参数；助手加载方式下为空串。
    required String arguments,

    /// 文件体积（字节），仅展示。
    required int size,
  }) = _ImportedPayload;

  /// 列表与执行共用的模型。
  ///
  /// [Payload.library] 放绝对路径，执行侧据此跳过 `nativeLibraryDir` 拼接；
  /// 内核信息一律按「未知」处理，自定义载荷不参与自动匹配。
  Payload toPayload() => Payload(
    id: 'custom:$devicePath',
    library: devicePath,
    vendor: 'custom',
    displayName: displayName,
    models: const <String>[],
    kernelUnknown: true,
    kernelVersion: '',
    kernelCommits: const <String>[],
    buildId: '',
    size: size,
    sha256: '',
    command: arguments.isEmpty ? devicePath : '$devicePath $arguments',
    standalone: standalone,
    source: 'custom',
  );
}

/// 导入自定义载荷失败。`code` 是稳定原因码，文案由展示层翻译。
///
/// 取值：`fileMissing`（本机文件不存在）、`fileEmpty`（文件为空）、
/// `pushFailed`（推送到设备失败）、`deleteFailed`（删除设备文件失败），
/// 后两者 `detail` 带设备侧原始报错。
class PayloadImportException implements Exception {
  const PayloadImportException(this.code, {this.detail = ''});

  final String code;

  /// 设备侧原始报错，可能为空。
  final String detail;

  @override
  String toString() => 'PayloadImportException($code)';
}

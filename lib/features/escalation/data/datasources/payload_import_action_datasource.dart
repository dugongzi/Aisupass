import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:Aisupass/core/constants/storage_keys.dart';
import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/features/escalation/data/models/imported_payload_dto.dart';
import 'package:Aisupass/features/escalation/domain/models/imported_payload.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// 自定义载荷的写数据源：推送 / 删除设备文件，写入 / 删除单条存储记录。
///
/// 载荷文件跟着 App 包走不了（外部文件进不了 `nativeLibraryDir`），所以导入时
/// 直接推到 `/data/local/tmp` 下：那里 adb shell（uid 2000）可写、可执行，
/// 而载荷本来就在这条链路上以同一 uid 运行。
///
/// 存储按「一条载荷一个键」组织，因此这里只做单条写与单条删，不需要先读回整份
/// 列表——写操作不承担查询职责。
class PayloadImportActionDatasource {
  const PayloadImportActionDatasource({
    required this._native,
    required this._storage,
  });

  /// 导入载荷在设备上的落点目录。
  static const String deviceDir = '/data/local/tmp/aisupass/payloads';

  /// 推送超时：几 MB 的 `.so` 走 ADB 流要一点时间，比普通命令放得宽。
  static const int pushTimeoutMs = 120000;

  /// 一次性命令的超时（mkdir / chmod / rm 这类）。
  static const int shortTimeoutMs = 15000;

  final pigeon.AdbShellNative _native;

  final KeyValueStore _storage;

  /// 把本机文件按 [deviceName] 推到设备落点目录，并补可执行位。
  ///
  /// 返回文件体积（字节）。同名文件覆盖：设备路径由文件名决定，重复导入不会
  /// 堆出一串旧副本。
  Future<int> pushFile({
    required String localPath,
    required String deviceName,
  }) async {
    final File file = File(localPath);
    if (!file.existsSync()) throw const PayloadImportException('fileMissing');
    final List<int> bytes = await file.readAsBytes();
    if (bytes.isEmpty) throw const PayloadImportException('fileEmpty');

    final String devicePath = '$deviceDir/$deviceName';
    await _exec('mkdir -p ${PayloadShell.quote(deviceDir)}', 'pushFailed');

    // `cat >` 把 stdin 原样写成文件：二进制不能走 echo / base64 绕一圈。
    final pigeon.ShellExecResult written = await _native.exec(
      'cat > ${PayloadShell.quote(devicePath)}',
      pushTimeoutMs,
      Uint8List.fromList(bytes),
    );
    if (written.exitCode != 0) {
      throw PayloadImportException('pushFailed', detail: _detailOf(written));
    }
    await _exec('chmod 700 ${PayloadShell.quote(devicePath)}', 'pushFailed');
    return bytes.length;
  }

  /// 删掉设备落点目录下的一个文件。
  ///
  /// 文件已不在也不报错：`rm -f` 的语义就是「删到没有为止」，用户重复点删除
  /// 或者手工清过设备目录时，不该被一句「文件不存在」挡住。
  Future<void> removeFile({required String devicePath}) =>
      _exec('rm -f ${PayloadShell.quote(devicePath)}', 'deleteFailed');

  /// 写入（覆盖）一条载荷记录。同路径再次导入时直接覆盖同一个键。
  Future<void> saveEntry(ImportedPayloadDto entry) => _storage.write<String>(
    _keyOf(entry.devicePath),
    jsonEncode(entry.toJson()),
  );

  /// 删除一条载荷记录。键不存在时是空操作。
  Future<void> removeEntry({required String devicePath}) =>
      _storage.remove(_keyOf(devicePath));

  /// 单条记录的存储键：前缀 + 设备路径。
  static String _keyOf(String devicePath) =>
      '${StorageKeys.escalationImportedPayloadPrefix}$devicePath';

  /// 一次性短命令；失败即抛，不在半成品状态上继续往下走。
  ///
  /// [code] 是抛出的原因码，调用方据此给出对应文案。
  Future<void> _exec(String command, String code) async {
    final pigeon.ShellExecResult result = await _native.exec(
      command,
      shortTimeoutMs,
      null,
    );
    if (result.exitCode != 0) {
      throw PayloadImportException(code, detail: _detailOf(result));
    }
  }

  /// 设备侧报错原文：stderr 优先，其次 stdout，都空时给退出码。
  static String _detailOf(pigeon.ShellExecResult result) {
    final String stderr = result.stderr.trim();
    if (stderr.isNotEmpty) return stderr;
    final String stdout = result.stdout.trim();
    if (stdout.isNotEmpty) return stdout;
    return 'exit ${result.exitCode}';
  }
}

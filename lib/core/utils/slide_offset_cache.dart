import 'package:Aisupass/core/storage/key_value_store.dart';
import 'package:Aisupass/core/utils/payload_shell.dart';
import 'package:Aisupass/core/utils/su_shell.dart';
import 'package:Aisupass/generated/adb_shell.g.dart' as pigeon;

/// KASLR P0 偏移的跨次复用缓存。
///
/// 同一 boot 会话内 slide 固定，缓存下来能让后续尝试跳过最贵的 P0 阶段；
/// 以 boot token 作会话凭据，跨 boot 不复用。
class SlideOffsetCache {
  const SlideOffsetCache({required this.exec, required this.storage});

  /// 读 `boot_id` 走它。
  final ShellExec exec;

  final KeyValueStore storage;

  /// 缓存的存储键：偏移值。
  static const String keyOffset = 'p0_cache.offset';

  /// 缓存的存储键：boot token。
  static const String keyBootId = 'p0_cache.boot_id';

  /// slide 偏移上限。超出此值的偏移无效。
  static const int maxOffset = 0x1f0000;

  /// slide 偏移掩码。偏移必须对齐此掩码。
  static const int offsetMask = 0xffff;

  /// 从载荷日志中抓取 slide 值。
  static final RegExp _slidePattern = RegExp(
    r'slide-kaslr-ok[^\n]*slide=([0-9a-fA-F]{16})',
  );

  /// 读取当前 boot 会话 token。取不到返回 null，调用方退化成不读也不写缓存，
  /// 那条路依然能跑通，只是每轮都重做 P0。
  Future<String?> bootToken() async {
    final pigeon.ShellExecResult result = await exec(
      PayloadShell.buildBootIdCommand(),
      PayloadShell.shortTimeoutMs,
    );
    if (result.exitCode != 0) return null;
    final String token = result.stdout.trim();
    return token.isEmpty ? null : token;
  }

  /// 读取缓存的偏移值。仅当 boot token 匹配且偏移合法时返回。
  ///
  /// 必须先 [KeyValueStore.containsKey]：`read<int>` 对缺失键返回 `-1` 而不是
  /// null，光判 null 会让「没缓存」伪装成「缓存了 -1」。
  Future<String?> read(String bootToken) async {
    if (!await storage.containsKey(keyBootId)) return null;
    final String cachedBootId = await storage.read<String>(keyBootId);
    if (cachedBootId != bootToken) return null;

    if (!await storage.containsKey(keyOffset)) return null;
    final int cachedOffset = await storage.read<int>(keyOffset);
    if (cachedOffset < 0) return null;
    if (cachedOffset > maxOffset) return null;
    if ((cachedOffset & offsetMask) != 0) return null;
    return '0x${cachedOffset.toRadixString(16)}';
  }

  /// 从日志片段中提取并缓存 slide 值。
  ///
  /// [log] 可以是全量日志，也可以是「上一轮尾部 + 本轮新增」的窗口。取**最后
  /// 一个**匹配，与上游 `cacheP0Offset` 的 `findAll(...).lastOrNull()` 等价：
  /// 载荷会反复试 P0，只有最后那次成功的候选值得记。
  Future<void> cacheFromLog(String log, String bootToken) async {
    final RegExpMatch? match = _slidePattern.allMatches(log).lastOrNull;
    if (match == null) return;

    final String? slideHex = match.group(1);
    if (slideHex == null) return;

    final int? slideValue = int.tryParse(slideHex, radix: 16);
    if (slideValue == null) return;
    if (slideValue > maxOffset) return;
    if ((slideValue & offsetMask) != 0) return;

    // 轮询里会反复调到这里，值没变就不重复落盘。
    if (await storage.containsKey(keyBootId) &&
        await storage.containsKey(keyOffset) &&
        await storage.read<String>(keyBootId) == bootToken &&
        await storage.read<int>(keyOffset) == slideValue) {
      return;
    }

    await storage.write<String>(keyBootId, bootToken);
    await storage.write<int>(keyOffset, slideValue);
  }
}

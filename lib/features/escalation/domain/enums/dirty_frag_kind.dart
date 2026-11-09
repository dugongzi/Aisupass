/// DirtyFrag 一次运行的终局分类。
///
/// 分类由 [DirtyFragActionRepositoryImpl] 依据原生证据判定，原生不回结论。
enum DirtyFragKind {
  /// 正在运行，尚未拿到终局证据。
  running,

  /// 原生拒绝受理：`alreadyArmed` / `busy` / `noIpSec` / `missingBinary` /
  /// `stagingFailed` / `badRequest`，具体码见 `DirtyFragOutcome.reason`。
  notStarted,

  /// 全链路成功，`ksud late-load` 已接管。
  succeeded,

  /// 内核没有该漏洞（`DEVICE NOT VULNERABLE`）。
  notVulnerable,

  /// 打补丁阶段失败。
  patchFailed,

  /// VR 反制阶段失败，已在移交前中止。
  vrFailed,

  /// 内核模块已加载，但 bootstrap 或 ksud 阶段失败。
  bootstrapFailed,

  /// 等待终局标记超时。
  timedOut,

  /// 以上都不匹配，只有证据没有结论。
  failed;

  /// 安全解析，非法值回落 [failed]。
  ///
  /// 禁止直接调用 `values.byName`：遇到未知名字会抛异常。
  static DirtyFragKind fromName(String? value) {
    for (final DirtyFragKind kind in DirtyFragKind.values) {
      if (kind.name == value) return kind;
    }
    return DirtyFragKind.failed;
  }
}

/// 该构建支持的 `major.minor` 内核系列。
///
/// 与 `02` 的 8 档 KMI 矩阵去重后一致：`android12-5.10` / `android13-5.10` /
/// `android13-5.15` / `android14-5.15` / `android14-6.1` / `android15-6.6` /
/// `android16-6.12` / `android17-6.18`。原生侧 `select_ko_image` 按
/// `(major, minor)` 精确匹配，回落同系列任一档，因此 Dart 侧只比对系列。
///
/// **新增一档 kernel 系列（不是新增一个 ko）才加一行**。8 个 ko 覆盖 6 个
/// 系列，`android12-5.10` 与 `android13-5.10` 共用 `5.10`、`android13-5.15`
/// 与 `android14-5.15` 共用 `5.15`，所以集合是 6 条而非 8 条。
const Set<String> kDirtyFragKernelSeries = <String>{
  '5.10',
  '5.15',
  '6.1',
  '6.6',
  '6.12',
  '6.18',
};

/// [kernelSeries] 为空（内核版本读不到）时按不支持处理。
bool isDirtyFragKernelSupported(String kernelSeries) =>
    kDirtyFragKernelSeries.contains(kernelSeries);

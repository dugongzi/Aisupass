<p align="center">
  <img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" width="120" height="120" alt="AISUPASS" />
</p>

<h1 align="center">AISUPASS</h1>

<p align="center">
  <b>AI 提权助手</b><br />
  对话式提权工具，支持多种方式提权
</p>

<p align="center">
  <a href="README.md">English</a> · <b>简体中文</b>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue.svg" alt="License: GPL-3.0" /></a>
  <img src="https://img.shields.io/badge/Android-11%2B-3DDC84.svg?logo=android&logoColor=white" alt="Android 11+" />
  <img src="https://img.shields.io/badge/Flutter-stable-02569B.svg?logo=flutter&logoColor=white" alt="Flutter" />
</p>

---

<table align="center">
  <tr>
    <th align="center" width="50%">官网</th>
    <th align="center" width="50%">发布</th>
  </tr>
  <tr>
    <td align="center"><a href="https://aisupass.org"><b>aisupass.org</b></a></td>
    <td align="center"><a href="https://github.com/dugongzi/Aisupass/releases"><b>GitHub Releases</b></a></td>
  </tr>
</table>

## 功能

| 模块 | 说明 |
| --- | --- |
| 设备洞察 | 设备信息、ROOT / ADB 状态、系统指标 |
| 提权 | GhostLock（CVE-2026-43499）、DirtyFrag（CVE-2026-43284）、GhostKey（CVE-2026-98260） |
| 内核表 | 从 `boot.img` 或 OTA 包导入，查看与编辑 |
| 排障 | 逐次运行记录与失败诊断 |

## 上游代码怎么用

| 交付层 | 上游 | 固定版本 | 许可证 | 分发形态 |
| --- | --- | :---: | :---: | --- |
| shell（adb，uid 2000） | [libadb-android](https://github.com/MuntashirAkon/libadb-android)、[sun-security-android](https://github.com/MuntashirAkon/sun-security-android)、[conscrypt](https://github.com/google/conscrypt) | `3.1.1` / `1.1` / `2.5.3` | 双许可 / GPL-2.0+CE / Apache-2.0 | JitPack 与 Maven AAR |
| OTA 解包 | [commons-compress](https://github.com/apache/commons-compress)、[xz](https://github.com/tukaani-project/xz) | `1.27.1` / `1.10` | Apache-2.0 / 0BSD | Maven AAR |
| GhostLock | [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app) | `4ebc726` | Apache-2.0 | [jni/cve43499](android/app/src/main/jni/cve43499) → `libghostlock.so` |
| DirtyFrag | [DONGDERS/DirtyFalg-vr](https://github.com/DONGDERS/DirtyFalg-vr)、[payload_extract_rs](https://github.com/YuKongA/payload_extract_rs) | `d4f5c9f` / `5534f07` | GPL-2.0-only / GPL-2.0 | [jni/dfroot](android/app/src/main/jni/dfroot)、[jni/vrext](android/app/src/main/jni/vrext) |
| GhostKey | [Again1996-bit/CVE-2026-98260-GhostKey](https://github.com/Again1996-bit/CVE-2026-98260-GhostKey) | `9c216a8` | **无** | [jni/cve98260](android/app/src/main/jni/cve98260) → `libcve98260.so` |
| 预编译载荷 | [hmascs/KSuRoot](https://github.com/hmascs/KSuRoot) | `4.1.2` | Apache-2.0 | [jniLibs/arm64-v8a](android/app/src/main/jniLibs/arm64-v8a)，129 个 `.so` 中的 127 个 |

> 逐组件出处、逐文件修改声明、72 个载荷上游的分布与未决许可证风险，见 **[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)**。root 管理器既不链接也不随包：应用只定位**选中的那个管理器自带**的 `ksud`（固定名优先，否则靠指纹 + 真跑一次 `late-load --help` 确认），在进程外调用。

## 构建

需要 Flutter、JDK 17、Android SDK（minSdk 30）与 Flutter 声明的 NDK 版本。

```powershell
flutter pub get
flutter gen-l10n
flutter build apk --debug
```

| 步骤 | 说明 |
| --- | --- |
| `flutter gen-l10n` | 重新生成 `lib/l10n/app_localizations*.dart`，改动任何 `.arb` 后都要执行 |
| 原生编译 | 三条提权链由 Gradle + CMake 依据 [jni/CMakeLists.txt](android/app/src/main/jni/CMakeLists.txt) 构建 |
| 预编译产物 | `libvrext.so` 与 `libaisup_probe.so` 随仓库提交；重建 `libvrext.so` 需在 [jni/vrext](android/app/src/main/jni/vrext) 内执行 `cargo build --release --features http`，交叉编译配置在该目录的 `.cargo/config.toml` |

## 许可证

本项目按 **GNU GPL v3.0** 分发（[LICENSE](LICENSE)）。

| 文件 | 用途 |
| --- | --- |
| [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) | 组件清单、修改声明、风险 |
| [LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt) | ghostlock-app、KSuRoot 及 Apache 系工件的全文 |
| [LICENSES/GPL-2.0.txt](LICENSES/GPL-2.0.txt) | DirtyFalg-vr 与 payload_extract_rs 的全文 |

`jni/cve43499`、`jni/dfroot`、`jni/vrext`、`jni/cve98260`、`jniLibs/arm64-v8a` 下各有一份 `NOTICE`，记录该目录的出处与改动。App 内「设置 → 关于 → 开源协议 / 第三方开源声明」可离线查看全部文档。

> **待处理**：GPL-2.0-only 与 GPL-3.0 的组合、GhostKey 移植缺少许可证——详见声明文件第 11 节。

## 致谢

- DirtyFrag 链路：[mitschud/DirtyFrag](https://github.com/mitschud/DirtyFrag)、[diabl0w/DFRoot](https://github.com/diabl0w/DFRoot)、[lsposed/lspromise](https://github.com/lsposed/lspromise)、[polygraphene/DFReroot](https://github.com/polygraphene/DFReroot)、[combeng6th/DirtyInit](https://github.com/combeng6th/DirtyInit)。
- KSuRoot 基于 [BuSung-dev/Root-My-Galaxy](https://github.com/BuSung-dev/Root-My-Galaxy)；其基线载荷配方源自 [boxiaolanya2008/CVE-2026-43499-Neo11Plus](https://github.com/boxiaolanya2008/CVE-2026-43499-Neo11Plus)。

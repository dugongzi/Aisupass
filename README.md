<p align="center">
  <img src="android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png" width="120" height="120" alt="AISUPASS" />
</p>

<h1 align="center">AISUPASS</h1>

<p align="center">
  <b>AI escalation assistant</b><br />
  A conversational escalation tool with multiple escalation methods
</p>

<p align="center">
  <b>English</b> · <a href="README_ZH.md">简体中文</a>
</p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-GPL--3.0-blue.svg" alt="License: GPL-3.0" /></a>
  <img src="https://img.shields.io/badge/Android-11%2B-3DDC84.svg?logo=android&logoColor=white" alt="Android 11+" />
  <img src="https://img.shields.io/badge/Flutter-stable-02569B.svg?logo=flutter&logoColor=white" alt="Flutter" />
</p>

---

<table align="center">
  <tr>
    <th align="center" width="50%">Website</th>
    <th align="center" width="50%">Releases</th>
  </tr>
  <tr>
    <td align="center"><a href="https://aisupass.org"><b>aisupass.org</b></a></td>
    <td align="center"><a href="https://github.com/dugongzi/Aisupass/releases"><b>GitHub Releases</b></a></td>
  </tr>
</table>

## Capabilities

| Module | What it does |
| --- | --- |
| Device insight | Device info, ROOT / ADB status, system metrics |
| Escalation | GhostLock (CVE-2026-43499), DirtyFrag (CVE-2026-43284), GhostKey (CVE-2026-98260) |
| Kernel profiles | Import from `boot.img` or OTA packages, then inspect and edit |
| Diagnostics | Per-run logs with failure diagnosis |

## How upstream code is used

| Layer | Upstream | Pinned | License | Shipped as |
| --- | --- | :---: | :---: | --- |
| Shell (adb, uid 2000) | [libadb-android](https://github.com/MuntashirAkon/libadb-android), [sun-security-android](https://github.com/MuntashirAkon/sun-security-android), [conscrypt](https://github.com/google/conscrypt) | `3.1.1` / `1.1` / `2.5.3` | dual / GPL-2.0+CE / Apache-2.0 | JitPack & Maven AARs |
| OTA unpack | [commons-compress](https://github.com/apache/commons-compress), [xz](https://github.com/tukaani-project/xz) | `1.27.1` / `1.10` | Apache-2.0 / 0BSD | Maven AARs |
| GhostLock | [YuKongA/ghostlock-app](https://github.com/YuKongA/ghostlock-app) | `4ebc726` | Apache-2.0 | [jni/cve43499](android/app/src/main/jni/cve43499) → `libghostlock.so` |
| DirtyFrag | [DONGDERS/DirtyFalg-vr](https://github.com/DONGDERS/DirtyFalg-vr), [payload_extract_rs](https://github.com/YuKongA/payload_extract_rs) | `d4f5c9f` / `5534f07` | GPL-2.0-only / GPL-2.0 | [jni/dfroot](android/app/src/main/jni/dfroot), [jni/vrext](android/app/src/main/jni/vrext) |
| GhostKey | [Again1996-bit/CVE-2026-98260-GhostKey](https://github.com/Again1996-bit/CVE-2026-98260-GhostKey) | `9c216a8` | **none** | [jni/cve98260](android/app/src/main/jni/cve98260) → `libcve98260.so` |
| Payloads | [hmascs/KSuRoot](https://github.com/hmascs/KSuRoot) | `4.1.2` | Apache-2.0 | [jniLibs/arm64-v8a](android/app/src/main/jniLibs/arm64-v8a), 127 of 129 `.so` |

> Per-component provenance, per-file modification statements, the 72-repo payload breakdown and open license risks live in **[THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)** (Chinese). Root managers are neither linked nor bundled: the app locates the selected manager's own `ksud` (fixed name first, otherwise fingerprint + a real `late-load --help` probe) and invokes it out of process.

## Build

Requires Flutter, JDK 17, Android SDK (minSdk 30) and the NDK version declared by Flutter.

```powershell
flutter pub get
flutter gen-l10n
flutter build apk --debug
```

| Step | Notes |
| --- | --- |
| `flutter gen-l10n` | Regenerates `lib/l10n/app_localizations*.dart`; run it after editing any `.arb` |
| Native build | The three escalation chains are compiled by Gradle + CMake from [jni/CMakeLists.txt](android/app/src/main/jni/CMakeLists.txt) |
| Prebuilts | `libvrext.so` and `libaisup_probe.so` are committed; to rebuild `libvrext.so` run `cargo build --release --features http` inside [jni/vrext](android/app/src/main/jni/vrext), with cross-compile settings in that directory's `.cargo/config.toml` |

## License

Distributed under **GNU GPL v3.0** ([LICENSE](LICENSE)).

| Artifact | Purpose |
| --- | --- |
| [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) | Component inventory, modification statements, risks |
| [LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt) | Apache-2.0 text for ghostlock-app, KSuRoot and Apache-licensed artifacts |
| [LICENSES/GPL-2.0.txt](LICENSES/GPL-2.0.txt) | GPL-2.0 text for DirtyFalg-vr and payload_extract_rs |

`NOTICE` files under `jni/cve43499`, `jni/dfroot`, `jni/vrext`, `jni/cve98260` and `jniLibs/arm64-v8a` record provenance per vendored directory. In the app, **Settings → About → License / Third-party Notices** renders all of these offline.

> **Open issues**: the GPL-2.0-only / GPL-3.0 combination and the unlicensed GhostKey port — see §11 of the notices file.

## Credits

- DirtyFrag chain: [mitschud/DirtyFrag](https://github.com/mitschud/DirtyFrag), [diabl0w/DFRoot](https://github.com/diabl0w/DFRoot), [lsposed/lspromise](https://github.com/lsposed/lspromise), [polygraphene/DFReroot](https://github.com/polygraphene/DFReroot), [combeng6th/DirtyInit](https://github.com/combeng6th/DirtyInit).
- KSuRoot is based on [BuSung-dev/Root-My-Galaxy](https://github.com/BuSung-dev/Root-My-Galaxy); its baseline payload recipes derive from [boxiaolanya2008/CVE-2026-43499-Neo11Plus](https://github.com/boxiaolanya2008/CVE-2026-43499-Neo11Plus).

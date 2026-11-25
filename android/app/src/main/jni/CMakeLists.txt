cmake_minimum_required(VERSION 3.22.1)

# 静态链接 C++ 运行时（对应上游 -static-libstdc++）。必须在 project() 之前，
# 否则 NDK toolchain 已按默认值展开。三个子目标里只有 cve43499 是 C++。
set(ANDROID_STL c++_static)

project(aisupnative)

# DirtyFrag（CVE-2026-43284）：libdfroot.so + libbootstrap.so
add_subdirectory(dfroot)

# GhostKey（CVE-2026-98260）：libcve98260.so（PIE 可执行文件）
add_subdirectory(cve98260)

# GhostLock（CVE-2026-43499）：libghostlock.so（PIE 可执行文件）
add_subdirectory(cve43499)

# Stellar 特权服务引导器：libstellar_svc.so（PIE 可执行文件，随 APK 分发）
add_subdirectory(stellar)

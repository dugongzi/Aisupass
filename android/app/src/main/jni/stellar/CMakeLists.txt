cmake_minimum_required(VERSION 3.22.1)

project("stellar")

# 产物 libstellar_svc.so 是一个可执行文件，不是动态库。
#
# 为什么必须叫 lib*.so：AGP 只把 CMAKE_LIBRARY_OUTPUT_DIRECTORY 下匹配 lib*.so
# 的文件打进 APK 的 nativeLibraryDir，其它名字不会被分发到设备上。这是打包约束，
# 与任何既有项目的命名无关。
add_executable(stellar_starter svc_launcher.c)

set_target_properties(stellar_starter PROPERTIES
    OUTPUT_NAME "stellar_svc"
    PREFIX "lib"
    SUFFIX ".so"
    # AGP 只打包 CMAKE_LIBRARY_OUTPUT_DIRECTORY 下的产物；add_executable 默认落
    # RUNTIME_OUTPUT_DIRECTORY，不对齐就不会进 APK。
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}"
)

target_compile_options(stellar_starter PRIVATE
    -Wall
    -Wextra
    -O2
    -fPIE
)

target_link_options(stellar_starter PRIVATE
    -pie
    # Android 15+ 16KB 页设备要求 ELF LOAD 段 16KB 对齐，否则安装被拒。
    -Wl,-z,max-page-size=16384
    -Wl,-z,common-page-size=16384
)

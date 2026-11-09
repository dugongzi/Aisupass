cmake_minimum_required(VERSION 3.22)
project(dfroot)
enable_language(ASM)

set(JNI_DIR ${CMAKE_CURRENT_SOURCE_DIR})

# 追加 -I${CMAKE_CURRENT_BINARY_DIR}，让 .incbin "splicehelper" 找得到产物
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -I${JNI_DIR} -I${CMAKE_CURRENT_BINARY_DIR}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I${JNI_DIR} -Wall -Wextra -fno-stack-protector -fomit-frame-pointer")

# splicehelper 产物落 binary dir，不回写源码树
set(SPLICEHELPER "${CMAKE_CURRENT_BINARY_DIR}/splicehelper")
add_custom_command(
    OUTPUT "${SPLICEHELPER}"
    COMMAND "${CMAKE_C_COMPILER}"
            --target=${CMAKE_C_COMPILER_TARGET}
            --sysroot=${CMAKE_SYSROOT}
            "${JNI_DIR}/splicehelper.c"
            -o "${SPLICEHELPER}"
            -nodefaultlibs -nostartfiles -ffreestanding -static
    COMMAND "${CMAKE_STRIP}" "${SPLICEHELPER}"
    DEPENDS "${JNI_DIR}/splicehelper.c"
    COMMENT "Building splicehelper"
)
add_custom_target(splicehelper_bin DEPENDS "${SPLICEHELPER}")

set(KO_FILES
    "${JNI_DIR}/ko/dfroot-android12-5.10.ko"
    "${JNI_DIR}/ko/dfroot-android13-5.10.ko"
    "${JNI_DIR}/ko/dfroot-android13-5.15.ko"
    "${JNI_DIR}/ko/dfroot-android14-5.15.ko"
    "${JNI_DIR}/ko/dfroot-android14-6.1.ko"
    "${JNI_DIR}/ko/dfroot-android15-6.6.ko"
    "${JNI_DIR}/ko/dfroot-android16-6.12.ko"
    "${JNI_DIR}/ko/dfroot-android17-6.18.ko"
)

# ko 必须是按本项目包名编的。用 CMake 自身读写，不依赖 grep
foreach(ko IN LISTS KO_FILES)
    if(NOT EXISTS "${ko}")
        message(FATAL_ERROR "missing kernel module: ${ko}")
    endif()
    file(READ "${ko}" ko_hex HEX)
    string(TOLOWER "${ko_hex}" ko_hex)                                              # file(READ HEX) 输出大写，统一转小写
    string(FIND "${ko_hex}" "6f72672e7375706173732e61695f73755f70617373" hit_ours)  # "org.supass.ai_su_pass"
    string(FIND "${ko_hex}" "64662e726f6f74" hit_stale)                              # "df.root"
    if(hit_ours EQUAL -1)
        message(FATAL_ERROR "stale .ko (no org.supass.ai_su_pass): ${ko}")
    endif()
    if(NOT hit_stale EQUAL -1)
        message(FATAL_ERROR "stale .ko (still references df.root): ${ko}")
    endif()
endforeach()

add_executable(dfroot exp.c libcxx.S elf_parser.c)
add_dependencies(dfroot splicehelper_bin)
set_target_properties(dfroot PROPERTIES
    PREFIX "lib"
    SUFFIX ".so"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")

set_source_files_properties(exp.c PROPERTIES
    OBJECT_DEPENDS "${KO_FILES};${SPLICEHELPER}")

target_link_libraries(dfroot log)
target_link_options(dfroot PRIVATE -Wl,-z,max-page-size=16384)

# target 名与产物名分开，避免和上面的可执行体 dfroot 混淆
add_executable(dfroot_bootstrap bootstrap.c)
set_target_properties(dfroot_bootstrap PROPERTIES
    OUTPUT_NAME "bootstrap"
    PREFIX "lib"
    SUFFIX ".so"
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
target_link_options(dfroot_bootstrap PRIVATE -Wl,-z,max-page-size=16384)

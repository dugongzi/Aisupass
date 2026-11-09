package org.supass.ai_su_pass.dirtyfrag

/**
 * `libvrext.so` 的 JNI 入口。
 *
 * 符号名由 Rust 侧的 `#[no_mangle]` 决定：`nativeDerive` / `nativeProgress`
 * 的包名段必须是 `Java_org_supass_ai_1su_1pass_dirtyfrag_DirtyFragVrExtractor_*`。
 */
object DirtyFragVrExtractor {

    init {
        System.loadLibrary("vrext")
    }

    /**
     * 阻塞到提取结束，返回 JSON；失败时返回 `{"ok":false,"error":"..."}`。
     *
     * [workDir] 传缓存目录，Rust 会在其下建 `vrext/` 放下载与解包中间产物。
     */
    external fun nativeDerive(input: String, workDir: String, insecure: Boolean): String

    /** 即时进度：`"<phase> <done> <total>"`。不阻塞。 */
    external fun nativeProgress(): String
}

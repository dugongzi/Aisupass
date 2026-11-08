# 当前未开启 minify（libadb 的 AAR 没有 consumer-rules，开启前需要补齐依赖侧的 keep）。
# 这里只记录开启时必须保留下来的入口。

# conscrypt 在旧版 Android 上的平台适配类引用的是系统私有实现，
# 运行时不存在，仅用于编译期桥接，忽略缺失类告警。
-dontwarn com.android.org.conscrypt.**
-dontwarn org.apache.harmony.xnet.provider.jsse.**

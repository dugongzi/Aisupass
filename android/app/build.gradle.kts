plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "org.supass.ai_su_pass"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "org.supass.ai_su_pass"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // 无线调试配对与 mDNS 发现需要 Android 11+（API 30）。
        minSdk = 30
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 只打 64 位产物。
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
    }

    packaging {
        jniLibs {
            // 保留目录内 .so 原始字节，不压缩、不 strip。
            useLegacyPackaging = true
            keepDebugSymbols += "**/*.so"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // 注意：当前未开启 minify（libadb 的 AAR 没有 consumer-rules），
            // 规则先挂在这里，开启 minify 前需要补齐依赖侧的 keep。
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    // shell 通道（L1）唯一来源：应用内完成 ADB 无线调试配对，无需装任何外部 App。
    // - libadb-android：SPAKE2 配对 + TLS 连接 + ADB 协议 + shell 流，全在库内；
    // - sun-security-android：生成配对/连接共用的自签 X509 证书（包名已 repackage 为
    //   android.sun.security.x509.*，不是 JDK 的 sun.security.x509.*）；
    // - conscrypt-android：TLS 1.3 provider，libadb 的 SslUtils 会优先查找它。
    // 三者只在 JitPack 发布，仓库配置见 settings.gradle.kts / build.gradle.kts。
    implementation("com.github.MuntashirAkon:libadb-android:3.1.1")
    implementation("com.github.MuntashirAkon:sun-security-android:1.1")
    implementation("org.conscrypt:conscrypt-android:2.5.3")
}

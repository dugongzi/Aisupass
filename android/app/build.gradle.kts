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
        // 提权链路依赖 Android 11+ 的 /proc 可读性与分区布局假设。
        minSdk = 30
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 手册 §7.2：提权链的 launcher 只有 64 位实现，避免把不存在的 32 位产物带进包。
        ndk {
            abiFilters += listOf("arm64-v8a")
        }
    }

    packaging {
        jniLibs {
            // 手册 §7.2：launcher / so 必须是可直接 exec 的独立文件。
            // 不设 true 会被压进 APK，运行时无法执行。
            useLegacyPackaging = true
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")

            // 手册 §7.2：SupassService 由 app_process 按「类名字符串」反射拉起，
            // R8 一旦开启必须保留类名与 main 方法，否则 release 包必崩。
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

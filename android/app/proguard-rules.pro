# 特权进程入口必须是「类名 + main 方法」可反射调用的：
# SupassLauncher 用 CLASSPATH 环境变量把 base.apk 交给 app_process，
# 一旦 R8 混淆或裁掉，拉起时表现为 ClassNotFoundException / NoSuchMethodError。
-keep class org.supass.ai_su_pass.privileged.SupassService { *; }
-keep class org.supass.ai_su_pass.privileged.PrivilegedExecBinder { *; }
-keep class org.supass.ai_su_pass.privileged.SupassProtocol { *; }

# Provider 由 Manifest 声明、系统按类名实例化。
-keep class org.supass.ai_su_pass.core.privileged.SupassBinderProvider { *; }

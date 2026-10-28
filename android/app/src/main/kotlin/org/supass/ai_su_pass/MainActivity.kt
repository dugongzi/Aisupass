package org.supass.ai_su_pass

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeProvider.registerAll(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        // 只在真正退出时释放。配置变更或系统回收导致的销毁要保留会话：
        // 配对期间用户往往正停在系统设置里，此时把通知和接收器拆掉，
        // 他提交的配对码就无处可去。
        if (isFinishing) NativeProvider.dispose()
        super.onDestroy()
    }
}

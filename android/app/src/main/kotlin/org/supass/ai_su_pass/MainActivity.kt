package org.supass.ai_su_pass

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NativeProvider.registerAll(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onDestroy() {
        NativeProvider.dispose()
        super.onDestroy()
    }
}

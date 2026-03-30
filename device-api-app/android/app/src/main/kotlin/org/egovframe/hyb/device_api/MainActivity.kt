package org.egovframe.hyb.egovframe_mobile_deviceapi_app

import android.app.ActivityManager
import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    private val CHANNEL = "egovframe_mobile_deviceapi_app/ram_info"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ImageReader 버퍼 문제 해결을 위한 메모리 최적화
        System.setProperty("org.chromium.base.ThreadUtils.WILL_PAUSE_THREADS", "false")

        GeneratedPluginRegistrant.registerWith(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getTotalRam") {
                val ramInfo = getTotalRam()
                result.success(ramInfo)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getTotalRam(): String {
        try {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memInfo)
            
            // 총 RAM을 GB로 변환
            val totalRamGB = memInfo.totalMem / (1024.0 * 1024.0 * 1024.0)
            val availableRamGB = memInfo.availMem / (1024.0 * 1024.0 * 1024.0)
            
            //return "Total: ${String.format("%.1f", totalRamGB)} GB, Available: ${String.format("%.1f", availableRamGB)} GB"
            return "${String.format("%.1f", totalRamGB)}GB"
        } catch (e: Exception) {
            return "Unknown"
        }
    }
}

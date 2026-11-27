package org.egovframe.hyb.egovframe_mobile_deviceapi_app

import android.app.ActivityManager
import android.content.ContentValues
import android.content.Context
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.io.FileInputStream

class MainActivity : FlutterActivity() {
    private val ramChannel = "egovframe_mobile_deviceapi_app/ram_info"
    private val downloadsChannel = "egovframe_mobile_deviceapi_app/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ImageReader 버퍼 문제 해결을 위한 메모리 최적화
        System.setProperty("org.chromium.base.ThreadUtils.WILL_PAUSE_THREADS", "false")

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ramChannel)
            .setMethodCallHandler { call, result ->
                if (call.method == "getTotalRam") {
                    result.success(getTotalRam())
                } else {
                    result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, downloadsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "saveToDownloads" -> {
                        val sourcePath = call.argument<String>("sourcePath")
                        val displayName = call.argument<String>("displayName")
                        if (sourcePath.isNullOrBlank() || displayName.isNullOrBlank()) {
                            result.error("INVALID_ARGS", "Missing arguments", null)
                            return@setMethodCallHandler
                        }
                        try {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                saveToDownloadsMediaStore(sourcePath, displayName)
                            } else {
                                saveToDownloadsLegacy(sourcePath, displayName)
                            }
                            result.success(displayName)
                        } catch (e: Exception) {
                            result.error("SAVE_FAILED", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun getTotalRam(): String {
        try {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memInfo)

            val totalRamGB = memInfo.totalMem / (1024.0 * 1024.0 * 1024.0)
            return "${String.format("%.1f", totalRamGB)}GB"
        } catch (e: Exception) {
            return "Unknown"
        }
    }

    private fun saveToDownloadsMediaStore(sourcePath: String, displayName: String) {
        val contentValues = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
            put(MediaStore.MediaColumns.MIME_TYPE, "application/x-sqlite3")
            put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
        }

        val resolver = contentResolver
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, contentValues)
            ?: throw IllegalStateException("MediaStore insert failed")

        FileInputStream(sourcePath).use { input ->
            resolver.openOutputStream(uri)?.use { output ->
                input.copyTo(output)
            } ?: throw IllegalStateException("Output stream open failed")
        }
    }

    private fun saveToDownloadsLegacy(sourcePath: String, displayName: String) {
        val downloadsDir =
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!downloadsDir.exists()) {
            downloadsDir.mkdirs()
        }
        File(sourcePath).copyTo(File(downloadsDir, displayName), overwrite = true)
    }
}

import 'dart:io';

import 'package:flutter/services.dart';

import '../config/sqlite_config.dart';

class DownloadsExportChannel {
  static MethodChannel get _channel =>
      MethodChannel(SqliteConfig.downloadsMethodChannel);

  static Future<String> saveToDownloads({
    required String sourcePath,
    required String displayName,
  }) async {
    if (!Platform.isAndroid) {
      throw UnsupportedError('DownloadsExportChannel is Android only');
    }

    final result = await _channel.invokeMethod<String>('saveToDownloads', {
      'sourcePath': sourcePath,
      'displayName': displayName,
    });

    if (result == null || result.isEmpty) {
      throw StateError('downloads_unavailable');
    }

    return result;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// 앱 로컬 미디어 경로 ↔ 사진첩 자산 ID 매핑 저장소.
///
/// [MediaGalleryOptions.saveCameraCaptureToGallery]로 사진첩에 저장한 파일만
/// `Documents/media/.gallery_links.json`에 기록하여,
/// 로컬 삭제 시 사진첩에서도 삭제할 수 있게 합니다.
abstract final class MediaGalleryLinkStore {
  static const String _fileName = '.gallery_links.json';

  static Future<File> _storeFile() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${documentsDir.path}/media');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }
    return File('${mediaDir.path}/$_fileName');
  }

  static Future<Map<String, String>> _readAll() async {
    final file = await _storeFile();
    if (!await file.exists()) {
      return {};
    }
    try {
      final decoded = json.decode(await file.readAsString());
      if (decoded is! Map) return {};
      return decoded.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      );
    } catch (_) {
      return {};
    }
  }

  static Future<void> _writeAll(Map<String, String> links) async {
    final file = await _storeFile();
    await file.writeAsString(json.encode(links));
  }

  /// 로컬 경로와 사진첩 자산 ID를 연결합니다.
  static Future<void> link({
    required String localPath,
    required String assetId,
  }) async {
    final links = await _readAll();
    links[localPath] = assetId;
    await _writeAll(links);
  }

  /// 연결을 해제하고 사진첩 자산 ID를 반환합니다. (없으면 null)
  static Future<String?> unlink(String localPath) async {
    final links = await _readAll();
    final assetId = links.remove(localPath);
    await _writeAll(links);
    return assetId;
  }

  /// 연결된 사진첩 자산 ID 조회 (삭제 없음)
  static Future<String?> findAssetId(String localPath) async {
    final links = await _readAll();
    return links[localPath];
  }
}

import 'dart:io';

import 'package:egovframe_mobile_deviceapi_app/config/media_gallery_options.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/media_gallery_link_store.dart';
import 'package:photo_manager/photo_manager.dart';

/// 사진첩(갤러리) 연동 선택 기능 구현.
///
/// [MediaGalleryOptions]의 플래그가 `true`일 때만 동작하며,
/// `false`이면 호출해도 즉시 반환합니다. (기존 미디어 흐름 유지)
abstract final class MediaGalleryService {
  /// 카메라 촬영본을 사진첩에 복사 저장합니다.
  ///
  /// - [MediaGalleryOptions.saveCameraCaptureToGallery] == `true` 일 때만 실행
  /// - 성공 시 [MediaGalleryLinkStore]에 로컬 경로 ↔ 사진첩 자산 ID 기록
  static Future<bool> saveCameraCaptureToGallery({
    required String localPath,
    required bool isVideo,
  }) async {
    if (!MediaGalleryOptions.saveCameraCaptureToGallery) {
      return false;
    }

    final permission = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.addOnly,
      ),
    );
    if (!permission.hasAccess) {
      return false;
    }

    try {
      final file = File(localPath);
      if (!await file.exists()) {
        return false;
      }

      final fileName = file.path.split(Platform.pathSeparator).last;
      final AssetEntity entity;
      if (isVideo) {
        entity = await PhotoManager.editor.saveVideo(file, title: fileName);
      } else {
        entity = await PhotoManager.editor.saveImageWithPath(
          localPath,
          title: fileName,
        );
      }

      await MediaGalleryLinkStore.link(
        localPath: localPath,
        assetId: entity.id,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  /// 로컬 경로에 연동된 사진첩 자산을 삭제합니다.
  ///
  /// - [MediaGalleryOptions.deleteFromGalleryWhenLocalDeleted] == `true` 일 때만 실행
  /// - [MediaGalleryLinkStore]에 기록된 자산만 대상 (카메라 촬영 + 사진첩 저장 옵션 사용 파일)
  static Future<bool> deleteLinkedGalleryAsset(String localPath) async {
    if (!MediaGalleryOptions.deleteFromGalleryWhenLocalDeleted) {
      return false;
    }

    final assetId = await MediaGalleryLinkStore.unlink(localPath);
    if (assetId == null) {
      return false;
    }

    final permission = await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        iosAccessLevel: IosAccessLevel.readWrite,
      ),
    );
    if (!permission.hasAccess) {
      return false;
    }

    try {
      final deletedIds = await PhotoManager.editor.deleteWithIds([assetId]);
      return deletedIds.contains(assetId);
    } catch (_) {
      return false;
    }
  }
}

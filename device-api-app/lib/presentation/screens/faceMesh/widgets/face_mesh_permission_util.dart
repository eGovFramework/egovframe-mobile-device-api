import 'package:permission_handler/permission_handler.dart';

class FaceMeshPermissionUtil {
  static Future<bool> ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.camera.request();
    return result.isGranted;
  }

  static Future<bool> ensurePhotosPermission() async {
    final photos = await Permission.photos.status;
    if (photos.isGranted || photos.isLimited) {
      return true;
    }

    final photosResult = await Permission.photos.request();
    if (photosResult.isGranted || photosResult.isLimited) {
      return true;
    }

    // Android êµ¬ë²????photos ê¶í???ë ?ê²½
    final storage = await Permission.storage.status;
    if (storage.isGranted) {
      return true;
    }
    final storageResult = await Permission.storage.request();
    return storageResult.isGranted;
  }
}

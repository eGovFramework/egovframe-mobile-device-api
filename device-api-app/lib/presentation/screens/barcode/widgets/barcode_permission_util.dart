import 'package:permission_handler/permission_handler.dart';

class BarcodePermissionUtil {
  static Future<bool> ensureCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.camera.request();
    return result.isGranted;
  }
}

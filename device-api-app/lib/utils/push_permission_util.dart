import 'package:permission_handler/permission_handler.dart';

class PushPermissionUtil {
  static Future<bool> ensureNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.notification.request();
    return result.isGranted;
  }
}

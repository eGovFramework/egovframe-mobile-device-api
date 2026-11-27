import 'package:permission_handler/permission_handler.dart';

class CompassPermissionUtil {
  static Future<bool> ensureLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (status.isGranted) {
      return true;
    }

    final result = await Permission.locationWhenInUse.request();
    return result.isGranted;
  }
}

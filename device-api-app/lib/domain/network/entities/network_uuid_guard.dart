import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';

bool networkBelongsToDevice(NetworkInfo info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.deviceId.isNotEmpty &&
      info.deviceId == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

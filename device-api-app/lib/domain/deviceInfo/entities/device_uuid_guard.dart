import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';

bool deviceBelongsToDevice(DeviceInfo info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.uuid.isNotEmpty &&
      info.uuid == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

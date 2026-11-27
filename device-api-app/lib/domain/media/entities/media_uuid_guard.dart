import 'package:egovframe_mobile_deviceapi_app/domain/media/entities/media_info.dart';

bool mediaBelongsToDevice(MediaFileInfo info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.uuid != null &&
      info.uuid!.isNotEmpty &&
      info.uuid == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

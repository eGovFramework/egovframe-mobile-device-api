import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';

bool acceleratorBelongsToDevice(AcceleratorInfo info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.uuid.isNotEmpty &&
      info.uuid == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

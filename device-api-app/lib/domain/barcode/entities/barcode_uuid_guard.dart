import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';

bool barcodeBelongsToDevice(BarcodeInfo info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.uuid != null &&
      info.uuid!.isNotEmpty &&
      info.uuid == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

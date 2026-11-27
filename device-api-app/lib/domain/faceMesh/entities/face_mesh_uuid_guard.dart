import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';

bool faceMeshBelongsToDevice(FaceMeshRecord info, String deviceUuid) {
  return deviceUuid.isNotEmpty &&
      info.uuid != null &&
      info.uuid!.isNotEmpty &&
      info.uuid == deviceUuid;
}

bool isDeviceUuidValid(String deviceUuid) => deviceUuid.isNotEmpty;

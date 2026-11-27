import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_uuid_guard.dart';

/// Face Mesh 서버 저장소 (persist only)
class FaceMeshRemoteRepositoryImpl {
  Future<bool> uploadFaceMeshInfo(FaceMeshRecord info) async {
    final response =
        await FaceMeshService.postFaceMeshInfo(info.toUploadFields());
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    if (resultState == 'OK') {
      return true;
    }

    final useYn = (response['useYn'] ?? '').toString();
    return useYn == 'OK';
  }

  Future<List<FaceMeshRecord>> getFaceMeshList(
    String deviceUuid,
  ) async {
    final rawList = await FaceMeshService.fetchFaceMeshInfoList(
      uuid: deviceUuid,
    );
    return rawList.map(FaceMeshRecord.fromJson).toList();
  }

  Future<bool> deleteFaceMeshInfo(
    FaceMeshRecord info,
    String deviceUuid,
  ) async {
    if (!faceMeshBelongsToDevice(info, deviceUuid)) {
      return false;
    }

    final response = await FaceMeshService.deleteFaceMeshInfo(
      sn: info.sn,
      uuid: deviceUuid,
    );
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}

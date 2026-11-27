import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:image_picker/image_picker.dart';

abstract class FaceMeshRepository {
  Future<FaceMeshPickResult> pickAndDetect(ImageSource source);

  Future<FaceMeshProcessResult> detectFromFile(
    String imagePath, {
    String? source,
  });

  Future<List<DetectedFaceMeshInfo>> detectFromInputImageBytes({
    required List<int> bytes,
    required int width,
    required int height,
    required int rotationDegrees,
    required int bytesPerRow,
    required String formatRaw,
    bool enrichAttributes = false,
  });

  Future<bool> uploadFaceMeshInfo(FaceMeshRecord info);

  Future<List<FaceMeshRecord>> getFaceMeshList(String deviceUuid);

  Future<bool> deleteFaceMeshInfo(
    FaceMeshRecord info,
    String deviceUuid,
  );
}

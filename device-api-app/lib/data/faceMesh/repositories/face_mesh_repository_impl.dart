import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/datasources/face_mesh_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/repositories/face_mesh_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/faceMesh/repositories/face_mesh_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_record.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/repositories/face_mesh_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';
import 'package:image_picker/image_picker.dart';

/// detect는 항상 로컬 MediaPipe, persist는 remote/sqlite 전환
class FaceMeshRepositoryImpl implements FaceMeshRepository {
  final FaceMeshService _service;
  final FaceMeshRemoteRepositoryImpl _remote;
  final FaceMeshSqliteRepositoryImpl _sqlite;
  final FaceMeshConnectionReader _readConnection;

  FaceMeshRepositoryImpl({
    required FaceMeshService service,
    required FaceMeshRemoteRepositoryImpl remote,
    required FaceMeshSqliteRepositoryImpl sqlite,
    required FaceMeshConnectionReader readConnection,
  })  : _service = service,
        _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  bool get _useSqlite => _readConnection().isSqlite;

  @override
  Future<FaceMeshPickResult> pickAndDetect(ImageSource source) async {
    try {
      final picked = await _service.pickImage(source);
      if (picked == null) {
        return const FaceMeshPickCancelled();
      }

      final sourceLabel =
          source == ImageSource.camera ? 'camera' : 'gallery';
      final session = await _service.detectFacesFromFile(
        picked.path,
        source: sourceLabel,
      );
      return FaceMeshPickSuccess(session);
    } catch (e) {
      final message = e.toString().toLowerCase();
      if (message.contains('permission') ||
          message.contains('access') ||
          message.contains('denied')) {
        return const FaceMeshPickPermissionDenied();
      }
      return FaceMeshPickFailure(
        '${FaceMeshMessageKeys.pickErrorPrefix}$e',
      );
    }
  }

  @override
  Future<FaceMeshProcessResult> detectFromFile(
    String imagePath, {
    String? source,
  }) async {
    try {
      final session = await _service.detectFacesFromFile(
        imagePath,
        source: source,
      );
      if (session.hasFaces) {
        return FaceMeshProcessSuccess(session);
      }
      return FaceMeshProcessEmpty(session);
    } catch (e) {
      return FaceMeshProcessFailure(
        '${FaceMeshMessageKeys.detectErrorPrefix}$e',
      );
    }
  }

  @override
  Future<List<DetectedFaceMeshInfo>> detectFromInputImageBytes({
    required List<int> bytes,
    required int width,
    required int height,
    required int rotationDegrees,
    required int bytesPerRow,
    required String formatRaw,
    bool enrichAttributes = false,
  }) {
    return _service.detectFacesFromCameraImage(
      bytes: bytes,
      width: width,
      height: height,
      rotationDegrees: rotationDegrees,
      bytesPerRow: bytesPerRow,
      formatRaw: formatRaw,
      mirrorHorizontal: false,
      enrichAttributes: enrichAttributes,
    );
  }

  @override
  Future<bool> uploadFaceMeshInfo(FaceMeshRecord info) {
    if (_useSqlite) {
      return _sqlite.uploadFaceMeshInfo(info);
    }
    return _remote.uploadFaceMeshInfo(info);
  }

  @override
  Future<List<FaceMeshRecord>> getFaceMeshList(String deviceUuid) {
    if (_useSqlite) {
      return _sqlite.getFaceMeshList(deviceUuid);
    }
    return _remote.getFaceMeshList(deviceUuid);
  }

  @override
  Future<bool> deleteFaceMeshInfo(
    FaceMeshRecord info,
    String deviceUuid,
  ) {
    if (_useSqlite) {
      return _sqlite.deleteFaceMeshInfo(info, deviceUuid);
    }
    return _remote.deleteFaceMeshInfo(info, deviceUuid);
  }

  Future<void> dispose() => _service.close();
}

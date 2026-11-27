import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediapipe_face_mesh/mediapipe_face_mesh.dart';

/// MediaPipe Face Mesh 감지 + 서버 HTTP 통신 (device-api-web /fms REST)
class FaceMeshService {
  static final ImagePicker _picker = ImagePicker();

  /// 한 프레임/이미지에서 처리할 최대 얼굴 수 (detector · mesh 공통)
  static const int _maxMeshFaces = 3;

  /// Iris(홍채) landmark 포함 여부 (true → 보통 478점, false → 468점)
  static const bool _enableIris = false;

  FaceDetectorProcessor? _detector;
  FaceMeshProcessor? _mesh;
  FaceMeshInferencePipeline? _pipeline;
  Future<void>? _initFuture;

  Future<void> _ensureReady() {
    return _initFuture ??= _initProcessors();
  }

  Future<void> _initProcessors() async {
    _detector = await FaceDetectorProcessor.create(
      maxResults: _maxMeshFaces,
      delegate: FaceMeshDelegate.cpu,
    );
    _mesh = await FaceMeshProcessor.createForMultiFace(
      enableIris: _enableIris,
      delegate: FaceMeshDelegate.cpu,
    );
    _pipeline = FaceMeshInferencePipeline(
      detector: _detector!,
      mesh: _mesh!,
    );
  }

  Future<XFile?> pickImage(ImageSource source) async {
    return _picker.pickImage(
      source: source,
      maxWidth: 1920,
      maxHeight: 1080,
      imageQuality: 85,
    );
  }

  Future<FaceMeshSession> detectFacesFromFile(
    String imagePath, {
    String? source,
  }) async {
    await _ensureReady();
    final imageSize = await _resolveImageSize(imagePath);
    final bytes = await File(imagePath).readAsBytes();
    final rgba = await _decodeToRgba(bytes);
    if (rgba == null) {
      return FaceMeshSession(
        imagePath: imagePath,
        imageSize: imageSize,
        faces: const [],
        detectedAt: DateTime.now(),
        source: source,
      );
    }

    final input = FaceMeshImage(
      pixels: rgba.bytes,
      width: rgba.width,
      height: rgba.height,
      pixelFormat: FaceMeshPixelFormat.rgba,
    );

    final result = _pipeline!.processMultiFace(
      input,
      maxMeshFaces: _maxMeshFaces,
      rotationDegrees: 0,
      mirrorHorizontal: false,
    );

    final faces = <DetectedFaceMeshInfo>[];
    for (final tracked in result.faces) {
      faces.add(_mapMeshResult(tracked.mesh, trackId: tracked.trackId));
    }

    return FaceMeshSession(
      imagePath: imagePath,
      imageSize: Size(rgba.width.toDouble(), rgba.height.toDouble()),
      faces: faces,
      detectedAt: DateTime.now(),
      source: source,
    );
  }

  /// 서버: Face Mesh 정보 등록
  static Future<Map<String, dynamic>?> postFaceMeshInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(
      AppConfig.getFaceMeshUrl('/insertFaceMeshInfo.do'),
    );

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('FaceMeshService.postFaceMeshInfo failed: $e');
      return null;
    }
  }

  /// 서버: Face Mesh 정보 목록 조회 (uuid 필터)
  static Future<List<Map<String, dynamic>>> fetchFaceMeshInfoList({
    required String uuid,
  }) async {
    final uri = Uri.parse(
      AppConfig.getFaceMeshUrl('/selectFaceMeshInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('faceMeshInfoList');
    } catch (e) {
      appLog('FaceMeshService.fetchFaceMeshInfoList failed: $e');
      return [];
    }
  }

  /// 서버: Face Mesh 정보 삭제 (sn + uuid, soft delete USEYN='N')
  static Future<Map<String, dynamic>?> deleteFaceMeshInfo({
    required int sn,
    required String uuid,
  }) async {
    final uri = Uri.parse(
      AppConfig.getFaceMeshUrl('/deleteFaceMeshInfo.do'),
    ).replace(queryParameters: {'sn': sn.toString(), 'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('FaceMeshService.deleteFaceMeshInfo failed: $e');
      return null;
    }
  }

  Future<List<DetectedFaceMeshInfo>> detectFacesFromCameraImage({
    required List<int> bytes,
    required int width,
    required int height,
    required int rotationDegrees,
    required int bytesPerRow,
    required String formatRaw,
    bool mirrorHorizontal = false,
    bool enrichAttributes = false,
  }) async {
    await _ensureReady();
    // CameraImage plane buffer는 재사용되므로 반드시 복사
    final raw = Uint8List.fromList(bytes);

    if (formatRaw == 'nv21') {
      final nv21 = FaceMeshNv21Image.tryFromSinglePlane(
        bytes: raw,
        width: width,
        height: height,
        bytesPerRow: bytesPerRow,
      );
      if (nv21 == null) {
        return const [];
      }
      final multi = _pipeline!.processNv21MultiFace(
        nv21,
        maxMeshFaces: _maxMeshFaces,
        rotationDegrees: rotationDegrees,
        mirrorHorizontal: false,
      );
      return [
        for (final tracked in multi.faces)
          _mapMeshResult(
            tracked.mesh,
            trackId: tracked.trackId,
            enrichAttributes: enrichAttributes,
          ),
      ];
    }

    // iOS BGRA8888 (이미지 픽셀 표현 - BGRA 8비트 채널)
    final input = FaceMeshImage(
      pixels: raw,
      width: width,
      height: height,
      pixelFormat: FaceMeshPixelFormat.bgra,
      bytesPerRow: bytesPerRow,
    );
    final multi = _pipeline!.processMultiFace(
      input,
      maxMeshFaces: _maxMeshFaces,
      rotationDegrees: rotationDegrees,
      mirrorHorizontal: false,
    );
    return [
      for (final tracked in multi.faces)
        _mapMeshResult(
          tracked.mesh,
          trackId: tracked.trackId,
          enrichAttributes: enrichAttributes,
        ),
    ];
  }

  DetectedFaceMeshInfo _mapMeshResult(
    FaceMeshResult mesh, {
    required int? trackId,
    bool enrichAttributes = true,
  }) {
    final box = mesh.boundingRect();
    final normalized = [
      for (final lm in mesh.landmarks) Offset(lm.x, lm.y),
    ];
    final offsets = enrichAttributes
        ? mesh.landmarksAsOffsets()
        : const <Offset>[];

    double? pitch;
    double? yaw;
    double? roll;

    if (enrichAttributes) {
      try {
        final geometry = mesh.estimateGeometry();
        pitch = geometry.headPose.pitchDegrees;
        yaw = geometry.headPose.yawDegrees;
        roll = geometry.headPose.rollDegrees;
      } catch (e) {
        appLog('FaceMeshService estimateGeometry failed: $e');
      }
    }

    return DetectedFaceMeshInfo.fromMeshParts(
      boundingBox: box,
      landmarks: offsets,
      normalizedLandmarks: normalized,
      landmarkCount: mesh.landmarks.length,
      headEulerAngleX: pitch,
      headEulerAngleY: yaw,
      headEulerAngleZ: roll,
      trackingId: trackId,
      score: mesh.score,
    );
  }

  Future<_RgbaImage?> _decodeToRgba(Uint8List bytes) async {
    try {
      final codec = await instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final byteData = await image.toByteData(format: ImageByteFormat.rawRgba);
      if (byteData == null) {
        image.dispose();
        return null;
      }
      final result = _RgbaImage(
        width: image.width,
        height: image.height,
        bytes: byteData.buffer.asUint8List(),
      );
      image.dispose();
      return result;
    } catch (e) {
      appLog('FaceMeshService._decodeToRgba failed: $e');
      return null;
    }
  }

  Future<Size> _resolveImageSize(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      return Size.zero;
    }

    final bytes = await file.readAsBytes();
    final codec = await instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final size = Size(image.width.toDouble(), image.height.toDouble());
    image.dispose();
    return size;
  }

  Future<void> close() async {
    _pipeline?.resetTracking();
    _pipeline = null;
    _mesh?.close();
    _mesh = null;
    _detector?.close();
    _detector = null;
    _initFuture = null;
  }
}

class _RgbaImage {
  final int width;
  final int height;
  final Uint8List bytes;

  const _RgbaImage({
    required this.width,
    required this.height,
    required this.bytes,
  });
}

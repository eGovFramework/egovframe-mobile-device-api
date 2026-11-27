import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/faceMesh/entities/face_mesh_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/face_mesh_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/faceMesh/widgets/face_painter.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/button.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaceMeshCameraPage extends ConsumerStatefulWidget {
  const FaceMeshCameraPage({super.key});

  @override
  ConsumerState<FaceMeshCameraPage> createState() => _FaceMeshCameraPageState();
}

class _FaceMeshCameraPageState extends ConsumerState<FaceMeshCameraPage> {
  CameraController? _controller;
  bool _isBusy = false;
  bool _isCapturing = false;
  bool _hasHandledError = false;
  List<DetectedFaceMeshInfo> _faces = const [];
  Size _imageSize = Size.zero;
  CameraLensDirection _lensDirection = CameraLensDirection.front;

  static const _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void initState() {
    super.initState();
    unawaited(_initCamera());
  }

  @override
  void dispose() {
    final controller = _controller;
    _controller = null;
    unawaited(_disposeController(controller));
    super.dispose();
  }

  Future<void> _disposeController(CameraController? controller) async {
    if (controller == null) return;
    if (controller.value.isStreamingImages) {
      await controller.stopImageStream();
    }
    await controller.dispose();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        await _showCameraError(FaceMeshMessageKeys.cameraUnavailable);
        return;
      }

      final preferred = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      await _startCamera(preferred);
    } catch (e) {
      await _showCameraError('${FaceMeshMessageKeys.cameraErrorPrefix}$e');
    }
  }

  Future<void> _startCamera(CameraDescription description) async {
    final previous = _controller;
    _controller = null;
    await _disposeController(previous);

    final controller = CameraController(
      description,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    _controller = controller;
    _lensDirection = description.lensDirection;

    await controller.initialize();
    if (!mounted) return;

    await controller.startImageStream(_onCameraImage);
    setState(() {});
  }

  Future<void> _switchCamera() async {
    final cameras = await availableCameras();
    if (cameras.length < 2 || _controller == null) return;

    final current = _controller!.description.lensDirection;
    final next = cameras.firstWhere(
      (c) => c.lensDirection != current,
      orElse: () => cameras.first,
    );
    await _startCamera(next);
  }

  void _onCameraImage(CameraImage image) {
    if (_isBusy || _isCapturing || !mounted) return;

    final input = _buildFrameInput(image);
    if (input == null) return;

    _isBusy = true;
    unawaited(
      _processFrame(
        input,
        Size(image.width.toDouble(), image.height.toDouble()),
      ),
    );
  }

  Future<void> _processFrame(_CameraFrameInput input, Size imageSize) async {
    try {
      final faces =
          await ref.read(faceMeshUseCaseProvider).detectFromCameraFrame(
                bytes: input.bytes,
                width: input.width,
                height: input.height,
                // 추론에도 rotation을 넘겨 검출 정확도를 유지
                rotationDegrees: input.rotationDegrees,
                bytesPerRow: input.bytesPerRow,
                formatRaw: input.formatRaw,
                enrichAttributes: false,
              );

      if (!mounted) return;
      setState(() {
        _faces = faces;
        _imageSize = imageSize;
      });
    } catch (_) {
      // Ignore frame errors and continue processing
    } finally {
      _isBusy = false;
    }
  }

  _CameraFrameInput? _buildFrameInput(CameraImage image) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return null;

    final camera = controller.description;
    final sensorOrientation = camera.sensorOrientation;
    int? rotationDegrees;

    if (Platform.isIOS) {
      // mediapipe 예제: iOS는 deviceOrientation 사용
      rotationDegrees =
          _orientations[controller.value.deviceOrientation] ?? 0;
    } else if (Platform.isAndroid) {
      final deviceOrientation = controller.value.deviceOrientation;
      var rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation =
            (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotationDegrees = rotationCompensation;
    }
    if (rotationDegrees == null) return null;

    if (image.planes.isEmpty) return null;
    final plane = image.planes.first;

    return _CameraFrameInput(
      bytes: Uint8List.fromList(plane.bytes),
      width: image.width,
      height: image.height,
      rotationDegrees: rotationDegrees,
      bytesPerRow: plane.bytesPerRow,
      formatRaw: Platform.isAndroid ? 'nv21' : 'bgra8888',
    );
  }

  Future<void> _captureAndDetect() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      final file = await controller.takePicture();

      final result = await ref
          .read(faceMeshUseCaseProvider)
          .detectFromFile(file.path, source: 'camera');

      if (!mounted) return;

      switch (result) {
        case FaceMeshProcessSuccess(:final session):
        case FaceMeshProcessEmpty(:final session):
          if (!mounted) return;
          Navigator.of(context).pop(session);
        case FaceMeshProcessFailure(:final message):
          await _showCameraError(message);
      }
    } catch (e) {
      await _showCameraError('${FaceMeshMessageKeys.cameraErrorPrefix}$e');
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _showCameraError(String message) async {
    if (_hasHandledError || !mounted) return;
    _hasHandledError = true;

    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'FaceMeshCameraPage.cameraError',
    );

    final errorType = ErrorHandler.detectErrorType(localizedMessage);
    final errorMessage = ErrorHandler.getErrorMessage(
      localizedMessage,
      errorType,
    );

    await ErrorHandler.showErrorDialog(
      context,
      errorMessage,
      title: l10n.commonError,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// CameraPreview가 기대하는 표시 크기 (portrait면 세로 비율)
  Size _previewDisplaySize(CameraController controller) {
    final preview = controller.value.previewSize;
    if (preview == null) {
      return const Size(3, 4);
    }
    final landscape = <DeviceOrientation>[
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ].contains(controller.value.deviceOrientation);

    // camera_preview.dart와 동일: portrait면 aspect 반전
    if (landscape) {
      return Size(preview.width, preview.height);
    }
    return Size(preview.height, preview.width);
  }

  /// CameraPreview child 좌표계에서는 추가 회전을 넣으면 ±90°로 틀어진다.
  /// (추론 단계 rotation과 중복 보정) → 오버레이는 0 고정
  int get _overlayRotationDegrees => 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = _controller;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Face Mesh Camera',
        actions: [
          IconButton(
            onPressed: _isCapturing ? null : _switchCamera,
            icon: const Icon(Icons.cameraswitch_outlined),
            tooltip: l10n.faceMeshSwitchCamera,
          ),
        ],
      ),
      backgroundColor: EgovColor.gray90,
      body: controller == null || !controller.value.isInitialized
          ? const Center(
              child: CircularProgressIndicator(color: EgovColor.white100),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final displaySize = _previewDisplaySize(controller);
                final mirror = faceMeshShouldMirrorPreview(_lensDirection);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // 화면을 채우되, 미리보기·오버레이는 동일 좌표계 공유
                    FittedBox(
                      fit: BoxFit.cover,
                      clipBehavior: Clip.hardEdge,
                      child: SizedBox(
                        width: displaySize.width,
                        height: displaySize.height,
                        child: CameraPreview(
                          controller,
                          child: (_faces.isNotEmpty)
                              ? CustomPaint(
                                  size: displaySize,
                                  painter: FaceMeshOverlayPainter(
                                    faces: _faces,
                                    imageSize: _imageSize,
                                    rotationDegrees: _overlayRotationDegrees,
                                    mirrorHorizontal: mirror,
                                    renderMode: FaceMeshRenderMode.points,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        color: Colors.black.withValues(alpha: 0.45),
                        child: Text(
                          _faces.isEmpty
                              ? '얼굴 없음'
                              : '얼굴 ${_faces.length} · '
                                  '랜드마크 ${_faces.first.landmarkCount}'
                                  '${_faces.first.hasIris ? ' · iris' : ''}'
                                  '${_faces.first.score != null ? ' · score ${_faces.first.score!.toStringAsFixed(2)}' : ''}',
                          style: EgovText.medium.copyWith(
                            color: EgovColor.white100,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      // 갤럭시 하단 시스템 네비/제스처 바 높이만큼 올림
                      bottom: 24 + MediaQuery.viewPaddingOf(context).bottom,
                      child: Column(
                        children: [
                          Text(
                            'Align your face and capture to save the mesh session.',
                            style: EgovText.medium.copyWith(
                              color: EgovColor.white100,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: l10n.faceMeshCaptureButton,
                            isLoading: _isCapturing,
                            onTap: _isCapturing ? null : _captureAndDetect,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: EgovColor.white100,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ), 
                  ],
                );
              },
            ),
    );
  }
}

class _CameraFrameInput {
  final Uint8List bytes;
  final int width;
  final int height;
  final int rotationDegrees;
  final int bytesPerRow;
  final String formatRaw;

  const _CameraFrameInput({
    required this.bytes,
    required this.width,
    required this.height,
    required this.rotationDegrees,
    required this.bytesPerRow,
    required this.formatRaw,
  });
}

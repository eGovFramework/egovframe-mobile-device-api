import 'dart:async';

import 'package:camera/camera.dart' show CameraException;
import 'package:egovframe_mobile_deviceapi_app/data/barcode/datasources/barcode_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan_session_result.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_localizations.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/app_message_resolver.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/barcode_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/color_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/resources/text_style.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/appbar.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/widgets/barcode_scan_overlay.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';

const Duration _barcodeReadTimeout = Duration(seconds: 30);

class BarcodeScanPage extends StatefulWidget {
  const BarcodeScanPage({super.key});

  @override
  State<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  Timer? _watchTimeout;
  bool _hasDetected = false;
  bool _hasHandledError = false;

  @override
  void initState() {
    super.initState();
    _watchTimeout = Timer(_barcodeReadTimeout, _onWatchTimeout);
  }

  @override
  void dispose() {
    _watchTimeout?.cancel();
    super.dispose();
  }

  Future<void> _showCameraError(String message) async {
    if (_hasHandledError || !mounted) return;
    _hasHandledError = true;
    _watchTimeout?.cancel();

    final l10n = AppLocalizations.of(context)!;
    final localizedMessage = resolveAppMessage(l10n, message);
    ErrorHandler.logError(
      localizedMessage,
      null,
      context: 'BarcodeScanPage.cameraError',
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

  Future<void> _onWatchTimeout() async {
    if (_hasDetected || _hasHandledError || !mounted) return;
    await _showCameraError(BarcodeMessageKeys.cameraUnavailable);
  }

  /// flutter_zxing: 코드 인식 성공 콜백
  void _onScan(Code code) {
    if (_hasDetected || _hasHandledError || !mounted) return;

    final scan = BarcodeService.scanFromCode(code);
    if (scan == null) return;

    _hasDetected = true;
    _watchTimeout?.cancel();

    Navigator.of(context).pop(
      BarcodeScanSessionResult(
        scan: scan,
        capturedAt: DateTime.now(),
      ),
    );
  }

  /// flutter_zxing: 카메라 컨트롤러 생성 결과 콜백 (초기화 실패 시 error 전달)
  void _onControllerCreated(CameraController? controller, Exception? error) {
    if (error == null) return;

    final detail = error is CameraException
        ? error.code
        : error.runtimeType.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showCameraError('${BarcodeMessageKeys.cameraErrorPrefix}$detail');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.barcodeScanPageTitle),
      backgroundColor: EgovColor.gray90,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scanWindow = barcodeScanWindowForSize(
            constraints.biggest,
            cropPercent: BarcodeService.scanCropPercent,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              ReaderWidget(
                onScan: _onScan,
                onControllerCreated: _onControllerCreated,
                codeFormat: BarcodeService.scanCodeFormat,
                cropPercent: BarcodeService.scanCropPercent,
                scanDelay: BarcodeService.scanDelay,
                scanDelaySuccess: BarcodeService.scanDelaySuccess,
                tryHarder: true,
                tryRotate: true,
                tryInverted: true,
                isMultiScan: false,
                showScannerOverlay: false,
                showFlashlight: false,
                showGallery: false,
                showToggleCamera: false,
                allowPinchZoom: false,
                lensDirection: CameraLensDirection.back,
                resolution: ResolutionPreset.high,
                loading: const Center(
                  child: CircularProgressIndicator(color: EgovColor.white100),
                ),
              ),
              IgnorePointer(
                child: CustomPaint(
                  // 스캔 가이드
                  painter: BarcodeScanOverlay(scanWindow: scanWindow),
                  size: constraints.biggest,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: Text(
                    l10n.barcodeScanPageHint,
                    style: EgovText.medium.copyWith(color: EgovColor.white100),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

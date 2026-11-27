import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan.dart';

class BarcodeScanSessionResult {
  final BarcodeScan scan;
  final DateTime capturedAt;

  const BarcodeScanSessionResult({
    required this.scan,
    required this.capturedAt,
  });
}

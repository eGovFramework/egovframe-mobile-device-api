import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan.dart';

class BarcodeMainState {
  final bool isLoading;
  final DateTime? capturedAt;
  final String uuid;
  final BarcodeScan scan;

  const BarcodeMainState({
    required this.isLoading,
    this.capturedAt,
    required this.uuid,
    required this.scan,
  });

  factory BarcodeMainState.initial() {
    return const BarcodeMainState(
      isLoading: true,
      uuid: '',
      scan: BarcodeScan.inactive(),
    );
  }

  bool get hasCapturedReading => capturedAt != null && scan.hasReading;

  BarcodeMainState copyWith({
    bool? isLoading,
    DateTime? capturedAt,
    bool clearCapturedAt = false,
    String? uuid,
    BarcodeScan? scan,
  }) {
    return BarcodeMainState(
      isLoading: isLoading ?? this.isLoading,
      capturedAt: clearCapturedAt ? null : (capturedAt ?? this.capturedAt),
      uuid: uuid ?? this.uuid,
      scan: scan ?? this.scan,
    );
  }
}

class BarcodeListState {
  final bool isLoading;
  final List<BarcodeInfo> barcodeList;
  final String errorMessage;

  const BarcodeListState({
    required this.isLoading,
    required this.barcodeList,
    required this.errorMessage,
  });

  factory BarcodeListState.initial() {
    return const BarcodeListState(
      isLoading: true,
      barcodeList: [],
      errorMessage: '',
    );
  }

  BarcodeListState copyWith({
    bool? isLoading,
    List<BarcodeInfo>? barcodeList,
    String? errorMessage,
  }) {
    return BarcodeListState(
      isLoading: isLoading ?? this.isLoading,
      barcodeList: barcodeList ?? this.barcodeList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

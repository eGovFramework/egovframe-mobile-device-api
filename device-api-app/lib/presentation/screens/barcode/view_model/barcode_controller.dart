import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/entities/barcode_scan_session_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/barcode/usecases/barcode_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/barcode_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/barcode/state/barcode_state.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'barcode_controller.g.dart';

BarcodeUseCase _barcodeUseCase(Ref ref) => ref.read(barcodeUseCaseProvider);

@riverpod
class BarcodeMain extends _$BarcodeMain {
  @override
  BarcodeMainState build() {
    Future.microtask(_initialize);
    return BarcodeMainState.initial();
  }

  Future<void> _initialize() async {
    final uuid = await _barcodeUseCase(ref).getDeviceUuid();
    state = state.copyWith(isLoading: false, uuid: uuid);
  }

  void applyScanResult(BarcodeScanSessionResult result) {
    state = state.copyWith(
      scan: result.scan,
      capturedAt: result.capturedAt,
    );
  }

  BarcodeInfo? buildUploadInfo() {
    final scan = state.scan;
    final capturedAt = state.capturedAt;
    if (!scan.hasReading || capturedAt == null) {
      return null;
    }

    return BarcodeInfo(
      sn: 0,
      uuid: state.uuid.isEmpty ? null : state.uuid,
      codeType: scan.codeType!,
      codeText: scan.codeText!,
      useYn: 'Y',
      codeDt: KstDateTimeUtil.format(capturedAt),
    );
  }

  Future<BarcodeUploadResult> uploadBarcodeInfo() async {
    final info = buildUploadInfo();
    if (info == null) {
      return const BarcodeUploadFailure(BarcodeMessageKeys.noScanData);
    }
    return _barcodeUseCase(ref).uploadBarcodeToServer(info);
  }
}

@riverpod
class BarcodeList extends _$BarcodeList {
  @override
  BarcodeListState build() {
    Future.microtask(reload);
    return BarcodeListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _barcodeUseCase(ref).loadBarcodeList();

    switch (result) {
      case BarcodeListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          barcodeList: items,
          errorMessage: '',
        );
      case BarcodeListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          barcodeList: [],
          errorMessage: '',
        );
      case BarcodeListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          barcodeList: [],
          errorMessage: message,
        );
    }
  }

  Future<BarcodeDeleteBatchResult> deleteSelectedItems(
    List<BarcodeInfo> items,
  ) async {
    return _barcodeUseCase(ref).deleteBarcodeItems(items);
  }
}

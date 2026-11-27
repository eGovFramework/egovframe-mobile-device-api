import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/gps/usecases/gps_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/gps_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/gps/state/gps_state.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gps_controller.g.dart';

GpsUseCase _gpsUseCase(Ref ref) => ref.read(gpsUseCaseProvider);

Position _toPosition(GpsInfo info) {
  return Position(
    latitude: info.latitude,
    longitude: info.longitude,
    timestamp: info.timestamp,
    accuracy: info.accrcy ?? 0,
    altitude: info.altitude ?? 0,
    heading: 0,
    speed: 0,
    speedAccuracy: 0,
    altitudeAccuracy: 0,
    headingAccuracy: 0,
  );
}

@riverpod
class GpsMain extends _$GpsMain {
  @override
  GpsMainState build() {
    Future.microtask(initialize);
    return GpsMainState.initial();
  }

  Future<void> initialize() async {
    final useCase = _gpsUseCase(ref);
    final deviceUuid = await useCase.getDeviceUuid();
    final permission = await useCase.resolveLocationPermission();

    state = state.copyWith(
      deviceUuid: deviceUuid,
      statusMessage: permission.statusMessage,
    );

    await reloadLocalGpsList();
  }

  Future<void> reloadLocalGpsList() async {
    if (state.deviceUuid.isEmpty) return;

    state = state.copyWith(isLoading: true);
    final result = await _gpsUseCase(ref).loadServerGpsList(state.deviceUuid);

    switch (result) {
      case GpsListLoadSuccess(:final items):
        state = state.copyWith(isLoading: false, savedGpsList: items);
      case GpsListLoadEmpty():
        state = state.copyWith(isLoading: false, savedGpsList: []);
      case GpsListLoadFailure():
        state = state.copyWith(isLoading: false, savedGpsList: []);
    }
  }

  /// 현재 위치 조회. UI는 반환값으로 토스트/설정 다이얼로그 처리
  Future<GpsLocationResult> fetchCurrentLocation() async {
    state = state.copyWith(isLoading: true);

    final result = await _gpsUseCase(
      ref,
    ).fetchCurrentLocation(state.deviceUuid);

    switch (result) {
      case GpsLocationSuccess(:final location):
        state = state.copyWith(
          isLoading: false,
          currentPosition: _toPosition(location),
          statusMessage: state.statusMessage,
        );
      case GpsLocationPermissionDenied(:final permission):
        state = state.copyWith(
          isLoading: false,
          statusMessage: permission.statusMessage,
        );
      case GpsLocationFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }

  void updatePositionFromMap(Position position) {
    state = state.copyWith(currentPosition: position);
  }

  Future<GpsSaveResult> saveCurrentLocation() async {
    final position = state.currentPosition;
    if (position == null) {
      return const GpsSaveFailure(GpsMessageKeys.saveNoLocation);
    }

    state = state.copyWith(
      isLoading: true,
      statusMessage: GpsMessageKeys.savingInProgress,
    );

    final location = GpsInfo.fromPosition(position, state.deviceUuid);
    final result = await _gpsUseCase(ref).saveLocationToServer(location);

    switch (result) {
      case GpsSaveSuccess():
        state = state.copyWith(
          isLoading: false,
          statusMessage: GpsMessageKeys.savedStatus,
        );
        await reloadLocalGpsList();
      case GpsSaveFailure(:final message):
        state = state.copyWith(isLoading: false, statusMessage: message);
    }

    return result;
  }

  Future<GpsDeleteBatchResult> deleteSelectedItems(List<GpsInfo> items) {
    return _gpsUseCase(ref).deleteGpsItems(items);
  }

  Future<bool> simulateServerUpload() async {
    if (state.savedGpsList.isEmpty) {
      return false;
    }
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(statusMessage: GpsMessageKeys.uploadedStatus);
    return true;
  }
}

@riverpod
class GpsList extends _$GpsList {
  @override
  GpsListState build() {
    Future.microtask(initialize);
    return GpsListState.initial();
  }

  Future<void> initialize() async {
    final deviceUuid = await _gpsUseCase(ref).getDeviceUuid();
    state = state.copyWith(deviceUuid: deviceUuid);
    await reload();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _gpsUseCase(ref).loadServerGpsList(state.deviceUuid);

    switch (result) {
      case GpsListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          gpsInfoList: items,
          errorMessage: '',
        );
      case GpsListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          gpsInfoList: [],
          errorMessage: '',
        );
      case GpsListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          gpsInfoList: [],
          errorMessage: message,
        );
    }
  }

  Future<GpsDeleteBatchResult> deleteSelectedItems(List<GpsInfo> items) {
    return _gpsUseCase(ref).deleteGpsItems(items);
  }
}

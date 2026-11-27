import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/usecases/device_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/device_info_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/deviceInfo/state/device_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_controller.g.dart';

DeviceUseCase _deviceUseCase(Ref ref) => ref.read(deviceUseCaseProvider);

@riverpod
class DeviceInfoMain extends _$DeviceInfoMain {
  @override
  DeviceInfoMainState build() {
    Future.microtask(loadDeviceInfo);
    return DeviceInfoMainState.initial();
  }

  Future<DeviceLoadResult> loadDeviceInfo() async {
    state = state.copyWith(isLoading: true, clearLoadError: true);

    final result = await _deviceUseCase(ref).loadLocalDeviceInfo();

    switch (result) {
      case DeviceLoadSuccess(:final device):
        state = state.copyWith(
          isLoading: false,
          deviceInfo: device,
          clearLoadError: true,
        );
      case DeviceLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          clearDeviceInfo: true,
          loadError: message,
        );
    }

    return result;
  }

  Future<DeviceUploadResult> uploadDeviceInfo() async {
    final device = state.deviceInfo;
    if (device == null) {
      return const DeviceUploadFailure(DeviceInfoMessageKeys.noUploadData);
    }

    return _deviceUseCase(ref).uploadDeviceToServer(device);
  }
}

@riverpod
class DeviceList extends _$DeviceList {
  @override
  DeviceListState build(String uuid) {
    Future.microtask(reload);
    return DeviceListState.initial(uuid: uuid);
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _deviceUseCase(ref).loadServerDeviceList(state.uuid);

    switch (result) {
      case DeviceListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          deviceList: items,
          errorMessage: '',
        );
      case DeviceListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          deviceList: [],
          errorMessage: '',
        );
      case DeviceListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          deviceList: [],
          errorMessage: message,
        );
    }
  }
}

@riverpod
class DeviceDetail extends _$DeviceDetail {
  @override
  DeviceDetailState build(int sn) {
    return DeviceDetailState.initial(sn: sn);
  }

  void initialize(DeviceInfo fallbackDevice) {
    state = state.copyWith(fallbackDevice: fallbackDevice);
    Future.microtask(loadDetail);
  }

  Future<void> loadDetail() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _deviceUseCase(ref).loadDeviceDetail(state.sn);

    switch (result) {
      case DeviceDetailLoadSuccess(:final device):
        state = state.copyWith(
          isLoading: false,
          deviceInfo: device,
          clearError: true,
        );
      case DeviceDetailLoadNotFound(:final message):
        state = state.copyWith(
          isLoading: false,
          clearDeviceInfo: true,
          errorMessage: message,
        );
      case DeviceDetailLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          clearDeviceInfo: true,
          errorMessage: message,
        );
    }
  }

  Future<DeviceDeleteResult> deleteDevice() async {
    state = state.copyWith(isDeleting: true);

    final sn = state.deviceInfo?.sn ?? state.fallbackDevice?.sn ?? state.sn;
    final device = state.deviceInfo ?? state.fallbackDevice;
    final result = await _deviceUseCase(ref).deleteDeviceFromServer(
      sn,
      device: device,
    );

    state = state.copyWith(isDeleting: false);

    return result;
  }
}

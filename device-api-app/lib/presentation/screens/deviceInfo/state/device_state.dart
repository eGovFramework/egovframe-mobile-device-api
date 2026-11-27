import 'package:egovframe_mobile_deviceapi_app/domain/deviceInfo/entities/device_info.dart';

class DeviceInfoMainState {
  final DeviceInfo? deviceInfo;
  final bool isLoading;
  final String? loadError;

  const DeviceInfoMainState({
    this.deviceInfo,
    this.isLoading = true,
    this.loadError,
  });

  factory DeviceInfoMainState.initial() => const DeviceInfoMainState();

  DeviceInfoMainState copyWith({
    DeviceInfo? deviceInfo,
    bool? isLoading,
    String? loadError,
    bool clearDeviceInfo = false,
    bool clearLoadError = false,
  }) {
    return DeviceInfoMainState(
      deviceInfo: clearDeviceInfo ? null : (deviceInfo ?? this.deviceInfo),
      isLoading: isLoading ?? this.isLoading,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
    );
  }
}

class DeviceListState {
  final String uuid;
  final List<DeviceInfo> deviceList;
  final bool isLoading;
  final String errorMessage;

  const DeviceListState({
    this.uuid = '',
    this.deviceList = const [],
    this.isLoading = true,
    this.errorMessage = '',
  });

  factory DeviceListState.initial({required String uuid}) =>
      DeviceListState(uuid: uuid);

  DeviceListState copyWith({
    String? uuid,
    List<DeviceInfo>? deviceList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DeviceListState(
      uuid: uuid ?? this.uuid,
      deviceList: deviceList ?? this.deviceList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DeviceDetailState {
  final int sn;
  final DeviceInfo? fallbackDevice;
  final DeviceInfo? deviceInfo;
  final bool isLoading;
  final bool isDeleting;
  final String? errorMessage;

  const DeviceDetailState({
    required this.sn,
    this.fallbackDevice,
    this.deviceInfo,
    this.isLoading = true,
    this.isDeleting = false,
    this.errorMessage,
  });

  factory DeviceDetailState.initial({
    required int sn,
    DeviceInfo? fallbackDevice,
  }) => DeviceDetailState(sn: sn, fallbackDevice: fallbackDevice);

  DeviceDetailState copyWith({
    int? sn,
    DeviceInfo? fallbackDevice,
    DeviceInfo? deviceInfo,
    bool? isLoading,
    bool? isDeleting,
    String? errorMessage,
    bool clearError = false,
    bool clearDeviceInfo = false,
  }) {
    return DeviceDetailState(
      sn: sn ?? this.sn,
      fallbackDevice: fallbackDevice ?? this.fallbackDevice,
      deviceInfo: clearDeviceInfo ? null : (deviceInfo ?? this.deviceInfo),
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

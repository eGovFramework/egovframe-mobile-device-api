import 'package:egovframe_mobile_deviceapi_app/domain/gps/entities/gps_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/gps_message_keys.dart';
import 'package:geolocator/geolocator.dart';

class GpsMainState {
  final String deviceUuid;
  final String statusMessage;
  final bool isLoading;
  final Position? currentPosition;
  final List<GpsInfo> savedGpsList;

  const GpsMainState({
    this.deviceUuid = '',
    this.statusMessage = GpsMessageKeys.permissionGranted,
    this.isLoading = false,
    this.currentPosition,
    this.savedGpsList = const [],
  });

  factory GpsMainState.initial() => const GpsMainState();

  GpsMainState copyWith({
    String? deviceUuid,
    String? statusMessage,
    bool? isLoading,
    Position? currentPosition,
    bool clearPosition = false,
    List<GpsInfo>? savedGpsList,
  }) {
    return GpsMainState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      statusMessage: statusMessage ?? this.statusMessage,
      isLoading: isLoading ?? this.isLoading,
      currentPosition: clearPosition
          ? null
          : (currentPosition ?? this.currentPosition),
      savedGpsList: savedGpsList ?? this.savedGpsList,
    );
  }
}

class GpsListState {
  final String deviceUuid;
  final List<GpsInfo> gpsInfoList;
  final bool isLoading;
  final String errorMessage;

  const GpsListState({
    this.deviceUuid = '',
    this.gpsInfoList = const [],
    this.isLoading = true,
    this.errorMessage = '',
  });

  factory GpsListState.initial() => const GpsListState();

  GpsListState copyWith({
    String? deviceUuid,
    List<GpsInfo>? gpsInfoList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GpsListState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      gpsInfoList: gpsInfoList ?? this.gpsInfoList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

import 'package:egovframe_mobile_deviceapi_app/domain/network/entities/network_info.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/network_message_keys.dart';

class NetworkMainState {
  final NetworkInfo? currentNetworkInfo;
  final bool isConnected;
  final String networkQuality;
  final bool isLoading;

  const NetworkMainState({
    this.currentNetworkInfo,
    this.isConnected = false,
    this.networkQuality = NetworkMessageKeys.unknownQuality,
    this.isLoading = false,
  });

  factory NetworkMainState.initial() => const NetworkMainState(isLoading: true);

  NetworkMainState copyWith({
    NetworkInfo? currentNetworkInfo,
    bool? isConnected,
    String? networkQuality,
    bool? isLoading,
    bool clearNetworkInfo = false,
  }) {
    return NetworkMainState(
      currentNetworkInfo: clearNetworkInfo
          ? null
          : (currentNetworkInfo ?? this.currentNetworkInfo),
      isConnected: isConnected ?? this.isConnected,
      networkQuality: networkQuality ?? this.networkQuality,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class NetworkListState {
  final String deviceUuid;
  final List<NetworkInfo> networkInfoList;
  final bool isLoading;
  final String errorMessage;

  const NetworkListState({
    this.deviceUuid = '',
    this.networkInfoList = const [],
    this.isLoading = true,
    this.errorMessage = '',
  });

  factory NetworkListState.initial() => const NetworkListState();

  NetworkListState copyWith({
    String? deviceUuid,
    List<NetworkInfo>? networkInfoList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NetworkListState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      networkInfoList: networkInfoList ?? this.networkInfoList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class NetworkDetailState {
  final NetworkInfo networkInfo;
  final bool isLoading;

  const NetworkDetailState({required this.networkInfo, this.isLoading = false});

  NetworkDetailState copyWith({NetworkInfo? networkInfo, bool? isLoading}) {
    return NetworkDetailState(
      networkInfo: networkInfo ?? this.networkInfo,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

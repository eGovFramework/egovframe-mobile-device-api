import 'package:egovframe_mobile_deviceapi_app/domain/push/entities/push_message_info.dart';

class PushMainState {
  final bool isLoading;
  final bool isInitialized;
  final bool permissionDenied;
  final String? loadError;
  final String uuid;
  final String tokenId;
  final String deviceNm;
  final String osType;
  final String osVer;
  final String ntwrkDeviceInfo;

  const PushMainState({
    required this.isLoading,
    required this.isInitialized,
    this.permissionDenied = false,
    this.loadError,
    required this.uuid,
    required this.tokenId,
    required this.deviceNm,
    required this.osType,
    required this.osVer,
    required this.ntwrkDeviceInfo,
  });

  factory PushMainState.initial() {
    return const PushMainState(
      isLoading: true,
      isInitialized: false,
      uuid: '',
      tokenId: '',
      deviceNm: '',
      osType: '',
      osVer: '',
      ntwrkDeviceInfo: '',
    );
  }

  bool get canRegister =>
      isInitialized && uuid.isNotEmpty && tokenId.isNotEmpty;

  PushMainState copyWith({
    bool? isLoading,
    bool? isInitialized,
    bool? permissionDenied,
    String? loadError,
    bool clearLoadError = false,
    String? uuid,
    String? tokenId,
    String? deviceNm,
    String? osType,
    String? osVer,
    String? ntwrkDeviceInfo,
  }) {
    return PushMainState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      uuid: uuid ?? this.uuid,
      tokenId: tokenId ?? this.tokenId,
      deviceNm: deviceNm ?? this.deviceNm,
      osType: osType ?? this.osType,
      osVer: osVer ?? this.osVer,
      ntwrkDeviceInfo: ntwrkDeviceInfo ?? this.ntwrkDeviceInfo,
    );
  }
}

class PushListState {
  final bool isLoading;
  final List<PushMessageInfo> messageList;
  final String errorMessage;

  const PushListState({
    required this.isLoading,
    required this.messageList,
    required this.errorMessage,
  });

  factory PushListState.initial() {
    return const PushListState(
      isLoading: true,
      messageList: [],
      errorMessage: '',
    );
  }

  PushListState copyWith({
    bool? isLoading,
    List<PushMessageInfo>? messageList,
    String? errorMessage,
  }) {
    return PushListState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

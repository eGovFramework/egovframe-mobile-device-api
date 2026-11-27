import 'package:egovframe_mobile_deviceapi_app/domain/accelerator/entities/accelerator_info.dart';

class AcceleratorMainState {
  final String deviceUuid;
  final double xAxis;
  final double yAxis;
  final double zAxis;
  final String timestamp;
  final bool isAccelerometerActive;
  final bool isLoading;

  const AcceleratorMainState({
    this.deviceUuid = '',
    this.xAxis = 0.0,
    this.yAxis = 0.0,
    this.zAxis = 0.0,
    this.timestamp = '',
    this.isAccelerometerActive = false,
    this.isLoading = true,
  });

  factory AcceleratorMainState.initial() => const AcceleratorMainState();

  AcceleratorMainState copyWith({
    String? deviceUuid,
    double? xAxis,
    double? yAxis,
    double? zAxis,
    String? timestamp,
    bool? isAccelerometerActive,
    bool? isLoading,
  }) {
    return AcceleratorMainState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      xAxis: xAxis ?? this.xAxis,
      yAxis: yAxis ?? this.yAxis,
      zAxis: zAxis ?? this.zAxis,
      timestamp: timestamp ?? this.timestamp,
      isAccelerometerActive:
          isAccelerometerActive ?? this.isAccelerometerActive,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AcceleratorListState {
  final String deviceUuid;
  final List<AcceleratorInfo> acceleratorInfoList;
  final bool isLoading;
  final String errorMessage;

  const AcceleratorListState({
    this.deviceUuid = '',
    this.acceleratorInfoList = const [],
    this.isLoading = true,
    this.errorMessage = '',
  });

  factory AcceleratorListState.initial() => const AcceleratorListState();

  AcceleratorListState copyWith({
    String? deviceUuid,
    List<AcceleratorInfo>? acceleratorInfoList,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AcceleratorListState(
      deviceUuid: deviceUuid ?? this.deviceUuid,
      acceleratorInfoList: acceleratorInfoList ?? this.acceleratorInfoList,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AcceleratorDetailState {
  final int sn;
  final AcceleratorInfo? fallbackInfo;
  final AcceleratorInfo? acceleratorInfo;
  final bool isLoading;
  final bool isDeleting;

  const AcceleratorDetailState({
    required this.sn,
    this.fallbackInfo,
    this.acceleratorInfo,
    this.isLoading = true,
    this.isDeleting = false,
  });

  factory AcceleratorDetailState.initial({
    required int sn,
    AcceleratorInfo? fallbackInfo,
  }) => AcceleratorDetailState(sn: sn, fallbackInfo: fallbackInfo);

  AcceleratorDetailState copyWith({
    int? sn,
    AcceleratorInfo? fallbackInfo,
    AcceleratorInfo? acceleratorInfo,
    bool? isLoading,
    bool? isDeleting,
  }) {
    return AcceleratorDetailState(
      sn: sn ?? this.sn,
      fallbackInfo: fallbackInfo ?? this.fallbackInfo,
      acceleratorInfo: acceleratorInfo ?? this.acceleratorInfo,
      isLoading: isLoading ?? this.isLoading,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

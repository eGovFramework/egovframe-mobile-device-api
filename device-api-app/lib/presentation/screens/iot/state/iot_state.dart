import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';

class IotMainState {
  final bool isLoading;
  final bool isConnecting;
  final bool isConnected;
  final String? loadError;
  final IotBrokerConfig config;
  final IotTelemetry? latestTelemetry;
  final List<IotMessageLog> logs;
  final String? lastCommandPayload;
  final String nextPowerValue;
  final String uuid;

  const IotMainState({
    required this.isLoading,
    required this.isConnecting,
    required this.isConnected,
    this.loadError,
    required this.config,
    this.latestTelemetry,
    required this.logs,
    this.lastCommandPayload,
    this.nextPowerValue = 'on',
    this.uuid = '',
  });

  factory IotMainState.initial() {
    return IotMainState(
      isLoading: true,
      isConnecting: false,
      isConnected: false,
      config: IotBrokerConfig.defaults(),
      logs: const [],
      nextPowerValue: 'on',
      uuid: '',
    );
  }

  IotMainState copyWith({
    bool? isLoading,
    bool? isConnecting,
    bool? isConnected,
    String? loadError,
    bool clearLoadError = false,
    IotBrokerConfig? config,
    IotTelemetry? latestTelemetry,
    bool clearTelemetry = false,
    List<IotMessageLog>? logs,
    String? lastCommandPayload,
    bool clearLastCommand = false,
    String? nextPowerValue,
    String? uuid,
  }) {
    return IotMainState(
      isLoading: isLoading ?? this.isLoading,
      isConnecting: isConnecting ?? this.isConnecting,
      isConnected: isConnected ?? this.isConnected,
      loadError: clearLoadError ? null : (loadError ?? this.loadError),
      config: config ?? this.config,
      latestTelemetry:
          clearTelemetry ? null : (latestTelemetry ?? this.latestTelemetry),
      logs: logs ?? this.logs,
      lastCommandPayload: clearLastCommand
          ? null
          : (lastCommandPayload ?? this.lastCommandPayload),
      nextPowerValue: nextPowerValue ?? this.nextPowerValue,
      uuid: uuid ?? this.uuid,
    );
  }
}

class IotSavedListState {
  final bool isLoading;
  final List<IotMessageInfo> messageList;
  final String errorMessage;

  const IotSavedListState({
    required this.isLoading,
    required this.messageList,
    required this.errorMessage,
  });

  factory IotSavedListState.initial() {
    return const IotSavedListState(
      isLoading: true,
      messageList: [],
      errorMessage: '',
    );
  }

  IotSavedListState copyWith({
    bool? isLoading,
    List<IotMessageInfo>? messageList,
    String? errorMessage,
  }) {
    return IotSavedListState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

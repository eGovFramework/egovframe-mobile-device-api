import 'dart:async';

import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_server_connection_service.dart';
import 'package:egovframe_mobile_deviceapi_app/di/iot_connection_provider.dart';
import 'package:egovframe_mobile_deviceapi_app/di/providers.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/usecases/iot_usecase.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/iot_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/presentation/screens/iot/state/iot_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'iot_controller.g.dart';

IotUseCase _iotUseCase(Ref ref) => ref.read(iotUseCaseProvider);

@riverpod
class IotMain extends _$IotMain {
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<IotTelemetry>? _telemetrySub;
  StreamSubscription<IotMessageLog>? _logSub;

  static const _maxLogs = 50;
  static const _storeCheckTtl = Duration(seconds: 30);

  DateTime? _lastStoreCheckAt;
  bool? _lastStoreAvailable;

  @override
  IotMainState build() {
    final useCase = _iotUseCase(ref);
    ref.onDispose(() {
      _disposeSubscriptions();
      unawaited(useCase.disconnect());
    });
    ref.listen(iotConnectionProvider, (_, __) {
      _lastStoreCheckAt = null;
      _lastStoreAvailable = null;
    });
    Future.microtask(_initialize);
    return IotMainState.initial();
  }

  Future<void> _initialize() async {
    await _connectionSub?.cancel();
    await _telemetrySub?.cancel();
    await _logSub?.cancel();

    final useCase = _iotUseCase(ref);
    final uuid = await useCase.getDeviceUuid();

    _connectionSub = useCase.watchConnectionState().listen((connected) {
      state = state.copyWith(
        isConnected: connected,
        isConnecting: false,
        clearLoadError: true,
      );
    });

    _telemetrySub = useCase.watchTelemetry().listen((telemetry) {
      final previous = state.latestTelemetry;
      state = state.copyWith(latestTelemetry: telemetry);
      if (telemetry.valuesDifferFrom(previous)) {
        unawaited(_autoPersistTelemetry(telemetry));
      }
    });

    _logSub = useCase.watchMessageLogs().listen((log) {
      final next = [log, ...state.logs];
      if (next.length > _maxLogs) {
        next.removeRange(_maxLogs, next.length);
      }
      state = state.copyWith(logs: next);

      if (log.messageType == IotMessageType.command) {
        unawaited(_autoPersistLog(log));
      }
    });

    final config = await useCase.loadBrokerConfig(state.config);
    state = state.copyWith(
      isLoading: false,
      uuid: uuid,
      config: config ?? state.config,
    );
  }

  void _disposeSubscriptions() {
    _connectionSub?.cancel();
    _telemetrySub?.cancel();
    _logSub?.cancel();
  }

  Future<bool> _canAutoPersist() async {
    if (state.uuid.isEmpty) return false;

    final connection = ref.read(iotConnectionProvider);
    if (connection.isSqlite) return true;

    final now = DateTime.now();
    if (_lastStoreCheckAt != null &&
        _lastStoreAvailable != null &&
        now.difference(_lastStoreCheckAt!) < _storeCheckTtl) {
      return _lastStoreAvailable!;
    }

    final available =
        await IotServerConnectionService().isServerConnected();
    _lastStoreCheckAt = now;
    _lastStoreAvailable = available;
    return available;
  }

  Future<void> _autoPersistTelemetry(IotTelemetry telemetry) async {
    final payload = telemetry.rawPayload?.trim() ?? '';
    if (payload.isEmpty) return;

    await _autoPersistLog(
      IotMessageLog(
        topic: telemetry.topic,
        payload: payload,
        at: telemetry.receivedAt,
        direction: IotMessageDirection.incoming,
        messageType: IotMessageType.telemetry,
      ),
    );
  }

  Future<void> _autoPersistLog(IotMessageLog log) async {
    if (!await _canAutoPersist()) return;

    final useCase = _iotUseCase(ref);
    final info = useCase.buildInfoFromLog(uuid: state.uuid, log: log);
    final sn = await useCase.uploadIotMessageInfo(info);
    if (sn == null) {
      if (!ref.read(iotConnectionProvider).isSqlite) {
        _lastStoreAvailable = false;
        _lastStoreCheckAt = DateTime.now();
      }
      return;
    }

    _markLogSynced(log, sn);
  }

  void _markLogSynced(IotMessageLog target, int sn) {
    final updated = [
      for (final log in state.logs)
        if (!log.isSynced &&
            log.topic == target.topic &&
            log.payload == target.payload &&
            log.at == target.at)
          log.copyWith(savedSn: sn)
        else
          log,
    ];
    state = state.copyWith(logs: updated);
  }

  void updateHost(String value) {
    final host = value.trim();
    state = state.copyWith(
      config: state.config.copyWith(host: host, enabled: host.isNotEmpty),
    );
  }

  void updatePort(String value) {
    final port = int.tryParse(value.trim());
    if (port == null) return;
    state = state.copyWith(config: state.config.copyWith(port: port));
  }

  void updateUsername(String value) {
    state = state.copyWith(
      config: state.config.copyWith(username: value.trim()),
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(config: state.config.copyWith(password: value));
  }

  void updateDeviceId(String value) {
    state = state.copyWith(
      config: state.config.copyWith(deviceId: value.trim()),
    );
  }

  Future<void> connect() async {
    if (state.isConnected || state.isConnecting) return;
    if (!state.config.enabled || state.config.host.trim().isEmpty) {
      state = state.copyWith(
        isConnecting: false,
        isConnected: false,
        loadError: IotMessageKeys.hostRequired,
      );
      return;
    }

    state = state.copyWith(isConnecting: true, clearLoadError: true);
    final result = await _iotUseCase(ref).connect(state.config);

    switch (result) {
      case IotConnectSuccess():
        state = state.copyWith(isConnecting: false, isConnected: true);
      case IotConnectFailure(:final message):
        state = state.copyWith(
          isConnecting: false,
          isConnected: false,
          loadError: message,
        );
    }
  }

  Future<void> disconnect() async {
    await _iotUseCase(ref).disconnect();
    state = state.copyWith(
      isConnected: false,
      isConnecting: false,
      clearLoadError: true,
    );
  }

  Future<void> toggleConnection() async {
    if (state.isConnected || state.isConnecting) {
      await disconnect();
      return;
    }
    await connect();
  }

  Future<IotPublishResult> sendPowerCommand() async {
    final value = state.nextPowerValue;
    final useCase = _iotUseCase(ref);
    final payload = useCase.buildCommandPayload(
      action: 'power',
      value: value,
    );
    final result = await useCase.publishCommand(
      topic: state.config.commandTopic,
      payload: payload,
    );

    if (result is IotPublishSuccess) {
      state = state.copyWith(
        lastCommandPayload: payload,
        nextPowerValue: value == 'on' ? 'off' : 'on',
      );
    } else {
      state = state.copyWith(lastCommandPayload: payload);
    }
    return result;
  }

  void clearSavedSn() {
    state = state.copyWith(
      logs: [
        for (final log in state.logs)
          IotMessageLog(
            topic: log.topic,
            payload: log.payload,
            at: log.at,
            direction: log.direction,
            messageType: log.messageType,
          ),
      ],
    );
  }

  void clearLogs() {
    state = state.copyWith(
      logs: const [],
      clearTelemetry: true,
      clearLastCommand: true,
    );
  }
}

@riverpod
class IotSavedList extends _$IotSavedList {
  @override
  IotSavedListState build() {
    Future.microtask(reload);
    return IotSavedListState.initial();
  }

  Future<void> reload() async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    final result = await _iotUseCase(ref).loadIotMessageList();

    switch (result) {
      case IotListLoadSuccess(:final items):
        state = state.copyWith(
          isLoading: false,
          messageList: items,
          errorMessage: '',
        );
      case IotListLoadEmpty():
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: '',
        );
      case IotListLoadFailure(:final message):
        state = state.copyWith(
          isLoading: false,
          messageList: [],
          errorMessage: message,
        );
    }
  }

  Future<IotDeleteAllResult> deleteAll() async {
    return _iotUseCase(ref).deleteAllIotMessages();
  }
}

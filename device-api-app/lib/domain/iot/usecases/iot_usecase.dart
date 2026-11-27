import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/repositories/iot_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/iot_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/kst_datetime_util.dart';

class IotUseCase {
  final IotRepository repository;

  IotUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Stream<bool> watchConnectionState() => repository.watchConnectionState();

  Stream<IotTelemetry> watchTelemetry() => repository.watchTelemetry();

  Stream<IotMessageLog> watchMessageLogs() => repository.watchMessageLogs();

  bool get isConnected => repository.isConnected;

  Future<IotConnectResult> connect(IotBrokerConfig config) async {
    if (config.host.trim().isEmpty) {
      return const IotConnectFailure(IotMessageKeys.hostRequired);
    }
    if (config.port <= 0 || config.port > 65535) {
      return const IotConnectFailure(IotMessageKeys.portInvalid);
    }
    if (config.deviceId.trim().isEmpty) {
      return const IotConnectFailure(IotMessageKeys.deviceIdRequired);
    }

    try {
      await repository.connect(config);
      return const IotConnectSuccess();
    } catch (e) {
      return IotConnectFailure('${IotMessageKeys.connectErrorPrefix}$e');
    }
  }

  Future<void> disconnect() => repository.disconnect();

  Future<IotBrokerConfig?> loadBrokerConfig(IotBrokerConfig current) =>
      repository.loadBrokerConfig(current);

  Future<IotPublishResult> publishCommand({
    required String topic,
    required String payload,
  }) async {
    if (!repository.isConnected) {
      return const IotPublishFailure(IotMessageKeys.notConnected);
    }
    if (topic.trim().isEmpty) {
      return const IotPublishFailure(IotMessageKeys.topicRequired);
    }
    if (payload.trim().isEmpty) {
      return const IotPublishFailure(IotMessageKeys.payloadRequired);
    }

    try {
      await repository.publishCommand(topic: topic, payload: payload);
      return const IotPublishSuccess();
    } catch (e) {
      return IotPublishFailure('${IotMessageKeys.publishErrorPrefix}$e');
    }
  }

  String buildCommandPayload({
    required String action,
    required String value,
    String? requestId,
  }) {
    final id = requestId ?? 'req-${DateTime.now().millisecondsSinceEpoch}';
    return '{"action":"$action","value":"$value","requestId":"$id"}';
  }

  Future<int?> uploadIotMessageInfo(IotMessageInfo info) async {
    if (info.uuid.isEmpty || info.payload.trim().isEmpty) return null;
    try {
      return await repository.uploadIotMessageInfo(info);
    } catch (_) {
      return null;
    }
  }

  Future<IotListLoadResult> loadIotMessageList() async {
    try {
      final items = await repository.getIotMessageList();
      if (items.isEmpty) return const IotListLoadEmpty();
      return IotListLoadSuccess(items);
    } catch (e) {
      return IotListLoadFailure('${IotMessageKeys.listLoadErrorPrefix}$e');
    }
  }

  Future<IotDeleteAllResult> deleteAllIotMessages() async {
    try {
      final success = await repository.deleteAllIotMessageInfo();
      if (success) return const IotDeleteAllSuccess();
      return const IotDeleteAllFailure(IotMessageKeys.deleteFailed);
    } catch (e) {
      return IotDeleteAllFailure('${IotMessageKeys.genericErrorPrefix}$e');
    }
  }

  IotMessageInfo buildInfoFromLog({
    required String uuid,
    required IotMessageLog log,
  }) {
    return IotMessageInfo.fromLog(
      uuid: uuid,
      log: log,
      timestamp: KstDateTimeUtil.format(log.at),
    );
  }
}

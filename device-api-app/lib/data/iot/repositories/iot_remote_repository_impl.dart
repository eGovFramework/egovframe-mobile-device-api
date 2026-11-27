import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_mqtt_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_remote_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/repositories/iot_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';

class IotRemoteRepositoryImpl implements IotRepository {
  final IotMqttService _mqttService;

  IotRemoteRepositoryImpl(this._mqttService);

  @override
  Stream<bool> watchConnectionState() => _mqttService.connectionStates;

  @override
  Stream<IotTelemetry> watchTelemetry() => _mqttService.telemetry;

  @override
  Stream<IotMessageLog> watchMessageLogs() => _mqttService.messageLogs;

  @override
  bool get isConnected => _mqttService.isConnected;

  @override
  Future<void> connect(IotBrokerConfig config) => _mqttService.connect(config);

  @override
  Future<void> disconnect() => _mqttService.disconnect();

  @override
  Future<IotBrokerConfig?> loadBrokerConfig(IotBrokerConfig current) =>
      IotRemoteService.loadBrokerConfig(current);

  @override
  Future<void> publishCommand({
    required String topic,
    required String payload,
  }) =>
      _mqttService.publish(topic: topic, payload: payload);

  @override
  Future<int?> uploadIotMessageInfo(IotMessageInfo info) async {
    final response = await IotRemoteService.postIotMessageInfo(
      info.toUploadFields(),
    );
    if (response == null) return null;
    final resultState = (response['resultState'] ?? '').toString();
    if (resultState != 'OK') return null;
    final sn = int.tryParse('${response['sn']}') ?? 0;
    return sn > 0 ? sn : null;
  }

  @override
  Future<List<IotMessageInfo>> getIotMessageList() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final rawList = await IotRemoteService.fetchIotMessageList(uuid);
    return rawList.map(IotMessageInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteAllIotMessageInfo() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    if (uuid.isEmpty) return false;
    final response = await IotRemoteService.deleteIotMessageInfo(uuid);
    if (response == null) return false;
    return (response['resultState'] ?? '').toString() == 'OK';
  }
}

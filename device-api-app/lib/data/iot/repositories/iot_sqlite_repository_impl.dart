import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_mqtt_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_remote_service.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/datasources/iot_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/repositories/iot_repository.dart';

class IotSqliteRepositoryImpl implements IotRepository {
  final IotMqttService _mqttService;
  final IotSqliteService _sqliteService;
  final IotConnectionReader _readConnection;

  IotSqliteRepositoryImpl(
    this._mqttService,
    this._sqliteService,
    this._readConnection,
  );

  String? get _dbFileName => _readConnection().sqliteDbFileName;

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
    final db = _dbFileName;
    if (db == null) return null;
    return _sqliteService.uploadIotMessageInfo(db, info);
  }

  @override
  Future<List<IotMessageInfo>> getIotMessageList() async {
    final db = _dbFileName;
    if (db == null) return [];
    return _sqliteService.getIotMessageList(db);
  }

  @override
  Future<bool> deleteAllIotMessageInfo() async {
    final db = _dbFileName;
    if (db == null) return false;
    return _sqliteService.deleteAllIotMessageInfo(db);
  }
}

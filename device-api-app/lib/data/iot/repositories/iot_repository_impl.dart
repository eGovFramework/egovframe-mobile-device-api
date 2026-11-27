import 'package:egovframe_mobile_deviceapi_app/data/iot/repositories/iot_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/iot/repositories/iot_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/repositories/iot_repository.dart';

class IotRepositoryImpl implements IotRepository {
  final IotRemoteRepositoryImpl _remote;
  final IotSqliteRepositoryImpl _sqlite;
  final IotConnectionReader _readConnection;

  IotRepositoryImpl({
    required IotRemoteRepositoryImpl remote,
    required IotSqliteRepositoryImpl sqlite,
    required IotConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  IotRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Stream<bool> watchConnectionState() => _remote.watchConnectionState();

  @override
  Stream<IotTelemetry> watchTelemetry() => _remote.watchTelemetry();

  @override
  Stream<IotMessageLog> watchMessageLogs() => _remote.watchMessageLogs();

  @override
  bool get isConnected => _remote.isConnected;

  @override
  Future<void> connect(IotBrokerConfig config) => _remote.connect(config);

  @override
  Future<void> disconnect() => _remote.disconnect();

  @override
  Future<IotBrokerConfig?> loadBrokerConfig(IotBrokerConfig current) =>
      _remote.loadBrokerConfig(current);

  @override
  Future<void> publishCommand({
    required String topic,
    required String payload,
  }) =>
      _remote.publishCommand(topic: topic, payload: payload);

  @override
  Future<int?> uploadIotMessageInfo(IotMessageInfo info) =>
      _active.uploadIotMessageInfo(info);

  @override
  Future<List<IotMessageInfo>> getIotMessageList() =>
      _active.getIotMessageList();

  @override
  Future<bool> deleteAllIotMessageInfo() => _active.deleteAllIotMessageInfo();
}

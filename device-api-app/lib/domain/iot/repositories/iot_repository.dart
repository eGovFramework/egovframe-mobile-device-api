import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';

abstract class IotRepository {
  Stream<bool> watchConnectionState();

  Stream<IotTelemetry> watchTelemetry();

  Stream<IotMessageLog> watchMessageLogs();

  bool get isConnected;

  Future<void> connect(IotBrokerConfig config);

  Future<void> disconnect();

  /// 서버 properties의 MQTT 값. 브로커에는 접속하지 않는다.
  Future<IotBrokerConfig?> loadBrokerConfig(IotBrokerConfig current);

  Future<void> publishCommand({
    required String topic,
    required String payload,
  });

  Future<int?> uploadIotMessageInfo(IotMessageInfo info);

  Future<List<IotMessageInfo>> getIotMessageList();

  Future<bool> deleteAllIotMessageInfo();
}

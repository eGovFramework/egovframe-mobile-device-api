import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';

/// RabbitMQ MQTT 브로커 접속 설정
class IotBrokerConfig {
  final String host;
  final int port;
  final String username;
  final String password;
  final String deviceId;
  final String clientId;
  final bool enabled;

  const IotBrokerConfig({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
    required this.deviceId,
    required this.clientId,
    this.enabled = false,
  });

  /// 서버 설정을 받기 전 값. 호스트가 비어 있어 연결하지 않는다.
  factory IotBrokerConfig.defaults({String? clientId}) {
    final id =
        clientId ??
        'flutter_iot_${DateTime.now().millisecondsSinceEpoch}';
    return IotBrokerConfig(
      host: '',
      port: 1883,
      username: '',
      password: '',
      deviceId: 'device01',
      clientId: id,
    );
  }

  String get telemetryTopic => AppConfig.mqttTelemetryTopic(deviceId);

  String get commandTopic => AppConfig.mqttCommandTopic(deviceId);

  IotBrokerConfig copyWith({
    String? host,
    int? port,
    String? username,
    String? password,
    String? deviceId,
    String? clientId,
    bool? enabled,
  }) {
    return IotBrokerConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      deviceId: deviceId ?? this.deviceId,
      clientId: clientId ?? this.clientId,
      enabled: enabled ?? this.enabled,
    );
  }
}

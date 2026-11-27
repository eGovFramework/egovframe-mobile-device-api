import 'dart:async';
import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_broker_config.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_message_log.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/iot/entities/iot_telemetry.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';

/// RabbitMQ MQTT plugin 연동 서비스
class IotMqttService {
  MqttServerClient? _client;
  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>? _updatesSub;
  IotBrokerConfig? _config;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  final StreamController<IotTelemetry> _telemetryController =
      StreamController<IotTelemetry>.broadcast();
  final StreamController<IotMessageLog> _logController =
      StreamController<IotMessageLog>.broadcast();

  Stream<bool> get connectionStates => _connectionController.stream;
  Stream<IotTelemetry> get telemetry => _telemetryController.stream;
  Stream<IotMessageLog> get messageLogs => _logController.stream;

  bool get isConnected =>
      _client?.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect(IotBrokerConfig config) async {
    await disconnect();

    _config = config;
    final client = MqttServerClient.withPort(
      config.host.trim(),
      config.clientId,
      config.port,
    );
    client.logging(on: false);
    client.keepAlivePeriod = 30;
    client.autoReconnect = false;
    client.onConnected = () {
      if (!_connectionController.isClosed) {
        _connectionController.add(true);
      }
    };
    client.onDisconnected = () {
      if (!_connectionController.isClosed) {
        _connectionController.add(false);
      }
    };

    final connMess = MqttConnectMessage().startClean();
    if (config.username.trim().isNotEmpty) {
      connMess.authenticateAs(config.username.trim(), config.password);
    }
    client.connectionMessage = connMess;

    _client = client;

    try {
      final status = await client.connect();
      if (status?.state != MqttConnectionState.connected) {
        await disconnect();
        throw Exception('MQTT connection failed: ${status?.state}');
      }
    } catch (e) {
      await disconnect();
      rethrow;
    }

    _updatesSub = client.updates?.listen(_onMessages);
    _subscribeTelemetry(client, config);

    if (!_connectionController.isClosed) {
      _connectionController.add(true);
    }
  }

  void _subscribeTelemetry(MqttServerClient client, IotBrokerConfig config) {
    final topic = config.telemetryTopic;
    client.subscribe(topic, MqttQos.atLeastOnce);
    appLog('IotMqttService subscribed: $topic');
  }

  void _onMessages(List<MqttReceivedMessage<MqttMessage>> events) {
    if (events.isEmpty) return;

    final received = events.first;
    final topic = received.topic;
    final payloadMessage = received.payload;
    if (payloadMessage is! MqttPublishMessage) return;

    final bytes = payloadMessage.payload.message;
    if (bytes == null || bytes.isEmpty) return;

    final payload = MqttUtilities.bytesToStringAsString(bytes);
    final now = DateTime.now();

    if (!_logController.isClosed) {
      _logController.add(
        IotMessageLog(
          topic: topic ?? '',
          payload: payload,
          at: now,
          direction: IotMessageDirection.incoming,
          messageType: IotMessageLog.resolveMessageType(topic ?? ''),
        ),
      );
    }

    final telemetryTopic = _config?.telemetryTopic;
    if (topic != null && telemetryTopic != null && topic == telemetryTopic) {
      final telemetry = _parseTelemetry(
        topic: topic,
        payload: payload,
        receivedAt: now,
      );
      if (!_telemetryController.isClosed) {
        _telemetryController.add(telemetry);
      }
    }
  }

  IotTelemetry _parseTelemetry({
    required String topic,
    required String payload,
    required DateTime receivedAt,
  }) {
    double? temp;
    double? humidity;

    try {
      final decoded = json.decode(payload);
      if (decoded is Map<String, dynamic>) {
        temp = _toDouble(decoded['temp'] ?? decoded['temperature']);
        humidity = _toDouble(decoded['humidity'] ?? decoded['hum']);
      }
    } catch (_) {
      // raw payload 유지
    }

    return IotTelemetry(
      temperature: temp,
      humidity: humidity,
      rawPayload: payload,
      topic: topic,
      receivedAt: receivedAt,
    );
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  Future<void> publish({
    required String topic,
    required String payload,
  }) async {
    final client = _client;
    if (client == null || !isConnected) {
      throw Exception('MQTT not connected');
    }

    final builder = MqttPayloadBuilder();
    builder.addString(payload);
    final data = builder.payload;
    if (data == null) {
      throw Exception('Empty MQTT payload');
    }

    client.publishMessage(topic, MqttQos.atLeastOnce, data);

    if (!_logController.isClosed) {
      _logController.add(
        IotMessageLog(
          topic: topic,
          payload: payload,
          at: DateTime.now(),
          direction: IotMessageDirection.outgoing,
          messageType: IotMessageLog.resolveMessageType(topic),
        ),
      );
    }
  }

  Future<void> disconnect() async {
    await _updatesSub?.cancel();
    _updatesSub = null;

    final client = _client;
    _client = null;
    _config = null;

    try {
      client?.disconnect();
    } catch (e) {
      appLog('IotMqttService disconnect error: $e');
    }

    if (!_connectionController.isClosed) {
      _connectionController.add(false);
    }
  }

  Future<void> dispose() async {
    await disconnect();
    await _connectionController.close();
    await _telemetryController.close();
    await _logController.close();
  }
}

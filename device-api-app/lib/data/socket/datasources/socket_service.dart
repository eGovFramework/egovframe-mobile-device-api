import 'dart:async';
import 'package:egovframe_mobile_deviceapi_app/core/device_api_client.dart';
import 'dart:convert';

import 'package:egovframe_mobile_deviceapi_app/config/app_config.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/app_logger.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/socket_chat_message_format.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/websocket_connection_util.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

/// WebSocket 채팅 및 서버 HTTP 통신 (device-api-web /ws REST)
class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  ws.WebSocket? _socket;
  StreamSubscription<ws.ConnectionState>? _connectionSubscription;
  StreamSubscription<dynamic>? _messageSubscription;
  final StreamController<String> _incomingMessagesController =
      StreamController<String>.broadcast();
  final StreamController<ws.ConnectionState> _connectionStateController =
      StreamController<ws.ConnectionState>.broadcast();

  Stream<String> get incomingMessages => _incomingMessagesController.stream;

  Stream<ws.ConnectionState> get connectionStates =>
      _connectionStateController.stream;

  ws.ConnectionState? get currentConnectionState => _socket?.connection.state;

  bool get isConnected =>
      isWebSocketConnected(_socket?.connection.state ?? const ws.Disconnected());

  Future<void> connect() async {
    if (_socket != null && isConnected) {
      return;
    }

    await disconnect();

    final socket = ws.WebSocket(
      Uri.parse(AppConfig.websocketUrl),
      headers: AppConfig.authorizationHeaders,
    );
    _socket = socket;

    await _connectionSubscription?.cancel();
    await _messageSubscription?.cancel();

    _connectionSubscription = socket.connection.listen(
      (state) {
        if (!_connectionStateController.isClosed) {
          _connectionStateController.add(state);
        }
      },
      onError: (Object error) {
        appLog('SocketService connection error: $error');
      },
    );

    _messageSubscription = socket.messages.listen(
      (message) {
        final text = message is String ? message : utf8.decode(message);
        if (text.isNotEmpty && !_incomingMessagesController.isClosed) {
          _incomingMessagesController.add(text);
        }
      },
      onError: (Object error) {
        appLog('SocketService message error: $error');
      },
    );

    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(socket.connection.state);
    }
  }

  Future<void> disconnect() async {
    await _messageSubscription?.cancel();
    _messageSubscription = null;
    await _connectionSubscription?.cancel();
    _connectionSubscription = null;

    final socket = _socket;
    _socket = null;
    socket?.close();

    if (!_connectionStateController.isClosed) {
      _connectionStateController.add(const ws.Disconnected());
    }
  }

  void sendMessage({
    required String sender,
    required String message,
  }) {
    final payload = SocketChatMessageFormat.encode(
      sender: sender,
      message: message,
    );
    if (payload.isEmpty || _socket == null) {
      return;
    }
    _socket!.send(payload);
  }

  /// 서버: 채팅 메시지 등록
  static Future<Map<String, dynamic>?> postSocketMessageInfo(
    Map<String, String> fields,
  ) async {
    final uri = Uri.parse(AppConfig.getSocketUrl('/insertSocketMessageInfo.do'));

    try {
      final resp = await DeviceApiClient.post(uri, body: fields);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('SocketService.postSocketMessageInfo failed: $e');
      return null;
    }
  }

  /// 서버: 채팅 메시지 목록 조회
  static Future<List<Map<String, dynamic>>> fetchSocketMessageList(
    String uuid,
  ) async {
    if (uuid.isEmpty) {
      return [];
    }
    final uri = Uri.parse(
      AppConfig.getSocketUrl('/selectSocketMessageInfoList.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.get(uri);

      if (resp.statusCode != 200) {
        return [];
      }

      return resp.list('socketMessageInfoList');
    } catch (e) {
      appLog('SocketService.fetchSocketMessageList failed: $e');
      return [];
    }
  }

  /// 서버: UUID 기준 채팅 메시지 삭제
  static Future<Map<String, dynamic>?> deleteSocketMessageInfo(
    String uuid,
  ) async {
    final uri = Uri.parse(
      AppConfig.getSocketUrl('/deleteSocketMessageInfo.do'),
    ).replace(queryParameters: {'uuid': uuid});

    try {
      final resp = await DeviceApiClient.delete(uri);

      if (resp.statusCode != 200) {
        return null;
      }

      return resp.json;
    } catch (e) {
      appLog('SocketService.deleteSocketMessageInfo failed: $e');
      return null;
    }
  }
}

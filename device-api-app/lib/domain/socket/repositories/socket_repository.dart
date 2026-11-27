import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

abstract class SocketRepository {
  Stream<ws.ConnectionState> watchConnectionState();

  Stream<String> watchIncomingMessages();

  Future<void> connectWebSocket();

  Future<void> disconnectWebSocket();

  bool get isWebSocketConnected;

  void sendChatMessage({
    required String sender,
    required String message,
  });

  Future<int?> uploadSocketMessageInfo(SocketMessageInfo info);

  Future<List<SocketMessageInfo>> getSocketMessageList();

  Future<bool> deleteAllSocketMessageInfo();
}

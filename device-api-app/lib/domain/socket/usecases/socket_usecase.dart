import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_result.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/repositories/socket_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/l10n/message_keys/socket_message_keys.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

class SocketUseCase {
  final SocketRepository repository;

  SocketUseCase(this.repository);

  Future<String> getDeviceUuid() => DeviceUuidUtil.getDeviceUuid();

  Stream<ws.ConnectionState> watchConnectionState() =>
      repository.watchConnectionState();

  Stream<String> watchIncomingMessages() => repository.watchIncomingMessages();

  Future<void> connectWebSocket() => repository.connectWebSocket();

  Future<void> disconnectWebSocket() => repository.disconnectWebSocket();

  bool get isWebSocketConnected => repository.isWebSocketConnected;

  void sendChatMessage({
    required String sender,
    required String message,
  }) =>
      repository.sendChatMessage(sender: sender, message: message);

  Future<int?> uploadSocketMessageInfo(SocketMessageInfo info) async {
    if (info.uuid.isEmpty) {
      return null;
    }
    if (info.message.trim().isEmpty) {
      return null;
    }

    try {
      return await repository.uploadSocketMessageInfo(info);
    } catch (e) {
      return null;
    }
  }

  Future<SocketListLoadResult> loadSocketMessageList() async {
    try {
      final items = await repository.getSocketMessageList();
      if (items.isEmpty) {
        return const SocketListLoadEmpty();
      }
      return SocketListLoadSuccess(items);
    } catch (e) {
      return SocketListLoadFailure(
        '${SocketMessageKeys.listLoadErrorPrefix}$e',
      );
    }
  }

  Future<SocketDeleteAllResult> deleteAllSocketMessages() async {
    try {
      final success = await repository.deleteAllSocketMessageInfo();
      if (success) {
        return const SocketDeleteAllSuccess();
      }
      return const SocketDeleteAllFailure(SocketMessageKeys.deleteFailed);
    } catch (e) {
      return SocketDeleteAllFailure(
        '${SocketMessageKeys.genericErrorPrefix}$e',
      );
    }
  }
}

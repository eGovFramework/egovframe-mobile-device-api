import 'package:egovframe_mobile_deviceapi_app/data/socket/datasources/socket_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/repositories/socket_repository.dart';
import 'package:egovframe_mobile_deviceapi_app/utils/device_uuid_util.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

class SocketRemoteRepositoryImpl implements SocketRepository {
  final SocketService _socketService;

  SocketRemoteRepositoryImpl({SocketService? socketService})
      : _socketService = socketService ?? SocketService.instance;

  @override
  Stream<ws.ConnectionState> watchConnectionState() =>
      _socketService.connectionStates;

  @override
  Stream<String> watchIncomingMessages() => _socketService.incomingMessages;

  @override
  Future<void> connectWebSocket() => _socketService.connect();

  @override
  Future<void> disconnectWebSocket() => _socketService.disconnect();

  @override
  bool get isWebSocketConnected => _socketService.isConnected;

  @override
  void sendChatMessage({
    required String sender,
    required String message,
  }) =>
      _socketService.sendMessage(sender: sender, message: message);

  @override
  Future<int?> uploadSocketMessageInfo(SocketMessageInfo info) async {
    final response =
        await SocketService.postSocketMessageInfo(info.toUploadFields());
    if (response == null) {
      return null;
    }

    final resultState = (response['resultState'] ?? '').toString();
    final useYn = (response['useYn'] ?? '').toString();
    final ok = resultState == 'OK' || useYn == 'OK';
    if (!ok) {
      return null;
    }

    final sn = int.tryParse('${response['sn']}') ?? 0;
    return sn > 0 ? sn : null;
  }

  @override
  Future<List<SocketMessageInfo>> getSocketMessageList() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    final rawList = await SocketService.fetchSocketMessageList(uuid);
    return rawList.map(SocketMessageInfo.fromJson).toList();
  }

  @override
  Future<bool> deleteAllSocketMessageInfo() async {
    final uuid = await DeviceUuidUtil.getDeviceUuid();
    if (uuid.isEmpty) {
      return false;
    }

    final response = await SocketService.deleteSocketMessageInfo(uuid);
    if (response == null) {
      return false;
    }

    final resultState = (response['resultState'] ?? '').toString();
    return resultState == 'OK';
  }
}

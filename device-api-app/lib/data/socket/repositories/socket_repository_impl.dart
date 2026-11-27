import 'package:egovframe_mobile_deviceapi_app/data/socket/repositories/socket_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/socket/repositories/socket_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/repositories/socket_repository.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

class SocketRepositoryImpl implements SocketRepository {
  final SocketRemoteRepositoryImpl _remote;
  final SocketSqliteRepositoryImpl _sqlite;
  final SocketConnectionReader _readConnection;

  SocketRepositoryImpl({
    required SocketRemoteRepositoryImpl remote,
    required SocketSqliteRepositoryImpl sqlite,
    required SocketConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  SocketRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Stream<ws.ConnectionState> watchConnectionState() =>
      _remote.watchConnectionState();

  @override
  Stream<String> watchIncomingMessages() => _remote.watchIncomingMessages();

  @override
  Future<void> connectWebSocket() => _remote.connectWebSocket();

  @override
  Future<void> disconnectWebSocket() => _remote.disconnectWebSocket();

  @override
  bool get isWebSocketConnected => _remote.isWebSocketConnected;

  @override
  void sendChatMessage({
    required String sender,
    required String message,
  }) =>
      _remote.sendChatMessage(sender: sender, message: message);

  @override
  Future<int?> uploadSocketMessageInfo(SocketMessageInfo info) =>
      _active.uploadSocketMessageInfo(info);

  @override
  Future<List<SocketMessageInfo>> getSocketMessageList() =>
      _active.getSocketMessageList();

  @override
  Future<bool> deleteAllSocketMessageInfo() =>
      _active.deleteAllSocketMessageInfo();
}

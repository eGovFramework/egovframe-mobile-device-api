import 'package:egovframe_mobile_deviceapi_app/data/socket/datasources/socket_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/entities/socket_message_info.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/socket/repositories/socket_repository.dart';
import 'package:web_socket_client/web_socket_client.dart' as ws;

typedef SocketConnectionReader = SocketConnectionState Function();

class SocketSqliteRepositoryImpl implements SocketRepository {
  final SocketSqliteService _service;
  final SocketConnectionReader _readConnection;

  SocketSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Stream<ws.ConnectionState> watchConnectionState() {
    throw UnsupportedError('SQLite 모드에서는 WebSocket 연결 상태를 사용하지 않습니다.');
  }

  @override
  Stream<String> watchIncomingMessages() {
    throw UnsupportedError('SQLite 모드에서는 WebSocket 수신 메시지를 사용하지 않습니다.');
  }

  @override
  Future<void> connectWebSocket() {
    throw UnsupportedError('SQLite 모드에서는 WebSocket 연결을 사용하지 않습니다.');
  }

  @override
  Future<void> disconnectWebSocket() {
    throw UnsupportedError('SQLite 모드에서는 WebSocket 해제를 사용하지 않습니다.');
  }

  @override
  bool get isWebSocketConnected =>
      throw UnsupportedError('SQLite 모드에서는 WebSocket 연결 여부를 사용하지 않습니다.');

  @override
  void sendChatMessage({
    required String sender,
    required String message,
  }) {
    throw UnsupportedError('SQLite 모드에서는 WebSocket 메시지 전송을 사용하지 않습니다.');
  }

  @override
  Future<int?> uploadSocketMessageInfo(SocketMessageInfo info) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return null;
    return _service.uploadSocketMessageInfo(dbFileName, info);
  }

  @override
  Future<List<SocketMessageInfo>> getSocketMessageList() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return [];
    return _service.getSocketMessageList(dbFileName);
  }

  @override
  Future<bool> deleteAllSocketMessageInfo() async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.deleteAllSocketMessageInfo(dbFileName);
  }
}

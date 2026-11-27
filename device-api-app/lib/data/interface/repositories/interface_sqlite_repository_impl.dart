import 'package:egovframe_mobile_deviceapi_app/data/interface/datasources/interface_sqlite_service.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/entities/interface_connection_mode.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/repositories/interface_repository.dart';

typedef InterfaceConnectionReader = InterfaceConnectionState Function();

class InterfaceSqliteRepositoryImpl implements InterfaceRepository {
  final InterfaceSqliteService _service;
  final InterfaceConnectionReader _readConnection;

  InterfaceSqliteRepositoryImpl(this._service, this._readConnection);

  String? get _dbFileName => _readConnection().sqliteDbFileName;

  @override
  Future<String> getDeviceUUID() {
    throw UnsupportedError('SQLite 모드에서는 로컬 UUID 조회를 사용하지 않습니다.');
  }

  @override
  Future<Map<String, dynamic>> login(String id, String password, String email) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {'success': false, 'message': 'SQLite DB가 선택되지 않았습니다.'};
    }
    return _service.login(dbFileName, id, password);
  }

  @override
  Future<Map<String, dynamic>> register(
    String id,
    String password,
    String email,
  ) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {'success': false, 'message': 'SQLite DB가 선택되지 않았습니다.'};
    }
    return _service.register(dbFileName, id, password, email);
  }

  @override
  Future<bool> checkAccountExists(String id, String password, String email) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) return false;
    return _service.checkAccountExists(dbFileName, id, password, email);
  }

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {'success': false, 'message': 'SQLite DB가 선택되지 않았습니다.'};
    }
    return _service.getUserInfo(dbFileName, userId, userPw);
  }

  @override
  Future<Map<String, dynamic>> withdraw(String userId, String userPw) async {
    final dbFileName = _dbFileName;
    if (dbFileName == null) {
      return {'success': false, 'message': 'SQLite DB가 선택되지 않았습니다.'};
    }
    return _service.withdraw(dbFileName, userId, userPw);
  }
}

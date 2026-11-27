import 'package:egovframe_mobile_deviceapi_app/data/interface/repositories/interface_remote_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/data/interface/repositories/interface_sqlite_repository_impl.dart';
import 'package:egovframe_mobile_deviceapi_app/domain/interface/repositories/interface_repository.dart';

class InterfaceRepositoryImpl implements InterfaceRepository {
  final InterfaceRemoteRepositoryImpl _remote;
  final InterfaceSqliteRepositoryImpl _sqlite;
  final InterfaceConnectionReader _readConnection;

  InterfaceRepositoryImpl({
    required InterfaceRemoteRepositoryImpl remote,
    required InterfaceSqliteRepositoryImpl sqlite,
    required InterfaceConnectionReader readConnection,
  })  : _remote = remote,
        _sqlite = sqlite,
        _readConnection = readConnection;

  InterfaceRepository get _active =>
      _readConnection().isSqlite ? _sqlite : _remote;

  @override
  Future<String> getDeviceUUID() => _remote.getDeviceUUID();

  @override
  Future<Map<String, dynamic>> login(String id, String password, String email) =>
      _active.login(id, password, email);

  @override
  Future<Map<String, dynamic>> register(
    String id,
    String password,
    String email,
  ) =>
      _active.register(id, password, email);

  @override
  Future<bool> checkAccountExists(String id, String password, String email) =>
      _active.checkAccountExists(id, password, email);

  @override
  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw) =>
      _active.getUserInfo(userId, userPw);

  @override
  Future<Map<String, dynamic>> withdraw(String userId, String userPw) =>
      _active.withdraw(userId, userPw);
}

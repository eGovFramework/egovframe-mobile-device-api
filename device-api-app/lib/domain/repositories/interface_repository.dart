abstract class InterfaceRepository {
  Future<Map<String, dynamic>> login(String id, String password, String email);
  Future<Map<String, dynamic>> register(String id, String password, String email);
  Future<bool> checkAccountExists(String id, String password, String email);
  Future<Map<String, dynamic>> getUserInfo(String userId, String userPw);
  Future<Map<String, dynamic>> withdraw(String userId, String userPw);
}


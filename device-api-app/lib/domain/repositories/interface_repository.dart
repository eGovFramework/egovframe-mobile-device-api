abstract class InterfaceRepository {
  Future<Map<String, dynamic>> login(String id, String password);
  Future<Map<String, dynamic>> register(String id, String password, String email);
  Future<bool> checkAccountExists(String id, String password, String email);
  Future<Map<String, dynamic>> getUserInfo(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  });

  Future<Map<String, dynamic>> withdraw(
    String userId,
    String userPw, {
    bool isPasswordHashed = false,
  });
}

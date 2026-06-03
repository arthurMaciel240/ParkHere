import '../models/user_model.dart';

abstract class AuthService {
  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;

  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String phone, String password, String role);
  Future<void> logout();
}

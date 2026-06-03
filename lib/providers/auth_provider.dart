import 'package:flutter/foundation.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService) {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  UserModel? _user;
  bool _loading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isDriver => _user?.role == 'driver';
  bool get isOwner => _user?.role == 'owner';
  bool get loading => _loading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.login(email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String phone, String password, String role) async {
    _setLoading(true);
    _error = null;
    try {
      await _authService.register(name, email, phone, password, role);
      _setLoading(false);
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}

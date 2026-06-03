import 'dart:async';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';
import 'auth_service.dart';

class AuthServiceMock implements AuthService {
  final _uuid = const Uuid();
  final _controller = StreamController<UserModel?>.broadcast();

  UserModel? _currentUser;

  final _users = <String, UserModel>{};

  AuthServiceMock() {
    // Seed users for demo
    _seedUsers();
  }

  void _seedUsers() {
    final driver = UserModel(
      id: 'driver-1',
      name: 'João Motorista',
      email: 'joao@email.com',
      phone: '31999999999',
      role: 'driver',
    );
    final owner = UserModel(
      id: 'owner-1',
      name: 'Maria Proprietária',
      email: 'maria@email.com',
      phone: '31988888888',
      role: 'owner',
    );
    _users[driver.email] = driver;
    _users[owner.email] = owner;
  }

  @override
  UserModel? get currentUser => _currentUser;

  @override
  Stream<UserModel?> get authStateChanges => _controller.stream;

  @override
  Future<UserModel> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = _users[email.toLowerCase()];
    if (user == null) {
      throw Exception('Usuário não encontrado');
    }
    if (password.length < 4) {
      throw Exception('Senha inválida');
    }
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<UserModel> register(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (_users.containsKey(email.toLowerCase())) {
      throw Exception('E-mail já cadastrado');
    }
    final user = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email.toLowerCase(),
      phone: phone,
      role: role,
    );
    _users[user.email] = user;
    _currentUser = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _controller.add(null);
  }
}

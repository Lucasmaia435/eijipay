import 'package:frontend/core/models/usuario.dart';

abstract class AuthRepository {
  Future<Usuario> login(String email, String senha);
  Future<Usuario> register(String nome, String email, String senha, String papel);
  Future<void> logout();
  Future<Usuario?> getCurrentUser();
  Future<bool> isAuthenticated();
}

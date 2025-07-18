import 'package:flutter/foundation.dart';
import 'package:frontend/core/models/usuario.dart';
import 'package:frontend/modules/auth/repositories/auth_repository.dart';

class AuthService extends ChangeNotifier {
  final AuthRepository _authRepository;

  Usuario? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = false;

  AuthService(this._authRepository);

  Usuario? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  // Inicializar serviço verificando se há usuário logado
  Future<void> initialize() async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.getCurrentUser();
      _isAuthenticated = _currentUser != null;

      if (_isAuthenticated) {
        // Verificar se o token ainda é válido
        final isValid = await _authRepository.isAuthenticated();
        if (!isValid) {
          await logout();
        }
      }
    } catch (e) {
      await logout();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login(String email, String senha) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.login(email, senha);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(String nome, String email, String senha, String papel) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.register(nome, email, senha, papel);
      _isAuthenticated = true;
      notifyListeners();
      return true;
    } catch (e) {
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authRepository.logout();
    } catch (e) {
      // Ignorar erros de logout
    } finally {
      _currentUser = null;
      _isAuthenticated = false;
      _setLoading(false);
      notifyListeners();
    }
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
}

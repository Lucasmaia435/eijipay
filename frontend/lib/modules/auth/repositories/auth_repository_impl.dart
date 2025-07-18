import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/http/http_adapter.dart';
import 'package:frontend/core/models/usuario.dart';
import 'package:frontend/core/services/storage_service.dart';
import 'package:frontend/core/exceptions/api_exceptions.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final HttpAdapter _httpAdapter;

  AuthRepositoryImpl(this._httpAdapter);

  @override
  Future<Usuario> login(String email, String senha) async {
    try {
      final response = await _httpAdapter.post('/users/login', data: {'email': email, 'senha': senha});

      // Estrutura de resposta da API:
      // {
      //   "message": "Login bem-sucedido!",
      //   "token": "token",
      //   "usuario": { "id": 4, "email": "...", "nome": "...", "papel": "..." }
      // }

      final usuario = Usuario.fromJson(response['usuario']);
      final token = response['token'];

      // Salvar token e dados do usuário
      await StorageService.saveToken(token);
      await StorageService.saveUserData(jsonEncode(usuario.toJson()));

      // Configurar token no adapter HTTP
      if (_httpAdapter is DioHttpAdapter) {
        _httpAdapter.setAuthToken(token);
      }

      return usuario.copyWith(token: token);
    } on DioException catch (e) {
      // Tratar resposta de erro específica da API
      if (e.response?.statusCode == 401 || e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          throw UnauthorizedException(errorData['message']);
        }
        throw const UnauthorizedException('Credenciais inválidas');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<Usuario> register(String nome, String email, String senha, String papel) async {
    try {
      final response = await _httpAdapter.post('/users/new', data: {'nome': nome, 'email': email, 'senha': senha, 'papel': papel});

      // Estrutura de resposta da API para registro:
      // Assumindo que pode ser similar ao login ou usar 'user'
      final usuarioData = response['usuario'] ?? response['user'];
      final usuario = Usuario.fromJson(usuarioData);
      final token = response['token'];

      // Salvar token e dados do usuário
      await StorageService.saveToken(token);
      await StorageService.saveUserData(jsonEncode(usuario.toJson()));

      // Configurar token no adapter HTTP
      if (_httpAdapter is DioHttpAdapter) {
        _httpAdapter.setAuthToken(token);
      }

      return usuario.copyWith(token: token);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          throw ValidationException(errorData['message']);
        }
        throw const ValidationException('Email já está em uso');
      } else if (e.response?.statusCode == 400) {
        final errorData = e.response?.data;
        if (errorData != null && errorData['message'] != null) {
          throw ValidationException(errorData['message']);
        }
        throw const ValidationException('Dados inválidos');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Limpar dados locais
      await StorageService.deleteToken();
      await StorageService.deleteUserData();

      // Remover token do adapter HTTP
      if (_httpAdapter is DioHttpAdapter) {
        _httpAdapter.removeAuthToken();
      }
    } catch (e) {
      // Em caso de erro, tentar limpar o token
      if (kDebugMode) {
        debugPrint('Erro ao limpar dados de logout: $e');
      }

      try {
        await StorageService.deleteToken();
        await StorageService.deleteUserData();
      } catch (cleanupError) {
        if (kDebugMode) {
          debugPrint('Erro crítico na limpeza de dados: $cleanupError');
        }
      }
    }
  }

  @override
  Future<Usuario?> getCurrentUser() async {
    try {
      final userData = await StorageService.getUserData();
      final token = await StorageService.getToken();

      if (userData != null && token != null) {
        final userJson = jsonDecode(userData);
        final usuario = Usuario.fromJson(userJson);

        // Configurar token no adapter HTTP
        if (_httpAdapter is DioHttpAdapter) {
          _httpAdapter.setAuthToken(token);
        }

        return usuario.copyWith(token: token);
      }

      return null;
    } catch (e) {
      await StorageService.deleteToken();
      await StorageService.deleteUserData();
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await StorageService.getToken();
      final userIdData = await StorageService.getUserData();
      final user = userIdData != null ? Usuario.fromJson(jsonDecode(userIdData)) : null;

      if (token == null) return false;

      // Para JWT, verificar se o token ainda é válido
      // Pode usar uma rota específica para verificação ou tentar qualquer rota protegida
      await _httpAdapter
          .get('/users/${user?.id}')
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout na verificação de autenticação');
            },
          );
      return true;
    } catch (e) {
      // Token inválido ou expirado, limpar dados
      await StorageService.deleteToken();
      await StorageService.deleteUserData();
      if (_httpAdapter is DioHttpAdapter) {
        _httpAdapter.removeAuthToken();
      }
      return false;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:frontend/core/http/http_adapter.dart';
import 'package:frontend/core/models/funcionario.dart';
import 'package:frontend/core/exceptions/api_exceptions.dart';
import 'funcionarios_repository.dart';

class FuncionariosRepositoryImpl implements FuncionariosRepository {
  final HttpAdapter _httpAdapter;

  FuncionariosRepositoryImpl(this._httpAdapter);

  @override
  Future<List<Funcionario>> getAllFuncionarios() async {
    try {
      final response = await _httpAdapter.get('/funcionarios');
      final funcionarios = (response['funcionarios'] as List).map((json) => Funcionario.fromJson(json)).toList();
      return funcionarios;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<Funcionario> getFuncionarioById(String id) async {
    try {
      final response = await _httpAdapter.get('/funcionarios/$id');
      return Funcionario.fromJson(response['funcionario']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ApiException('Funcionário não encontrado');
      } else if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<Funcionario> createFuncionario(Funcionario funcionario) async {
    try {
      final response = await _httpAdapter.post('/funcionarios', data: funcionario.toCreateJson());
      return Funcionario.fromJson(response['funcionario']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException('Dados inválidos', errors: _parseValidationErrors(e.response?.data));
      } else if (e.response?.statusCode == 409) {
        throw const ValidationException('CPF ou email já cadastrado');
      } else if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<Funcionario> updateFuncionario(String id, Funcionario funcionario) async {
    try {
      final response = await _httpAdapter.put('/funcionarios/$id', data: funcionario.toCreateJson());
      return Funcionario.fromJson(response['funcionario']);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ApiException('Funcionário não encontrado');
      } else if (e.response?.statusCode == 400) {
        throw ValidationException('Dados inválidos', errors: _parseValidationErrors(e.response?.data));
      } else if (e.response?.statusCode == 409) {
        throw const ValidationException('CPF ou email já cadastrado');
      } else if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFuncionario(String id) async {
    try {
      await _httpAdapter.delete('/funcionarios/$id');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw const ApiException('Funcionário não encontrado');
      } else if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  @override
  Future<List<Funcionario>> searchFuncionarios(String query) async {
    try {
      final response = await _httpAdapter.get('/funcionarios/search', params: {'q': query});
      final funcionarios = (response['funcionarios'] as List).map((json) => Funcionario.fromJson(json)).toList();
      return funcionarios;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Sessão expirada');
      }
      throw NetworkException(e.message ?? 'Erro de conexão');
    } catch (e) {
      throw ApiException('Erro inesperado: ${e.toString()}');
    }
  }

  Map<String, List<String>>? _parseValidationErrors(dynamic data) {
    if (data is Map<String, dynamic> && data.containsKey('errors')) {
      final errors = data['errors'] as Map<String, dynamic>;
      return errors.map((key, value) => MapEntry(key, (value as List).map((e) => e.toString()).toList()));
    }
    return null;
  }
}

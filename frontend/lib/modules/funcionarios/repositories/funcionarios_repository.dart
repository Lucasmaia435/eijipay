import 'package:frontend/core/models/funcionario.dart';

abstract class FuncionariosRepository {
  Future<List<Funcionario>> getAllFuncionarios();
  Future<Funcionario> getFuncionarioById(String id);
  Future<Funcionario> createFuncionario(Funcionario funcionario);
  Future<Funcionario> updateFuncionario(String id, Funcionario funcionario);
  Future<void> deleteFuncionario(String id);
  Future<List<Funcionario>> searchFuncionarios(String query);
}

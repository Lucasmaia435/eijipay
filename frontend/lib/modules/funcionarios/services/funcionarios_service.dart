import 'package:flutter/foundation.dart';
import 'package:frontend/core/models/funcionario.dart';
import 'package:frontend/modules/funcionarios/repositories/funcionarios_repository.dart';

class FuncionariosService extends ChangeNotifier {
  final FuncionariosRepository _funcionariosRepository;

  List<Funcionario> _funcionarios = [];
  List<Funcionario> _filteredFuncionarios = [];
  bool _isLoading = false;
  String _searchQuery = '';

  FuncionariosService(this._funcionariosRepository);

  List<Funcionario> get funcionarios => _filteredFuncionarios;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  Future<void> loadFuncionarios() async {
    _setLoading(true);
    try {
      _funcionarios = await _funcionariosRepository.getAllFuncionarios();
      _applyFilter();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchFuncionarios(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredFuncionarios = List.from(_funcionarios);
    } else {
      _setLoading(true);
      try {
        _filteredFuncionarios = await _funcionariosRepository.searchFuncionarios(query);
      } catch (e) {
        _applyFilter();
      } finally {
        _setLoading(false);
      }
    }
    notifyListeners();
  }

  Future<Funcionario> createFuncionario(Funcionario funcionario) async {
    try {
      final novoFuncionario = await _funcionariosRepository.createFuncionario(funcionario);
      _funcionarios.add(novoFuncionario);
      _applyFilter();
      return novoFuncionario;
    } catch (e) {
      rethrow;
    }
  }

  Future<Funcionario> updateFuncionario(String id, Funcionario funcionario) async {
    try {
      final funcionarioAtualizado = await _funcionariosRepository.updateFuncionario(id, funcionario);

      final index = _funcionarios.indexWhere((f) => f.id == id);
      if (index != -1) {
        _funcionarios[index] = funcionarioAtualizado;
        _applyFilter();
      }

      return funcionarioAtualizado;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFuncionario(String id) async {
    try {
      await _funcionariosRepository.deleteFuncionario(id);
      _funcionarios.removeWhere((f) => f.id == id);
      _applyFilter();
    } catch (e) {
      rethrow;
    }
  }

  Future<Funcionario> getFuncionarioById(String id) async {
    try {
      return await _funcionariosRepository.getFuncionarioById(id);
    } catch (e) {
      rethrow;
    }
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredFuncionarios = List.from(_funcionarios);
    } else {
      _filteredFuncionarios = _funcionarios.where((funcionario) {
        return funcionario.nome.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            funcionario.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            funcionario.cpf.contains(_searchQuery) ||
            funcionario.cargo.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilter();
  }
}

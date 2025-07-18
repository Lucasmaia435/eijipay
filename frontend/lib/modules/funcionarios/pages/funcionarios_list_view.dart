import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/modules/funcionarios/services/funcionarios_service.dart';
import 'package:frontend/core/models/funcionario.dart';
import 'package:intl/intl.dart';

class FuncionariosListView extends StatefulWidget {
  const FuncionariosListView({super.key});

  @override
  State<FuncionariosListView> createState() => _FuncionariosListViewState();
}

class _FuncionariosListViewState extends State<FuncionariosListView> {
  late final FuncionariosService _funcionariosService;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _funcionariosService = getIt<FuncionariosService>();
    _loadFuncionarios();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFuncionarios() async {
    try {
      await _funcionariosService.loadFuncionarios();
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Erro ao carregar funcionários');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Funcionários',
          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(onPressed: _loadFuncionarios, icon: const Icon(Icons.refresh), tooltip: 'Atualizar'),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => context.push('/funcionarios/novo'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.add, size: 20),
              label: Text(isDesktop ? 'Novo Funcionário' : 'Novo'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),

            Expanded(
              child: AnimatedBuilder(
                animation: _funcionariosService,
                builder: (context, child) {
                  if (_funcionariosService.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final funcionarios = _funcionariosService.funcionarios;

                  if (funcionarios.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildFuncionariosList(funcionarios, isDesktop);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar funcionários...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _funcionariosService.clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: (value) {
          setState(() {});
          _funcionariosService.searchFuncionarios(value);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: const Color(0xFF64748B).withOpacity(0.1), borderRadius: BorderRadius.circular(60)),
            child: const Icon(Icons.people_outline, size: 60, color: Color(0xFF64748B)),
          ),
          const SizedBox(height: 24),

          const Text(
            'Nenhum funcionário encontrado',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
          ),
          const SizedBox(height: 8),

          const Text(
            'Comece adicionando o primeiro funcionário da empresa',
            style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: () => context.push('/funcionarios/novo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Funcionário'),
          ),
        ],
      ),
    );
  }

  Widget _buildFuncionariosList(List<Funcionario> funcionarios, bool isDesktop) {
    if (isDesktop) {
      return _buildDesktopList(funcionarios);
    } else {
      return _buildMobileList(funcionarios);
    }
  }

  Widget _buildDesktopList(List<Funcionario> funcionarios) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Nome', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Cargo', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Salário', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
                Expanded(
                  flex: 1,
                  child: Text('Ações', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: funcionarios.length,
              itemBuilder: (context, index) {
                final funcionario = funcionarios[index];
                return _buildDesktopFuncionarioItem(funcionario, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopFuncionarioItem(Funcionario funcionario, int index) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF2563EB),
                  child: Text(
                    funcionario.nome.isNotEmpty ? funcionario.nome[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        funcionario.nome,
                        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                      ),
                      Text(funcionario.cpf, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(funcionario.cargo, style: const TextStyle(color: Color(0xFF374151))),
          ),
          Expanded(
            flex: 2,
            child: Text(funcionario.email, style: const TextStyle(color: Color(0xFF374151))),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(funcionario.salario),
              style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF059669)),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => context.push('/funcionarios/${funcionario.id}/editar'), icon: const Icon(Icons.edit_outlined), tooltip: 'Editar'),
                IconButton(onPressed: () => _showDeleteConfirmation(funcionario), icon: const Icon(Icons.delete_outlined), color: Colors.red, tooltip: 'Excluir'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileList(List<Funcionario> funcionarios) {
    return ListView.builder(
      itemCount: funcionarios.length,
      itemBuilder: (context, index) {
        final funcionario = funcionarios[index];
        return _buildMobileFuncionarioItem(funcionario);
      },
    );
  }

  Widget _buildMobileFuncionarioItem(Funcionario funcionario) {
    final currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/funcionarios/${funcionario.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF2563EB),
                    child: Text(
                      funcionario.nome.isNotEmpty ? funcionario.nome[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          funcionario.nome,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                        ),
                        Text(funcionario.cargo, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [Icon(Icons.edit_outlined), SizedBox(width: 8), Text('Editar')]),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outlined, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Excluir', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          context.push('/funcionarios/${funcionario.id}/editar');
                          break;
                        case 'delete':
                          _showDeleteConfirmation(funcionario);
                          break;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                        Text(funcionario.email, style: const TextStyle(fontSize: 14, color: Color(0xFF374151))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Salário',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                      Text(
                        currencyFormat.format(funcionario.salario),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF059669)),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Funcionario funcionario) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja excluir o funcionário ${funcionario.nome}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _deleteFuncionario(funcionario.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFuncionario(String id) async {
    try {
      await _funcionariosService.deleteFuncionario(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Funcionário excluído com sucesso'), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Erro ao excluir funcionário');
      }
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
  }
}

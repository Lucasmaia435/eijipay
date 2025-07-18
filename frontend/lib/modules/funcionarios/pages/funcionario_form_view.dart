import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/core/service_locator.dart';
import 'package:frontend/modules/funcionarios/services/funcionarios_service.dart';
import 'package:frontend/core/models/funcionario.dart';
import 'package:frontend/core/exceptions/api_exceptions.dart';
import 'package:intl/intl.dart';

class FuncionarioFormView extends StatefulWidget {
  final String? funcionarioId;

  const FuncionarioFormView({super.key, this.funcionarioId});

  @override
  State<FuncionarioFormView> createState() => _FuncionarioFormViewState();
}

class _FuncionarioFormViewState extends State<FuncionarioFormView> {
  final _formKey = GlobalKey<FormState>();
  late final FuncionariosService _funcionariosService;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cargoController = TextEditingController();
  final _salarioController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _enderecoController = TextEditingController();

  DateTime _dataAdmissao = DateTime.now();
  bool _ativo = true;
  bool _isLoading = false;
  bool _isEditing = false;
  Funcionario? _funcionarioOriginal;

  @override
  void initState() {
    super.initState();
    _funcionariosService = getIt<FuncionariosService>();
    _isEditing = widget.funcionarioId != null;

    if (_isEditing) {
      _loadFuncionario();
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _cargoController.dispose();
    _salarioController.dispose();
    _telefoneController.dispose();
    _enderecoController.dispose();
    super.dispose();
  }

  Future<void> _loadFuncionario() async {
    if (widget.funcionarioId == null) return;

    setState(() => _isLoading = true);

    try {
      _funcionarioOriginal = await _funcionariosService.getFuncionarioById(widget.funcionarioId!);
      _populateForm(_funcionarioOriginal!);
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Erro ao carregar dados do funcionário');
        context.pop();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _populateForm(Funcionario funcionario) {
    _nomeController.text = funcionario.nome;
    _emailController.text = funcionario.email;
    _cpfController.text = funcionario.cpf;
    _cargoController.text = funcionario.cargo;
    _salarioController.text = funcionario.salario.toStringAsFixed(2);
    _telefoneController.text = funcionario.telefone ?? '';
    _enderecoController.text = funcionario.endereco ?? '';
    _dataAdmissao = funcionario.dataAdmissao;
    _ativo = funcionario.ativo;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Funcionário' : 'Novo Funcionário',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 600 : double.infinity),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEditing ? 'Editar Funcionário' : 'Adicionar Novo Funcionário',
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                            ),
                            const SizedBox(height: 8),
                            Text(_isEditing ? 'Atualize as informações do funcionário' : 'Preencha as informações do novo funcionário', style: const TextStyle(fontSize: 16, color: Color(0xFF64748B))),
                            const SizedBox(height: 32),

                            _buildSectionHeader('Informações Pessoais'),
                            const SizedBox(height: 16),

                            if (isDesktop) ...[
                              Row(
                                children: [
                                  Expanded(child: _buildNomeField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildEmailField()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _buildCpfField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildTelefoneField()),
                                ],
                              ),
                            ] else ...[
                              _buildNomeField(),
                              const SizedBox(height: 16),
                              _buildEmailField(),
                              const SizedBox(height: 16),
                              _buildCpfField(),
                              const SizedBox(height: 16),
                              _buildTelefoneField(),
                            ],
                            const SizedBox(height: 16),
                            _buildEnderecoField(),
                            const SizedBox(height: 32),

                            _buildSectionHeader('Informações Profissionais'),
                            const SizedBox(height: 16),

                            if (isDesktop) ...[
                              Row(
                                children: [
                                  Expanded(child: _buildCargoField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildSalarioField()),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(child: _buildDataAdmissaoField()),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildAtivoField()),
                                ],
                              ),
                            ] else ...[
                              _buildCargoField(),
                              const SizedBox(height: 16),
                              _buildSalarioField(),
                              const SizedBox(height: 16),
                              _buildDataAdmissaoField(),
                              const SizedBox(height: 16),
                              _buildAtivoField(),
                            ],

                            const SizedBox(height: 32),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Cancelar'),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _handleSubmit,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2563EB),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                                        : Text(_isEditing ? 'Atualizar' : 'Salvar'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 2)),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
      ),
    );
  }

  Widget _buildNomeField() {
    return TextFormField(
      controller: _nomeController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Nome Completo *',
        prefixIcon: const Icon(Icons.person_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Nome é obrigatório';
        if (value!.trim().split(' ').length < 2) return 'Digite nome e sobrenome';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email *',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Email é obrigatório';
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
          return 'Digite um email válido';
        }
        return null;
      },
    );
  }

  Widget _buildCpfField() {
    return TextFormField(
      controller: _cpfController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _CpfInputFormatter()],
      decoration: InputDecoration(
        labelText: 'CPF *',
        prefixIcon: const Icon(Icons.badge_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'CPF é obrigatório';
        if (value!.replaceAll(RegExp(r'[^0-9]'), '').length != 11) {
          return 'CPF deve ter 11 dígitos';
        }
        return null;
      },
    );
  }

  Widget _buildTelefoneField() {
    return TextFormField(
      controller: _telefoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, _PhoneInputFormatter()],
      decoration: InputDecoration(
        labelText: 'Telefone',
        prefixIcon: const Icon(Icons.phone_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
    );
  }

  Widget _buildEnderecoField() {
    return TextFormField(
      controller: _enderecoController,
      maxLines: 2,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Endereço',
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
    );
  }

  Widget _buildCargoField() {
    return TextFormField(
      controller: _cargoController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: 'Cargo *',
        prefixIcon: const Icon(Icons.work_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Cargo é obrigatório';
        return null;
      },
    );
  }

  Widget _buildSalarioField() {
    return TextFormField(
      controller: _salarioController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      decoration: InputDecoration(
        labelText: 'Salário *',
        prefixIcon: const Icon(Icons.attach_money),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
        ),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Salário é obrigatório';
        final salary = double.tryParse(value!);
        if (salary == null || salary <= 0) return 'Digite um salário válido';
        return null;
      },
    );
  }

  Widget _buildDataAdmissaoField() {
    final dateFormat = DateFormat('dd/MM/yyyy');

    return InkWell(
      onTap: _selectDataAdmissao,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Data de Admissão *',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
        ),
        child: Text(dateFormat.format(_dataAdmissao), style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildAtivoField() {
    return Row(
      children: [
        const Icon(Icons.toggle_on_outlined),
        const SizedBox(width: 12),
        const Text('Status:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(width: 16),
        Expanded(
          child: Row(
            children: [
              Switch(value: _ativo, onChanged: (value) => setState(() => _ativo = value), activeColor: const Color(0xFF2563EB)),
              const SizedBox(width: 8),
              Text(
                _ativo ? 'Ativo' : 'Inativo',
                style: TextStyle(fontSize: 14, color: _ativo ? const Color(0xFF059669) : const Color(0xFFEF4444), fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDataAdmissao() async {
    final date = await showDatePicker(context: context, initialDate: _dataAdmissao, firstDate: DateTime(1900), lastDate: DateTime.now(), locale: const Locale('pt', 'BR'));

    if (date != null) {
      setState(() => _dataAdmissao = date);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final funcionario = Funcionario(
        id: _funcionarioOriginal?.id ?? '',
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        cpf: _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
        cargo: _cargoController.text.trim(),
        salario: double.parse(_salarioController.text),
        dataAdmissao: _dataAdmissao,
        telefone: _telefoneController.text.isNotEmpty ? _telefoneController.text : null,
        endereco: _enderecoController.text.isNotEmpty ? _enderecoController.text : null,
        ativo: _ativo,
      );

      if (_isEditing) {
        await _funcionariosService.updateFuncionario(widget.funcionarioId!, funcionario);
      } else {
        await _funcionariosService.createFuncionario(funcionario);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEditing ? 'Funcionário atualizado com sucesso!' : 'Funcionário cadastrado com sucesso!'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        String message = 'Erro ao salvar funcionário';

        if (e is ValidationException) {
          message = e.message;
          if (e.errors != null) {
            final errors = e.errors!.values.expand((x) => x).join(', ');
            message = errors;
          }
        } else if (e is NetworkException) {
          message = 'Erro de conexão. Verifique sua internet.';
        }

        _showErrorMessage(message);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
  }
}

class _CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length <= 11) {
      String formatted = text;
      if (text.length > 3) {
        formatted = '${text.substring(0, 3)}.${text.substring(3)}';
      }
      if (text.length > 6) {
        formatted = '${formatted.substring(0, 7)}.${formatted.substring(7)}';
      }
      if (text.length > 9) {
        formatted = '${formatted.substring(0, 11)}-${formatted.substring(11)}';
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return oldValue;
  }
}

// Formatador para Telefone
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (text.length <= 11) {
      String formatted = text;
      if (text.length > 2) {
        formatted = '(${text.substring(0, 2)}) ${text.substring(2)}';
      }
      if (text.length > 7) {
        formatted = '${formatted.substring(0, 10)}-${formatted.substring(10)}';
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    return oldValue;
  }
}

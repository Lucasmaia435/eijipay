class Funcionario {
  final String id;
  final String nome;
  final String email;
  final String cpf;
  final String cargo;
  final double salario;
  final DateTime dataAdmissao;
  final String? telefone;
  final String? endereco;
  final bool ativo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Funcionario({
    required this.id,
    required this.nome,
    required this.email,
    required this.cpf,
    required this.cargo,
    required this.salario,
    required this.dataAdmissao,
    this.telefone,
    this.endereco,
    this.ativo = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      id: json['id']?.toString() ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      cargo: json['cargo'] ?? '',
      salario: (json['salario'] ?? 0).toDouble(),
      dataAdmissao: json['dataAdmissao'] != null ? DateTime.parse(json['dataAdmissao']) : DateTime.now(),
      telefone: json['telefone'],
      endereco: json['endereco'],
      ativo: json['ativo'] ?? true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'cargo': cargo,
      'salario': salario,
      'dataAdmissao': dataAdmissao.toIso8601String(),
      'telefone': telefone,
      'endereco': endereco,
      'ativo': ativo,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {'nome': nome, 'email': email, 'cpf': cpf, 'cargo': cargo, 'salario': salario, 'dataAdmissao': dataAdmissao.toIso8601String(), 'telefone': telefone, 'endereco': endereco, 'ativo': ativo};
  }

  Funcionario copyWith({String? id, String? nome, String? email, String? cpf, String? cargo, double? salario, DateTime? dataAdmissao, String? telefone, String? endereco, bool? ativo, DateTime? createdAt, DateTime? updatedAt}) {
    return Funcionario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      cargo: cargo ?? this.cargo,
      salario: salario ?? this.salario,
      dataAdmissao: dataAdmissao ?? this.dataAdmissao,
      telefone: telefone ?? this.telefone,
      endereco: endereco ?? this.endereco,
      ativo: ativo ?? this.ativo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

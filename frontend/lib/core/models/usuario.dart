class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? papel;
  final String? token;
  final DateTime? createdAt;

  Usuario({required this.id, required this.nome, required this.email, this.papel, this.token, this.createdAt});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(id: json['id']?.toString() ?? '', nome: json['nome'] ?? '', email: json['email'] ?? '', papel: json['papel'], token: json['token'], createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'email': email, 'papel': papel, 'token': token, 'createdAt': createdAt?.toIso8601String()};
  }

  Usuario copyWith({String? id, String? nome, String? email, String? papel, String? token, DateTime? createdAt}) {
    return Usuario(id: id ?? this.id, nome: nome ?? this.nome, email: email ?? this.email, papel: papel ?? this.papel, token: token ?? this.token, createdAt: createdAt ?? this.createdAt);
  }
}

class Usuario {
  final String username;
  final String nombreCompleto;
  final String role;
  final String token;

  Usuario({
    required this.username,
    required this.nombreCompleto,
    required this.role,
    required this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      nombreCompleto: json['nombreCompleto'],
      role: json['role'],
      token: json['token'],
    );
  }

  bool esAdmin() {
    return role == 'ROLE_ADMIN';
  }

  bool esCajero() {
    return role == 'ROLE_CAJERO';
  }

  bool esCocina() {
    return role == 'ROLE_COCINA';
  }
}

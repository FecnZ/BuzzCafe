class Environment {
  Environment._();

  // Usa 'localhost' para que funcione en cualquier computadora donde corras
  // el frontend (Cajero/Admin) y el backend al mismo tiempo.
  // NOTA: Para la tablet de Cocina, tendrás que cambiar esto temporalmente a la IP de tu PC (ej. 10.228.6.20)
  static const String baseUrl = "http://localhost:8080/api";
}

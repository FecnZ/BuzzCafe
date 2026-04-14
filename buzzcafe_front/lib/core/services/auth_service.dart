import 'dart:convert';
import 'package:buzzcafe_front/core/models/Usuario.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String url =
      "http://10.228.6.86:8080/api/auth/login"; // Cambia la IP por la tuya

  Future<Usuario> login(String user, String pass) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": user, "password": pass}),
      );

      if (response.statusCode == 200) {
        return Usuario.fromJson(jsonDecode(response.body));
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? "Error desconocido");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}

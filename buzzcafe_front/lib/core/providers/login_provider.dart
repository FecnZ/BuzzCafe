import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/Usuario.dart'; // ¡Asegúrate de que la U sea mayúscula si tu archivo se llama así!

class LoginProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<Usuario?> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuario = await _authService.login(username, password);
      _isLoading = false;
      notifyListeners();
      return usuario;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      notifyListeners();
      return null;
    }
  }
}

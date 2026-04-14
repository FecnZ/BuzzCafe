// lib/providers/user_provider.dart
import 'package:buzzcafe_front/core/models/Usuario.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  Usuario? _usuario;

  Usuario? get usuario => _usuario;
  String? get role => _usuario?.role;
  String? get token => _usuario?.token;

  void setUsuario(Usuario user) {
    _usuario = user;
    notifyListeners();
  }

  void logout() {
    _usuario = null;
    notifyListeners();
  }
}

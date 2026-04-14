// lib/screens/main_wrapper.dart
import 'package:buzzcafe_front/features/admin/screens/admin_screen.dart';
import 'package:buzzcafe_front/features/cajero/screens/cajero_screen.dart';
import 'package:buzzcafe_front/features/cocina/screens/cocina_screen.dart';
import 'package:buzzcafe_front/features/auth/screens/login_screen.dart';
import 'package:buzzcafe_front/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    // 1. Si no hay usuario, mandamos al Login
    if (userProvider.usuario == null) {
      return const LoginScreen();
    }

    // 2. Si hay usuario, decidimos por ROL
    switch (userProvider.usuario!.role) {
      case 'ROLE_ADMIN':
        return const AdminScreen();
      case 'ROLE_COCINA':
        return const CocinaScreen();
      case 'ROLE_CAJERO':
        return const CajeroScreen();
      default:
        return const LoginScreen(); // Por seguridad
    }
  }
}

// lib/screens/login_screen.dart
import 'package:buzzcafe_front/core/providers/user_provider.dart';
import 'package:buzzcafe_front/core/utils/notificacionesUI.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/login_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _intentarLogin() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, llena ambos campos")),
      );
      return;
    }

    final loginProvider = context.read<LoginProvider>();

    final usuario = await loginProvider.login(
      _userController.text.trim(),
      _passController.text,
    );

    if (usuario != null) {
      if (!mounted) return;

      context.read<UserProvider>().setUsuario(usuario);
      NotificacionesUI.mostrarExito(
        context,
        "Bienvenido ${usuario.nombreCompleto}",
      );
    } else {
      // Mostrar el error que viene del Provider
      NotificacionesUI.mostrarError(
        context,
        loginProvider.errorMessage ?? "Usuario o contraseña incorrectos",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: colorScheme.brightness == Brightness.light
                  ? Colors.white
                  : AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.coffee_rounded,
                    size: 48,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  "BuzzCafe",
                  style: AppTextStyles.titleStyle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Ingresa a tu cuenta",
                  style: AppTextStyles.subtitleStyle.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 36),

                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: "Usuario",
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.iconBrown,
                    ),
                    filled: true,
                    fillColor: AppColors.textDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.iconBrown,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.iconBrown,
                    ),
                    filled: true,
                    fillColor: AppColors.textDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppColors.iconBrown,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 36),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBrown,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: loginProvider.isLoading ? null : _intentarLogin,
                    child: loginProvider.isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "ENTRAR",
                            style: AppTextStyles.buttonTextStyle,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

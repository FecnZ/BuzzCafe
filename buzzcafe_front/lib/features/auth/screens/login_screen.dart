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

    // Esperamos la respuesta del servidor...
    final usuario = await loginProvider.login(
      _userController.text.trim(),
      _passController.text,
    );

    // SOLUCIÓN AL SUBRAYADO AZUL:
    // Verificamos si el widget sigue en pantalla antes de usar el context
    if (!mounted) return;

    if (usuario != null) {
      context.read<UserProvider>().setUsuario(usuario);
      NotificacionesUI.mostrarExito(
        context,
        "Bienvenido ${usuario.nombreCompleto}",
      );
    } else {
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
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Imagen de Fondo
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?q=80&w=1000&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),

          // Capa oscura usando un color predefinido de Material (sin withOpacity)
          Positioned.fill(
            child: Container(
              color: Colors
                  .black54, // Equivale a un negro con 54% de transparencia
            ),
          ),

          // Contenido Principal
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 380),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    // Colores completamente sólidos
                    color: colorScheme.brightness == Brightness.light
                        ? Colors.white
                        : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54, // Sombra predefinida
                        blurRadius: 24,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors
                              .brown
                              .shade50, // Color sólido suave para el fondo del ícono
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ingresa a tu cuenta",
                        style: AppTextStyles.subtitleStyle.copyWith(
                          color: Colors
                              .grey
                              .shade600, // Color sólido en lugar de onSurface con opacidad
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Input Usuario
                      TextField(
                        controller: _userController,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          labelText: "Usuario",
                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.iconBrown,
                          ),
                          filled: true,
                          fillColor: colorScheme.brightness == Brightness.light
                              ? Colors
                                    .grey
                                    .shade100 // Fondo sólido claro
                              : Colors.grey.shade900, // Fondo sólido oscuro
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

                      // Input Contraseña
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        style: TextStyle(color: colorScheme.onSurface),
                        decoration: InputDecoration(
                          labelText: "Contraseña",
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: AppColors.iconBrown,
                          ),
                          filled: true,
                          fillColor: colorScheme.brightness == Brightness.light
                              ? Colors.grey.shade100
                              : Colors.grey.shade900,
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

                      // Botón
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBrown,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: loginProvider.isLoading
                              ? null
                              : _intentarLogin,
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
          ),
        ],
      ),
    );
  }
}

import 'package:buzzcafe_front/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class NotificacionesUI {
  // 1. Mensaje de éxito (Verde o del color de tu tema, como Marrón)
  static void mostrarExito(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryBrown,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // 2. Mensaje de error (Rojo)
  static void mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(
          seconds: 4,
        ), // Un poco más de tiempo para leer el error
      ),
    );
  }
}

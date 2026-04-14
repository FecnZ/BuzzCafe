import 'package:flutter/material.dart';

class AppTextStyles {
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
    // Eliminamos el color fijo para que use el del tema (onSurface)
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    // Color manejado por el el tema o gris por defecto
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );
}

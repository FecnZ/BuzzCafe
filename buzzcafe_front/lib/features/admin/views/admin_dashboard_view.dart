import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final Color selectedColor = AppColors.primaryOrange;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Resumen general del sistema",
          style: TextStyle(
            color: colorScheme.onSurface.withAlpha(153),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 20),

        // Fila de tarjetas de resumen
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                "Ventas del día",
                "\$ 8,450 mxn",
                true,
                colorScheme,
                isDark,
                selectedColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInfoCard(
                "Pedidos realizados",
                "124 hoy",
                false,
                colorScheme,
                isDark,
                selectedColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInfoCard(
                "Producto más vendido",
                "Café",
                false,
                colorScheme,
                isDark,
                selectedColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildInfoCard(
                "Ingresos Mensuales",
                "\$50, 500 mxn",
                false,
                colorScheme,
                isDark,
                selectedColor,
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Gráfica y Alertas
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ventas de la semana",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Icon(
                            Icons.show_chart,
                            size: 150,
                            color: selectedColor.withAlpha(isDark ? 204 : 102),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Alertas",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildAlertItem(
                        Icons.inventory_2_outlined,
                        "Producto sin stock:\nCappuccino",
                        Colors.red,
                        colorScheme,
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildAlertItem(
                        Icons.warning_amber_rounded,
                        "Stock bajo: Brownie\n(5 unidades)",
                        Colors.orange,
                        colorScheme,
                        isDark,
                      ),
                      const SizedBox(height: 10),
                      _buildAlertItem(
                        Icons.error_outline,
                        "Error en sistema\ndetectado",
                        Colors.red,
                        colorScheme,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    bool isPrimary,
    ColorScheme colorScheme,
    bool isDark,
    Color selectedColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isPrimary ? selectedColor : colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isPrimary
                  ? (isDark ? AppColors.textDark : Colors.white.withAlpha(230))
                  : colorScheme.onSurface.withAlpha(153),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: TextStyle(
              color: isPrimary
                  ? (isDark ? Colors.black87 : Colors.white)
                  : colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    IconData icon,
    String text,
    Color color,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withAlpha(38) : color.withAlpha(13),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: isDark ? color.withAlpha(230) : color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 13,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_sidebar.dart';
import '../views/cajero_card_config_view.dart';
import '../views/cajero_pos_view.dart';

class CajeroScreen extends StatefulWidget {
  const CajeroScreen({super.key});

  @override
  State<CajeroScreen> createState() => _CajeroScreenState();
}

class _CajeroScreenState extends State<CajeroScreen> {
  int selectedIndex = 0;

  final List<SidebarItem> _cajeroItems = [
    SidebarItem(icon: Icons.point_of_sale, title: "Menú / POS"),
    SidebarItem(icon: Icons.history, title: "Historial"),
    SidebarItem(icon: Icons.card_membership, title: "Configuración Tarjeta"),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final Color selectedColor = AppColors.primaryOrange;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          CustomSidebar(
            roleName: "Cajero Panel",
            items: _cajeroItems,
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            onLogout: () {
              context.read<UserProvider>().logout();
            },
          ),
          Expanded(
            child: _buildMainContent(colorScheme, isDark, selectedColor),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(
      ColorScheme colorScheme, bool isDark, Color selectedColor) {
    return Column(
      children: [
        // Top Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getTitleForIndex(selectedIndex),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Cajero",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "caja1@buzzcafe.com",
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  CircleAvatar(
                    backgroundColor: selectedColor,
                    child: Icon(
                      Icons.person,
                      color: isDark ? AppColors.textDark : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _getContentForIndex(selectedIndex, colorScheme),
          ),
        ),
      ],
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return "Tomar Pedido";
      case 1:
        return "Historial de Órdenes";
      case 2:
        return "Configuración de Tarjeta De Fidelización";
      default:
        return "";
    }
  }

  Widget _getContentForIndex(int index, ColorScheme colorScheme) {
    switch (index) {
      case 0:
        return const CajeroPOSView();
      case 1:
        return Center(
          child: Text(
            "Historial de ventas va aquí",
            style: TextStyle(color: colorScheme.onSurface),
          ),
        );
      case 2:
        return const CajeroCardConfigView();
      default:
        return Center(
          child: Text("Selecciona una opción",
              style: TextStyle(color: colorScheme.onSurface)),
        );
    }
  }
}

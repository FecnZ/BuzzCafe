import 'package:buzzcafe_front/features/admin/provider/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_sidebar.dart'; // Importa nuestro nuevo widget
import '../views/admin_dashboard_view.dart'; // Importa la nueva vista separada
import '../views/admin_menu_view.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  // Índice de la opción seleccionada del menú
  int selectedIndex = 0;

  // Lista de opciones para el panel de administración
  final List<SidebarItem> _adminItems = [
    SidebarItem(icon: Icons.dashboard_outlined, title: "Vista General"),
    SidebarItem(icon: Icons.restaurant_menu, title: "Menú y precios"),
    SidebarItem(icon: Icons.people_outline, title: "Usuarios"),
    SidebarItem(icon: Icons.access_time, title: "Historial"),
    SidebarItem(icon: Icons.settings_outlined, title: "Configuración"),
  ];

  @override
  void initState() {
    super.initState();
    // Pedimos los productos en cuanto el Admin entra al panel principal
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<UserProvider>().token;
      if (token != null) {
        context.read<AdminProvider>().cargarProductos(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // Colores basados en el tema (Claro u Oscuro)
    final Color selectedColor =
        AppColors.primaryOrange; // Mantenemos el naranja como acento principal

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Implementación de nuestro CustomSidebar reutilizable
          CustomSidebar(
            roleName: "Admin Panel",
            items: _adminItems,
            selectedIndex: selectedIndex,
            onItemSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            onLogout: () {
              // La lógica centralizada del log out ahora vive en el padre "Inteligente"
              context.read<UserProvider>().logout();
            },
          ),

          // Contenido Principal
          Expanded(
            child: _buildMainContent(colorScheme, isDark, selectedColor),
          ),
        ],
      ),
    );
  }

  // Constructor del contenido principal a la derecha del sidebar
  Widget _buildMainContent(
    ColorScheme colorScheme,
    bool isDark,
    Color selectedColor,
  ) {
    return Column(
      children: [
        // Header superior del contenido (Top Bar)
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
                        "Administrador",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "admin@buzzcafe.com",
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

        // Cuerpo de la vista seleccionada
        Expanded(
          child: Container(
            color: Theme.of(
              context,
            ).scaffoldBackgroundColor, // Usa el fondo base del tema
            padding: const EdgeInsets.all(30),
            child: _getContentForIndex(
              selectedIndex,
              colorScheme,
              isDark,
              selectedColor,
            ),
          ),
        ),
      ],
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return "Vista General";
      case 1:
        return "Menú y precios";
      case 2:
        return "Usuarios";
      case 3:
        return "Historial";
      case 4:
        return "Configuración";
      default:
        return "";
    }
  }

  Widget _getContentForIndex(
    int index,
    ColorScheme colorScheme,
    bool isDark,
    Color selectedColor,
  ) {
    switch (index) {
      case 0:
        return const AdminDashboardView();
      case 1:
        return const AdminMenuView();
      case 2:
        return Center(
          child: Text(
            "Gestión de Usuarios",
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
        );
      default:
        return Center(
          child: Text(
            "Aquí va el contenido de: ${_getTitleForIndex(index)}",
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.onSurface.withAlpha(153),
            ),
          ),
        );
    }
  }
}

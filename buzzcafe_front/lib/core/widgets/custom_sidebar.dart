import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Modelo de datos para las opciones del menú en el sidebar
class SidebarItem {
  final IconData icon;
  final String title;

  SidebarItem({required this.icon, required this.title});
}

/// Un Sidebar animado y reutilizable para cualquier rol de usuario
class CustomSidebar extends StatefulWidget {
  final String roleName;
  final List<SidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback
  onLogout; // Nuevo callback ciego para delegar el logout al padre

  const CustomSidebar({
    super.key,
    required this.roleName,
    required this.items,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  State<CustomSidebar> createState() => _CustomSidebarState();
}

class _CustomSidebarState extends State<CustomSidebar> {
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    final Color sidebarColor = isDark
        ? AppColors.surfaceDark
        : AppColors.primaryBrown;
    final Color selectedColor = AppColors.primaryOrange;

    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 350,
      ), // Aumentamos la duración para mayor suavidad
      curve: Curves.fastOutSlowIn, // Curva más estética para deslizar
      width: isExpanded ? 230 : 70, // Ancho dinámico
      color: sidebarColor,
      child: Column(
        children: [
          const SizedBox(height: 25),

          // Cabecera: Icono de hamburguesa y Logo (usamos SingleChildScrollView para evitar desbordes al achicar)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width:
                  230, // Fijar tamaño para que el interior no recalcule y provoque saltos
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  // Botón que siempre queda anclado a la izquierda
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    tooltip: isExpanded ? 'Colapsar menú' : 'Expandir menú',
                  ),

                  // Retenedor de imagen (suavizado con opacidad en lugar de solo desaparecer)
                  AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 150,
                    ), // Se desvanece rápido
                    opacity: isExpanded ? 1.0 : 0.0,
                    child: Container(
                      margin: const EdgeInsets.only(left: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? colorScheme.surface : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.coffee,
                            color: isDark ? selectedColor : Colors.brown,
                            size: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "BUZZCAFE",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isDark ? selectedColor : Colors.brown,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            softWrap: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          // Título del Rol, también prevenimos su desborde
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              width: 230,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isExpanded ? 1.0 : 0.0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: Text(
                      widget.roleName,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Lista dinámica de opciones recibidas
          Expanded(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return _buildMenuItem(
                  icon: item.icon,
                  title: item.title,
                  index: index,
                  isSelected: widget.selectedIndex == index,
                  isDark: isDark,
                  selectedColor: selectedColor,
                );
              },
            ),
          ),

          // Botón de Cerrar Sesión
          _buildMenuItem(
            icon: Icons.logout,
            title: "Cerrar Sesión",
            index: -1, // No importa el índice local
            isSelected: false,
            isLogout: true,
            isDark: isDark,
            selectedColor: selectedColor,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Celda o elemento individual del menú
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required int index,
    required bool isSelected,
    bool isLogout = false,
    required bool isDark,
    required Color selectedColor,
  }) {
    return InkWell(
      onTap: () {
        if (isLogout) {
          // Ya no tenemos lógica de negocio aquí. Solo "avisamos" al padre.
          widget.onLogout();
        } else {
          widget.onItemSelected(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected && !isLogout ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        // Fijo la anchura interna a través de una Fila predecible
        // y aplico el clip por el AnimatedContainer padre.
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width: 210, // Ancho fijo para evitar redibujados del texto
            child: Row(
              children: [
                // Margen fijo a la izquierda. Al ensanchar o achicar,
                // el icono siempre estará estático y en la misma posición visual.
                const SizedBox(width: 13),
                Icon(
                  icon,
                  color: isLogout
                      ? Colors.red[400]
                      : (isSelected
                            ? (isDark ? Colors.black87 : Colors.white)
                            : Colors.white70),
                  size: 24,
                ),
                const SizedBox(width: 15),
                // Texto que desvanece su borde si no cabe (cuando colapsamos se oculta tras la máscara)
                Expanded(
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isExpanded ? 1.0 : 0.0,
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isLogout
                            ? Colors.red[400]
                            : (isSelected
                                  ? (isDark ? Colors.black87 : Colors.white)
                                  : Colors.white70),
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      softWrap:
                          false, // ¡Crucial! Evita que baje a renglones extra
                      overflow: TextOverflow
                          .fade, // Efecto suave al ocultarse/mostrar
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

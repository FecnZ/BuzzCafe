import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_sidebar.dart';
import '../models/kitchen_order.dart';
import '../views/cocina_orders_view.dart';
import '../views/cocina_history_view.dart';

class CocinaScreen extends StatefulWidget {
  const CocinaScreen({super.key});

  @override
  State<CocinaScreen> createState() => _CocinaScreenState();
}

class _CocinaScreenState extends State<CocinaScreen> {
  int selectedIndex = 0;

  final List<SidebarItem> _cocinaItems = [
    SidebarItem(icon: Icons.restaurant_menu, title: "Órdenes Activas"),
    SidebarItem(icon: Icons.history, title: "Historial"),
  ];

  // ═══════════════════════════════════════════════════════════════════
  //  Datos MOCK — Se reemplazarán con datos reales del backend
  // ═══════════════════════════════════════════════════════════════════
  late List<KitchenOrder> _activeOrders;
  late List<KitchenOrder> _completedOrders;

  @override
  void initState() {
    super.initState();
    _completedOrders = [
      KitchenOrder('098', 'Mesa 4', '09:15', 'entregado', [
        OrderItem(1, 'Café Latte'),
        OrderItem(1, 'Croissant'),
      ], cajero: 'Cajero 1'),
      KitchenOrder('099', 'Mesa 2', '09:40', 'entregado', [
        OrderItem(2, 'Huevos Revueltos'),
        OrderItem(1, 'Jugo Verde'),
      ], cajero: 'Cajero 2'),
    ];
    _activeOrders = [
      KitchenOrder('001', 'Mesa 1', '10:15', 'pendiente', [
        OrderItem(2, 'Hot Cakes Extras', note: 'Sin mantequilla'),
        OrderItem(1, 'Café Americano'),
        OrderItem(1, 'Jugo de Naranja'),
      ], cajero: 'Cajero 1'),
      KitchenOrder('002', 'Mesa 3', '10:22', 'pendiente', [
        OrderItem(1, 'Ensalada César'),
        OrderItem(2, 'Frappé Moka', note: 'Extra chocolate'),
      ], cajero: 'Cajero 1'),
      KitchenOrder('003', 'Mesa 1', '10:30', 'preparando', [
        OrderItem(1, 'Huevos Revueltos'),
        OrderItem(1, 'Capuccino', note: 'Sin azúcar'),
        OrderItem(2, 'Pan de Dulce'),
      ], cajero: 'Cajero 2'),
      KitchenOrder('004', 'Mesa 5', '10:35', 'preparando', [
        OrderItem(3, 'Tarta de Queso'),
        OrderItem(1, 'Café Latte'),
      ], cajero: 'Cajero 1'),
      KitchenOrder('005', 'Mesa 7', '10:40', 'listo', [
        OrderItem(1, 'Ensalada César'),
        OrderItem(1, 'Agua Mineral'),
      ], cajero: 'Cajero 2'),
      KitchenOrder('006', 'Mesa 2', '10:45', 'pendiente', [
        OrderItem(2, 'Café Americano', note: 'Doble cargado'),
        OrderItem(1, 'Croissant'),
      ], cajero: 'Cajero 1'),
    ];
  }

  void _handleStatusChange(KitchenOrder order) {
    setState(() {
      if (order.status == 'entregado') {
        _activeOrders.removeWhere((o) => o.id == order.id);
        _completedOrders.insert(0, order);
      }
      // Si no es 'entregado', el estado ya se actualizó en el modelo
    });
    
    // Mostrar confirmación
    final statusLabels = {
      'preparando': 'en preparación',
      'listo': 'listo para servir',
      'entregado': 'entregado',
    };
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Orden #${order.id} (${order.mesa}) → ${statusLabels[order.status] ?? order.status}',
        ),
        backgroundColor: order.status == 'entregado'
            ? Colors.green
            : AppColors.primaryOrange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          CustomSidebar(
            roleName: "Cocina Panel",
            items: _cocinaItems,
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
            child: _buildMainContent(colorScheme, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ColorScheme colorScheme, bool isDark) {
    // Conteo rápido para el header
    final pendientes =
        _activeOrders.where((o) => o.status == 'pendiente').length;
    final preparando =
        _activeOrders.where((o) => o.status == 'preparando').length;
    final listos = _activeOrders.where((o) => o.status == 'listo').length;

    return Column(
      children: [
        // ── Top Bar ──
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: isDark ? Colors.white10 : Colors.black12,
              ),
            ),
          ),
          child: Row(
            children: [
              // Título de la sección
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTitleForIndex(selectedIndex),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (selectedIndex == 0)
                    Text(
                      "$pendientes pendientes · $preparando preparando · $listos listos",
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              // Avatar del usuario
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Cocina",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        "cocina@buzzcafe.com",
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withAlpha(153),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryOrange,
                    child: Icon(
                      Icons.restaurant,
                      color: isDark ? AppColors.textDark : Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Content ──
        Expanded(
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: _getContentForIndex(selectedIndex),
          ),
        ),
      ],
    );
  }

  String _getTitleForIndex(int index) {
    switch (index) {
      case 0:
        return "Órdenes Activas";
      case 1:
        return "Historial de Órdenes";
      default:
        return "";
    }
  }

  Widget _getContentForIndex(int index) {
    switch (index) {
      case 0:
        return CocinaOrdersView(
          orders: _activeOrders,
          onStatusChange: _handleStatusChange,
        );
      case 1:
        return CocinaHistoryView(completedOrders: _completedOrders);
      default:
        return const Center(child: Text("Selecciona una opción"));
    }
  }
}

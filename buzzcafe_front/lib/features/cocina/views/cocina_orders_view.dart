import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/kitchen_order.dart';

/// Vista principal de cocina: Tablero Kanban con columnas de estado.
/// Permite al personal de cocina ver todas las órdenes organizadas
/// por su estado actual y avanzarlas con un solo toque.
class CocinaOrdersView extends StatefulWidget {
  final List<KitchenOrder> orders;
  final ValueChanged<KitchenOrder> onStatusChange;

  const CocinaOrdersView({
    super.key,
    required this.orders,
    required this.onStatusChange,
  });

  @override
  State<CocinaOrdersView> createState() => _CocinaOrdersViewState();
}

class _CocinaOrdersViewState extends State<CocinaOrdersView> {
  String _filtroMesa = 'Todas';

  List<String> get _mesasDisponibles {
    final mesas = widget.orders.map((o) => o.mesa).toSet().toList();
    mesas.sort();
    return ['Todas', ...mesas];
  }

  List<KitchenOrder> _filteredByMesa(List<KitchenOrder> orders) {
    if (_filtroMesa == 'Todas') return orders;
    return orders.where((o) => o.mesa == _filtroMesa).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    // Separar órdenes por estado
    final pendientes = _filteredByMesa(
        widget.orders.where((o) => o.status == 'pendiente').toList());
    final preparando = _filteredByMesa(
        widget.orders.where((o) => o.status == 'preparando').toList());
    final listos = _filteredByMesa(
        widget.orders.where((o) => o.status == 'listo').toList());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Barra de filtros ──
        _buildFilterBar(isDark, colorScheme),
        // ── Columnas Kanban ──
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Si la pantalla es angosta, usar tabs
                if (constraints.maxWidth < 700) {
                  return _buildMobileLayout(
                      pendientes, preparando, listos, isDark, colorScheme);
                }
                // Desktop: 3 columnas
                return _buildDesktopLayout(
                    pendientes, preparando, listos, isDark, colorScheme);
              },
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Barra de filtros superior
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildFilterBar(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Icon(Icons.filter_list,
                color: colorScheme.onSurface.withAlpha(150), size: 20),
            const SizedBox(width: 10),
            Text("Mesa:",
                style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(180),
                    fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            ..._mesasDisponibles.map((mesa) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: ChoiceChip(
                    label: Text(mesa),
                    selected: _filtroMesa == mesa,
                    selectedColor: AppColors.primaryOrange,
                    labelStyle: TextStyle(
                      color: _filtroMesa == mesa
                          ? Colors.white
                          : colorScheme.onSurface,
                      fontSize: 13,
                    ),
                    onSelected: (selected) {
                      setState(() => _filtroMesa = mesa);
                    },
                  ),
                )),
            const SizedBox(width: 20),
            // Resumen rápido
            _buildCountBadge("Pendientes", _filteredByMesa(
                widget.orders.where((o) => o.status == 'pendiente').toList()).length,
                Colors.orange),
            const SizedBox(width: 8),
            _buildCountBadge("En Preparación", _filteredByMesa(
                widget.orders.where((o) => o.status == 'preparando').toList()).length,
                Colors.blue),
            const SizedBox(width: 8),
            _buildCountBadge("Listos", _filteredByMesa(
                widget.orders.where((o) => o.status == 'listo').toList()).length,
                Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildCountBadge(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text("$count",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: color, fontSize: 13)),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 11)),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Layout Desktop: 3 columnas Kanban
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildDesktopLayout(
      List<KitchenOrder> pendientes,
      List<KitchenOrder> preparando,
      List<KitchenOrder> listos,
      bool isDark,
      ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildKanbanColumn(
            title: "🔴 Pendientes",
            orders: pendientes,
            headerColor: Colors.orange,
            actionLabel: "Iniciar Preparación",
            actionColor: Colors.orange,
            nextStatus: 'preparando',
            isDark: isDark,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildKanbanColumn(
            title: "🟡 En Preparación",
            orders: preparando,
            headerColor: Colors.blue,
            actionLabel: "Marcar como Listo",
            actionColor: Colors.blue,
            nextStatus: 'listo',
            isDark: isDark,
            colorScheme: colorScheme,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildKanbanColumn(
            title: "🟢 Listos para Servir",
            orders: listos,
            headerColor: Colors.green,
            actionLabel: "Entregar",
            actionColor: Colors.green,
            nextStatus: 'entregado',
            isDark: isDark,
            colorScheme: colorScheme,
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Layout Móvil: Tabs
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildMobileLayout(
      List<KitchenOrder> pendientes,
      List<KitchenOrder> preparando,
      List<KitchenOrder> listos,
      bool isDark,
      ColorScheme colorScheme) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.primaryOrange,
            unselectedLabelColor: colorScheme.onSurface.withAlpha(150),
            indicatorColor: AppColors.primaryOrange,
            tabs: [
              Tab(text: "Pendientes (${pendientes.length})"),
              Tab(text: "Preparando (${preparando.length})"),
              Tab(text: "Listos (${listos.length})"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildOrderList(pendientes, "Iniciar Preparación",
                    Colors.orange, 'preparando', isDark, colorScheme),
                _buildOrderList(preparando, "Marcar como Listo", Colors.blue,
                    'listo', isDark, colorScheme),
                _buildOrderList(listos, "Entregar", Colors.green, 'entregado',
                    isDark, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(
      List<KitchenOrder> orders,
      String actionLabel,
      Color actionColor,
      String nextStatus,
      bool isDark,
      ColorScheme colorScheme) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline,
                size: 48, color: colorScheme.onSurface.withAlpha(80)),
            const SizedBox(height: 10),
            Text("Sin órdenes aquí",
                style: TextStyle(color: colorScheme.onSurface.withAlpha(120))),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildOrderCard(
              orders[index], actionLabel, actionColor, nextStatus, isDark, colorScheme),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Columna Kanban completa
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildKanbanColumn({
    required String title,
    required List<KitchenOrder> orders,
    required Color headerColor,
    required String actionLabel,
    required Color actionColor,
    required String nextStatus,
    required bool isDark,
    required ColorScheme colorScheme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surface.withAlpha(120)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header de columna
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: headerColor.withAlpha(isDark ? 50 : 30),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: headerColor.withAlpha(60)),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? headerColor.withAlpha(220) : headerColor.withAlpha(200),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: headerColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "${orders.length}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: headerColor,
                        fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          // Lista de tarjetas
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 40,
                              color: colorScheme.onSurface.withAlpha(60)),
                          const SizedBox(height: 8),
                          Text(
                            "Sin órdenes",
                            style: TextStyle(
                              color: colorScheme.onSurface.withAlpha(100),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildOrderCard(orders[index], actionLabel,
                            actionColor, nextStatus, isDark, colorScheme),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  Tarjeta individual de orden
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildOrderCard(
    KitchenOrder order,
    String actionLabel,
    Color actionColor,
    String nextStatus,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.black.withAlpha(15),
        ),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header: Mesa + Hora ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.primaryBrown.withAlpha(80)
                  : AppColors.primaryBrown,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(Icons.table_restaurant,
                    color: Colors.white.withAlpha(200), size: 18),
                const SizedBox(width: 8),
                Text(
                  order.mesa,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(40),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.access_time,
                          size: 13, color: Colors.white.withAlpha(200)),
                      const SizedBox(width: 4),
                      Text(
                        order.time,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withAlpha(220),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Items de la orden ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryOrange.withAlpha(30),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'x${item.qty}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (item.note != null)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 38, top: 2),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 12, color: Colors.red.shade400),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      item.note!,
                                      style: TextStyle(
                                        color: Colors.red.shade400,
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    )),
                // Info del cajero
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Registrado por: ${order.cajero}",
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurface.withAlpha(100),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Botón de acción ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: SizedBox(
              height: 42,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  order.status = nextStatus;
                  widget.onStatusChange(order);
                },
                icon: Icon(
                  nextStatus == 'preparando'
                      ? Icons.restaurant
                      : nextStatus == 'listo'
                          ? Icons.check_circle
                          : Icons.delivery_dining,
                  size: 18,
                ),
                label: Text(
                  actionLabel,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

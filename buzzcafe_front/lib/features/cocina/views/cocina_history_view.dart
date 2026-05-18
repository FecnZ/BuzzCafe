import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../models/kitchen_order.dart';

/// Vista de historial de órdenes completadas.
/// Muestra una tabla con todas las órdenes que ya fueron entregadas,
/// permitiendo al personal de cocina revisar el registro del día.
class CocinaHistoryView extends StatefulWidget {
  final List<KitchenOrder> completedOrders;

  const CocinaHistoryView({super.key, required this.completedOrders});

  @override
  State<CocinaHistoryView> createState() => _CocinaHistoryViewState();
}

class _CocinaHistoryViewState extends State<CocinaHistoryView> {
  String _searchQuery = '';

  List<KitchenOrder> get _filteredOrders {
    if (_searchQuery.isEmpty) return widget.completedOrders;
    final q = _searchQuery.toLowerCase();
    return widget.completedOrders.where((o) {
      return o.mesa.toLowerCase().contains(q) ||
          o.id.toLowerCase().contains(q) ||
          o.items.any((i) => i.name.toLowerCase().contains(q));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final cardColor = isDark ? colorScheme.surface : Colors.white;

    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth =
            constraints.maxWidth > 900 ? 860.0 : constraints.maxWidth - 30;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──
                  Text(
                    "Órdenes Completadas Hoy",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${widget.completedOrders.length} órdenes entregadas",
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onSurface.withAlpha(120),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Búsqueda ──
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: isDark ? Colors.white10 : Colors.black12),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Buscar por mesa, ID o producto...",
                        prefixIcon: const Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      onChanged: (v) => setState(() => _searchQuery = v),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Lista de órdenes ──
                  if (_filteredOrders.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history,
                                size: 48,
                                color: colorScheme.onSurface.withAlpha(60)),
                            const SizedBox(height: 10),
                            Text(
                              "No hay órdenes completadas aún",
                              style: TextStyle(
                                color: colorScheme.onSurface.withAlpha(100),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._filteredOrders.map(
                        (order) => _buildHistoryCard(order, isDark, cardColor, colorScheme)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(KitchenOrder order, bool isDark, Color cardColor,
      ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10)),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(8),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header Premium ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(isDark ? 30 : 15),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(
                bottom: BorderSide(color: Colors.green.withAlpha(isDark ? 50 : 30)),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(isDark ? 60 : 40),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.green, size: 16),
                ),
                const SizedBox(width: 10),
                Text(
                  "Orden #${order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withAlpha(40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Entregado",
                    style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                  ),
                ),
                const Spacer(),
                Icon(Icons.table_restaurant_outlined, size: 16, color: AppColors.primaryOrange.withAlpha(200)),
                const SizedBox(width: 4),
                Text(
                  order.mesa,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOrange,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time_rounded, size: 14, color: colorScheme.onSurface.withAlpha(100)),
                const SizedBox(width: 4),
                Text(
                  order.time,
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(150),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // ── Items listados de manera compacta y estética ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 10,
              runSpacing: 8,
              children: order.items
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withAlpha(8) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDark ? Colors.white.withAlpha(10) : Colors.black.withAlpha(5)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${item.qty}x",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface.withAlpha(180),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

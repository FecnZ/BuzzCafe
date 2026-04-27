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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.green.withAlpha(isDark ? 40 : 25),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Orden #${order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                Text(
                  order.mesa,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryOrange,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  order.time,
                  style: TextStyle(
                    color: colorScheme.onSurface.withAlpha(120),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // ── Items listados de manera compacta ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              children: order.items
                  .map((item) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withAlpha(10)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "x${item.qty} ${item.name}",
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.onSurface,
                          ),
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

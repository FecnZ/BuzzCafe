import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

// Modelo de datos simulado para el historial de ventas
class _HistoricalTicket {
  final String id;
  final String date;
  final String time;
  final double total;
  final String paymentMethod;
  final String status; // 'Completado' o 'Cancelado'
  final List<Map<String, dynamic>> items;

  _HistoricalTicket({
    required this.id,
    required this.date,
    required this.time,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.items,
  });
}

class CajeroHistoryView extends StatefulWidget {
  const CajeroHistoryView({super.key});

  @override
  State<CajeroHistoryView> createState() => _CajeroHistoryViewState();
}

class _CajeroHistoryViewState extends State<CajeroHistoryView> {
  // Lista de ventas pasadas (Mock)
  final List<_HistoricalTicket> _tickets = [
    _HistoricalTicket(
      id: "TKT-0899",
      date: "Hoy",
      time: "14:20",
      total: 185.00,
      paymentMethod: "Tarjeta de Crédito",
      status: "Completado",
      items: [
        {"nombre": "Ensalada César", "qty": 1, "precio": 85.00, "nota": ""},
        {"nombre": "Frappé Moka", "qty": 1, "precio": 65.00, "nota": "Deslactosada"},
        {"nombre": "Café Americano", "qty": 1, "precio": 35.00, "nota": ""},
      ],
    ),
    _HistoricalTicket(
      id: "TKT-0898",
      date: "Hoy",
      time: "13:45",
      total: 110.00,
      paymentMethod: "Efectivo",
      status: "Completado",
      items: [
        {"nombre": "Hot Cakes Extras", "qty": 2, "precio": 55.00, "nota": "Sin miel"},
      ],
    ),
    _HistoricalTicket(
      id: "TKT-0897",
      date: "Hoy",
      time: "13:10",
      total: 50.00,
      paymentMethod: "Tarjeta de Débito",
      status: "Cancelado",
      items: [
        {"nombre": "Tarta de Queso", "qty": 1, "precio": 50.00, "nota": ""},
      ],
    ),
    _HistoricalTicket(
      id: "TKT-0896",
      date: "Ayer",
      time: "18:30",
      total: 240.00,
      paymentMethod: "Tarjeta de Crédito",
      status: "Completado",
      items: [
        {"nombre": "Huevos Revueltos", "qty": 2, "precio": 60.00, "nota": ""},
        {"nombre": "Huevos Revueltos", "qty": 1, "precio": 60.00, "nota": "Sin cebolla"},
        {"nombre": "Café Americano", "qty": 1, "precio": 60.00, "nota": ""},
      ],
    ),
  ];

  _HistoricalTicket? _selectedTicket;

  @override
  void initState() {
    super.initState();
    if (_tickets.isNotEmpty) {
      _selectedTicket = _tickets.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Row(
      children: [
        // ── LADO IZQUIERDO: Lista de Historial ──
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Transacciones Recientes",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = _tickets[index];
                    final isSelected = _selectedTicket?.id == ticket.id;
                    final isCancelled = ticket.status == "Cancelado";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedTicket = ticket;
                          });
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? Colors.white.withAlpha(20) : AppColors.primaryOrange.withAlpha(15))
                                : (isDark ? colorScheme.surfaceContainerHigh : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryOrange
                                  : (isDark ? Colors.white.withAlpha(15) : Colors.black.withAlpha(10)),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        ticket.id,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isCancelled ? colorScheme.onSurface.withAlpha(100) : colorScheme.onSurface,
                                          decoration: isCancelled ? TextDecoration.lineThrough : null,
                                        ),
                                      ),
                                      if (isCancelled)
                                        Container(
                                          margin: const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.red.withAlpha(30),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text("Cancelado", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold)),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${ticket.date} • ${ticket.time}",
                                    style: TextStyle(color: colorScheme.onSurface.withAlpha(150), fontSize: 13),
                                  ),
                                ],
                              ),
                              Text(
                                "\$${ticket.total.toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isCancelled ? colorScheme.onSurface.withAlpha(100) : AppColors.primaryOrange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        if (!isDark) Container(width: 1, color: Colors.black.withAlpha(10), margin: const EdgeInsets.symmetric(horizontal: 10)),

        // ── LADO DERECHO: Detalle del Ticket ──
        Expanded(
          flex: 6,
          child: _selectedTicket == null
              ? Center(child: Text("Selecciona un ticket para ver el detalle", style: TextStyle(color: colorScheme.onSurface.withAlpha(150))))
              : _buildTicketDetail(_selectedTicket!, colorScheme, isDark),
        ),
      ],
    );
  }

  Widget _buildTicketDetail(_HistoricalTicket ticket, ColorScheme colorScheme, bool isDark) {
    final isCancelled = ticket.status == "Cancelado";

    return Container(
      margin: EdgeInsets.only(left: isDark ? 16 : 0, right: 16, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black.withAlpha(15)),
        boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 20)],
      ),
      child: Column(
        children: [
          // Cabecera del Recibo
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: isDark ? Colors.white10 : Colors.black.withAlpha(10), style: BorderStyle.solid)),
            ),
            child: Column(
              children: [
                Icon(Icons.receipt_long, size: 40, color: colorScheme.onSurface.withAlpha(150)),
                const SizedBox(height: 10),
                Text("Recibo de Venta", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                const SizedBox(height: 5),
                Text(ticket.id, style: TextStyle(fontSize: 16, color: colorScheme.onSurface.withAlpha(150))),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: colorScheme.onSurface.withAlpha(120)),
                    const SizedBox(width: 4),
                    Text(ticket.date, style: TextStyle(color: colorScheme.onSurface.withAlpha(150))),
                    const SizedBox(width: 15),
                    Icon(Icons.access_time, size: 14, color: colorScheme.onSurface.withAlpha(120)),
                    const SizedBox(width: 4),
                    Text(ticket.time, style: TextStyle(color: colorScheme.onSurface.withAlpha(150))),
                  ],
                ),
                if (isCancelled)
                   Container(
                     margin: const EdgeInsets.only(top: 15),
                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     decoration: BoxDecoration(color: Colors.red.withAlpha(30), borderRadius: BorderRadius.circular(20)),
                     child: const Text("VENTA CANCELADA", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                   )
              ],
            ),
          ),
          
          // Desglose de Productos
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: ticket.items.length,
              itemBuilder: (context, index) {
                final item = ticket.items[index];
                final itemTotal = (item["qty"] as int) * (item["precio"] as double);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${item["qty"]}x", style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface.withAlpha(200))),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["nombre"], style: TextStyle(fontSize: 16, color: colorScheme.onSurface, fontWeight: FontWeight.w500)),
                            if ((item["nota"] as String).isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(item["nota"], style: TextStyle(fontSize: 13, color: AppColors.primaryOrange, fontStyle: FontStyle.italic)),
                              )
                          ],
                        ),
                      ),
                      Text("\$${itemTotal.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // Totales y Métodos de Pago
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black.withAlpha(10), style: BorderStyle.solid)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Método de Pago", style: TextStyle(color: colorScheme.onSurface.withAlpha(150))),
                    Text(ticket.paymentMethod, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Final", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    Text("\$${ticket.total.toStringAsFixed(2)}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryOrange)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text("Imprimir"),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Simulando impresión...")));
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.cancel),
                        label: const Text("Reembolsar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: isCancelled ? null : () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reembolso en desarrollo...")));
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

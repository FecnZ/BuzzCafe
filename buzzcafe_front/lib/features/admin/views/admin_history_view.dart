import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AdminHistoryView extends StatefulWidget {
  const AdminHistoryView({super.key});

  @override
  State<AdminHistoryView> createState() => _AdminHistoryViewState();
}

class _AdminHistoryViewState extends State<AdminHistoryView> {
  // Filtros seleccionados
  String _filtroEstado = "Todos";
  String _filtroVendedor = "Todos";

  // Datos simulados (Mock) para diseñar la interfaz
  final List<Map<String, dynamic>> _ordenesMock = [
    {
      "id": 105,
      "fecha": "17/05/2026 14:30",
      "vendedor": "Sam Cajero",
      "total": 150.0,
      "estado": "Completada",
      "productos": [
        {"nombre": "Espresso", "cantidad": 2, "precio": 35.0, "subtotal": 70.0},
        {
          "nombre": "Tarta de Queso",
          "cantidad": 1,
          "precio": 80.0,
          "subtotal": 80.0,
        },
      ],
    },
    {
      "id": 104,
      "fecha": "17/05/2026 12:15",
      "vendedor": "Fernando Admin",
      "total": 45.0,
      "estado": "Cancelada",
      "productos": [
        {
          "nombre": "Capuccino",
          "cantidad": 1,
          "precio": 45.0,
          "subtotal": 45.0,
        },
      ],
    },
    {
      "id": 103,
      "fecha": "16/05/2026 18:45",
      "vendedor": "Sam Cajero",
      "total": 350.0,
      "estado": "Completada",
      "productos": [
        {
          "nombre": "Frappé Moka",
          "cantidad": 2,
          "precio": 105.0,
          "subtotal": 210.0,
        },
        {
          "nombre": "Ensalada César",
          "cantidad": 1,
          "precio": 140.0,
          "subtotal": 140.0,
        },
      ],
    },
    {
      "id": 102,
      "fecha": "16/05/2026 09:10",
      "vendedor": "Sam Cajero",
      "total": 70.0,
      "estado": "Completada",
      "productos": [
        {"nombre": "Espresso", "cantidad": 2, "precio": 35.0, "subtotal": 70.0},
      ],
    },
  ];

  List<Map<String, dynamic>> get ordenesFiltradas {
    return _ordenesMock.where((orden) {
      final pasaEstado =
          _filtroEstado == "Todos" || orden["estado"] == _filtroEstado;
      final pasaVendedor =
          _filtroVendedor == "Todos" || orden["vendedor"] == _filtroVendedor;
      return pasaEstado && pasaVendedor;
    }).toList();
  }

  void _verDetalleTicket(BuildContext context, Map<String, dynamic> orden) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono
                Icon(
                  Icons.receipt_long,
                  size: 40,
                  color: AppColors.primaryOrange,
                ),
                const SizedBox(height: 12),

                // Titulo
                Text(
                  "Detalle de Orden #${orden['id']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  orden['fecha'],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(thickness: 1), // Usar linea punteada idealmente
                const SizedBox(height: 10),

                // Productos
                ...List.generate(orden['productos'].length, (index) {
                  final p = orden['productos'][index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${p['cantidad']}x ${p['nombre']}"),
                        Text("\$${p['subtotal'].toStringAsFixed(2)}"),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),
                const Divider(thickness: 1),
                const SizedBox(height: 10),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "\$${orden['total'].toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Atendido por:", style: TextStyle(fontSize: 12)),
                    Text(
                      orden['vendedor'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          theme.colorScheme.secondaryContainer,
                      foregroundColor: theme.colorScheme.onSecondaryContainer,
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cerrar Ticket"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF242424) : Colors.white;
    final onSurface = theme.colorScheme.onSurface;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titulo de la página
          Text(
            "Historial de Órdenes",
            style: TextStyle(
              color: onSurface.withAlpha(200),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Barra de Filtros (Mejorada visualmente)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(12),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Wrap(
              spacing: 30,
              runSpacing: 15,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.filter_alt_outlined, color: AppColors.primaryOrange),
                    const SizedBox(width: 8),
                    Text("Filtros:", style: TextStyle(fontWeight: FontWeight.bold, color: onSurface.withAlpha(150))),
                  ],
                ),

                // Filtro Fecha
                _FiltroDropdown(
                  label: "Fecha",
                  value: "Todos",
                  items: const ["Todos", "Hoy", "Esta Semana", "Este Mes"],
                  onChanged: (val) {}, // Simulado
                ),

                // Filtro Estado
                _FiltroDropdown(
                  label: "Estado",
                  value: _filtroEstado,
                  items: const ["Todos", "Completada", "Cancelada"],
                  onChanged: (val) {
                    setState(() => _filtroEstado = val!);
                  },
                ),

                // Filtro Cajero
                _FiltroDropdown(
                  label: "Cajero",
                  value: _filtroVendedor,
                  items: const ["Todos", "Sam Cajero", "Fernando Admin"],
                  onChanged: (val) {
                    setState(() => _filtroVendedor = val!);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tabla Principal (Ahora es PaginatedDataTable)
          Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(12),
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 16,
                      ),
                    ],
            ),
            child: Theme(
              data: theme.copyWith(
                cardColor: bg,
                dividerColor: isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
              ),
              child: PaginatedDataTable(
                header: Text(
                  "Registros de Ventas",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: onSurface.withAlpha(200),
                  ),
                ),
                columnSpacing: 20,
                horizontalMargin: 24,
                rowsPerPage: ordenesFiltradas.length > 5 ? 5 : (ordenesFiltradas.isEmpty ? 1 : ordenesFiltradas.length),
                columns: const [
                  DataColumn(label: Text("ID Orden", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Fecha", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Vendedor", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Estado", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text("Ticket", style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                source: _OrdenDataSource(
                  ordenes: ordenesFiltradas,
                  context: context,
                  isDark: isDark,
                  onVerTicket: (orden) => _verDetalleTicket(context, orden),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdenDataSource extends DataTableSource {
  final List<Map<String, dynamic>> ordenes;
  final BuildContext context;
  final bool isDark;
  final Function(Map<String, dynamic>) onVerTicket;

  _OrdenDataSource({
    required this.ordenes,
    required this.context,
    required this.isDark,
    required this.onVerTicket,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= ordenes.length) return null;
    final orden = ordenes[index];
    final bool esCompletada = orden["estado"] == "Completada";

    return DataRow(
      cells: [
        DataCell(Text("#${orden['id']}", style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(orden['fecha'])),
        DataCell(Text(orden['vendedor'])),
        DataCell(Text("\$${orden['total'].toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: esCompletada ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: esCompletada ? Colors.green.withAlpha(100) : Colors.red.withAlpha(100),
              ),
            ),
            child: Text(
              orden["estado"],
              style: TextStyle(
                color: esCompletada ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(
              Icons.receipt_long,
              size: 20,
              color: isDark ? Colors.lightBlueAccent : Colors.blue,
            ),
            tooltip: "Ver Detalle",
            onPressed: () => onVerTicket(orden),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => ordenes.length;
  @override
  int get selectedRowCount => 0;
}

class _FiltroDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FiltroDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, size: 16),
          underline: const SizedBox(),
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String val) {
            return DropdownMenuItem<String>(value: val, child: Text(val));
          }).toList(),
        ),
      ],
    );
  }
}

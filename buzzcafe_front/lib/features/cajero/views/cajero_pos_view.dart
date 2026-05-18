import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class _CartItem {
  final Map<String, dynamic> producto;
  int cantidad = 1;
  String notas = "";

  _CartItem({required this.producto});

  double get total => (producto["precio"] as double) * cantidad;
}

class CajeroPOSView extends StatefulWidget {
  const CajeroPOSView({super.key});

  @override
  State<CajeroPOSView> createState() => _CajeroPOSViewState();
}

class _CajeroPOSViewState extends State<CajeroPOSView> {
  // Datos Falsos Temporales
  final List<String> _categorias = [
    "Todos",
    "Desayunos",
    "Comida",
    "Bebidas",
    "Postres",
  ];
  String _categoriaSeleccionada = "Todos";

  final List<Map<String, dynamic>> _productosMock = [
    {
      "id": 1,
      "nombre": "Hot Cakes Extras",
      "precio": 55.0,
      "categoria": "Desayunos",
      "color": Colors.orange,
    },
    {
      "id": 2,
      "nombre": "Café Americano",
      "precio": 35.0,
      "categoria": "Bebidas",
      "color": Colors.brown,
    },
    {
      "id": 3,
      "nombre": "Huevos Revueltos",
      "precio": 60.0,
      "categoria": "Desayunos",
      "color": Colors.yellow,
    },
    {
      "id": 4,
      "nombre": "Ensalada César",
      "precio": 85.0,
      "categoria": "Comida",
      "color": Colors.green,
    },
    {
      "id": 5,
      "nombre": "Frappé Moka",
      "precio": 65.0,
      "categoria": "Bebidas",
      "color": Colors.brown,
    },
    {
      "id": 6,
      "nombre": "Tarta de Queso",
      "precio": 50.0,
      "categoria": "Postres",
      "color": Colors.red,
    },
  ];

  final List<_CartItem> _carrito = [];

  List<Map<String, dynamic>> get productosFiltrados {
    if (_categoriaSeleccionada == "Todos") return _productosMock;
    return _productosMock
        .where((p) => p["categoria"] == _categoriaSeleccionada)
        .toList();
  }

  double get totalCarrito =>
      _carrito.fold(0.0, (sum, item) => sum + item.total);

  void agregarProductoBase(Map<String, dynamic> prod) {
    setState(() {
      final index = _carrito.indexWhere(
        (item) => item.producto["id"] == prod["id"] && item.notas.isEmpty,
      );
      if (index >= 0) {
        _carrito[index].cantidad++;
      } else {
        _carrito.add(_CartItem(producto: prod));
      }
    });
  }

  void reducirCantidad(int index) {
    setState(() {
      if (_carrito[index].cantidad > 1) {
        _carrito[index].cantidad--;
      } else {
        _carrito.removeAt(index);
      }
    });
  }

  void aumentarCantidad(int index) {
    setState(() => _carrito[index].cantidad++);
  }

  void borrarCarrito() => setState(() => _carrito.clear());

  void _mostrarDialogoNotas(int index) {
    final item = _carrito[index];
    final ctrl = TextEditingController(text: item.notas);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF242424) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Notas: ${item.producto["nombre"]}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: "Ej. Sin cebolla, extra queso...",
            filled: true,
            fillColor: isDark
                ? Colors.white.withAlpha(12)
                : Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "Cancelar",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              foregroundColor: Colors.white,
              minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              setState(() => item.notas = ctrl.text.trim());
              Navigator.pop(ctx);
            },
            child: const Text("Guardar Nota"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Row(
      children: [
        // ── Lado Izquierdo: Catálogo Minimalista ──
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorias(),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: productosFiltrados.length,
                  itemBuilder: (context, index) {
                    final prod = productosFiltrados[index];
                    return _ProductCard(
                      producto: prod,
                      isDark: isDark,
                      onTap: () => agregarProductoBase(prod),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        if (!isDark)
          Container(
            width: 1,
            color: Colors.black.withAlpha(10),
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),

        // ── Lado Derecho: Ticket Minimalista ──
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(left: isDark ? 16.0 : 0.0),
            decoration: BoxDecoration(
              color: isDark
                  ? colorScheme.surfaceContainerHighest
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white10 : Colors.black.withAlpha(15),
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha(5),
                        blurRadius: 20,
                      ),
                    ],
            ),
            child: Column(
              children: [
                _buildCartHeader(colorScheme, isDark),
                Expanded(
                  child: _carrito.isEmpty
                      ? Center(
                          child: Text(
                            "Ticket vacío",
                            style: TextStyle(
                              color: colorScheme.onSurface.withAlpha(100),
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: _carrito.length,
                          itemBuilder: (context, index) => _CartItemRow(
                            item: _carrito[index],
                            colorScheme: colorScheme,
                            isDark: isDark,
                            onAdd: () => aumentarCantidad(index),
                            onRemove: () => reducirCantidad(index),
                            onEditNote: () => _mostrarDialogoNotas(index),
                          ),
                        ),
                ),
                _CartFooter(
                  total: totalCarrito,
                  colorScheme: colorScheme,
                  isDark: isDark,
                  onPay: _carrito.isEmpty
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Módulo de pago en desarrollo..."),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorias() {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categorias.length,
        itemBuilder: (context, index) {
          final cat = _categorias[index];
          final isSelected = cat == _categoriaSeleccionada;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                cat,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              selected: isSelected,
              selectedColor: AppColors.primaryOrange,
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withAlpha(10)
                  : Colors.grey.shade100,
              side: BorderSide.none,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : colorScheme.onSurface.withAlpha(180),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              onSelected: (selected) =>
                  setState(() => _categoriaSeleccionada = cat),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartHeader(ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Orden Actual",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 22,
            ),
            onPressed: _carrito.isEmpty ? null : borrarCarrito,
            tooltip: "Borrar todo",
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
//  COMPONENTES EXTRAÍDOS PARA REDUCIR CÓDIGO
// ══════════════════════════════════════════════════════════════════════════════

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> producto;
  final bool isDark;
  final VoidCallback onTap;

  const _ProductCard({
    required this.producto,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = producto["color"] as Color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark
                ? Colors.white.withAlpha(15)
                : Colors.black.withAlpha(10),
          ),
          boxShadow: isDark
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withAlpha(4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indicador de color sutil superior
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: categoryColor.withAlpha(200),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      producto["nombre"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "\$${producto["precio"].toStringAsFixed(2)}",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange.withAlpha(20),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 18,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  final _CartItem item;
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback onEditNote;

  const _CartItemRow({
    required this.item,
    required this.colorScheme,
    required this.isDark,
    required this.onAdd,
    required this.onRemove,
    required this.onEditNote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withAlpha(10) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(10)
              : Colors.black.withAlpha(5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.producto["nombre"],
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "\$${item.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          if (item.notas.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Text(
                "Nota: ${item.notas}",
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.primaryOrange,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onEditNote,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_note_rounded,
                        size: 18,
                        color: colorScheme.onSurface.withAlpha(150),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.notas.isEmpty ? "Añadir nota" : "Editar nota",
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurface.withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withAlpha(15) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.transparent
                        : Colors.black.withAlpha(10),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 16),
                      onPressed: onRemove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Text(
                      "${item.cantidad}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 16),
                      onPressed: onAdd,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CartFooter extends StatelessWidget {
  final double total;
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback? onPay;

  const _CartFooter({
    required this.total,
    required this.colorScheme,
    required this.isDark,
    required this.onPay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade50,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : Colors.black.withAlpha(10),
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total a cobrar:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                "\$${total.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                minimumSize: Size.zero,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: onPay,
              child: const Text(
                "Ir a Pagar",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

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
    "Postres"
  ];
  String _categoriaSeleccionada = "Todos";

  final List<Map<String, dynamic>> _productosMock = [
    {
      "id": 1,
      "nombre": "Hot Cakes Extras",
      "precio": 55.0,
      "categoria": "Desayunos",
      "color": Colors.orange.shade300
    },
    {
      "id": 2,
      "nombre": "Café Americano",
      "precio": 35.0,
      "categoria": "Bebidas",
      "color": Colors.brown.shade400
    },
    {
      "id": 3,
      "nombre": "Huevos Revueltos",
      "precio": 60.0,
      "categoria": "Desayunos",
      "color": Colors.yellow.shade400
    },
    {
      "id": 4,
      "nombre": "Ensalada César",
      "precio": 85.0,
      "categoria": "Comida",
      "color": Colors.green.shade400
    },
    {
      "id": 5,
      "nombre": "Frappé Moka",
      "precio": 65.0,
      "categoria": "Bebidas",
      "color": Colors.brown.shade300
    },
    {
      "id": 6,
      "nombre": "Tarta de Queso",
      "precio": 50.0,
      "categoria": "Postres",
      "color": Colors.red.shade200
    },
  ];

  // Carrito de compras: {producto_id: cantidad}
  final Map<int, int> _carrito = {};

  List<Map<String, dynamic>> get productosFiltrados {
    if (_categoriaSeleccionada == "Todos") {
      return _productosMock;
    }
    return _productosMock
        .where((p) => p["categoria"] == _categoriaSeleccionada)
        .toList();
  }

  double get totalCarrito {
    double total = 0.0;
    _carrito.forEach((id, cantidad) {
      final prod = _productosMock.firstWhere((p) => p["id"] == id);
      total += (prod["precio"] as double) * cantidad;
    });
    return total;
  }

  void agrergarProducto(int id) {
    setState(() {
      if (_carrito.containsKey(id)) {
        _carrito[id] = _carrito[id]! + 1;
      } else {
        _carrito[id] = 1;
      }
    });
  }

  void reducirProducto(int id) {
    setState(() {
      if (_carrito.containsKey(id)) {
        if (_carrito[id]! > 1) {
          _carrito[id] = _carrito[id]! - 1;
        } else {
          _carrito.remove(id);
        }
      }
    });
  }

  void borrarCarrito() {
    setState(() {
      _carrito.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;

    return Row(
      children: [
        // Lado Izquierdo: Catálogo de Productos
        Expanded(
          flex: 7, // 70% de la pantalla aprox
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de Categorías
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categorias.length,
                  itemBuilder: (context, index) {
                    final cat = _categorias[index];
                    final isSelected = cat == _categoriaSeleccionada;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.primaryOrange,
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : colorScheme.onSurface),
                        onSelected: (selected) {
                          setState(() {
                            _categoriaSeleccionada = cat;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Grid de Productos
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                  ),
                  itemCount: productosFiltrados.length,
                  itemBuilder: (context, index) {
                    final prod = productosFiltrados[index];
                    return InkWell(
                      onTap: () => agrergarProducto(prod["id"]),
                      borderRadius:  BorderRadius.circular(12),
                      child: Card(
                        elevation: isDark ? 2 : 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: isDark ? colorScheme.surfaceContainerHigh : prod["color"],
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prod["nombre"],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isDark ? colorScheme.onSurface : Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${prod["precio"].toStringAsFixed(2)}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 18,
                                      color: isDark ? colorScheme.onSurface : Colors.black,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withAlpha(200),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add,
                                        size: 20, color: Colors.black87),
                                  )
                                ],
                              )
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
        
        // Divisor
        if (!isDark)
           Container(width: 1, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 10)),

        // Lado Derecho: Carrito (Ticket)
        Expanded(
          flex: 3, // 30% de la pantalla
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
            ),
            child: Column(
              children: [
                // Header Ticket
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade100,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: _carrito.isEmpty ? null : borrarCarrito,
                        tooltip: "Borrar todo",
                      )
                    ],
                  ),
                ),
                // Items Carrito
                Expanded(
                  child: _carrito.isEmpty
                      ? Center(
                          child: Text(
                            "Sin productos",
                            style: TextStyle(color: colorScheme.onSurface.withAlpha(100)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(10),
                          itemCount: _carrito.length,
                          itemBuilder: (context, index) {
                            final id = _carrito.keys.elementAt(index);
                            final cantidad = _carrito[id]!;
                            final prod = _productosMock.firstWhere((p) => p["id"] == id);
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  // Controles cantidad
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, size: 20),
                                        onPressed: () => reducirProducto(id),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                      const SizedBox(width: 8),
                                      Text("$cantidad", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 8),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, size: 20),
                                        onPressed: () => agrergarProducto(id),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 10),
                                  // Nombre
                                  Expanded(
                                    child: Text(
                                      prod["nombre"],
                                      style: TextStyle(color: colorScheme.onSurface),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Total item
                                  Text(
                                    "\$${(prod["precio"] * cantidad).toStringAsFixed(2)}",
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Footer Ticket (Total y Pagar)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? colorScheme.surfaceContainerHigh : Colors.grey.shade50,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                    border: Border(top: BorderSide(color: isDark ? Colors.white10 : Colors.black12)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                          ),
                          Text(
                            "\$${totalCarrito.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _carrito.isEmpty
                              ? null
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Opciones de pago en desarrollo..."))
                                  );
                                },
                          child: const Text("Ir a Pagar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

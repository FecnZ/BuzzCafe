import 'package:flutter/material.dart';

// Modelo de datos de prueba para pintar la interfaz
class OrderItem {
  final int qty;
  final String name;
  final String? note;

  OrderItem(this.qty, this.name, {this.note});
}

class Order {
  final String id;
  final String mesa;
  final String time;
  final String status; // 'preparar' o 'finalizar'
  final List<OrderItem> items;

  Order(this.id, this.mesa, this.time, this.status, this.items);
}

class CocinaScreen extends StatefulWidget {
  const CocinaScreen({super.key});

  @override
  State<CocinaScreen> createState() => _CocinaScreenState();
}

class _CocinaScreenState extends State<CocinaScreen> {
  // Datos MOCK idénticos a la imagen
  final List<Order> pendingOrders = [
    Order('1', 'Mesa 7', '5:33', 'preparar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
    Order('2', 'Mesa 7', '5:33', 'finalizar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
    Order('3', 'Mesa 7', '5:33', 'finalizar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
    Order('4', 'Mesa 8', '5:40', 'preparar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
    Order('5', 'Mesa 8', '5:40', 'finalizar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
    Order('6', 'Mesa 8', '5:40', 'finalizar', [
      OrderItem(1, 'caffe', note: 'sin azucar'),
      OrderItem(2, 'pan de dulce'),
      OrderItem(1, 'capuccino'),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    // Detectamos si está en modo oscuro para ajustar el fondo principal y las tarjetas
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF1B1B1B) : const Color(0xFFFFF9F0); // Color cremita de fondo

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Pedidos Pendientes'),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D3915), // Café oscuro de la cabecera
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 28),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // Flecha Izquierda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, size: 40),
              color: isDark ? Colors.white54 : Colors.black87,
              onPressed: () {}, // Acción de paginación
            ),
          ),
          
          // Grid Central de Pedidos
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: GridView.builder(
                itemCount: pendingOrders.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 350,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 0.85, // Relación ancho/alto de las tarjetas
                ),
                itemBuilder: (context, index) {
                  return _buildOrderCard(pendingOrders[index], isDark);
                },
              ),
            ),
          ),

          // Flecha Derecha
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios, size: 40),
              color: isDark ? Colors.white54 : Colors.black87,
              onPressed: () {}, // Acción de paginación
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order, bool isDark) {
    // Lógica de colores según el estado
    final isPreparar = order.status == 'preparar';
    
    final headerColor = isPreparar 
        ? const Color(0xFF4E2A04) // Café muy oscuro
        : const Color(0xFFC7A84E); // Dorado/Amarillo mostaza
        
    final headerTextColor = isPreparar ? Colors.white : Colors.black87;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // CABECERA (Mesa y Hora)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: headerColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.mesa,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: headerTextColor,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    order.time,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // LISTA DE PRODUCTOS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: order.items.length,
              itemBuilder: (context, i) {
                final item = order.items[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'x${item.qty} ',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      if (item.note != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 4.0),
                          child: Text(
                            'Nota: ${item.note}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          // BOTÓN DE ACCIÓN
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C2C), // Gris muy oscuro / casi negro
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                // Aquí iría la lógica para cambiar el estado de la orden
              },
              child: Text(
                isPreparar ? 'Preparar' : 'finalizar',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

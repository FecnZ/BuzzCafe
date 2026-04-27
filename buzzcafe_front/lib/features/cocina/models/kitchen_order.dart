

/// Modelo de un item dentro de una orden
class OrderItem {
  final int qty;
  final String name;
  final String? note;

  OrderItem(this.qty, this.name, {this.note});
}

/// Modelo de una orden completa
class KitchenOrder {
  final String id;
  final String mesa;
  final String time;
  String status; // 'pendiente', 'preparando', 'listo'
  final List<OrderItem> items;
  final String cajero;

  KitchenOrder(
    this.id,
    this.mesa,
    this.time,
    this.status,
    this.items, {
    this.cajero = 'Cajero 1',
  });
}

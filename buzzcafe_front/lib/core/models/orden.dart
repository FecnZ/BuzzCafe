// lib/models/orden.dart

class Orden {
  final int id;
  final String fecha;
  final String estado;
  final double total;
  final List<DetalleOrden> detalles;

  Orden({
    required this.id,
    required this.fecha,
    required this.estado,
    required this.total,
    required this.detalles,
  });

  // Este es el "traductor" de JSON a objeto Dart
  factory Orden.fromJson(Map<String, dynamic> json) {
    var list = json['detalles'] as List;
    List<DetalleOrden> detallesList = list
        .map((i) => DetalleOrden.fromJson(i))
        .toList();

    return Orden(
      id: json['id'],
      fecha: json['fecha'],
      estado: json['estado'],
      total: json['total'].toDouble(),
      detalles: detallesList,
    );
  }
}

class DetalleOrden {
  final int id;
  final int cantidad;
  final String nombreProducto;

  DetalleOrden({
    required this.id,
    required this.cantidad,
    required this.nombreProducto,
  });

  factory DetalleOrden.fromJson(Map<String, dynamic> json) {
    return DetalleOrden(
      id: json['id'],
      cantidad: json['cantidad'],
      // Accedemos al objeto 'producto' y luego a 'nombre' como en tu JSON
      nombreProducto: json['producto']['nombre'],
    );
  }
}

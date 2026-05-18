class Product {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String categoria;
  final bool activo;

  const Product({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.categoria,
    this.activo = true,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: (json['precio'] as num).toDouble(),
      stock: json['stock'],
      categoria: json['categoria'],
      activo: json['activo'] ?? true,
    );
  }

  Product copyWith({
    String? id,
    String? nombre,
    String? descripcion,
    double? precio,
    int? stock,
    String? categoria,
    bool? activo,
  }) {
    return Product(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      stock: stock ?? this.stock,
      categoria: categoria ?? this.categoria,
      activo: activo ?? this.activo,
    );
  }
}

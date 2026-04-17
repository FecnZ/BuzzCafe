import 'dart:convert';
import 'package:buzzcafe_front/core/config/environment.dart';
import 'package:buzzcafe_front/features/admin/models/product.dart';
import 'package:http/http.dart' as http;

class AdminService {
  final String baseUrl = "${Environment.baseUrl}/admin";

  Future<List<Product>> getProductosAdmin(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/products"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((json) => Product.fromJson(json)).toList();
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? "Error desconocido");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }

  Future<Product?> crearProducto(Product producto, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/products"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'nombre': producto.nombre,
          'descripcion': producto.descripcion,
          'precio': producto.precio,
          'stock': producto.stock,
          'categoria': producto.categoria,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );
        return Product.fromJson(data);
      } else {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody['message'] ?? "Error desconocido");
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll("Exception :", ""));
    }
  }
}

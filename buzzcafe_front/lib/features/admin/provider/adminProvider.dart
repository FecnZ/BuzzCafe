import 'package:buzzcafe_front/features/admin/models/product.dart';
import 'package:buzzcafe_front/features/admin/services/adminService.dart';
import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  List<Product> _productos = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<Product> get productos => _productos;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  final AdminService _adminService = AdminService();

  Future<void> cargarProductos(String token) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      _productos = await _adminService.getProductosAdmin(token);
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarProducto(Product producto, String token) async {
    try {
      final productocreado = await _adminService.crearProducto(producto, token);

      _productos.add(productocreado!);

      notifyListeners();
      return true;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

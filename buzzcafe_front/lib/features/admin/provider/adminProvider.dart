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
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final productocreado = await _adminService.crearProducto(producto, token);
      if (productocreado != null) {
        _productos.add(productocreado);
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> eliminarProducto(String id, String token) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final success = await _adminService.eliminarProducto(id, token);
      if (success) {
        final index = _productos.indexWhere((p) => p.id == id);
        if (index != -1) {
          _productos[index] = _productos[index].copyWith(activo: false);
        }
        return true;
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

import 'package:buzzcafe_front/features/admin/provider/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/user_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/notificacionesUI.dart';
import '../models/product.dart';

class AdminAddProductView extends StatefulWidget {
  final VoidCallback onCancel;
  final Product? productToEdit;
  const AdminAddProductView({super.key, required this.onCancel, this.productToEdit});

  @override
  State<AdminAddProductView> createState() => _AdminAddProductViewState();
}

class _AdminAddProductViewState extends State<AdminAddProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  final _stockCtrl = TextEditingController();
  final _categoriaCtrl = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.productToEdit != null) {
      final p = widget.productToEdit!;
      _nombreCtrl.text = p.nombre;
      _descripcionCtrl.text = p.descripcion;
      _precioCtrl.text = p.precio.toString();
      _stockCtrl.text = p.stock.toString();
      _categoriaCtrl.text = p.categoria;
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _descripcionCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _categoriaCtrl.dispose();
    super.dispose();
  }

  void _intentarCrearProducto() async {
    // Validar campos vacíos primero
    if (_nombreCtrl.text.isEmpty ||
        _descripcionCtrl.text.isEmpty ||
        _precioCtrl.text.isEmpty ||
        _stockCtrl.text.isEmpty ||
        _categoriaCtrl.text.isEmpty) {
      NotificacionesUI.mostrarError(
        context,
        "Por favor, llena todos los campos",
      );
      return;
    }

    // Validar formulario (precio válido, stock válido, etc.)
    if (!_formKey.currentState!.validate()) return;

    if (widget.productToEdit != null) {
      // Modo Edición
      Map<String, dynamic> changedFields = {};
      final p = widget.productToEdit!;
      
      if (_nombreCtrl.text.trim() != p.nombre) changedFields['nombre'] = _nombreCtrl.text.trim();
      if (_descripcionCtrl.text.trim() != p.descripcion) changedFields['descripcion'] = _descripcionCtrl.text.trim();
      
      final nuevoPrecio = double.parse(_precioCtrl.text.trim());
      if (nuevoPrecio != p.precio) changedFields['precio'] = nuevoPrecio;
      
      final nuevoStock = int.parse(_stockCtrl.text.trim());
      if (nuevoStock != p.stock) changedFields['stock'] = nuevoStock;
      
      if (_categoriaCtrl.text.trim() != p.categoria) changedFields['categoria'] = _categoriaCtrl.text.trim();

      if (changedFields.isEmpty) {
        NotificacionesUI.mostrarExito(context, "No se realizaron cambios");
        widget.onCancel();
        return;
      }

      NotificacionesUI.mostrarExito(
        context, 
        "Edición lista. Campos a actualizar: ${changedFields.keys.join(', ')}"
      );
      widget.onCancel();
      return;
    }

    // Modo Creación
    setState(() => _isSubmitting = true);

    final producto = Product(
      id: '',
      nombre: _nombreCtrl.text.trim(),
      descripcion: _descripcionCtrl.text.trim(),
      precio: double.parse(_precioCtrl.text.trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      categoria: _categoriaCtrl.text.trim(),
    );

    final adminProvider = context.read<AdminProvider>();
    final token = context.read<UserProvider>().token;

    if (token == null) {
      NotificacionesUI.mostrarError(
        context,
        "Sesión expirada, inicia sesión de nuevo",
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final exito = await adminProvider.agregarProducto(producto, token);

    if (!mounted) return;

    if (exito) {
      NotificacionesUI.mostrarExito(
        context,
        "Producto '${producto.nombre}' creado exitosamente",
      );
      widget.onCancel(); // Regresar al menú
    } else {
      NotificacionesUI.mostrarError(
        context,
        "Error al crear producto: ${adminProvider.errorMessage}",
      );
    }
    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = isDark
        ? const Color(0xFFE0E0E0)
        : const Color(0xFF212121);
    final cardBg = isDark ? const Color(0xFF242424) : Colors.white;
    final inputFill = isDark
        ? Colors.white.withAlpha(12)
        : const Color(0xFFF9F6F0);
    final borderColor = isDark
        ? Colors.white.withAlpha(25)
        : Colors.black.withAlpha(18);
    final focusBorder = isDark
        ? AppColors.primaryCoffeeLight
        : AppColors.primaryOrange;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onCancel,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: onSurface.withAlpha(180),
                      ),
                      tooltip: "Regresar",
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.productToEdit == null ? "Nuevo Producto" : "Editar Producto",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: onSurface.withAlpha(200),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Form Card ──
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                    boxShadow: isDark
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black.withAlpha(10),
                              blurRadius: 16,
                            ),
                          ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Información del Producto",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.productToEdit == null 
                            ? "Llena los campos para registrar un nuevo producto." 
                            : "Modifica los campos que deseas actualizar.",
                          style: TextStyle(
                            fontSize: 13,
                            color: onSurface.withAlpha(130),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 20),

                        // Nombre
                        _label("Nombre", onSurface),
                        const SizedBox(height: 6),
                        _field(
                          ctrl: _nombreCtrl,
                          hint: "Ej: Cappuccino",
                          onSurface: onSurface,
                          inputFill: inputFill,
                          focusBorder: focusBorder,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Obligatorio"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Descripción
                        _label("Descripción", onSurface),
                        const SizedBox(height: 6),
                        _field(
                          ctrl: _descripcionCtrl,
                          hint: "Ej: Café espresso con leche espumada",
                          onSurface: onSurface,
                          inputFill: inputFill,
                          focusBorder: focusBorder,
                          maxLines: 3,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Obligatorio"
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Precio y Stock
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label("Precio (\$)", onSurface),
                                  const SizedBox(height: 6),
                                  _field(
                                    ctrl: _precioCtrl,
                                    hint: "45.00",
                                    onSurface: onSurface,
                                    inputFill: inputFill,
                                    focusBorder: focusBorder,
                                    keyboard:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    formatters: [
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d+\.?\d{0,2}'),
                                      ),
                                    ],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty)
                                        return "Obligatorio";
                                      final n = double.tryParse(v.trim());
                                      return (n == null || n <= 0)
                                          ? "Precio inválido"
                                          : null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label("Stock", onSurface),
                                  const SizedBox(height: 6),
                                  _field(
                                    ctrl: _stockCtrl,
                                    hint: "50",
                                    onSurface: onSurface,
                                    inputFill: inputFill,
                                    focusBorder: focusBorder,
                                    keyboard: TextInputType.number,
                                    formatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty)
                                        return "Obligatorio";
                                      final n = int.tryParse(v.trim());
                                      return (n == null || n < 0)
                                          ? "Stock inválido"
                                          : null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Categoría
                        _label("Categoría", onSurface),
                        const SizedBox(height: 6),
                        _field(
                          ctrl: _categoriaCtrl,
                          hint: "Ej: Bebidas Calientes",
                          onSurface: onSurface,
                          inputFill: inputFill,
                          focusBorder: focusBorder,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? "Obligatorio"
                              : null,
                        ),
                        const SizedBox(height: 28),
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 20),

                        // ── Botones ──
                        Align(
                          alignment: Alignment.centerRight,
                          child: Wrap(
                            spacing: 12,
                            children: [
                              // Cancelar
                              Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: _isSubmitting ? null : widget.onCancel,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: onSurface.withAlpha(60),
                                      ),
                                    ),
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: onSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Crear
                              Material(
                                color: _isSubmitting
                                    ? AppColors.primaryOrange.withAlpha(150)
                                    : AppColors.primaryOrange,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: _isSubmitting
                                      ? null
                                      : _intentarCrearProducto,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    child: _isSubmitting
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            widget.productToEdit == null ? "Crear Producto" : "Guardar Cambios",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _label(String text, Color c) => Text(
    text,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: c.withAlpha(180),
    ),
  );

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    required Color onSurface,
    required Color inputFill,
    required Color focusBorder,
    int maxLines = 1,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboard,
      inputFormatters: formatters,
      validator: validator,
      style: TextStyle(color: onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: onSurface.withAlpha(100)),
        filled: true,
        fillColor: inputFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: onSurface.withAlpha(50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: onSurface.withAlpha(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusBorder),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
      ),
    );
  }
}

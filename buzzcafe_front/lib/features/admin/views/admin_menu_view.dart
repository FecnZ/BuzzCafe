import 'package:buzzcafe_front/features/admin/provider/adminProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../models/product.dart';
import 'admin_add_product_view.dart';

const _kDarkSurface = Color(0xFF242424);
const _kLightSurface = Color(0xFFFFFFFF);
const _kDarkOn = Color(0xFFE0E0E0);
const _kLightOn = Color(0xFF212121);

class AdminMenuView extends StatefulWidget {
  const AdminMenuView({super.key});

  @override
  State<AdminMenuView> createState() => _AdminMenuViewState();
}

class _AdminMenuViewState extends State<AdminMenuView> {
  bool _showAddForm = false;

  @override
  Widget build(BuildContext context) {
    // Si se activa el formulario, mostrarlo en lugar de la tabla
    if (_showAddForm) {
      return AdminAddProductView(
        onCancel: () => setState(() => _showAddForm = false),
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final provider = context.watch<AdminProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage.isNotEmpty && provider.productos.isEmpty) {
      return Center(child: Text("Error: ${provider.errorMessage}"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Gestión de Menú y Precios",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withAlpha(200),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _FilterBar(
            isDark: isDark,
            onAddPressed: () => setState(() => _showAddForm = true),
          ),
          const SizedBox(height: 20),
          _ProductTablePaginada(productos: provider.productos, isDark: isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Barra de filtros: fondo neutro independiente del seedColor
// ─────────────────────────────────────────────────────────────────────────────
class _FilterBar extends StatelessWidget {
  final bool isDark;
  final VoidCallback onAddPressed;
  const _FilterBar({required this.isDark, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? _kDarkSurface : _kLightSurface;
    final onSurface = isDark ? _kDarkOn : _kLightOn;
    final border = isDark
        ? Border.all(color: Colors.white.withAlpha(18))
        : Border.all(color: Colors.black.withAlpha(12));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: border,
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Búsqueda
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                style: TextStyle(color: onSurface),
                decoration: InputDecoration(
                  hintText: "Buscar producto...",
                  hintStyle: TextStyle(color: onSurface.withAlpha(120)),
                  filled: true,
                  fillColor: isDark
                      ? Colors.white.withAlpha(8)
                      : Colors.transparent,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: onSurface.withAlpha(153),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 15,
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
                    borderSide: BorderSide(
                      color: isDark
                          ? AppColors.primaryCoffeeLight
                          : AppColors.primaryOrange,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Dropdown categoría
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: onSurface.withAlpha(50)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: "Todas",
                isDense: true,
                style: TextStyle(color: onSurface, fontSize: 14),
                dropdownColor: bg,
                items:
                    [
                          "Todas",
                          "Bebidas Calientes",
                          "Bebidas Frías",
                          "Panadería",
                          "Postres",
                        ]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(width: 15),

          // Botón Añadir (Material + InkWell evita crashes de ElevatedButton)
          Material(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: onAddPressed,
              child: const SizedBox(
                height: 42,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Añadir",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTablePaginada extends StatefulWidget {
  final List<Product> productos;
  final bool isDark;

  const _ProductTablePaginada({required this.productos, required this.isDark});

  @override
  State<_ProductTablePaginada> createState() => _ProductTablePaginadaState();
}

class _ProductTablePaginadaState extends State<_ProductTablePaginada> {
  late _ProductDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _ProductDataSource(
      products: widget.productos,
      isDark: widget.isDark,
    );
  }

  @override
  void didUpdateWidget(covariant _ProductTablePaginada oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualiza datos SIN recrear el DataSource (preserva página actual)
    _dataSource.update(widget.productos, widget.isDark);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final bg = isDark ? _kDarkSurface : _kLightSurface;
    final onSurface = isDark ? _kDarkOn : _kLightOn;

    // ColorScheme completamente neutro para PaginatedDataTable
    final neutralScheme = Theme.of(context).colorScheme.copyWith(
      surface: bg,
      onSurface: onSurface,
      surfaceTint: Colors.transparent, // Elimina el tinte café del seedColor
    );

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? Colors.white.withAlpha(18)
              : Colors.black.withAlpha(12),
        ),
        boxShadow: isDark
            ? null
            : [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 16)],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: neutralScheme,
          cardColor: bg,
          dividerColor: isDark
              ? Colors.white.withAlpha(18)
              : Colors.black.withAlpha(12),
        ),
        child: PaginatedDataTable(
          header: Text(
            "Catálogo de Productos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: onSurface,
            ),
          ),
          rowsPerPage: 8,
          showCheckboxColumn: false,
          columnSpacing: 40,
          horizontalMargin: 20,
          headingRowColor: WidgetStateProperty.resolveWith(
            (_) =>
                isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(8),
          ),
          columns: [
            for (final title in [
              "ID",
              "Producto",
              "Categoría",
              "Precio",
              "Stock",
              "Acciones",
            ])
              DataColumn(
                label: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: onSurface,
                  ),
                ),
              ),
          ],
          source: _dataSource,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// DataSource — separado del build para no recrearse con cada redibujado
// ─────────────────────────────────────────────────────────────────────────────
class _ProductDataSource extends DataTableSource {
  List<Product> _products;
  bool _isDark;

  _ProductDataSource({required List<Product> products, required bool isDark})
    : _products = products,
      _isDark = isDark;

  // Actualiza datos y modo oscuro preservando el estado de paginación
  void update(List<Product> products, bool isDark) {
    _products = products;
    _isDark = isDark;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= _products.length) return null;
    final item = _products[index];
    final onSurface = _isDark ? _kDarkOn : _kLightOn;
    final iconBg = _isDark
        ? Colors.white.withAlpha(18)
        : Colors.black.withAlpha(12);

    return DataRow(
      cells: [
        DataCell(
          Text(
            "#${item.id}",
            style: TextStyle(color: onSurface.withAlpha(180)),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.fastfood,
                  size: 16,
                  color: onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                item.nombre,
                style: TextStyle(fontWeight: FontWeight.w500, color: onSurface),
              ),
            ],
          ),
        ),
        DataCell(Text(item.categoria, style: TextStyle(color: onSurface))),
        DataCell(
          Text(
            "\$${item.precio.toStringAsFixed(2)}",
            style: TextStyle(color: onSurface),
          ),
        ),
        DataCell(
          Text(item.stock.toString(), style: TextStyle(color: onSurface)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: _isDark ? Colors.lightBlueAccent : Colors.blue,
                ),
                onPressed: () {},
                tooltip: "Editar",
                constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: _isDark ? Colors.redAccent : Colors.red,
                ),
                onPressed: () {},
                tooltip: "Eliminar",
                constraints: const BoxConstraints(maxWidth: 32, maxHeight: 32),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _products.length;
  @override
  int get selectedRowCount => 0;
}

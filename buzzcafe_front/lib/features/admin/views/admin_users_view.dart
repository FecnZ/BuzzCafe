import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/notificacionesUI.dart';

class AdminUsersView extends StatefulWidget {
  const AdminUsersView({super.key});

  @override
  State<AdminUsersView> createState() => _AdminUsersViewState();
}

class _AdminUsersViewState extends State<AdminUsersView> {
  bool _showForm = false;
  Map<String, dynamic>? _userToEdit;

  // Datos simulados (Mock Data) de personal
  final List<Map<String, dynamic>> _usuariosMock = [
    {
      "id": 1,
      "nombre": "Fernando Administrador",
      "usuario": "admin",
      "rol": "ADMIN",
      "activo": true,
    },
    {
      "id": 2,
      "nombre": "Sam Cajero",
      "usuario": "sam_pos",
      "rol": "CAJERO",
      "activo": true,
    },
    {
      "id": 3,
      "nombre": "Juan Chef",
      "usuario": "juan_kitchen",
      "rol": "COCINA",
      "activo": true,
    },
    {
      "id": 4,
      "nombre": "María Auxiliar",
      "usuario": "maria_aux",
      "rol": "CAJERO",
      "activo": false,
    },
  ];

  void _abrirFormulario({Map<String, dynamic>? usuario}) {
    setState(() {
      _userToEdit = usuario;
      _showForm = true;
    });
  }

  void _cerrarFormulario() {
    setState(() {
      _showForm = false;
      _userToEdit = null;
    });
  }

  void _toggleEstadoUsuario(Map<String, dynamic> usuario) {
    setState(() {
      usuario["activo"] = !usuario["activo"];
    });
    final String mensaje = usuario["activo"] ? "activado" : "desactivado";
    NotificacionesUI.mostrarExito(
      context,
      "Usuario ${usuario['nombre']} $mensaje exitosamente.",
    );
  }

  void _mostrarDialogoCambiarPassword(Map<String, dynamic> usuario) {
    final passwordCtrl = TextEditingController();
    final confirmPasswordCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(Icons.lock_reset, size: 44, color: AppColors.primaryOrange),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      "Cambiar Contraseña",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      usuario["nombre"],
                      style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withAlpha(150)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Nueva Contraseña
                  const Text("Nueva Contraseña", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: passwordCtrl,
                    obscureText: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: _inputStyle("Mínimo 4 caracteres", theme, isDark),
                    validator: (v) => (v == null || v.trim().length < 4)
                        ? "Debe tener al menos 4 caracteres"
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Confirmar Contraseña
                  const Text("Confirmar Contraseña", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: confirmPasswordCtrl,
                    obscureText: true,
                    style: const TextStyle(fontSize: 14),
                    decoration: _inputStyle("Repite la contraseña", theme, isDark),
                    validator: (v) {
                      if (v == null || v.isEmpty) return "Obligatorio";
                      if (v != passwordCtrl.text) return "Las contraseñas no coinciden";
                      return null;
                    },
                  ),
                  
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancelar", style: TextStyle(color: theme.colorScheme.onSurface.withAlpha(150))),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          minimumSize: Size.zero,
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            NotificacionesUI.mostrarExito(
                              context,
                              "Contraseña de ${usuario['nombre']} actualizada correctamente",
                            );
                          }
                        },
                        child: const Text("Actualizar"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  InputDecoration _inputStyle(String hint, ThemeData theme, bool isDark) {
    final inputFill = isDark ? Colors.white.withAlpha(12) : const Color(0xFFF9F6F0);
    final focusBorder = isDark ? AppColors.primaryCoffeeLight : AppColors.primaryOrange;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(100)),
      filled: true,
      fillColor: inputFill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withAlpha(50)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: theme.colorScheme.onSurface.withAlpha(50)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: focusBorder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showForm) {
      return _UserForm(
        usuario: _userToEdit,
        onCancel: _cerrarFormulario,
        onSave: (nuevoUser) {
          setState(() {
            if (_userToEdit == null) {
              // Simular agregar
              nuevoUser["id"] = _usuariosMock.length + 1;
              nuevoUser["activo"] = true;
              _usuariosMock.add(nuevoUser);
              NotificacionesUI.mostrarExito(context, "Usuario creado exitosamente");
            } else {
              // Simular editar
              final idx = _usuariosMock.indexWhere((u) => u["id"] == _userToEdit!["id"]);
              if (idx != -1) {
                _usuariosMock[idx]["nombre"] = nuevoUser["nombre"];
                _usuariosMock[idx]["usuario"] = nuevoUser["usuario"];
                _usuariosMock[idx]["rol"] = nuevoUser["rol"];
                NotificacionesUI.mostrarExito(context, "Usuario modificado exitosamente");
              }
            }
          });
          _cerrarFormulario();
        },
      );
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Titulo y Boton Registrar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gestión de Personal",
                style: TextStyle(
                  color: onSurface.withAlpha(200),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryOrange,
                  foregroundColor: Colors.white,
                  minimumSize: Size.zero, // Override global infinite width
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _abrirFormulario(),
                icon: const Icon(Icons.person_add_alt_1, size: 18),
                label: const Text("Nuevo Empleado", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Tabla
          _UserTablePaginada(
            usuarios: _usuariosMock,
            isDark: isDark,
            onEdit: (u) => _abrirFormulario(usuario: u),
            onChangePass: _mostrarDialogoCambiarPassword,
            onToggleActive: _toggleEstadoUsuario,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WIDGET DE TABLA ENCAPSULADO PARA EVITAR BUCLES INFINITOS DE RENDERIZADO
// ─────────────────────────────────────────────────────────────────────────────
class _UserTablePaginada extends StatefulWidget {
  final List<Map<String, dynamic>> usuarios;
  final bool isDark;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onChangePass;
  final Function(Map<String, dynamic>) onToggleActive;

  const _UserTablePaginada({
    required this.usuarios,
    required this.isDark,
    required this.onEdit,
    required this.onChangePass,
    required this.onToggleActive,
  });

  @override
  State<_UserTablePaginada> createState() => _UserTablePaginadaState();
}

class _UserTablePaginadaState extends State<_UserTablePaginada> {
  late _UserDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = _UserDataSource(
      usuarios: widget.usuarios,
      isDark: widget.isDark,
      onEdit: widget.onEdit,
      onChangePass: widget.onChangePass,
      onToggleActive: widget.onToggleActive,
    );
  }

  @override
  void didUpdateWidget(covariant _UserTablePaginada oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Actualiza datos SIN recrear el objeto de la fuente (evita loops y reinicios)
    _dataSource.update(widget.usuarios, widget.isDark);
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDark ? const Color(0xFF242424) : Colors.white;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.isDark ? Colors.white.withAlpha(18) : Colors.black.withAlpha(12),
        ),
        boxShadow: widget.isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 16,
                ),
              ],
      ),
      child: Theme(
        data: theme.copyWith(
          cardColor: bg,
          dividerColor: widget.isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(15),
        ),
        child: PaginatedDataTable(
          header: Text(
            "Lista de Personal Registrado",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: onSurface.withAlpha(200),
            ),
          ),
          columnSpacing: 20,
          horizontalMargin: 24,
          rowsPerPage: widget.usuarios.length > 5 ? 5 : (widget.usuarios.isEmpty ? 1 : widget.usuarios.length),
          columns: const [
            DataColumn(label: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Nombre Completo", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Usuario", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Rol / Permiso", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Estado", style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text("Acciones", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          source: _dataSource,
        ),
      ),
    );
  }
}

class _UserDataSource extends DataTableSource {
  List<Map<String, dynamic>> usuarios;
  bool isDark;
  final Function(Map<String, dynamic>) onEdit;
  final Function(Map<String, dynamic>) onChangePass;
  final Function(Map<String, dynamic>) onToggleActive;

  _UserDataSource({
    required this.usuarios,
    required this.isDark,
    required this.onEdit,
    required this.onChangePass,
    required this.onToggleActive,
  });

  void update(List<Map<String, dynamic>> nuevosUsuarios, bool nuevoIsDark) {
    usuarios = nuevosUsuarios;
    isDark = nuevoIsDark;
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    if (index >= usuarios.length) return null;
    final u = usuarios[index];
    final bool esActivo = u["activo"];

    // Definición de colores de rol
    Color rolColor;
    Color rolBg;
    switch (u["rol"]) {
      case "ADMIN":
        rolColor = AppColors.primaryOrange;
        rolBg = AppColors.primaryOrange.withAlpha(20);
        break;
      case "CAJERO":
        rolColor = Colors.blue;
        rolBg = Colors.blue.withAlpha(20);
        break;
      case "COCINA":
      default:
        rolColor = Colors.teal;
        rolBg = Colors.teal.withAlpha(20);
        break;
    }

    return DataRow(
      cells: [
        DataCell(Text("#${u['id']}", style: const TextStyle(fontWeight: FontWeight.bold))),
        DataCell(Text(u['nombre'])),
        DataCell(Text(u['usuario'])),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: rolBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: rolColor.withAlpha(100)),
            ),
            child: Text(
              u["rol"],
              style: TextStyle(color: rolColor, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: esActivo ? Colors.green.withAlpha(25) : Colors.red.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: esActivo ? Colors.green.withAlpha(100) : Colors.red.withAlpha(100)),
            ),
            child: Text(
              esActivo ? "Activo" : "Inactivo",
              style: TextStyle(
                color: esActivo ? Colors.green : Colors.red,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit_outlined, size: 18, color: isDark ? Colors.lightBlueAccent : Colors.blue),
                tooltip: "Editar Datos",
                onPressed: () => onEdit(u),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: Icon(Icons.vpn_key_outlined, size: 18, color: Colors.orange.shade400),
                tooltip: "Cambiar Contraseña",
                onPressed: () => onChangePass(u),
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
              ),
              IconButton(
                icon: Icon(
                  esActivo ? Icons.block_flipped : Icons.check_circle_outline,
                  size: 18,
                  color: esActivo ? Colors.red.shade400 : Colors.green.shade400,
                ),
                tooltip: esActivo ? "Desactivar Usuario" : "Activar Usuario",
                onPressed: () => onToggleActive(u),
                visualDensity: VisualDensity.compact,
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
  int get rowCount => usuarios.length;
  @override
  int get selectedRowCount => 0;
}

class _UserForm extends StatefulWidget {
  final Map<String, dynamic>? usuario;
  final VoidCallback onCancel;
  final Function(Map<String, dynamic>) onSave;

  const _UserForm({
    required this.usuario,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<_UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<_UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _usuarioCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  String _rolSeleccionado = "CAJERO";
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (widget.usuario != null) {
      final u = widget.usuario!;
      _nombreCtrl.text = u["nombre"];
      _usuarioCtrl.text = u["usuario"];
      _rolSeleccionado = u["rol"];
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _usuarioCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    final cardBg = isDark ? const Color(0xFF242424) : Colors.white;
    final inputFill = isDark ? Colors.white.withAlpha(12) : const Color(0xFFF9F6F0);
    final borderColor = isDark ? Colors.white.withAlpha(25) : Colors.black.withAlpha(18);
    final focusBorder = isDark ? AppColors.primaryCoffeeLight : AppColors.primaryOrange;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    IconButton(
                      onPressed: widget.onCancel,
                      icon: Icon(Icons.arrow_back_rounded, color: onSurface.withAlpha(180)),
                      tooltip: "Regresar",
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.usuario == null ? "Nuevo Empleado" : "Editar Empleado",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: onSurface.withAlpha(200),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form Card
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
                          "Información de Credenciales",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.usuario == null
                              ? "Crea las credenciales de acceso para el nuevo personal."
                              : "Actualiza los datos personales y de rol del empleado.",
                          style: TextStyle(fontSize: 13, color: onSurface.withAlpha(130)),
                        ),
                        const SizedBox(height: 20),
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 20),

                        // Nombre Completo
                        _label("Nombre Completo"),
                        const SizedBox(height: 6),
                        _field(
                          ctrl: _nombreCtrl,
                          hint: "Ej: Juan Pérez",
                          theme: theme,
                          isDark: isDark,
                          focusBorder: focusBorder,
                          inputFill: inputFill,
                          validator: (v) => (v == null || v.trim().isEmpty) ? "Obligatorio" : null,
                        ),
                        const SizedBox(height: 16),

                        // Usuario Login
                        _label("Usuario (Login)"),
                        const SizedBox(height: 6),
                        _field(
                          ctrl: _usuarioCtrl,
                          hint: "Ej: juan_pos",
                          theme: theme,
                          isDark: isDark,
                          focusBorder: focusBorder,
                          inputFill: inputFill,
                          validator: (v) => (v == null || v.trim().isEmpty) ? "Obligatorio" : null,
                        ),
                        const SizedBox(height: 16),

                        // Rol Dropdown
                        _label("Rol / Permisos"),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _rolSeleccionado,
                          style: TextStyle(fontSize: 14, color: onSurface),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: inputFill,
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: onSurface.withAlpha(50)),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(value: "ADMIN", child: Text("Administrador (Acceso Total)")),
                            DropdownMenuItem(value: "CAJERO", child: Text("Cajero (Punto de Venta)")),
                            DropdownMenuItem(value: "COCINA", child: Text("Cocina (Pedidos y Pantalla)")),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _rolSeleccionado = val);
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password (Solo para nuevos registros)
                        if (widget.usuario == null) ...[
                          _label("Contraseña de Acceso"),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscurePassword,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: "Mínimo 4 caracteres",
                              hintStyle: TextStyle(color: onSurface.withAlpha(100)),
                              filled: true,
                              fillColor: inputFill,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: onSurface.withAlpha(50)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) => (v == null || v.trim().length < 4)
                                ? "Mínimo 4 caracteres"
                                : null,
                          ),
                          const SizedBox(height: 28),
                        ] else ...[
                          const SizedBox(height: 12),
                        ],
                        
                        Divider(color: borderColor, height: 1),
                        const SizedBox(height: 20),

                        // Botones
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: widget.onCancel,
                              child: Text("Cancelar", style: TextStyle(color: onSurface.withAlpha(150))),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryOrange,
                                foregroundColor: Colors.white,
                                minimumSize: Size.zero,
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final data = {
                                    "nombre": _nombreCtrl.text.trim(),
                                    "usuario": _usuarioCtrl.text.trim(),
                                    "rol": _rolSeleccionado,
                                  };
                                  widget.onSave(data);
                                }
                              },
                              child: Text(widget.usuario == null ? "Registrar Empleado" : "Guardar Cambios"),
                            ),
                          ],
                        )
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

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
        ),
      );

  Widget _field({
    required TextEditingController ctrl,
    required String hint,
    required ThemeData theme,
    required bool isDark,
    required Color focusBorder,
    required Color inputFill,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      validator: validator,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(100)),
        filled: true,
        fillColor: inputFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withAlpha(50)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colorScheme.onSurface.withAlpha(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusBorder),
        ),
      ),
    );
  }
}

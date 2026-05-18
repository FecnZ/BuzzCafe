import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/notificacionesUI.dart';

class AdminSettingsView extends StatefulWidget {
  const AdminSettingsView({super.key});

  @override
  State<AdminSettingsView> createState() => _AdminSettingsViewState();
}

class _AdminSettingsViewState extends State<AdminSettingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controladores de datos del negocio
  final _nombreCtrl = TextEditingController(text: "BuzzCafé Centro");
  final _direccionCtrl = TextEditingController(
    text: "Av. Universidad #402, Col. Centro",
  );
  final _telefonoCtrl = TextEditingController(text: "449-123-4567");
  final _mensajeCtrl = TextEditingController(
    text: "¡Gracias por su visita! Vuelva pronto.",
  );

  // Opciones de apariencia
  String _temaSeleccionado = "Oscuro"; // Claro, Oscuro, Sistema
  Color _colorAcentoSeleccionado = AppColors.primaryOrange;

  final List<Map<String, dynamic>> _coloresMock = [
    {"nombre": "Naranja Buzz", "color": AppColors.primaryOrange},
    {"nombre": "Azul Espresso", "color": Colors.blue},
    {"nombre": "Verde Matcha", "color": Colors.teal},
    {"nombre": "Rojo Fresa", "color": Colors.red},
    {"nombre": "Café Capuccino", "color": const Color(0xFF8D6E63)},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Escuchar cambios en los textos para actualizar la vista previa
    _nombreCtrl.addListener(() => setState(() {}));
    _direccionCtrl.addListener(() => setState(() {}));
    _telefonoCtrl.addListener(() => setState(() {}));
    _mensajeCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nombreCtrl.dispose();
    _direccionCtrl.dispose();
    _telefonoCtrl.dispose();
    _mensajeCtrl.dispose();
    super.dispose();
  }

  void _guardarConfiguraciones() {
    NotificacionesUI.mostrarExito(
      context,
      "Configuraciones guardadas y aplicadas con éxito.",
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF242424) : Colors.white;
    final onSurface = theme.colorScheme.onSurface;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titulo de la página
          Text(
            "Configuración del Sistema",
            style: TextStyle(
              color: onSurface.withAlpha(200),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Pestañas (Tabs)
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: _colorAcentoSeleccionado,
            labelColor: _colorAcentoSeleccionado,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(
                icon: Icon(Icons.storefront_outlined),
                text: "Negocio y Ticket",
              ),
              Tab(
                icon: Icon(Icons.palette_outlined),
                text: "Personalización y Apariencia",
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Contenedor de las Vistas de las Pestañas
          Container(
            height: 520, // Altura fija para manejar la cuadrícula
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNegocioTab(bg, theme, isDark),
                _buildAparienciaTab(bg, theme, isDark),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botón Guardar Cambios
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorAcentoSeleccionado,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _guardarConfiguraciones,
              icon: const Icon(Icons.save_outlined),
              label: const Text(
                "Guardar Cambios",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pestaña 1: Negocio y Ticket con Vista Previa del Ticket en Tiempo Real
  Widget _buildNegocioTab(Color bg, ThemeData theme, bool isDark) {
    final borderColor = isDark
        ? Colors.white.withAlpha(25)
        : Colors.black.withAlpha(18);
    final inputFill = isDark
        ? Colors.white.withAlpha(12)
        : const Color(0xFFF9F6F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Formulario
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Datos Generales",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Introduce los datos que aparecerán en la cabecera y pie de tus tickets.",
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withAlpha(140),
                  ),
                ),
                const SizedBox(height: 20),

                // Nombre
                _label("Nombre Comercial"),
                const SizedBox(height: 6),
                _field(
                  _nombreCtrl,
                  "Nombre del café",
                  theme,
                  isDark,
                  inputFill,
                ),
                const SizedBox(height: 16),

                // Dirección
                _label("Dirección"),
                const SizedBox(height: 6),
                _field(
                  _direccionCtrl,
                  "Ubicación física",
                  theme,
                  isDark,
                  inputFill,
                ),
                const SizedBox(height: 16),

                // Teléfono
                _label("Teléfono"),
                const SizedBox(height: 6),
                _field(
                  _telefonoCtrl,
                  "Número telefónico",
                  theme,
                  isDark,
                  inputFill,
                ),
                const SizedBox(height: 16),

                // Mensaje del Ticket
                _label("Mensaje de Pie de Ticket"),
                const SizedBox(height: 6),
                _field(
                  _mensajeCtrl,
                  "Mensaje de despedida",
                  theme,
                  isDark,
                  inputFill,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24),

        // Vista Previa Interactiva del Ticket
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "VISTA PREVIA DEL TICKET",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withAlpha(130),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Simulación de Papel de Ticket Térmico
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // Los tickets son tradicionalmente blancos
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(20),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Colors.black,
                      fontFamily: 'monospace',
                      fontSize: 11,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Cabecera
                        Center(
                          child: Text(
                            _nombreCtrl.text.toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Text(
                            _direccionCtrl.text,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(child: Text("Tel: ${_telefonoCtrl.text}")),
                        const SizedBox(height: 12),
                        const Text("---------------------------------"),
                        const SizedBox(height: 8),

                        // Cuerpo (Ficticio para rellenar)
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1x Cappuccino Mediano"),
                            Text("\$45.00"),
                          ],
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("1x Tarta de Queso"),
                            Text("\$80.00"),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text("---------------------------------"),
                        const SizedBox(height: 8),

                        // Total
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "TOTAL:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "\$125.00",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mensaje
                        const Spacer(),
                        Center(
                          child: Text(
                            _mensajeCtrl.text,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(child: Text("BuzzCafé Software")),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Pestaña 2: Personalización y Apariencia
  Widget _buildAparienciaTab(Color bg, ThemeData theme, bool isDark) {
    final borderColor = isDark
        ? Colors.white.withAlpha(25)
        : Colors.black.withAlpha(18);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Personalización de la Aplicación",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Elige cómo se ve y siente la aplicación para tus dispositivos.",
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withAlpha(140),
            ),
          ),
          const SizedBox(height: 28),

          // Tema
          const Text(
            "Tema del Sistema",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildThemeCard("Claro", Icons.wb_sunny_outlined, theme),
              const SizedBox(width: 16),
              _buildThemeCard("Oscuro", Icons.dark_mode_outlined, theme),
              const SizedBox(width: 16),
              _buildThemeCard(
                "Sistema",
                Icons.settings_brightness_outlined,
                theme,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Color de Acento
          const Text(
            "Color de Acento Principal",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Afecta el color de botones, selecciones e indicadores primarios de toda la app.",
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withAlpha(120),
            ),
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 16,
            children: _coloresMock.map((colorMap) {
              final Color c = colorMap["color"];
              final bool seleccionado = _colorAcentoSeleccionado == c;

              return InkWell(
                onTap: () {
                  setState(() {
                    _colorAcentoSeleccionado = c;
                  });
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: seleccionado
                          ? theme.colorScheme.onSurface
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: seleccionado
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String label, IconData icon, ThemeData theme) {
    final bool seleccionado = _temaSeleccionado == label;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _temaSeleccionado = label;
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: seleccionado
                ? _colorAcentoSeleccionado.withAlpha(20)
                : (isDark
                      ? Colors.white.withAlpha(8)
                      : Colors.black.withAlpha(5)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: seleccionado
                  ? _colorAcentoSeleccionado
                  : Colors.grey.withAlpha(60),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: seleccionado
                    ? _colorAcentoSeleccionado
                    : theme.colorScheme.onSurface.withAlpha(150),
                size: 28,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: seleccionado
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: seleccionado
                      ? _colorAcentoSeleccionado
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _field(
    TextEditingController ctrl,
    String hint,
    ThemeData theme,
    bool isDark,
    Color inputFill, {
    int maxLines = 1,
  }) {
    final focusBorder = isDark
        ? AppColors.primaryCoffeeLight
        : _colorAcentoSeleccionado;
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: theme.colorScheme.onSurface.withAlpha(100)),
        filled: true,
        fillColor: inputFill,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withAlpha(50),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: theme.colorScheme.onSurface.withAlpha(50),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusBorder),
        ),
      ),
    );
  }
}

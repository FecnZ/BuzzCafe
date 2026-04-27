import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class CajeroCardConfigView extends StatefulWidget {
  const CajeroCardConfigView({super.key});

  @override
  State<CajeroCardConfigView> createState() => _CajeroCardConfigViewState();
}

class _CajeroCardConfigViewState extends State<CajeroCardConfigView> {
  final TextEditingController _rechargeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  // Mock data para simular estado
  bool _cardFound = false;
  double _saldo = 25.0;
  int _puntos = 3;
  bool _isActive = true;

  @override
  void dispose() {
    _rechargeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchCard() {
    FocusScope.of(context).unfocus();
    if (_searchController.text.isNotEmpty) {
      setState(() {
        _cardFound = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarjeta encontrada exitosamente')),
      );
    }
  }

  void _confirmRecharge() {
    final monto = double.tryParse(_rechargeController.text) ?? 0.0;
    if (monto > 0) {
      setState(() {
        _saldo += monto;
        _rechargeController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recarga de \$${monto.toStringAsFixed(2)} exitosa'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un monto válido')),
      );
    }
  }

  void _toggleCardStatus(bool status) {
    setState(() {
      _isActive = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final cardColor = isDark ? colorScheme.surface : Colors.white;
    final inputColor = isDark ? Colors.white10 : Colors.grey.shade50;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double contentWidth =
            constraints.maxWidth > 830 ? 800 : constraints.maxWidth - 30;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),
                  // ── Buscador de Tarjeta ──
                  _buildSearchSection(cardColor, inputColor, isDark),
                  const SizedBox(height: 30),
                  // ── Contenido principal ──
                  if (_cardFound)
                    _buildCardDetails(
                        colorScheme, isDark, cardColor, inputColor)
                  else
                    _buildPlaceholder(colorScheme),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SECCIÓN: Buscador
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildSearchSection(Color cardColor, Color inputColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Ingrese Número de Tarjeta o Email de Cliente",
              prefixIcon: const Icon(Icons.credit_card),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: inputColor,
            ),
            onSubmitted: (_) => _searchCard(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _searchCard,
              icon: const Icon(Icons.search),
              label: const Text("Buscar", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SECCIÓN: Detalles de la tarjeta encontrada
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildCardDetails(
      ColorScheme colorScheme, bool isDark, Color cardColor, Color inputColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Resumen General Tarjeta",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 20),

        // ── Saldo ──
        _buildInfoCard("Saldo", "\$${_saldo.toStringAsFixed(2)}", isDark,
            cardColor, inputColor),
        const SizedBox(height: 15),

        // ── Estado ──
        _buildStateCard(isDark, cardColor),
        const SizedBox(height: 15),

        // ── Puntos ──
        _buildInfoCard("Puntos", "$_puntos", isDark, cardColor, inputColor),
        const SizedBox(height: 15),

        // ── Botones Activar / Bloquear ──
        _buildActionButtons(),
        const SizedBox(height: 30),

        // ── Sección de Recarga ──
        _buildRechargeSection(cardColor, inputColor, isDark),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SECCIÓN: Placeholder cuando no hay tarjeta
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildPlaceholder(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Center(
        child: Text(
          "Busque una tarjeta para ver su información",
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  WIDGET: Tarjeta de información (Saldo, Puntos)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildInfoCard(
      String title, String value, bool isDark, Color cardColor, Color inputColor) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8),
              color: inputColor,
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  WIDGET: Tarjeta de Estado (Activa / Bloqueada)
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildStateCard(bool isDark, Color cardColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
        boxShadow: !isDark
            ? [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          Text(
            "Estado",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
              border: Border.all(color: _isActive ? Colors.green : Colors.red),
              borderRadius: BorderRadius.circular(8),
              color: _isActive
                  ? Colors.green.withAlpha(30)
                  : Colors.red.withAlpha(30),
            ),
            child: Text(
              _isActive ? "Activa" : "Bloqueada",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isActive ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  WIDGET: Botones de Activar / Bloquear
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _toggleCardStatus(true),
            child: const Text("Activar", style: TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _toggleCardStatus(false),
            child: const Text("Bloquear", style: TextStyle(fontSize: 16)),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════
  //  SECCIÓN: Recarga
  // ═══════════════════════════════════════════════════════════════════
  Widget _buildRechargeSection(
      Color cardColor, Color inputColor, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Recargar",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryOrange,
            ),
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _rechargeController,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: "Ingrese monto",
              prefixIcon: const Icon(Icons.attach_money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: inputColor,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _confirmRecharge,
              child: const Text(
                "Confirmar Recarga",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

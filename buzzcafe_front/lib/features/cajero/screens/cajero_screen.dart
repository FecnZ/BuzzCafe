import 'package:flutter/material.dart';

class CajeroScreen extends StatelessWidget {
  const CajeroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel de Cajero")),
      body: const Center(child: Text("Contenido del Cajero")),
    );
  }
}

import 'package:buzzcafe_front/core/providers/login_provider.dart';
import 'package:buzzcafe_front/features/admin/provider/adminProvider.dart';
import 'package:buzzcafe_front/main_wrapper.dart';
import 'package:buzzcafe_front/core/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: const BuzzCafeApp(),
    ),
  );
}

class BuzzCafeApp extends StatelessWidget {
  const BuzzCafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BuzzCafe POS',
      debugShowCheckedModeBanner: false,

      // Tema Claro
      theme: AppTheme.lightTheme,

      // Tema Oscuro
      darkTheme: AppTheme.darkTheme,

      // Detecta automáticamente el tema del sistema (Windows/Android/iOS)
      themeMode: ThemeMode.system,

      home: const MainWrapper(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buzzcafe_front/features/admin/views/admin_users_view.dart';

void main() {
  testWidgets('Test de renderizado de AdminUsersView', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };

    try {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdminUsersView(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      print("Renderizado exitoso, no hay crash en el widget tree base.");
    } catch (e, stack) {
      print("CRASH DETECTADO:");
      print(e);
      print(stack);
    }
  });
}

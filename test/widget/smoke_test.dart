import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:math_mania/src/ui/app/theme_provider.dart';
import 'package:math_mania/src/ui/dashboard/dashboard_provider.dart';
import 'package:math_mania/src/ui/dashboard/dashboard_view.dart';

void main() {
  testWidgets('Smoke: dashboard renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(sharedPreferences: prefs),
          ),
          ChangeNotifierProvider(
            create: (_) => DashboardProvider(preferences: prefs),
          ),
        ],
        child: const MaterialApp(home: DashboardView()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Math Mania'), findsOneWidget);
  });
}

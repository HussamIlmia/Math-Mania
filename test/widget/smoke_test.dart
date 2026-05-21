import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/ui/app/app.dart';
import '/src/ui/app/theme_provider.dart';
import '/src/ui/dashboard/dashboard_provider.dart';

void main() {
  testWidgets('Smoke: app root renders', (WidgetTester tester) async {
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
        child: const MyApp(firebaseAnalytics: null),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Math Mania'), findsOneWidget);
  });
}

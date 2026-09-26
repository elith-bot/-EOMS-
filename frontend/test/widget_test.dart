// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elm_frontend/src/providers/auth_provider.dart';
import 'package:elm_frontend/src/screens/login_screen.dart';
import 'package:elm_frontend/src/app.dart';

void main() {
  testWidgets('auth screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Directionality(textDirection: TextDirection.rtl, child: ChangeNotifierProvider(create: (_) => AuthProvider(), child: const LoginScreen()))));
    await tester.pump();
    expect(find.text('تسجيل الدخول'), findsWidgets);
    expect(find.text('رقم الهاتف أو البريد الإلكتروني'), findsOneWidget);
  });
}

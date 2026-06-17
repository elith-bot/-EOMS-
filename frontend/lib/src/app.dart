import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class ElmApp extends StatelessWidget {
  const ElmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELM Educational Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
    );
  }
}

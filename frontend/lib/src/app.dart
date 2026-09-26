import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/settings_screen.dart';

class ElmApp extends StatelessWidget {
  const ElmApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3157D5), brightness: Brightness.light);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..checkAuthStatus()),
      ],
      child: MaterialApp(
        title: 'ELM Educational Management',
        theme: ThemeData(
          colorScheme: scheme,
          useMaterial3: true,
          fontFamily: 'Arial',
          scaffoldBackgroundColor: const Color(0xFFF7F8FC),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF3157D5), width: 1.5)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          ),
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
        routes: {
          '/home': (_) => const HomeScreen(),
          '/schedule': (_) => const ScheduleScreen(),
          '/settings': (_) => const SettingsScreen(),
        },
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (!authProvider.initialized) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return authProvider.isAuthenticated ? const HomeScreen() : const LoginScreen();
          },
        ),
      ),
    );
  }
}

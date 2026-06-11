import 'package:flutter/material.dart';
import 'views/login_page.dart';

// ============================================================
// Notificateur global pour le thème — solution simple sans Provider
// Accessible depuis n'importe quel fichier via : import '../main.dart';
// ============================================================
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TaskFlow — Gestion des Tâches',
          // ---------- Thème Clair ----------
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFFF0F4F8),
            cardColor: Colors.white,
          ),
          // ---------- Thème Sombre ----------
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF6C63FF),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
            scaffoldBackgroundColor: const Color(0xFF12121F),
            cardColor: const Color(0xFF1E1E2E),
          ),
          themeMode: mode,
          home: const LoginPage(),
        );
      },
    );
  }
}
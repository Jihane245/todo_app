import 'package:flutter/material.dart';
import 'views/login_page.dart';

// 1. Création d'un Notificateur global pour le thème
// Il permet de notifier l'application dès que la valeur (light/dark) change.
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Utilisation de ValueListenableBuilder pour reconstruire 
    // l'interface automatiquement lors du changement de mode
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          
          // Configuration des thèmes
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          
          // Application du mode courant
          themeMode: currentMode,
          
          home: const LoginPage(),
        );
      },
    );
  }
}
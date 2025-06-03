import 'package:flutter/material.dart';
import 'package:habitus/screens/auth/login_screen.dart';
import 'package:habitus/screens/auth/registro_screen.dart';
import 'package:habitus/screens/habitos/habitos_screen.dart';
import 'package:habitus/screens/habitos/habitos_sugeridos_screen.dart';
import 'package:habitus/screens/home_screen.dart';
import 'package:habitus/screens/settings/ajustes_screen.dart';
import 'package:habitus/screens/stats/estadisticas_screen.dart';

void main() {
  runApp(const HabitusApp());
}

class HabitusApp extends StatelessWidget {
  const HabitusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habitus',
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/login': (context) => LoginScreen(),
        '/registro': (context) => RegistroScreen(),
        '/habitos': (context) => HabitosScreen(),
        '/estadisticas': (context) => EstadisticasScreen(),
        '/ajustes': (context) => AjustesScreen(),
        '/habitos-sugeridos': (context) => HabitosSugeridosScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:habitus/screens/auth/login_screen.dart';
import 'package:habitus/screens/auth/registro_screen.dart';
import 'package:habitus/screens/habitos/habitos_screen.dart';
import 'package:habitus/screens/habitos/habitos_sugeridos_screen.dart';
import 'package:habitus/screens/home_screen.dart';
import 'package:habitus/screens/settings/ajustes_screen.dart';
import 'package:habitus/screens/stats/estadisticas_screen.dart';
import 'package:habitus/utils/token_utils.dart';

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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case '/registro':
            return MaterialPageRoute(builder: (_) => RegistroScreen());
          case '/habitos':
            return MaterialPageRoute(builder: (_) => HabitosScreen());
          case '/estadisticas':
            return MaterialPageRoute(
              builder: (context) => FutureBuilder<String?>(
                future: obtenerToken(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return LoginScreen();
                  }
                  final usuarioId = obtenerUsuarioIdDesdeToken(snapshot.data!);
                  if (usuarioId == null) {
                    return LoginScreen();
                  }
                  return EstadisticasScreen(usuarioId: int.parse(usuarioId));
                },
              ),
            );
          case '/ajustes':
            return MaterialPageRoute(builder: (_) => AjustesScreen());
          case '/habitos-sugeridos':
            return MaterialPageRoute(builder: (_) => HabitosSugeridosScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final darkBlue = Color(0xFF0D1B2A);
    final blueAccent = Color(0xFF1B263B);
    final cyanAccent = Color(0xFF63A4FF);

    return Scaffold(
      backgroundColor: darkBlue,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          decoration: BoxDecoration(
            color: blueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'HABITUS',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: cyanAccent,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black87,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyanAccent,
                  foregroundColor: darkBlue,
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black87,
                ),
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/login'),
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: cyanAccent, width: 2),
                  minimumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  foregroundColor: cyanAccent,
                ),
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                child: const Text(
                  'Crear una cuenta',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

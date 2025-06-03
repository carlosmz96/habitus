import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? error;

  Future<void> login() async {
    setState(() {
      loading = true;
      error = null;
    });

    final url = Uri.parse('http://localhost:8080/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      Navigator.pushReplacementNamed(context, '/habitos');
    } else {
      setState(() {
        error = 'Credenciales incorrectas';
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = const Color(0xFF0D1B2A);
    final blueAccent = const Color(0xFF1B263B);
    final cyanAccent = const Color(0xFF63A4FF);

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: blueAccent,
        foregroundColor: cyanAccent,
        title: const Text('Entrar en Habitus'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: blueAccent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
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
                TextField(
                  controller: emailController,
                  style: TextStyle(color: cyanAccent),
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    labelStyle: TextStyle(color: cyanAccent),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cyanAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cyanAccent, width: 2),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: cyanAccent),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(color: cyanAccent),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cyanAccent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: cyanAccent, width: 2),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 40),
                if (error != null)
                  Text(error!, style: const TextStyle(color: Colors.red)),
                loading
                    ? const CircularProgressIndicator(color: Colors.cyanAccent)
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cyanAccent,
                            foregroundColor: darkBlue,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                          ),
                          onPressed: login,
                          child: const Text(
                            'Entrar',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

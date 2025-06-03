import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();

  String _nombre = '';
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    final url = Uri.parse('http://localhost:8080/auth/register');

    final body = json.encode({
      'nombre': _nombre,
      'email': _email,
      'password': _password,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Registro correcto
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro completado con éxito')),
        );
        Navigator.pop(context);
      } else {
        final resBody = json.decode(response.body);
        final message = resBody['message'] ?? 'Error en el registro';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final darkBlue = Color(0xFF0D1B2A);
    final blueAccent = Color(0xFF1B263B);
    final cyanAccent = Color(0xFF63A4FF);

    return Scaffold(
      backgroundColor: darkBlue,
      appBar: AppBar(
        backgroundColor: blueAccent,
        foregroundColor: cyanAccent,
        title: const Text('Regístrate en Habitus'),
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
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    style: TextStyle(color: cyanAccent),
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: TextStyle(color: cyanAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: cyanAccent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: cyanAccent, width: 2),
                      ),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Introduce tu nombre'
                        : null,
                    onSaved: (value) => _nombre = value!.trim(),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: TextStyle(color: cyanAccent),
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: TextStyle(color: cyanAccent),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: cyanAccent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: cyanAccent, width: 2),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un email válido';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                      if (!emailRegex.hasMatch(value)) return 'Email no válido';
                      return null;
                    },
                    onSaved: (value) => _email = value!.trim(),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
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
                    validator: (value) => (value == null || value.length < 6)
                        ? 'La contraseña debe tener al menos 6 caracteres'
                        : null,
                    onSaved: (value) => _password = value!.trim(),
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.cyanAccent,
                        )
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
                            onPressed: _submit,
                            child: const Text(
                              'Registrar',
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
      ),
    );
  }
}

// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:habitus/models/habito.dart';
import 'package:habitus/utils/token_utils.dart';
import 'package:http/http.dart' as http;

class HabitoService {
  static const String baseUrl = 'http://localhost:8080/api/habitos';

  // Método para listar todos los hábitos
  Future<List<Habito>> listarHabitos() async {
    final token = await obtenerToken();

    // Decodifica el token
    final parts = token?.split('.');
    final payload = json.decode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts![1]))),
    );

    // Extrae el ID
    final id = payload['id'];

    final res = await http.get(
      Uri.parse('$baseUrl/usuario/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      final List jsonData = json.decode(res.body);
      return jsonData.map((e) => Habito.fromJson(e)).toList();
    } else {
      return []; // lista vacía sin error
    }
  }

  // Método para crear un nuevo hábito
  Future<Habito> crearHabito(String nombre) async {
    final token = await obtenerToken();
    final usuarioId = obtenerUsuarioIdDesdeToken(token!);

    final res = await http.post(
      Uri.parse('$baseUrl/usuario/$usuarioId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(Habito(nombre: nombre).toJson()),
    );

    try {
      final decoded = json.decode(res.body);
      return Habito.fromJson(decoded);
    } catch (e) {
      print('Error parseando JSON: $e');
      rethrow;
    }
  }

  // Método para obtener un hábito por ID
  Future<Habito?> obtenerSugerencia() async {
    final token = await obtenerToken();
    final res = await http.get(
      Uri.parse('$baseUrl/sugerencia'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (res.statusCode == 200 && res.body.isNotEmpty) {
      try {
        final data = json.decode(res.body);
        return Habito.fromJson(data);
      } catch (e) {
        print('Error parseando JSON sugerencia: $e');
        return null;
      }
    }
    return null;
  }

  // Método para marcar un hábito como completado
  Future<void> marcarComoHecho(int id) async {
    final token = await obtenerToken();
    final usuarioId = obtenerUsuarioIdDesdeToken(token!);

    await http.post(
      Uri.parse('$baseUrl/$id/completar/$usuarioId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  // Método para eliminar un hábito
  Future<void> desmarcarComoHecho(int id) async {
    final token = await obtenerToken();
    final usuarioId = obtenerUsuarioIdDesdeToken(token!);

    final res = await http.delete(
      Uri.parse('$baseUrl/$id/cancelar/$usuarioId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode != 200) throw Exception('Error al desmarcar');
  }

  // Método para buscar hábitos por nombre
  Future<List<Habito>> buscarHabitos(String query) async {
    final token = await obtenerToken();
    final res = await http.get(
      Uri.parse('$baseUrl/buscar?query=$query'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (res.statusCode == 200) {
      final List jsonData = json.decode(res.body);
      return jsonData.map((e) => Habito.fromJson(e)).toList();
    } else {
      throw Exception('Error al buscar hábitos');
    }
  }

  // Método para actualizar el estado de sugerido de un hábito
  Future<void> actualizarSugerido(int id, bool sugerido) async {
    final token = await obtenerToken();
    await http.put(
      Uri.parse('$baseUrl/$id/sugerido'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(sugerido),
    );
  }
}

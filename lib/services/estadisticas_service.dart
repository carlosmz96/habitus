import 'dart:convert';

import 'package:habitus/models/estadisticas.dart';
import 'package:habitus/utils/token_utils.dart';
import 'package:http/http.dart' as http;

class EstadisticasService {
  final String baseUrl =
      'http://localhost:8080/api/estadisticas'; // Cámbialo si usas IP real

  Future<Estadisticas> obtenerEstadisticas(int usuarioId) async {
    final token = await obtenerToken();

    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/$usuarioId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        throw Exception('Respuesta vacía al obtener estadísticas');
      }
      final jsonBody = json.decode(response.body);
      if (jsonBody == null) {
        throw Exception('JSON nulo al obtener estadísticas');
      }
      return Estadisticas.fromJson(jsonBody);
    } else {
      throw Exception('Error al obtener estadísticas: ${response.statusCode}');
    }
  }
}

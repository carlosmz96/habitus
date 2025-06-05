import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<String?> obtenerToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('jwt_token');
}

String? obtenerUsuarioIdDesdeToken(String token) {
  final partes = token.split('.');
  if (partes.length != 3) return null;

  final payload = json.decode(
    utf8.decode(base64Url.decode(base64Url.normalize(partes[1]))),
  );

  final id = payload['id'];
  if (id == null) return null;

  return id.toString(); // convierte a String
}

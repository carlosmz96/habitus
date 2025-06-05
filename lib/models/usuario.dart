import 'package:habitus/models/estadisticas.dart';
import 'package:habitus/models/habito.dart';

class Usuario {
  final int id;
  final String nombre;
  final String email;
  final String password;
  final String imagenPerfil;
  final bool activo;
  final List<Habito> habitos;
  final Estadisticas? estadisticas;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.password,
    required this.imagenPerfil,
    required this.activo,
    required this.habitos,
    this.estadisticas,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      password: json['password'],
      imagenPerfil: json['imagenPerfil'],
      activo: json['activo'],
      habitos: (json['habitos'] as List<dynamic>)
          .map((h) => Habito.fromJson(h))
          .toList(),
      estadisticas: json['estadisticas'] != null
          ? Estadisticas.fromJson(json['estadisticas'])
          : null,
    );
  }
}

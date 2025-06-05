import 'package:habitus/models/gamificacion.dart';
import 'package:habitus/models/usuario.dart';

class Estadisticas {
  final int id;
  final int habitosActivos;
  final int habitosCompletados;
  final int rachaActual;
  final int rachaMaxima;
  final List<int> cumplimientoSemanal;
  final Gamificacion? gamificacion;
  final Usuario? usuario;

  Estadisticas({
    required this.id,
    required this.habitosActivos,
    required this.habitosCompletados,
    required this.rachaActual,
    required this.rachaMaxima,
    required this.cumplimientoSemanal,
    this.gamificacion,
    this.usuario,
  });

  factory Estadisticas.fromJson(Map<String, dynamic> json) {
    return Estadisticas(
      id: json['id'],
      habitosActivos: json['habitosActivos'],
      habitosCompletados: json['habitosCompletados'],
      rachaActual: json['rachaActual'],
      rachaMaxima: json['rachaMaxima'],
      cumplimientoSemanal: List<int>.from(json['cumplimientoSemanal']),
      gamificacion: json['gamificacion'] != null
          ? Gamificacion.fromJson(json['gamificacion'])
          : null,
      usuario: json['usuario'] != null
          ? Usuario.fromJson(json['usuario'])
          : null,
    );
  }
}

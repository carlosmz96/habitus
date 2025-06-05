class Habito {
  final int? id;
  final String nombre;
  bool sugerido;
  bool completadoHoy;

  Habito({
    this.id,
    required this.nombre,
    this.sugerido = false,
    this.completadoHoy = false,
  });

  factory Habito.fromJson(Map<String, dynamic> json) {
    return Habito(
      id: json['id'],
      nombre: json['nombre'],
      sugerido: json['sugerido'],
      completadoHoy: json['completadoHoy'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'sugerido': sugerido,
      'completadoHoy': completadoHoy,
    };
  }

  Habito copyWith({
    int? id,
    String? nombre,
    bool? sugerido,
    bool? completadoHoy,
  }) {
    return Habito(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      sugerido: sugerido ?? this.sugerido,
      completadoHoy: completadoHoy ?? this.completadoHoy,
    );
  }
}

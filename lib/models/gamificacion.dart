class Gamificacion {
  final int experienciaTotal;
  final int nivelActual;
  final List<String> logrosDesbloqueados;

  Gamificacion({
    required this.experienciaTotal,
    required this.nivelActual,
    required this.logrosDesbloqueados,
  });

  factory Gamificacion.fromJson(Map<String, dynamic> json) {
    return Gamificacion(
      experienciaTotal: json['experienciaTotal'] ?? 0,
      nivelActual: json['nivelActual'] ?? 0,
      logrosDesbloqueados: List<String>.from(json['logrosDesbloqueados'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experienciaTotal': experienciaTotal,
      'nivelActual': nivelActual,
      'logrosDesbloqueados': logrosDesbloqueados,
    };
  }
}

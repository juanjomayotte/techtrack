class EstadoDispositivo {
  final int idEstadoDispositivo;
  final String nombreEstadoDispositivo;
  final String? descripcionEstadoDispositivo;
  final int? estadoDispositivoCreadoPorId;

  EstadoDispositivo({
    required this.idEstadoDispositivo,
    required this.nombreEstadoDispositivo,
    this.descripcionEstadoDispositivo,
    this.estadoDispositivoCreadoPorId,
  });

  factory EstadoDispositivo.fromJson(Map<String, dynamic> json) {
    return EstadoDispositivo(
      idEstadoDispositivo: json['idEstadoDispositivo'] ?? 0,
      nombreEstadoDispositivo: json['nombreEstadoDispositivo'] ?? '',
      descripcionEstadoDispositivo: json['descripcionEstadoDispositivo'],
      estadoDispositivoCreadoPorId: json['estadoDispositivoCreadoPorId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idEstadoDispositivo': idEstadoDispositivo,
    'nombreEstadoDispositivo': nombreEstadoDispositivo,
    'descripcionEstadoDispositivo': descripcionEstadoDispositivo,
    'estadoDispositivoCreadoPorId': estadoDispositivoCreadoPorId,
  };
}
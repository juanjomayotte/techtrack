// models/TipoDispositivo.dart
class TipoDispositivo {
  final int idTipoDispositivo;
  final String nombreTipoDispositivo;
  final String? descripcionTipoDispositivo;
  final int? tipoDispositivoCreadoPorId;

  TipoDispositivo({
    required this.idTipoDispositivo,
    required this.nombreTipoDispositivo,
    this.descripcionTipoDispositivo,
    this.tipoDispositivoCreadoPorId,
  });

  factory TipoDispositivo.fromJson(Map<String, dynamic> json) {
    return TipoDispositivo(
      idTipoDispositivo: json['idTipoDispositivo'] ?? 0,
      nombreTipoDispositivo: json['nombreTipoDispositivo'] ?? '',
      descripcionTipoDispositivo: json['descripcionTipoDispositivo'],
      tipoDispositivoCreadoPorId: json['tipoDispositivoCreadoPorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idTipoDispositivo': idTipoDispositivo,
      'nombreTipoDispositivo': nombreTipoDispositivo,
      'descripcionTipoDispositivo': descripcionTipoDispositivo,
      'tipoDispositivoCreadoPorId': tipoDispositivoCreadoPorId,
    };
  }
}
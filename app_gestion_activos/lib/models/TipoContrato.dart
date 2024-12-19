// lib/models/TipoContrato.dart

class TipoContrato {
  final int idTipoContrato;
  final String nombreTipoContrato;
  final String descripcionTipoContrato;
  final int tipoContratoCreadoPor;

  TipoContrato({
    required this.idTipoContrato,
    required this.nombreTipoContrato,
    required this.descripcionTipoContrato,
    required this.tipoContratoCreadoPor,
  });


  factory TipoContrato.fromJson(Map<String, dynamic> json) {
    return TipoContrato(
      idTipoContrato: json['idTipoContrato'] ?? 0,
      nombreTipoContrato: json['nombreTipoContrato'] ?? '',
      descripcionTipoContrato: json['descripcionTipoContrato'] ?? '',
      tipoContratoCreadoPor: json['tipoContratoCreadoPor'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idTipoContrato': idTipoContrato,
      'nombreTipoContrato': nombreTipoContrato,
      'descripcionTipoContrato': descripcionTipoContrato,
      'tipoContratoCreadoPor': tipoContratoCreadoPor,
    };
  }

  TipoContrato copyWith({
    int? idTipoContrato,
    String? nombreTipoContrato,
    String? descripcionTipoContrato,
    int? tipoContratoCreadoPor,
  }) {
    return TipoContrato(
      idTipoContrato: idTipoContrato ?? this.idTipoContrato,
      nombreTipoContrato: nombreTipoContrato ?? this.nombreTipoContrato,
      descripcionTipoContrato: descripcionTipoContrato ?? this.descripcionTipoContrato,
      tipoContratoCreadoPor: tipoContratoCreadoPor ?? this.tipoContratoCreadoPor,
    );
  }
}
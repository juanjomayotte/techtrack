import 'dart:convert';

class TipoLicencia {
  final int idTipoLicencia;
  final String nombreTipoLicencia;
  final String descripcionTipoLicencia;
  final int tipoLicenciaCreadaPor;

  // Constructor
  TipoLicencia({
    required this.idTipoLicencia,
    required this.nombreTipoLicencia,
    required this.descripcionTipoLicencia,
    required this.tipoLicenciaCreadaPor,
  });

  // Factory method para crear un objeto a partir de un JSON
  factory TipoLicencia.fromJson(Map<String, dynamic> json) {
    if (json['idTipoLicencia'] == null) {
      throw ArgumentError('El campo idTipoLicencia es obligatorio.');
    }
    return TipoLicencia(
      idTipoLicencia: json['idTipoLicencia'],
      nombreTipoLicencia: json['nombreTipoLicencia'] ?? 'Sin nombre',
      descripcionTipoLicencia: json['descripcionTipoLicencia'] ?? 'Sin descripción',
      tipoLicenciaCreadaPor: json['tipoLicenciaCreadaPor'] ?? 0,
    );
  }

  // Método para convertir un objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'idTipoLicencia': idTipoLicencia,
      'nombreTipoLicencia': nombreTipoLicencia,
      'descripcionTipoLicencia': descripcionTipoLicencia,
      'tipoLicenciaCreadaPor': tipoLicenciaCreadaPor,
    };
  }

  // Método para clonar y modificar un objeto
  TipoLicencia copyWith({
    int? idTipoLicencia,
    String? nombreTipoLicencia,
    String? descripcionTipoLicencia,
    int? tipoLicenciaCreadaPor,
  }) {
    return TipoLicencia(
      idTipoLicencia: idTipoLicencia ?? this.idTipoLicencia,
      nombreTipoLicencia: nombreTipoLicencia ?? this.nombreTipoLicencia,
      descripcionTipoLicencia: descripcionTipoLicencia ?? this.descripcionTipoLicencia,
      tipoLicenciaCreadaPor: tipoLicenciaCreadaPor ?? this.tipoLicenciaCreadaPor,
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

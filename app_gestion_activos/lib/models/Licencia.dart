import 'package:app_gestion_activos/models/TipoLicencia.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/TipoSoftware.dart'; // Importación de TipoSoftware

class Licencia {
  int idLicencia;
  String nombreLicencia;
  String? descripcionLicencia;
  int tipoLicenciaId;
  TipoLicencia? tipoLicencia;
  int? tipoSoftwareId; // Nuevo campo
  TipoSoftware? tipoSoftware; // Nueva referencia
  DateTime fechaInicio;
  DateTime fechaExpiracion;
  String estadoLicencia;
  int? maximoUsuarios;
  int softwareId;
  Software? software;

  Licencia({
    required this.idLicencia,
    required this.nombreLicencia,
    this.descripcionLicencia,
    required this.tipoLicenciaId,
    this.tipoLicencia,
    this.tipoSoftwareId,
    this.tipoSoftware,
    required this.fechaInicio,
    required this.fechaExpiracion,
    required this.estadoLicencia,
    this.maximoUsuarios,
    required this.softwareId,
    this.software,
  });

  factory Licencia.fromJson(Map<String, dynamic> json) {
    return Licencia(
      idLicencia: json['idLicencia'],
      nombreLicencia: json['nombreLicencia'],
      descripcionLicencia: json['descripcionLicencia'],
      tipoLicenciaId: json['tipoLicenciaId'],
      tipoLicencia: json['tipoLicencia'] != null ? TipoLicencia.fromJson(json['tipoLicencia']) : null,
      tipoSoftwareId: json['tipoSoftwareId'],
      tipoSoftware: json['tipoSoftware'] != null ? TipoSoftware.fromJson(json['tipoSoftware']) : null,
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion']),
      estadoLicencia: json['estadoLicencia'],
      maximoUsuarios: json['maximoUsuarios'],
      softwareId: json['softwareId'],
      software: json['software'] != null ? Software.fromJson(json['software']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idLicencia': idLicencia,
      'nombreLicencia': nombreLicencia,
      'descripcionLicencia': descripcionLicencia,
      'tipoLicenciaId': tipoLicenciaId,
      'tipoSoftwareId': tipoSoftwareId,
      'fechaInicio': fechaInicio.toIso8601String().split('T')[0],
      'fechaExpiracion': fechaExpiracion.toIso8601String().split('T')[0],
      'estadoLicencia': estadoLicencia,
      'maximoUsuarios': maximoUsuarios,
      'softwareId': softwareId,
    };
  }

  @override
  String toString() {
    return 'Licencia{idLicencia: $idLicencia, nombreLicencia: $nombreLicencia, descripcionLicencia: $descripcionLicencia, tipoLicenciaId: $tipoLicenciaId, tipoSoftwareId: $tipoSoftwareId, fechaInicio: $fechaInicio, fechaExpiracion: $fechaExpiracion, estadoLicencia: $estadoLicencia, maximoUsuarios: $maximoUsuarios, softwareId: $softwareId}';
  }

  Licencia copyWith({
    int? idLicencia,
    String? nombreLicencia,
    String? descripcionLicencia,
    int? tipoLicenciaId,
    TipoLicencia? tipoLicencia,
    int? tipoSoftwareId,
    TipoSoftware? tipoSoftware,
    DateTime? fechaInicio,
    DateTime? fechaExpiracion,
    String? estadoLicencia,
    int? maximoUsuarios,
    int? softwareId,
    Software? software,
  }) {
    return Licencia(
      idLicencia: idLicencia ?? this.idLicencia,
      nombreLicencia: nombreLicencia ?? this.nombreLicencia,
      descripcionLicencia: descripcionLicencia ?? this.descripcionLicencia,
      tipoLicenciaId: tipoLicenciaId ?? this.tipoLicenciaId,
      tipoLicencia: tipoLicencia ?? this.tipoLicencia,
      tipoSoftwareId: tipoSoftwareId ?? this.tipoSoftwareId,
      tipoSoftware: tipoSoftware ?? this.tipoSoftware,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      estadoLicencia: estadoLicencia ?? this.estadoLicencia,
      maximoUsuarios: maximoUsuarios ?? this.maximoUsuarios,
      softwareId: softwareId ?? this.softwareId,
      software: software ?? this.software,
    );
  }
}

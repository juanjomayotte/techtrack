import 'package:app_gestion_activos/models/TipoSoftware.dart';

class Software {
  final int idSoftware;
  final String nombreSoftware;
  final String versionSoftware;
  final int? tipoSoftwareId;
  final TipoSoftware? tipoSoftware;
  final bool requiereActualizacion;
  final bool estaEnListaNegra;
  final int? licenciaVinculadaSoftwareId;
  final int? contratoVinculadoSoftwareId;
  final int? softwareCreadoPorId;

  Software({
    required this.idSoftware,
    required this.nombreSoftware,
    required this.versionSoftware,
    this.tipoSoftwareId,
    this.tipoSoftware,
    required this.requiereActualizacion,
    required this.estaEnListaNegra,
    this.licenciaVinculadaSoftwareId,
    this.contratoVinculadoSoftwareId,
    this.softwareCreadoPorId,
  });

  factory Software.fromJson(Map<String, dynamic> json) {
    return Software(
      idSoftware: json['idSoftware'] ?? 0,
      nombreSoftware: json['nombreSoftware'] ?? '',
      versionSoftware: json['versionSoftware'] ?? '',
      tipoSoftwareId: json['tipoSoftwareId'],
      requiereActualizacion: json['requiereActualizacion'] ?? false,
      estaEnListaNegra: json['estaEnListaNegra'] ?? false,
      licenciaVinculadaSoftwareId: json['licenciaVinculadaSoftwareId'],
      contratoVinculadoSoftwareId: json['contratoVinculadoSoftwareId'],
      softwareCreadoPorId: json['softwareCreadoPorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idSoftware': idSoftware,
      'nombreSoftware': nombreSoftware,
      'versionSoftware': versionSoftware,
      'tipoSoftwareId': tipoSoftwareId,
      'requiereActualizacion': requiereActualizacion,
      'estaEnListaNegra': estaEnListaNegra,
      'licenciaVinculadaSoftwareId': licenciaVinculadaSoftwareId,
      'contratoVinculadoSoftwareId': contratoVinculadoSoftwareId,
      'softwareCreadoPorId': softwareCreadoPorId,
    };
  }

  Software copyWith({
    int? idSoftware,
    String? nombreSoftware,
    String? versionSoftware,
    int? tipoSoftwareId,
    TipoSoftware? tipoSoftware,
    bool? requiereActualizacion,
    bool? estaEnListaNegra,
    int? licenciaVinculadaSoftwareId,
    int? contratoVinculadoSoftwareId,
    int? softwareCreadoPorId,
  }) {
    return Software(
      idSoftware: idSoftware ?? this.idSoftware,
      nombreSoftware: nombreSoftware ?? this.nombreSoftware,
      versionSoftware: versionSoftware ?? this.versionSoftware,
      tipoSoftwareId: tipoSoftwareId ?? this.tipoSoftwareId,
      tipoSoftware: tipoSoftware ?? this.tipoSoftware,
      requiereActualizacion: requiereActualizacion ?? this.requiereActualizacion,
      estaEnListaNegra: estaEnListaNegra ?? this.estaEnListaNegra,
      licenciaVinculadaSoftwareId: licenciaVinculadaSoftwareId ?? this.licenciaVinculadaSoftwareId,
      contratoVinculadoSoftwareId: contratoVinculadoSoftwareId ?? this.contratoVinculadoSoftwareId,
      softwareCreadoPorId: softwareCreadoPorId ?? this.softwareCreadoPorId,
    );
  }
}
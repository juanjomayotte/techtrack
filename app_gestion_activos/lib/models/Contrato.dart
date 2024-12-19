// lib/models/contrato.dart
import 'package:app_gestion_activos/models/TipoContrato.dart';

class Contrato {
  final int idContrato;
  final String nombreContrato;
  final String? descripcionContrato;
  final int tipoContratoId;
  final TipoContrato? tipoContrato; // Added optional type contract
  final DateTime fechaInicio;
  final DateTime fechaExpiracion;
  final String proveedor;
  final String? terminosGenerales;
  final String estadoContrato;
  final int ContratoCreadoPor;

  Contrato({
    required this.idContrato,
    required this.nombreContrato,
    this.descripcionContrato,
    required this.tipoContratoId,
    this.tipoContrato,
    required this.fechaInicio,
    required this.fechaExpiracion,
    required this.proveedor,
    this.terminosGenerales,
    required this.estadoContrato,
    required this.ContratoCreadoPor,
  });

  factory Contrato.fromJson(Map<String, dynamic> json) {
    return Contrato(
      idContrato: json['idContrato'] ?? 0,
      nombreContrato: json['nombreContrato'] ?? '',
      descripcionContrato: json['descripcionContrato'],
      tipoContratoId: json['tipoContratoId'] ?? 0,
      tipoContrato: json['tipoContrato'] != null ? TipoContrato.fromJson(json['tipoContrato']) : null,
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaExpiracion: DateTime.parse(json['fechaExpiracion']),
      proveedor: json['proveedor'] ?? '',
      terminosGenerales: json['terminosGenerales'],
      estadoContrato: json['EstadoContrato'] ?? '',
      ContratoCreadoPor: json['ContratoCreadoPor'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idContrato': idContrato,
      'nombreContrato': nombreContrato,
      'descripcionContrato': descripcionContrato,
      'tipoContratoId': tipoContratoId,
      'fechaInicio': fechaInicio.toIso8601String().split('T')[0],
      'fechaExpiracion': fechaExpiracion.toIso8601String().split('T')[0],
      'proveedor': proveedor,
      'terminosGenerales': terminosGenerales,
      'estadoContrato': estadoContrato,
      'ContratoCreadoPor': ContratoCreadoPor,
    };
  }

  Contrato copyWith({
    int? idContrato,
    String? nombreContrato,
    String? descripcionContrato,
    int? tipoContratoId,
    TipoContrato? tipoContrato,
    DateTime? fechaInicio,
    DateTime? fechaExpiracion,
    String? proveedor,
    String? terminosGenerales,
    String? estadoContrato,
    int? ContratoCreadoPor,
  }) {
    return Contrato(
      idContrato: idContrato ?? this.idContrato,
      nombreContrato: nombreContrato ?? this.nombreContrato,
      descripcionContrato: descripcionContrato ?? this.descripcionContrato,
      tipoContratoId: tipoContratoId ?? this.tipoContratoId,
      tipoContrato: tipoContrato ?? this.tipoContrato,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaExpiracion: fechaExpiracion ?? this.fechaExpiracion,
      proveedor: proveedor ?? this.proveedor,
      terminosGenerales: terminosGenerales ?? this.terminosGenerales,
      estadoContrato: estadoContrato ?? this.estadoContrato,
      ContratoCreadoPor: ContratoCreadoPor ?? this.ContratoCreadoPor,
    );
  }
}
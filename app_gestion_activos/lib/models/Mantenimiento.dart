//models/Mantenimiento.dart

import 'package:app_gestion_activos/models/Dispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';

class Mantenimiento {
  final int idMantenimiento;
  final String? descripcionMantenimiento;
  final String situacionMantenimiento;
  final String prioridadMantenimiento;
  final String? observacionesMantenimiento;
  final int? softwareAsociadoMantenimientoId;
  final int? dispositivoAsociadoMantenimientoId;
  final int? mantenimientoCreadoPorId;
  final Dispositivo? dispositivoAsociado;
  final Software? softwareAsociado;

  Mantenimiento({
    required this.idMantenimiento,
    this.descripcionMantenimiento,
    required this.situacionMantenimiento,
    required this.prioridadMantenimiento,
    this.observacionesMantenimiento,
    this.softwareAsociadoMantenimientoId,
    this.dispositivoAsociadoMantenimientoId,
    this.mantenimientoCreadoPorId,
    this.dispositivoAsociado,
    this.softwareAsociado
  });

  factory Mantenimiento.fromJson(Map<String, dynamic> json) {
    return Mantenimiento(
      idMantenimiento: json['idMantenimiento'] ?? 0,
      descripcionMantenimiento: json['descripcionMantenimiento'],
      situacionMantenimiento: json['situacionMantenimiento'] ?? '',
      prioridadMantenimiento: json['prioridadMantenimiento'] ?? '',
      observacionesMantenimiento: json['observacionesMantenimiento'],
      softwareAsociadoMantenimientoId: json['softwareAsociadoMantenimientoId'],
      dispositivoAsociadoMantenimientoId: json['dispositivoAsociadoMantenimientoId'],
      mantenimientoCreadoPorId: json['mantenimientoCreadoPorId'],
      dispositivoAsociado: json['dispositivo'] != null
          ? Dispositivo.fromJson(json['dispositivo'])
          : null,
      softwareAsociado: json['software'] != null
          ? Software.fromJson(json['software'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'idMantenimiento': idMantenimiento,
    'descripcionMantenimiento': descripcionMantenimiento,
    'situacionMantenimiento': situacionMantenimiento,
    'prioridadMantenimiento': prioridadMantenimiento,
    'observacionesMantenimiento': observacionesMantenimiento,
    'softwareAsociadoMantenimientoId': softwareAsociadoMantenimientoId,
    'dispositivoAsociadoMantenimientoId': dispositivoAsociadoMantenimientoId,
    'mantenimientoCreadoPorId': mantenimientoCreadoPorId,
  };
  Mantenimiento copyWith({
    int? idMantenimiento,
    String? descripcionMantenimiento,
    String? situacionMantenimiento,
    String? prioridadMantenimiento,
    String? observacionesMantenimiento,
    int? softwareAsociadoMantenimientoId,
    int? dispositivoAsociadoMantenimientoId,
    int? mantenimientoCreadoPorId,
    Dispositivo? dispositivoAsociado,
    Software? softwareAsociado,
  }) {
    return Mantenimiento(
      idMantenimiento: idMantenimiento ?? this.idMantenimiento,
      descripcionMantenimiento: descripcionMantenimiento ?? this.descripcionMantenimiento,
      situacionMantenimiento: situacionMantenimiento ?? this.situacionMantenimiento,
      prioridadMantenimiento: prioridadMantenimiento ?? this.prioridadMantenimiento,
      observacionesMantenimiento:
      observacionesMantenimiento ?? this.observacionesMantenimiento,
      softwareAsociadoMantenimientoId: softwareAsociadoMantenimientoId ?? this.softwareAsociadoMantenimientoId,
      dispositivoAsociadoMantenimientoId: dispositivoAsociadoMantenimientoId ?? this.dispositivoAsociadoMantenimientoId,
      mantenimientoCreadoPorId: mantenimientoCreadoPorId ?? this.mantenimientoCreadoPorId,
      dispositivoAsociado: dispositivoAsociado ?? this.dispositivoAsociado,
      softwareAsociado: softwareAsociado ?? this.softwareAsociado,
    );
  }
}
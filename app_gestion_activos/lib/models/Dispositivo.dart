import 'package:app_gestion_activos/models/ModeloDispositivo.dart';
import 'package:app_gestion_activos/models/EstadoDispositivo.dart';
import 'package:app_gestion_activos/models/Software.dart';
import 'package:app_gestion_activos/models/Usuario.dart';
import 'package:app_gestion_activos/models/TipoDispositivo.dart';

class Dispositivo {
  final int idDispositivo;
  final String numeroSerieDispositivo;
  final String? ubicacionDispositivo;
  final DateTime? fechaAdquisicionDispositivo; // Mantén este campo
  final int? modeloDispositivoId;
  final ModeloDispositivo? modeloDispositivo;
  final int? estadoDispositivoId;
  final EstadoDispositivo? estadoDispositivo;
  final int? softwareInstaladoId;
  final Software? softwareInstalado;
  final int? usuarioAsignadoId;
  final Usuario? usuarioAsignado;
  final int? dispositivoCreadoPorId;
  final TipoDispositivo? tipoDispositivo;

  Dispositivo({
    required this.idDispositivo,
    required this.numeroSerieDispositivo,
    this.ubicacionDispositivo,
    this.fechaAdquisicionDispositivo,
    this.modeloDispositivoId,
    this.modeloDispositivo,
    this.estadoDispositivoId,
    this.estadoDispositivo,
    this.softwareInstaladoId,
    this.softwareInstalado,
    this.usuarioAsignadoId,
    this.usuarioAsignado,
    this.dispositivoCreadoPorId,
    this.tipoDispositivo
  });

  Dispositivo copyWith({
    int? idDispositivo,
    String? numeroSerieDispositivo,
    String? ubicacionDispositivo,
    DateTime? fechaAdquisicionDispositivo,
    int? modeloDispositivoId,
    ModeloDispositivo? modeloDispositivo,
    int? estadoDispositivoId,
    EstadoDispositivo? estadoDispositivo,
    int? softwareInstaladoId,
    Software? softwareInstalado,
    int? usuarioAsignadoId,
    Usuario? usuarioAsignado,
    int? dispositivoCreadoPorId,
    TipoDispositivo? tipoDispositivo,
  }) {
    return Dispositivo(
        idDispositivo: idDispositivo ?? this.idDispositivo,
        numeroSerieDispositivo: numeroSerieDispositivo ?? this.numeroSerieDispositivo,
        ubicacionDispositivo: ubicacionDispositivo ?? this.ubicacionDispositivo,
        fechaAdquisicionDispositivo: fechaAdquisicionDispositivo ?? this.fechaAdquisicionDispositivo,
        modeloDispositivoId: modeloDispositivoId ?? this.modeloDispositivoId,
        modeloDispositivo: modeloDispositivo ?? this.modeloDispositivo,
        estadoDispositivoId: estadoDispositivoId ?? this.estadoDispositivoId,
        estadoDispositivo: estadoDispositivo ?? this.estadoDispositivo,
        softwareInstaladoId: softwareInstaladoId ?? this.softwareInstaladoId,
        softwareInstalado: softwareInstalado ?? this.softwareInstalado,
        usuarioAsignadoId: usuarioAsignadoId ?? this.usuarioAsignadoId,
        usuarioAsignado: usuarioAsignado ?? this.usuarioAsignado,
        dispositivoCreadoPorId: dispositivoCreadoPorId ?? this.dispositivoCreadoPorId,
        tipoDispositivo: tipoDispositivo ?? this.tipoDispositivo
    );
  }

  factory Dispositivo.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;

    if (json['createdAt'] != null){
      parsedDate = DateTime.tryParse(json['createdAt']);
    }
    return Dispositivo(
      idDispositivo: json['idDispositivo'] ?? 0,
      numeroSerieDispositivo: json['numeroSerieDispositivo'] ?? 'Desconocido',
      ubicacionDispositivo: json['ubicacionDispositivo'] ?? 'No especificada',
      fechaAdquisicionDispositivo: parsedDate, // Use createdAt
      modeloDispositivoId: json['modeloDispositivoId'],
      modeloDispositivo: json['modeloDispositivo'] != null
          ? ModeloDispositivo.fromJson(json['modeloDispositivo'])
          : null,
      estadoDispositivoId: json['estadoDispositivoId'],
      estadoDispositivo: json['estadoDispositivo'] != null
          ? EstadoDispositivo.fromJson(json['estadoDispositivo'])
          : null,
      softwareInstaladoId: json['softwareInstaladoId'],
      softwareInstalado: json['softwareInstalado'] != null
          ? Software.fromJson(json['softwareInstalado'])
          : null,
      usuarioAsignadoId: json['usuarioAsignadoId'],
      usuarioAsignado: json['usuarioAsignado'] != null
          ? Usuario.fromJson(json['usuarioAsignado'])
          : null,
      dispositivoCreadoPorId: json['dispositivoCreadoPorId'] ?? 0,
      tipoDispositivo: json['tipoDispositivo'] != null
          ? TipoDispositivo.fromJson(json['tipoDispositivo'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDispositivo': idDispositivo,
      'numeroSerieDispositivo': numeroSerieDispositivo,
      'ubicacionDispositivo': ubicacionDispositivo,
      'modeloDispositivoId': modeloDispositivoId,
      'estadoDispositivoId': estadoDispositivoId,
      'softwareInstaladoId': softwareInstaladoId,
      'usuarioAsignadoId': usuarioAsignadoId,
      'dispositivoCreadoPorId': dispositivoCreadoPorId,
    };
  }
}
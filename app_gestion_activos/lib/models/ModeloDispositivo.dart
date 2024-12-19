// models/modeloDispositivo.dart
import 'package:app_gestion_activos/models/TipoDispositivo.dart';

class ModeloDispositivo {
  final int idModeloDispositivo;
  final String nombreModeloDispositivo;
  final String marca;
  final String? descripcionModeloDispositivo;
  final int cantidadEnInventario;
  final int? tipoDispositivoId;
  final TipoDispositivo? tipoDispositivo;
  final int? modeloDispositivoCreadoPorId;

  ModeloDispositivo({
    required this.idModeloDispositivo,
    required this.nombreModeloDispositivo,
    required this.marca,
    this.descripcionModeloDispositivo,
    required this.cantidadEnInventario,
    this.tipoDispositivoId,
    this.tipoDispositivo,
    this.modeloDispositivoCreadoPorId,
  });

  factory ModeloDispositivo.fromJson(Map<String, dynamic> json) {
    return ModeloDispositivo(
      idModeloDispositivo: json['idModeloDispositivo'] ?? 0,
      nombreModeloDispositivo: json['nombreModeloDispositivo'] ?? '',
      marca: json['marca'] ?? '',
      descripcionModeloDispositivo: json['descripcionModeloDispositivo'],
      cantidadEnInventario: json['cantidadEnInventario'] ?? 0,
      tipoDispositivoId: json['tipoDispositivoId'],
      tipoDispositivo: json['tipoDispositivo'] != null
          ? TipoDispositivo.fromJson(json['tipoDispositivo'])
          : null,
      modeloDispositivoCreadoPorId: json['modeloDispositivoCreadoPorId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idModeloDispositivo': idModeloDispositivo,
      'nombreModeloDispositivo': nombreModeloDispositivo,
      'marca': marca,
      'descripcionModeloDispositivo': descripcionModeloDispositivo,
      'cantidadEnInventario': cantidadEnInventario,
      'tipoDispositivoId': tipoDispositivoId,
      'modeloDispositivoCreadoPorId': modeloDispositivoCreadoPorId,
    };
  }


  ModeloDispositivo copyWith({
    int? idModeloDispositivo,
    String? nombreModeloDispositivo,
    String? marca,
    String? descripcionModeloDispositivo,
    int? cantidadEnInventario,
    int? tipoDispositivoId,
    TipoDispositivo? tipoDispositivo,
    int? modeloDispositivoCreadoPorId,
  }) {
    return ModeloDispositivo(
      idModeloDispositivo: idModeloDispositivo ?? this.idModeloDispositivo,
      nombreModeloDispositivo: nombreModeloDispositivo ?? this.nombreModeloDispositivo,
      marca: marca ?? this.marca,
      descripcionModeloDispositivo:
      descripcionModeloDispositivo ?? this.descripcionModeloDispositivo,
      cantidadEnInventario: cantidadEnInventario ?? this.cantidadEnInventario,
      tipoDispositivoId: tipoDispositivoId ?? this.tipoDispositivoId,
      tipoDispositivo: tipoDispositivo ?? this.tipoDispositivo,
      modeloDispositivoCreadoPorId: modeloDispositivoCreadoPorId ?? this.modeloDispositivoCreadoPorId,
    );
  }
}
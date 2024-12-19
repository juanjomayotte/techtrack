//models/TipoSoftware.dart

class TipoSoftware {
  final int idTipoSoftware;
  final String nombreTipoSoftware;
  final String? descripcionTipoSoftware;
  final int? tipoSoftwareCreadoPorId;

  TipoSoftware({
    required this.idTipoSoftware,
    required this.nombreTipoSoftware,
    this.descripcionTipoSoftware,
    this.tipoSoftwareCreadoPorId,
  });

  factory TipoSoftware.fromJson(Map<String, dynamic> json) {
    return TipoSoftware(
      idTipoSoftware: json['idTipoSoftware'] ?? 0,
      nombreTipoSoftware: json['nombreTipoSoftware'] ?? '',
      descripcionTipoSoftware: json['descripcionTipoSoftware'],
      tipoSoftwareCreadoPorId: json['tipoSoftwareCreadoPorId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'idTipoSoftware': idTipoSoftware,
    'nombreTipoSoftware': nombreTipoSoftware,
    'descripcionTipoSoftware': descripcionTipoSoftware,
    'tipoSoftwareCreadoPorId': tipoSoftwareCreadoPorId,
  };

  TipoSoftware copyWith({
    int? idTipoSoftware,
    String? nombreTipoSoftware,
    String? descripcionTipoSoftware,
    int? tipoSoftwareCreadoPorId
  }) {
    return TipoSoftware(
      idTipoSoftware: idTipoSoftware ?? this.idTipoSoftware,
      nombreTipoSoftware: nombreTipoSoftware ?? this.nombreTipoSoftware,
      descripcionTipoSoftware: descripcionTipoSoftware ?? this.descripcionTipoSoftware,
      tipoSoftwareCreadoPorId: tipoSoftwareCreadoPorId ?? this.tipoSoftwareCreadoPorId,
    );
  }
}
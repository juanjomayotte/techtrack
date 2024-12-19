import 'Rol.dart';

class Usuario {
  final int idUsuario;
  final String nombreUsuario;
  final String correoElectronicoUsuario;
  final String? passwordUsuario;
  final int rolId;
  final Rol? rol; // Incluye la relación con el Rol

  Usuario({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.correoElectronicoUsuario,
    this.passwordUsuario,
    required this.rolId,
    this.rol,
  });

  // Método para crear una instancia de Usuario a partir de un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'] ?? 0,
      nombreUsuario: json['nombreUsuario'] ?? '',
      correoElectronicoUsuario: json['correoElectronicoUsuario'] ?? '',
      passwordUsuario: json['passwordUsuario'],
      rolId: json['rolId'] ?? 0,
      rol: json['rol'] != null ? Rol.fromJson(json['rol']) : null,
    );
  }

  // Método para convertir una instancia de Usuario a un JSON
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombreUsuario': nombreUsuario,
      'correoElectronicoUsuario': correoElectronicoUsuario,
      'passwordUsuario': passwordUsuario,
      'rolId': rolId,
      'rol': rol?.toJson(),
    };
  }
}

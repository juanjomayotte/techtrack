class Rol {
  final int idRol;
  final String nombreRol;
  final String? descripcionRol;
  final Map<String, bool> permisos;

  Rol({
    required this.idRol,
    required this.nombreRol,
    this.descripcionRol,
    required this.permisos,
  });

  // Método para crear una instancia de Rol a partir de un JSON
  factory Rol.fromJson(Map<String, dynamic> json) {
    // Extraer permisos dinámicamente
    Map<String, bool> permisos = {};
    json.forEach((key, value) {
      if (key.startsWith('permiso')) {
        permisos[key] = value ?? false; // Asegura que el valor sea un bool (si es nulo, asigna false)
      }
    });

    return Rol(
      idRol: json['idRol'] ?? 0, // Valor predeterminado 0 si no está presente
      nombreRol: json['nombreRol'] ?? '', // Valor predeterminado vacío si no está presente
      descripcionRol: json['descripcionRol'], // Puede ser null
      permisos: permisos,
    );
  }

  // Método para convertir una instancia de Rol a un JSON
  Map<String, dynamic> toJson() {
    return {
      'idRol': idRol,
      'nombreRol': nombreRol,
      'descripcionRol': descripcionRol,
      ...permisos, // Incluye todos los permisos en el JSON
    };
  }
}

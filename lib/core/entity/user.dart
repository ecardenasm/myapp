class Usuario {
  final String id;       // Nuevo campo para el ID del usuario
  final String nombre;
  final String correo;
  final String telefono;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.telefono,
  });

  // Método para convertir el objeto Usuario a un mapa (sin la contraseña)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'telefono': telefono,
    };
  }
}



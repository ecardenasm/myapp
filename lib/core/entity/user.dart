class Usuario {
  final String id; // Nuevo campo para el ID del usuario
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

  // Método para crear una instancia de Usuario desde un mapa
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] ?? '', // Asignar un valor vacío si no existe
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      telefono: map['telefono'] ?? '',
    );
  }
}

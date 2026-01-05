class Estudiante {

  const Estudiante({
    this.id,
    required this.nombre,
    required this.apellido,
    this.numeroIdentidad,
    this.telefono,
    this.email,
    this.direccion,
    this.activo = true,
  });

  factory Estudiante.fromMap(Map<String, dynamic> map) => Estudiante(
        id: map['id']?.toInt(),
        nombre: map['nombre'] ?? '',
        apellido: map['apellido'] ?? '',
        numeroIdentidad: map['numero_identidad'],
        telefono: map['telefono'],
        email: map['email'],
        direccion: map['direccion'],
        activo: map['activo'] == 1,
      );
  final int? id;
  final String nombre;
  final String apellido;
  final String? numeroIdentidad;
  final String? telefono;
  final String? email;
  final String? direccion;
  final bool activo;

  Estudiante copyWith({
    int? id,
    String? nombre,
    String? apellido,
    String? numeroIdentidad,
    String? telefono,
    String? email,
    String? direccion,
    bool? activo,
  }) =>
      Estudiante(
        id: id ?? this.id,
        nombre: nombre ?? this.nombre,
        apellido: apellido ?? this.apellido,
        numeroIdentidad: numeroIdentidad ?? this.numeroIdentidad,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
        direccion: direccion ?? this.direccion,
        activo: activo ?? this.activo,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'numero_identidad': numeroIdentidad,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'activo': activo ? 1 : 0,
      };

  String get nombreCompleto => '$nombre $apellido';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Estudiante &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          nombre == other.nombre &&
          apellido == other.apellido &&
          numeroIdentidad == other.numeroIdentidad &&
          telefono == other.telefono &&
          email == other.email &&
          direccion == other.direccion &&
          activo == other.activo;

  @override
  int get hashCode => Object.hash(
        id,
        nombre,
        apellido,
        numeroIdentidad,
        telefono,
        email,
        direccion,
        activo,
      );
}

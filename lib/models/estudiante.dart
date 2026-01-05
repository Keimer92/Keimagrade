class Estudiante {

  const Estudiante({
    this.id,
    required this.estudiante,
    this.numeroIdentidad,
    this.telefono,
    this.email,
    this.direccion,
    this.sexo,
    this.activo = true,
  });

  factory Estudiante.fromMap(Map<String, dynamic> map) => Estudiante(
        id: map['id']?.toInt(),
        estudiante: map['estudiante'] ?? '',
        numeroIdentidad: map['numero_identidad'],
        telefono: map['telefono'],
        email: map['email'],
        direccion: map['direccion'],
        sexo: map['sexo'],
        activo: map['activo'] == 1,
      );
  final int? id;
  final String estudiante;
  final String? numeroIdentidad;
  final String? telefono;
  final String? email;
  final String? direccion;
  final String? sexo;
  final bool activo;

  Estudiante copyWith({
    int? id,
    String? estudiante,
    String? numeroIdentidad,
    String? telefono,
    String? email,
    String? direccion,
    String? sexo,
    bool? activo,
  }) =>
      Estudiante(
        id: id ?? this.id,
        estudiante: estudiante ?? this.estudiante,
        numeroIdentidad: numeroIdentidad ?? this.numeroIdentidad,
        telefono: telefono ?? this.telefono,
        email: email ?? this.email,
        direccion: direccion ?? this.direccion,
        sexo: sexo ?? this.sexo,
        activo: activo ?? this.activo,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'estudiante': estudiante,
        'numero_identidad': numeroIdentidad,
        'telefono': telefono,
        'email': email,
        'direccion': direccion,
        'sexo': sexo,
        'activo': activo ? 1 : 0,
      };

  String get nombreCompleto => estudiante;

  // Getters para compatibilidad hacia atrás
  String get nombre => estudiante.split(' ').first;
  String get apellido => estudiante.split(' ').skip(1).join(' ');

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
          sexo == other.sexo &&
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
        sexo,
        activo,
      );
}

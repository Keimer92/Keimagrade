class Colegio {

  Colegio({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.director,
    this.activo = true,
  });

  factory Colegio.fromMap(Map<String, dynamic> map) => Colegio(
      id: map['id'],
      nombre: map['nombre'],
      direccion: map['direccion'],
      telefono: map['telefono'],
      email: map['email'],
      director: map['director'],
      activo: map['activo'] == 1,
    );
  final int? id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;
  final String director;
  final bool activo;

  Map<String, dynamic> toMap() => {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'email': email,
      'director': director,
      'activo': activo ? 1 : 0,
    };

  Colegio copyWith({
    int? id,
    String? nombre,
    String? direccion,
    String? telefono,
    String? email,
    String? director,
    bool? activo,
  }) => Colegio(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      director: director ?? this.director,
      activo: activo ?? this.activo,
    );
}

class Seccion {

  Seccion({
    this.id,
    required this.letra,
    this.activo = true,
  });

  factory Seccion.fromMap(Map<String, dynamic> map) => Seccion(
      id: map['id'],
      letra: map['letra'],
      activo: map['activo'] == 1,
    );
  final int? id;
  final String letra;
  final bool activo;

  Map<String, dynamic> toMap() => {
      'id': id,
      'letra': letra,
      'activo': activo ? 1 : 0,
    };

  Seccion copyWith({
    int? id,
    String? letra,
    bool? activo,
  }) => Seccion(
      id: id ?? this.id,
      letra: letra ?? this.letra,
      activo: activo ?? this.activo,
    );
}

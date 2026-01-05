class Grado {

  Grado({
    this.id,
    required this.numero,
    required this.nombre,
    this.activo = true,
    this.cualitativo = false,
  });

  factory Grado.fromMap(Map<String, dynamic> map) => Grado(
      id: map['id'],
      numero: map['numero'],
      nombre: map['nombre'],
      activo: map['activo'] == 1,
      cualitativo: map['cualitativo'] == 1,
    );
  final int? id;
  final int numero;
  final String nombre;
  final bool activo;
  final bool cualitativo;

  Map<String, dynamic> toMap() => {
      'id': id,
      'numero': numero,
      'nombre': nombre,
      'activo': activo ? 1 : 0,
      'cualitativo': cualitativo ? 1 : 0,
    };

  Grado copyWith({
    int? id,
    int? numero,
    String? nombre,
    bool? activo,
    bool? cualitativo,
  }) => Grado(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      nombre: nombre ?? this.nombre,
      activo: activo ?? this.activo,
      cualitativo: cualitativo ?? this.cualitativo,
    );
}

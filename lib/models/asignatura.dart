class Asignatura {

  Asignatura({
    this.id,
    required this.nombre,
    required this.codigo,
    this.horas = 0,
    this.activo = true,
    this.cualitativo = false,
  });

  factory Asignatura.fromMap(Map<String, dynamic> map) => Asignatura(
      id: map['id'],
      nombre: map['nombre'],
      codigo: map['codigo'],
      horas: map['horas'],
      activo: map['activo'] == 1,
      cualitativo: map['cualitativo'] == 1,
    );
  final int? id;
  final String nombre;
  final String codigo;
  final int horas;
  final bool activo;
  final bool cualitativo;

  Map<String, dynamic> toMap() => {
      'id': id,
      'nombre': nombre,
      'codigo': codigo,
      'horas': horas,
      'activo': activo ? 1 : 0,
      'cualitativo': cualitativo ? 1 : 0,
    };

  Asignatura copyWith({
    int? id,
    String? nombre,
    String? codigo,
    int? horas,
    bool? activo,
    bool? cualitativo,
  }) => Asignatura(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      codigo: codigo ?? this.codigo,
      horas: horas ?? this.horas,
      activo: activo ?? this.activo,
      cualitativo: cualitativo ?? this.cualitativo,
    );
}

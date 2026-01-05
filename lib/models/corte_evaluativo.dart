class CorteEvaluativo {

  CorteEvaluativo({
    required this.id,
    required this.numero,
    required this.nombre,
    required this.puntosTotales,
    required this.activo,
  });

  factory CorteEvaluativo.fromMap(Map<String, dynamic> map) => CorteEvaluativo(
        id: map['id'],
        numero: map['numero'],
        nombre: map['nombre'],
        puntosTotales: map['puntosTotales'],
        activo: map['activo'] == 1,
      );
  final int id;
  final int numero;
  final String nombre;
  final int puntosTotales;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'id': id,
        'numero': numero,
        'nombre': nombre,
        'puntosTotales': puntosTotales,
        'activo': activo ? 1 : 0,
      };

  CorteEvaluativo copyWith({
    int? id,
    int? numero,
    String? nombre,
    int? puntosTotales,
    bool? activo,
  }) =>
      CorteEvaluativo(
        id: id ?? this.id,
        numero: numero ?? this.numero,
        nombre: nombre ?? this.nombre,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
      );
}

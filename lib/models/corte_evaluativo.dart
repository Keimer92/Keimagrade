class CorteEvaluativo {

  CorteEvaluativo({
    this.id,
    required this.anioLectivoId,
    required this.numero,
    required this.nombre,
    required this.puntosTotales,
    required this.activo,
  });

  factory CorteEvaluativo.fromMap(Map<String, dynamic> map) => CorteEvaluativo(
        id: map['id'],
        anioLectivoId: map['anio_lectivo_id'],
        numero: map['numero'],
        nombre: map['nombre'],
        puntosTotales: map['puntosTotales'],
        activo: map['activo'] == 1,
      );
  final int? id;
  final int anioLectivoId;
  final int numero;
  final String nombre;
  final int puntosTotales;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'id': id,
        'anio_lectivo_id': anioLectivoId,
        'numero': numero,
        'nombre': nombre,
        'puntosTotales': puntosTotales,
        'activo': activo ? 1 : 0,
      };

  CorteEvaluativo copyWith({
    int? id,
    int? anioLectivoId,
    int? numero,
    String? nombre,
    int? puntosTotales,
    bool? activo,
  }) =>
      CorteEvaluativo(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        numero: numero ?? this.numero,
        nombre: nombre ?? this.nombre,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
      );
}

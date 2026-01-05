class IndicadorEvaluacion {

  IndicadorEvaluacion({
    required this.id,
    required this.corteId,
    required this.numero,
    required this.descripcion,
    required this.puntosTotales,
    required this.activo,
  });

  factory IndicadorEvaluacion.fromMap(Map<String, dynamic> map) =>
      IndicadorEvaluacion(
        id: map['id'],
        corteId: map['corteId'],
        numero: map['numero'],
        descripcion: map['descripcion'],
        puntosTotales: map['puntosTotales'],
        activo: map['activo'] == 1,
      );
  final int id;
  final int corteId;
  final int numero;
  final String descripcion;
  final int puntosTotales;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'id': id,
        'corteId': corteId,
        'numero': numero,
        'descripcion': descripcion,
        'puntosTotales': puntosTotales,
        'activo': activo ? 1 : 0,
      };

  IndicadorEvaluacion copyWith({
    int? id,
    int? corteId,
    int? numero,
    String? descripcion,
    int? puntosTotales,
    bool? activo,
  }) =>
      IndicadorEvaluacion(
        id: id ?? this.id,
        corteId: corteId ?? this.corteId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
      );
}

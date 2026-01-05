class CriterioEvaluacion {

  CriterioEvaluacion({
    required this.id,
    required this.indicadorId,
    required this.numero,
    required this.descripcion,
    required this.puntosMaximos,
    required this.puntosObtenidos,
    required this.activo,
  });

  factory CriterioEvaluacion.fromMap(Map<String, dynamic> map) =>
      CriterioEvaluacion(
        id: map['id'],
        indicadorId: map['indicadorId'],
        numero: map['numero'],
        descripcion: map['descripcion'],
        puntosMaximos: map['puntosMaximos'],
        puntosObtenidos: map['puntosObtenidos'],
        activo: map['activo'] == 1,
      );
  final int id;
  final int indicadorId;
  final int numero;
  final String descripcion;
  final int puntosMaximos;
  final int puntosObtenidos;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'id': id,
        'indicadorId': indicadorId,
        'numero': numero,
        'descripcion': descripcion,
        'puntosMaximos': puntosMaximos,
        'puntosObtenidos': puntosObtenidos,
        'activo': activo ? 1 : 0,
      };

  CriterioEvaluacion copyWith({
    int? id,
    int? indicadorId,
    int? numero,
    String? descripcion,
    int? puntosMaximos,
    int? puntosObtenidos,
    bool? activo,
  }) =>
      CriterioEvaluacion(
        id: id ?? this.id,
        indicadorId: indicadorId ?? this.indicadorId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosMaximos: puntosMaximos ?? this.puntosMaximos,
        puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
        activo: activo ?? this.activo,
      );
}

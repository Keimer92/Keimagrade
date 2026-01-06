class CriterioEvaluacion {

  CriterioEvaluacion({
    required this.id,
    required this.anioLectivoId,
    required this.indicadorId,
    required this.numero,
    required this.descripcion,
    required this.puntosMaximos,
    required this.puntosObtenidos,
    required this.activo,
  });

  factory CriterioEvaluacion.fromMap(Map<String, dynamic> map) =>
      CriterioEvaluacion(
        id: map['id'] as int,
        anioLectivoId: map['anio_lectivo_id'] as int,
        indicadorId: map['indicadorId'] as int,
        numero: map['numero'] as int,
        descripcion: map['descripcion'] as String,
        puntosMaximos: map['puntosMaximos'] as int,
        puntosObtenidos: map['puntosObtenidos'] as int,
        activo: map['activo'] == 1,
      );
  final int? id;
  final int anioLectivoId;
  final int indicadorId;
  final int numero;
  final String descripcion;
  final int puntosMaximos;
  final int puntosObtenidos;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'anio_lectivo_id': anioLectivoId,
        'indicadorId': indicadorId,
        'numero': numero,
        'descripcion': descripcion,
        'puntosMaximos': puntosMaximos,
        'puntosObtenidos': puntosObtenidos,
        'activo': activo ? 1 : 0,
      };

  CriterioEvaluacion copyWith({
    int? id,
    int? anioLectivoId,
    int? indicadorId,
    int? numero,
    String? descripcion,
    int? puntosMaximos,
    int? puntosObtenidos,
    bool? activo,
  }) =>
      CriterioEvaluacion(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        indicadorId: indicadorId ?? this.indicadorId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosMaximos: puntosMaximos ?? this.puntosMaximos,
        puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
        activo: activo ?? this.activo,
      );
}

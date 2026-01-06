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
    this.valorCualitativo,
  });

  factory CriterioEvaluacion.fromMap(Map<String, dynamic> map) =>
      CriterioEvaluacion(
        id: map['id'] as int,
        anioLectivoId: map['anio_lectivo_id'] as int,
        indicadorId: map['indicadorId'] as int,
        numero: map['numero'] as int,
        descripcion: map['descripcion'] as String,
        puntosMaximos: (map['puntosMaximos'] as num).toDouble(),
        puntosObtenidos: (map['puntosObtenidos'] as num).toDouble(),
        activo: map['activo'] == 1,
        valorCualitativo: map['valor_cualitativo'] as String?,
      );
  final int? id;
  final int anioLectivoId;
  final int indicadorId;
  final int numero;
  final String descripcion;
  final double puntosMaximos;
  final double puntosObtenidos;
  final bool activo;
  final String? valorCualitativo;

  Map<String, dynamic> toMap() => {
        'anio_lectivo_id': anioLectivoId,
        'indicadorId': indicadorId,
        'numero': numero,
        'descripcion': descripcion,
        'puntosMaximos': puntosMaximos,
        'puntosObtenidos': puntosObtenidos,
        'activo': activo ? 1 : 0,
        'valor_cualitativo': valorCualitativo,
      };

  CriterioEvaluacion copyWith({
    int? id,
    int? anioLectivoId,
    int? indicadorId,
    int? numero,
    String? descripcion,
    double? puntosMaximos,
    double? puntosObtenidos,
    bool? activo,
    String? valorCualitativo,
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
        valorCualitativo: valorCualitativo ?? this.valorCualitativo,
      );
}

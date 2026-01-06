import 'criterio_evaluacion.dart';

class IndicadorEvaluacion {
  IndicadorEvaluacion({
    required this.id,
    required this.anioLectivoId,
    required this.corteId,
    required this.numero,
    required this.descripcion,
    required this.puntosTotales,
    required this.activo,
    this.criterios = const [],
  });

  factory IndicadorEvaluacion.fromMap(Map<String, dynamic> map) =>
      IndicadorEvaluacion(
        id: map['id'] as int,
        anioLectivoId: map['anio_lectivo_id'] as int,
        corteId: map['corteId'] as int,
        numero: map['numero'] as int,
        descripcion: map['descripcion'] as String,
        puntosTotales: map['puntosTotales'] as int,
        activo: map['activo'] == 1,
      );
  final int? id;
  final int anioLectivoId;
  final int corteId;
  final int numero;
  final String descripcion;
  final int puntosTotales;
  final bool activo;
  final List<CriterioEvaluacion> criterios;

  Map<String, dynamic> toMap() => {
        'anio_lectivo_id': anioLectivoId,
        'corteId': corteId,
        'numero': numero,
        'descripcion': descripcion,
        'puntosTotales': puntosTotales,
        'activo': activo ? 1 : 0,
      };

  IndicadorEvaluacion copyWith({
    int? id,
    int? anioLectivoId,
    int? corteId,
    int? numero,
    String? descripcion,
    int? puntosTotales,
    bool? activo,
    List<CriterioEvaluacion>? criterios,
  }) =>
      IndicadorEvaluacion(
        id: id ?? this.id,
        anioLectivoId: anioLectivoId ?? this.anioLectivoId,
        corteId: corteId ?? this.corteId,
        numero: numero ?? this.numero,
        descripcion: descripcion ?? this.descripcion,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        activo: activo ?? this.activo,
        criterios: criterios ?? this.criterios,
      );
}

class Nota {
  Nota({
    required this.id,
    required this.estudianteId,
    required this.estudianteNombreCompleto,
    required this.numeroIdentidad,
    required this.corteEvaluativoId,
    required this.corteEvaluativoNombre,
    required this.puntosTotales,
    required this.puntosObtenidos,
    required this.porcentaje,
    required this.calificacion,
    this.activo = true,
  });

  factory Nota.fromMap(Map<String, dynamic> map) => Nota(
        id: map['id'],
        estudianteId: map['estudianteId'],
        estudianteNombreCompleto: map['estudianteNombreCompleto'] ?? '',
        numeroIdentidad: map['numeroIdentidad'],
        corteEvaluativoId: map['corteEvaluativoId'],
        corteEvaluativoNombre: map['corteEvaluativoNombre'],
        puntosTotales: map['puntosTotales'],
        puntosObtenidos: map['puntosObtenidos'],
        porcentaje: map['porcentaje'],
        calificacion: map['calificacion'],
        activo: map['activo'] == 1,
      );

  final int id;
  final int estudianteId;
  final String estudianteNombreCompleto;
  final String? numeroIdentidad;
  final int corteEvaluativoId;
  final String corteEvaluativoNombre;
  final int puntosTotales;
  final int puntosObtenidos;
  final double porcentaje;
  final String calificacion;
  final bool activo;

  Map<String, dynamic> toMap() => {
        'id': id,
        'estudianteId': estudianteId,
        'estudianteNombreCompleto': estudianteNombreCompleto,
        'numeroIdentidad': numeroIdentidad,
        'corteEvaluativoId': corteEvaluativoId,
        'corteEvaluativoNombre': corteEvaluativoNombre,
        'puntosTotales': puntosTotales,
        'puntosObtenidos': puntosObtenidos,
        'porcentaje': porcentaje,
        'calificacion': calificacion,
        'activo': activo ? 1 : 0,
      };

  Nota copyWith({
    int? id,
    int? estudianteId,
    String? estudianteNombreCompleto,
    String? numeroIdentidad,
    int? corteEvaluativoId,
    String? corteEvaluativoNombre,
    int? puntosTotales,
    int? puntosObtenidos,
    double? porcentaje,
    String? calificacion,
    bool? activo,
  }) =>
      Nota(
        id: id ?? this.id,
        estudianteId: estudianteId ?? this.estudianteId,
        estudianteNombreCompleto: estudianteNombreCompleto ?? this.estudianteNombreCompleto,
        numeroIdentidad: numeroIdentidad ?? this.numeroIdentidad,
        corteEvaluativoId: corteEvaluativoId ?? this.corteEvaluativoId,
        corteEvaluativoNombre: corteEvaluativoNombre ?? this.corteEvaluativoNombre,
        puntosTotales: puntosTotales ?? this.puntosTotales,
        puntosObtenidos: puntosObtenidos ?? this.puntosObtenidos,
        porcentaje: porcentaje ?? this.porcentaje,
        calificacion: calificacion ?? this.calificacion,
        activo: activo ?? this.activo,
      );
}

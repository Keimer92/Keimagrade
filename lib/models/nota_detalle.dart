class NotaDetalle {
  NotaDetalle({
    required this.estudianteId,
    required this.estudianteNombre,
    required this.estudianteApellido,
    required this.numeroIdentidad,
    required this.corteId,
    required this.corteNombre,
    required this.indicadores,
    required this.totalPuntos,
    required this.totalMaximo,
    required this.porcentaje,
    required this.calificacion,
  });

  factory NotaDetalle.fromMap(Map<String, dynamic> map) => NotaDetalle(
        estudianteId: map['estudianteId'],
        estudianteNombre: map['estudianteNombre'],
        estudianteApellido: map['estudianteApellido'],
        numeroIdentidad: map['numeroIdentidad'],
        corteId: map['corteId'],
        corteNombre: map['corteNombre'],
        indicadores: _parseIndicadores(map['indicadores']),
        totalPuntos: map['totalPuntos'],
        totalMaximo: map['totalMaximo'],
        porcentaje: map['porcentaje'],
        calificacion: map['calificacion'],
      );

  final int estudianteId;
  final String estudianteNombre;
  final String estudianteApellido;
  final String? numeroIdentidad;
  final int corteId;
  final String corteNombre;
  final List<IndicadorDetalle> indicadores;
  final int totalPuntos;
  final int totalMaximo;
  final double porcentaje;
  final String calificacion;

  String get estudianteNombreCompleto => '$estudianteNombre $estudianteApellido';

  static List<IndicadorDetalle> _parseIndicadores(dynamic indicadoresData) {
    if (indicadoresData is List) {
      return indicadoresData.map((item) => IndicadorDetalle.fromMap(item)).toList();
    }
    return [];
  }
}

class IndicadorDetalle {
  IndicadorDetalle({
    required this.id,
    required this.numero,
    required this.descripcion,
    required this.criterios,
    required this.totalPuntos,
    required this.totalMaximo,
  });

  factory IndicadorDetalle.fromMap(Map<String, dynamic> map) => IndicadorDetalle(
        id: map['id'],
        numero: map['numero'],
        descripcion: map['descripcion'],
        criterios: _parseCriterios(map['criterios']),
        totalPuntos: map['totalPuntos'],
        totalMaximo: map['totalMaximo'],
      );

  final int id;
  final int numero;
  final String descripcion;
  final List<CriterioDetalle> criterios;
  final int totalPuntos;
  final int totalMaximo;

  static List<CriterioDetalle> _parseCriterios(dynamic criteriosData) {
    if (criteriosData is List) {
      return criteriosData.map((item) => CriterioDetalle.fromMap(item)).toList();
    }
    return [];
  }
}

class CriterioDetalle {
  CriterioDetalle({
    required this.id,
    required this.numero,
    required this.descripcion,
    required this.puntosMaximos,
    required this.puntosObtenidos,
  });

  factory CriterioDetalle.fromMap(Map<String, dynamic> map) => CriterioDetalle(
        id: map['id'],
        numero: map['numero'],
        descripcion: map['descripcion'],
        puntosMaximos: map['puntosMaximos'],
        puntosObtenidos: map['puntosObtenidos'],
      );

  final int id;
  final int numero;
  final String descripcion;
  final int puntosMaximos;
  final int puntosObtenidos;
}

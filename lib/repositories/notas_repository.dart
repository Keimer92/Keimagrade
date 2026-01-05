import '../database/database_helper.dart';
import '../models/nota.dart';
import '../models/nota_detalle.dart';
import '../models/corte_evaluativo.dart';

class NotasRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Obtiene todas las notas agrupadas por estudiante y corte evaluativo
  Future<List<Nota>> obtenerTodas() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.nombre as estudianteNombre,
        e.apellido as estudianteApellido,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntosTotales as puntosTotales,
        COALESCE(SUM(cri.puntosObtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntosTotales > 0 THEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntosTotales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      CROSS JOIN cortes_evaluativos ce
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      WHERE e.activo = 1 AND ce.activo = 1
      GROUP BY e.id, e.nombre, e.apellido, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.apellido, e.nombre, ce.numero
    ''');
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

  /// Obtiene notas filtradas por asignación de estudiante
  Future<List<Nota>> obtenerPorAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.nombre as estudianteNombre,
        e.apellido as estudianteApellido,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntosTotales as puntosTotales,
        COALESCE(SUM(cri.puntosObtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntosTotales > 0 THEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntosTotales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      CROSS JOIN cortes_evaluativos ce
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
      GROUP BY e.id, e.nombre, e.apellido, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.apellido, e.nombre, ce.numero
    ''', [anioLectivoId, colegioId, asignaturaId, gradoId, seccionId]);
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

  /// Busca notas por nombre de estudiante o número de identidad
  Future<List<Nota>> buscar(String query) async {
    final db = await _dbHelper.database;
    final searchTerm = '%${query.toLowerCase()}%';
    final maps = await db.rawQuery('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.nombre as estudianteNombre,
        e.apellido as estudianteApellido,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntosTotales as puntosTotales,
        COALESCE(SUM(cri.puntosObtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntosTotales > 0 THEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntosTotales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      CROSS JOIN cortes_evaluativos ce
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      WHERE e.activo = 1
        AND ce.activo = 1
        AND (LOWER(e.nombre || ' ' || e.apellido) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.nombre, e.apellido, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.apellido, e.nombre, ce.numero
    ''', [searchTerm, searchTerm]);
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

  /// Busca notas filtradas por asignación y búsqueda
  Future<List<Nota>> buscarPorAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
    required String query,
  }) async {
    final db = await _dbHelper.database;
    final searchTerm = '%${query.toLowerCase()}%';
    final maps = await db.rawQuery('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.nombre as estudianteNombre,
        e.apellido as estudianteApellido,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntosTotales as puntosTotales,
        COALESCE(SUM(cri.puntosObtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntosTotales > 0 THEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntosTotales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntosObtenidos), 0) * 100.0) / ce.puntosTotales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      CROSS JOIN cortes_evaluativos ce
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
        AND (LOWER(e.nombre || ' ' || e.apellido) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.nombre, e.apellido, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.apellido, e.nombre, ce.numero
    ''', [anioLectivoId, colegioId, asignaturaId, gradoId, seccionId, searchTerm, searchTerm]);
    return List.generate(maps.length, (i) => Nota.fromMap(maps[i]));
  }

  /// Obtiene notas detalladas para tabla Excel por corte específico
  Future<List<NotaDetalle>> obtenerNotasDetalladasPorCorte({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
    required int corteId,
    String? searchQuery,
  }) async {
    final db = await _dbHelper.database;

    // Base query for students
    String studentQuery = '''
      SELECT DISTINCT e.id, e.nombre, e.apellido, e.numero_identidad
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      WHERE e.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
    ''';

    List<dynamic> studentParams = [anioLectivoId, colegioId, asignaturaId, gradoId, seccionId];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      studentQuery += ' AND (LOWER(e.nombre || \' \' || e.apellido) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)';
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      studentParams.add(searchTerm);
      studentParams.add(searchTerm);
    }

    studentQuery += ' ORDER BY e.apellido, e.nombre';

    final studentMaps = await db.rawQuery(studentQuery, studentParams);

    List<NotaDetalle> notasDetalladas = [];

    for (final studentMap in studentMaps) {
      final estudianteId = studentMap['id'] as int;

      // Get all indicators for this cut
      final indicadorMaps = await db.rawQuery('''
        SELECT ie.id, ie.numero, ie.descripcion, ie.puntosTotales
        FROM indicadores_evaluacion ie
        WHERE ie.corteId = ? AND ie.activo = 1
        ORDER BY ie.numero
      ''', [corteId]);

      List<IndicadorDetalle> indicadores = [];

      for (final indicadorMap in indicadorMaps) {
        final indicadorId = indicadorMap['id'] as int;

        // Get all criteria for this indicator
        final criterioMaps = await db.rawQuery('''
          SELECT cri.id, cri.numero, cri.descripcion, cri.puntosMaximos,
                 COALESCE(cri.puntosObtenidos, 0) as puntosObtenidos
          FROM criterios_evaluacion cri
          WHERE cri.indicadorId = ? AND cri.activo = 1
          ORDER BY cri.numero
        ''', [indicadorId]);

        List<CriterioDetalle> criterios = criterioMaps.map((map) => CriterioDetalle(
          id: map['id'] as int,
          numero: map['numero'] as int,
          descripcion: map['descripcion'] as String,
          puntosMaximos: map['puntosMaximos'] as int,
          puntosObtenidos: map['puntosObtenidos'] as int,
        )).toList();

        // Calculate indicator total
        final totalPuntos = criterios.fold<int>(0, (sum, criterio) => sum + criterio.puntosObtenidos);
        final totalMaximo = indicadorMap['puntosTotales'] as int;

        indicadores.add(IndicadorDetalle(
          id: indicadorId,
          numero: indicadorMap['numero'] as int,
          descripcion: indicadorMap['descripcion'] as String,
          criterios: criterios,
          totalPuntos: totalPuntos,
          totalMaximo: totalMaximo,
        ));
      }

      // Calculate total for the cut
      final totalPuntos = indicadores.fold<int>(0, (sum, indicador) => sum + indicador.totalPuntos);
      final totalMaximo = indicadores.fold<int>(0, (sum, indicador) => sum + indicador.totalMaximo);

      final porcentaje = totalMaximo > 0 ? (totalPuntos / totalMaximo) * 100 : 0.0;
      final calificacion = _calcularCalificacion(porcentaje);

      // Get cut name
      final corteMaps = await db.rawQuery('SELECT nombre FROM cortes_evaluativos WHERE id = ?', [corteId]);
      final corteNombre = corteMaps.isNotEmpty ? corteMaps.first['nombre'] as String : 'Corte';

      notasDetalladas.add(NotaDetalle(
        estudianteId: estudianteId,
        estudianteNombre: studentMap['nombre'] as String,
        estudianteApellido: studentMap['apellido'] as String,
        numeroIdentidad: studentMap['numero_identidad'] as String?,
        corteId: corteId,
        corteNombre: corteNombre,
        indicadores: indicadores,
        totalPuntos: totalPuntos,
        totalMaximo: totalMaximo,
        porcentaje: porcentaje,
        calificacion: calificacion,
      ));
    }

    return notasDetalladas;
  }

  /// Obtiene los cortes evaluativos que tienen indicadores configurados para un año lectivo
  Future<List<CorteEvaluativo>> obtenerCortesPorAnioLectivo(int anioLectivoId) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT ce.*
      FROM cortes_evaluativos ce
      INNER JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1 AND ie.anio_lectivo_id = ?
      WHERE ce.activo = 1 AND ce.anio_lectivo_id = ?
      ORDER BY ce.numero
    ''', [anioLectivoId, anioLectivoId]);
    return List.generate(maps.length, (i) => CorteEvaluativo.fromMap(maps[i]));
  }

  /// Obtiene los cortes evaluativos que tienen indicadores configurados
  Future<List<int>> obtenerCortesConIndicadores() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT ce.id
      FROM cortes_evaluativos ce
      INNER JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      WHERE ce.activo = 1
      ORDER BY ce.numero
    ''');
    return maps.map((m) => m['id'] as int).toList();
  }

  String _calcularCalificacion(double porcentaje) {
    if (porcentaje >= 90) return 'A';
    if (porcentaje >= 80) return 'B';
    if (porcentaje >= 70) return 'C';
    if (porcentaje >= 60) return 'D';
    return 'F';
  }
}

import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/nota.dart';
import '../models/nota_detalle.dart';
import '../models/corte_evaluativo.dart';
import '../repositories/corte_evaluativo_repository.dart';

class NotasRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Obtiene todas las notas agrupadas por estudiante y corte evaluativo
  Future<List<Nota>> obtenerTodas() async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.estudiante as estudianteNombreCompleto,
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
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1 AND ce.activo = 1 AND ea.activo = 1
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.estudiante, ce.numero
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
        e.estudiante as estudianteNombreCompleto,
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
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.estudiante, ce.numero
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
        e.estudiante as estudianteNombreCompleto,
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
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corteId = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicadorId = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.estudiante, ce.numero
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
        e.estudiante as estudianteNombreCompleto,
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
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
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
        AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntosTotales
      ORDER BY e.estudiante, ce.numero
    ''', [
      anioLectivoId,
      colegioId,
      asignaturaId,
      gradoId,
      seccionId,
      searchTerm,
      searchTerm
    ]);
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
      SELECT DISTINCT e.id, e.estudiante, e.numero_identidad
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

    final List<dynamic> studentParams = [
      anioLectivoId,
      colegioId,
      asignaturaId,
      gradoId,
      seccionId
    ];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      studentQuery +=
          ' AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)';
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      studentParams.add(searchTerm);
      studentParams.add(searchTerm);
    }

    studentQuery += ' ORDER BY e.estudiante';

    final studentMaps = await db.rawQuery(studentQuery, studentParams);

    final List<NotaDetalle> notasDetalladas = [];

    for (final studentMap in studentMaps) {
      final estudianteId = studentMap['id'] as int;

      // Get all indicators for this cut
      final indicadorMaps = await db.rawQuery('''
        SELECT ie.id, ie.numero, ie.descripcion, ie.puntosTotales
        FROM indicadores_evaluacion ie
        WHERE ie.corteId = ? AND ie.activo = 1
        ORDER BY ie.numero
      ''', [corteId]);

      final List<IndicadorDetalle> indicadores = [];

      for (final indicadorMap in indicadorMaps) {
        final indicadorId = indicadorMap['id'] as int;

        // Get all criteria for this indicator and student's note
        final criterioMaps = await db.rawQuery('''
          SELECT cri.id, cri.numero, cri.descripcion, cri.puntosMaximos,
                 COALESCE(ne.puntos_obtenidos, 0) as puntosObtenidos,
                 ne.valor_cualitativo
          FROM criterios_evaluacion cri
          LEFT JOIN notas_estudiantes ne ON ne.criterio_id = cri.id AND ne.estudiante_id = ?
          WHERE cri.indicadorId = ? AND cri.activo = 1
          ORDER BY cri.numero
        ''', [estudianteId, indicadorId]);

        final List<CriterioDetalle> criterios = criterioMaps
            .map((map) => CriterioDetalle(
                  id: map['id'] as int,
                  numero: map['numero'] as int,
                  descripcion: map['descripcion'] as String,
                  puntosMaximos: (map['puntosMaximos'] as num).toDouble(),
                  puntosObtenidos: (map['puntosObtenidos'] as num).toDouble(),
                  valorCualitativo: map['valor_cualitativo'] as String?,
                ))
            .toList();

        // Calculate indicator total
        final totalPuntos = criterios.fold<double>(
            0, (sum, criterio) => sum + criterio.puntosObtenidos);
        final totalMaximo = (indicadorMap['puntosTotales'] as num).toDouble();

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
      final totalPuntos = indicadores.fold<double>(
          0, (sum, indicador) => sum + indicador.totalPuntos);
      final totalMaximo = indicadores.fold<double>(
          0, (sum, indicador) => sum + indicador.totalMaximo);

      final porcentaje =
          totalMaximo > 0 ? (totalPuntos / totalMaximo) * 100 : 0.0;
      final calificacion = _calcularCalificacion(porcentaje);

      // Get cut name
      final corteMaps = await db.rawQuery(
          'SELECT nombre FROM cortes_evaluativos WHERE id = ?', [corteId]);
      final corteNombre =
          corteMaps.isNotEmpty ? corteMaps.first['nombre'] as String : 'Corte';

      notasDetalladas.add(NotaDetalle(
        estudianteId: estudianteId,
        estudianteNombre: studentMap['estudiante'] as String,
        estudianteApellido: '', // No longer used, but required by model
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

  /// Obtiene los cortes evaluativos para un año lectivo
  Future<List<CorteEvaluativo>> obtenerCortesPorAnioLectivo(
      int anioLectivoId) async {
    final db = await _dbHelper.database;

    // First check if cortes exist for this academic year
    final existingMaps = await db.rawQuery('''
      SELECT ce.*
      FROM cortes_evaluativos ce
      WHERE ce.activo = 1 AND ce.anio_lectivo_id = ?
      ORDER BY ce.numero
    ''', [anioLectivoId]);

    if (existingMaps.isNotEmpty) {
      // Check if they have indicators before returning
      // (Optional, but ensures structure if cortes existed but indicators didn't)
    }

    // Ensure default structure exists (centralized logic)
    final CorteEvaluativoRepository corteRepo = CorteEvaluativoRepository();
    await corteRepo.asegurarEstructuraDefault(anioLectivoId);

    // Fetch the cortes
    final maps = await db.rawQuery('''
      SELECT ce.*
      FROM cortes_evaluativos ce
      WHERE ce.activo = 1 AND ce.anio_lectivo_id = ?
      ORDER BY ce.numero
    ''', [anioLectivoId]);

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

  /// Obtiene los años lectivos que tienen notas para un colegio específico
  Future<List<int>> obtenerAniosConNotasDesdeColegio(int colegioId) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT ce.anio_lectivo_id
      FROM notas n
      INNER JOIN estudiantes e ON n.estudiante_id = e.id
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN cortes_evaluativos ce ON n.corte_evaluativo_id = ce.id
      WHERE ea.colegio_id = ? AND e.activo = 1 AND ea.activo = 1 AND ce.activo = 1
      ORDER BY ce.anio_lectivo_id DESC
    ''', [colegioId]);
    return maps.map((m) => m['anio_lectivo_id'] as int).toList();
  }

  String _calcularCalificacion(double porcentaje) {
    if (porcentaje >= 90) return 'AA';
    if (porcentaje >= 80) return 'AS';
    if (porcentaje >= 60) return 'AF';
    if (porcentaje >= 40) return 'AI';
    return '-';
  }

  /// Guarda o actualiza una nota de estudiante
  Future<void> guardarNotaEstudiante({
    required int estudianteId,
    required int criterioId,
    required String valorCualitativo,
    required double puntosObtenidos,
  }) async {
    final db = await _dbHelper.database;
    await db.insert(
      'notas_estudiantes',
      {
        'estudiante_id': estudianteId,
        'criterio_id': criterioId,
        'valor_cualitativo': valorCualitativo,
        'puntos_obtenidos': puntosObtenidos,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

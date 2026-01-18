import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/nota.dart';
import '../models/nota_detalle.dart';
import '../models/corte_evaluativo.dart';
import '../repositories/corte_evaluativo_repository.dart';

class NotasRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Obtiene todas las notas agrupadas por estudiante y corte evaluativo
  Future<List<Nota>> obtenerTodas() async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.estudiante as estudianteNombreCompleto,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntos_totales as puntosTotales,
        COALESCE(SUM(cri.puntos_obtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntos_totales > 0 THEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntos_totales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corte_id = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicador_id = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1 AND ce.activo = 1 AND ea.activo = 1
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntos_totales
      ORDER BY e.estudiante, ce.numero
    ''').get();

    return rows.map((row) => Nota.fromMap(row.data)).toList();
  }

  /// Obtiene notas filtradas por asignación de estudiante
  Future<List<Nota>> obtenerPorAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.estudiante as estudianteNombreCompleto,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntos_totales as puntosTotales,
        COALESCE(SUM(cri.puntos_obtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntos_totales > 0 THEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntos_totales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corte_id = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicador_id = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntos_totales
      ORDER BY e.estudiante, ce.numero
    ''', variables: [
      Variable.withInt(anioLectivoId),
      Variable.withInt(colegioId),
      Variable.withInt(asignaturaId),
      Variable.withInt(gradoId),
      Variable.withInt(seccionId),
    ]).get();

    return rows.map((row) => Nota.fromMap(row.data)).toList();
  }

  /// Busca notas por nombre de estudiante o número de identidad
  Future<List<Nota>> buscar(String query) async {
    final database = await _dbHelper.database;
    final searchTerm = '%${query.toLowerCase()}%';
    final rows = await database.customSelect('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.estudiante as estudianteNombreCompleto,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntos_totales as puntosTotales,
        COALESCE(SUM(cri.puntos_obtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntos_totales > 0 THEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntos_totales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corte_id = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicador_id = ie.id AND cri.activo = 1
      LEFT JOIN notas_estudiantes ne ON ne.estudiante_id = e.id AND ne.criterio_id = cri.id
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntos_totales
      ORDER BY e.estudiante, ce.numero
    ''', variables: [
      Variable.withString(searchTerm),
      Variable.withString(searchTerm),
    ]).get();

    return rows.map((row) => Nota.fromMap(row.data)).toList();
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
    final database = await _dbHelper.database;
    final searchTerm = '%${query.toLowerCase()}%';
    final rows = await database.customSelect('''
      SELECT
        ROW_NUMBER() OVER (ORDER BY e.id, ce.id) as id,
        e.id as estudianteId,
        e.estudiante as estudianteNombreCompleto,
        e.numero_identidad as numeroIdentidad,
        ce.id as corteEvaluativoId,
        ce.nombre as corteEvaluativoNombre,
        ce.puntos_totales as puntosTotales,
        COALESCE(SUM(cri.puntos_obtenidos), 0) as puntosObtenidos,
        CASE
          WHEN ce.puntos_totales > 0 THEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2)
          ELSE 0
        END as porcentaje,
        CASE
          WHEN ce.puntos_totales > 0 THEN
            CASE
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 90 THEN 'A'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 80 THEN 'B'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 70 THEN 'C'
              WHEN ROUND((COALESCE(SUM(cri.puntos_obtenidos), 0) * 100.0) / ce.puntos_totales, 2) >= 60 THEN 'D'
              ELSE 'F'
            END
          ELSE 'N/A'
        END as calificacion,
        1 as activo
      FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN cortes_evaluativos ce ON ce.anio_lectivo_id = ea.anio_lectivo_id
      LEFT JOIN indicadores_evaluacion ie ON ie.corte_id = ce.id AND ie.activo = 1
      LEFT JOIN criterios_evaluacion cri ON cri.indicador_id = ie.id AND cri.activo = 1
      WHERE e.activo = 1
        AND ce.activo = 1
        AND ea.activo = 1
        AND ea.anio_lectivo_id = ?
        AND ea.colegio_id = ?
        AND ea.asignatura_id = ?
        AND ea.grado_id = ?
        AND ea.seccion_id = ?
        AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)
      GROUP BY e.id, e.estudiante, e.numero_identidad, ce.id, ce.nombre, ce.puntos_totales
      ORDER BY e.estudiante, ce.numero
    ''', variables: [
      Variable.withInt(anioLectivoId),
      Variable.withInt(colegioId),
      Variable.withInt(asignaturaId),
      Variable.withInt(gradoId),
      Variable.withInt(seccionId),
      Variable.withString(searchTerm),
      Variable.withString(searchTerm),
    ]).get();

    return rows.map((row) => Nota.fromMap(row.data)).toList();
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
    final database = await _dbHelper.database;

    // Check if asignatura or grado is qualitative
    final asignaturaRow = await (database.select(database.asignaturas)
          ..where((t) => t.id.equals(asignaturaId)))
        .getSingleOrNull();
    final gradoRow = await (database.select(database.grados)
          ..where((t) => t.id.equals(gradoId)))
        .getSingleOrNull();

    final esCualitativaAsignatura =
        asignaturaRow != null && asignaturaRow.cualitativo;
    final esCualitativoGrado = gradoRow != null && gradoRow.cualitativo;
    final esCualitativa = esCualitativaAsignatura || esCualitativoGrado;

    // Base query for students
    var studentQuery = '''
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

    final List<Variable> studentParams = [
      Variable.withInt(anioLectivoId),
      Variable.withInt(colegioId),
      Variable.withInt(asignaturaId),
      Variable.withInt(gradoId),
      Variable.withInt(seccionId)
    ];

    if (searchQuery != null && searchQuery.isNotEmpty) {
      studentQuery +=
          ' AND (LOWER(e.estudiante) LIKE ? OR LOWER(e.numero_identidad) LIKE ?)';
      final searchTerm = '%${searchQuery.toLowerCase()}%';
      studentParams.add(Variable.withString(searchTerm));
      studentParams.add(Variable.withString(searchTerm));
    }

    studentQuery += ' ORDER BY e.estudiante';

    final studentRows = await database
        .customSelect(studentQuery, variables: studentParams)
        .get();

    final List<NotaDetalle> notasDetalladas = [];

    for (final studentRow in studentRows) {
      final studentMap = studentRow.data;
      final estudianteId = studentMap['id'] as int;

      // Get all indicators for this cut
      final indicadorRows = await database.customSelect('''
        SELECT ie.id, ie.numero, ie.descripcion, ie.puntos_totales as puntosTotales
        FROM indicadores_evaluacion ie
        WHERE ie.corte_id = ? AND ie.activo = 1
        ORDER BY ie.numero
      ''', variables: [Variable.withInt(corteId)]).get();

      final List<IndicadorDetalle> indicadores = [];

      for (final indicadorRow in indicadorRows) {
        final indicadorMap = indicadorRow.data;
        final indicadorId = indicadorMap['id'] as int;

        // Get all criteria for this indicator and student's note
        final criterioRows = await database.customSelect('''
          SELECT cri.id, cri.numero, cri.descripcion, cri.puntos_maximos as puntosMaximos,
                 COALESCE(ne.puntos_obtenidos, 0) as puntosObtenidos,
                 ne.valor_cualitativo
          FROM criterios_evaluacion cri
          LEFT JOIN notas_estudiantes ne ON ne.criterio_id = cri.id AND ne.estudiante_id = ?
          WHERE cri.indicador_id = ? AND cri.activo = 1
          ORDER BY cri.numero
        ''', variables: [
          Variable.withInt(estudianteId),
          Variable.withInt(indicadorId)
        ]).get();

        final List<CriterioDetalle> criterios = criterioRows
            .map((row) => CriterioDetalle(
                  id: row.data['id'] as int,
                  numero: row.data['numero'] as int,
                  descripcion: row.data['descripcion'] as String,
                  puntosMaximos: (row.data['puntosMaximos'] as num).toDouble(),
                  puntosObtenidos:
                      (row.data['puntosObtenidos'] as num).toDouble(),
                  valorCualitativo: row.data['valor_cualitativo'] as String?,
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
      final calificacion = esCualitativa
          ? _calcularModa(indicadores)
          : _calcularCalificacion(porcentaje);

      // Get cut name
      final corteRow = await (database.select(database.cortesEvaluativos)
            ..where((t) => t.id.equals(corteId)))
          .getSingleOrNull();
      final corteNombre = corteRow?.nombre ?? 'Corte';

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
    final database = await _dbHelper.database;

    // Ensure default structure exists (centralized logic)
    final CorteEvaluativoRepository corteRepo = CorteEvaluativoRepository();
    await corteRepo.asegurarEstructuraDefault(anioLectivoId);

    // Fetch the cortes using drift select
    final rows = await (database.select(database.cortesEvaluativos)
          ..where((t) => t.activo.equals(true))
          ..where((t) => t.anioLectivoId.equals(anioLectivoId))
          ..orderBy([(t) => OrderingTerm(expression: t.numero)]))
        .get();

    return rows
        .map((row) => CorteEvaluativo(
              id: row.id,
              anioLectivoId: row.anioLectivoId,
              numero: row.numero,
              nombre: row.nombre,
              puntosTotales: row.puntosTotales,
              activo: row.activo,
            ))
        .toList();
  }

  /// Obtiene los cortes evaluativos que tienen indicadores configurados
  Future<List<int>> obtenerCortesConIndicadores() async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect('''
      SELECT DISTINCT ce.id
      FROM cortes_evaluativos ce
      INNER JOIN indicadores_evaluacion ie ON ie.corte_id = ce.id AND ie.activo = 1
      WHERE ce.activo = 1
      ORDER BY ce.numero
    ''').get();
    return rows.map((row) => row.data['id'] as int).toList();
  }

  /// Obtiene los años lectivos que tienen notas para un colegio específico
  Future<List<int>> obtenerAniosConNotasDesdeColegio(int colegioId) async {
    final database = await _dbHelper.database;
    // Corregido el join para usar la tabla correcta y ruta de relaciones
    final rows = await database.customSelect('''
      SELECT DISTINCT ce.anio_lectivo_id
      FROM notas_estudiantes ne
      INNER JOIN estudiantes e ON ne.estudiante_id = e.id
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      INNER JOIN criterios_evaluacion cri ON ne.criterio_id = cri.id
      INNER JOIN indicadores_evaluacion ie ON cri.indicador_id = ie.id
      INNER JOIN cortes_evaluativos ce ON ie.corte_id = ce.id
      WHERE ea.colegio_id = ? AND e.activo = 1 AND ea.activo = 1 AND ce.activo = 1
      ORDER BY ce.anio_lectivo_id DESC
    ''', variables: [Variable.withInt(colegioId)]).get();
    return rows.map((row) => row.data['anio_lectivo_id'] as int).toList();
  }

  String _calcularModa(List<IndicadorDetalle> indicadores) {
    final qualifying = ['AA', 'AS', 'AF'];
    final Map<String, int> frecuencias = {};
    for (final ind in indicadores) {
      for (final cri in ind.criterios) {
        final sigla = cri.valorCualitativo ?? '';
        if (qualifying.contains(sigla)) {
          frecuencias[sigla] = (frecuencias[sigla] ?? 0) + 1;
        }
      }
    }
    if (frecuencias.isEmpty) return '-';
    final maxFreq = frecuencias.values.reduce((a, b) => a > b ? a : b);
    final tied = frecuencias.entries
        .where((e) => e.value == maxFreq)
        .map((e) => e.key)
        .toList();
    if (tied.length == 1) return tied[0];
    // En caso de empate, ordenar por valor ascendente y tomar el del medio
    final order = {'AA': 4, 'AS': 3, 'AF': 2};
    tied.sort((a, b) => order[a]!.compareTo(order[b]!)); // asc: AF, AS, AA
    final middleIndex = tied.length ~/ 2;
    return tied[middleIndex];
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
    final database = await _dbHelper.database;
    await database.into(database.notasEstudiantes).insertOnConflictUpdate(
          db.NotasEstudiantesCompanion.insert(
            estudianteId: estudianteId,
            criterioId: criterioId,
            valorCualitativo: Value(valorCualitativo),
            puntosObtenidos: puntosObtenidos,
          ),
        );
  }
}

import '../database/database_helper.dart';
import '../models/nota.dart';

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
}

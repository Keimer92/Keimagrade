import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/corte_evaluativo.dart';

class CorteEvaluativoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<CorteEvaluativo>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('cortes_evaluativos');
    return List.generate(maps.length, (i) => CorteEvaluativo.fromMap(maps[i]));
  }

  Future<List<CorteEvaluativo>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cortes_evaluativos',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => CorteEvaluativo.fromMap(maps[i]));
  }

  Future<List<CorteEvaluativo>> obtenerPorAnioLectivo(int anioLectivoId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cortes_evaluativos',
      where: 'anio_lectivo_id = ? AND activo = ?',
      whereArgs: [anioLectivoId, 1],
      orderBy: 'numero',
    );
    return List.generate(maps.length, (i) => CorteEvaluativo.fromMap(maps[i]));
  }

  Future<CorteEvaluativo?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'cortes_evaluativos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CorteEvaluativo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(CorteEvaluativo corte) async {
    final db = await _dbHelper.database;
    final data = corte.toMap();
    // Remove id from insert data since it's auto-generated
    data.remove('id');
    return db.insert('cortes_evaluativos', data);
  }

  Future<int> actualizar(CorteEvaluativo corte) async {
    final db = await _dbHelper.database;
    return db.update(
      'cortes_evaluativos',
      corte.toMap(),
      where: 'id = ?',
      whereArgs: [corte.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'cortes_evaluativos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Asegura que el año lectivo tenga sus 4 cortes y sus indicadores por defecto
  Future<void> asegurarEstructuraDefault(int anioLectivoId) async {
    final db = await _dbHelper.database;

    // 1. Asegurar cortes
    final cortesDefault = [
      {
        'anio_lectivo_id': anioLectivoId,
        'numero': 1,
        'nombre': '1er Corte',
        'puntosTotales': 100,
        'activo': 1
      },
      {
        'anio_lectivo_id': anioLectivoId,
        'numero': 2,
        'nombre': '2do Corte',
        'puntosTotales': 100,
        'activo': 1
      },
      {
        'anio_lectivo_id': anioLectivoId,
        'numero': 3,
        'nombre': '3er Corte',
        'puntosTotales': 100,
        'activo': 1
      },
      {
        'anio_lectivo_id': anioLectivoId,
        'numero': 4,
        'nombre': '4to Corte',
        'puntosTotales': 100,
        'activo': 1
      },
    ];

    await db.transaction((txn) async {
      for (final corte in cortesDefault) {
        try {
          await txn.insert('cortes_evaluativos', corte);
        } catch (e) {
          // Ya existe
        }
      }

      // Obtener los cortes (ya creados o existentes)
      final maps = await txn.query('cortes_evaluativos',
          where: 'anio_lectivo_id = ?', whereArgs: [anioLectivoId]);

      for (final map in maps) {
        final corteId = map['id'] as int;

        // Verificar indicadores
        final indicatorCount = Sqflite.firstIntValue(await txn.rawQuery(
                'SELECT COUNT(*) FROM indicadores_evaluacion WHERE corteId = ? AND activo = 1',
                [corteId])) ??
            0;

        if (indicatorCount == 0) {
          // Crear 5 indicadores
          for (int i = 1; i <= 5; i++) {
            final int indicadorId = await txn.insert('indicadores_evaluacion', {
              'anio_lectivo_id': anioLectivoId,
              'corteId': corteId,
              'numero': i,
              'descripcion': 'Descripción del Indicador $i',
              'puntosTotales': 20,
              'activo': 1
            });

            // Crear 3 criterios (7, 7, 6 pts)
            final points = [7, 7, 6];
            for (int j = 0; j < 3; j++) {
              await txn.insert('criterios_evaluacion', {
                'anio_lectivo_id': anioLectivoId,
                'indicadorId': indicadorId,
                'numero': j + 1,
                'descripcion': 'Descripción del Criterio ${j + 1}',
                'puntosMaximos': points[j],
                'puntosObtenidos': 0,
                'activo': 1
              });
            }
          }
        }
      }
    });
  }
}

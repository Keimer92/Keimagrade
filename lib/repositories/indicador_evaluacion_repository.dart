import '../database/database_helper.dart';
import '../models/indicador_evaluacion.dart';
import '../models/criterio_evaluacion.dart';

class IndicadorEvaluacionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<IndicadorEvaluacion>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('indicadores_evaluacion');
    final indicators =
        List.generate(maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));

    for (var i = 0; i < indicators.length; i++) {
      final criteriaMaps = await db.query(
        'criterios_evaluacion',
        where: 'indicadorId = ? AND activo = 1',
        whereArgs: [indicators[i].id],
      );
      indicators[i] = indicators[i].copyWith(
        criterios:
            criteriaMaps.map(CriterioEvaluacion.fromMap).toList(),
      );
    }
    return indicators;
  }

  Future<List<IndicadorEvaluacion>> obtenerPorCorte(int corteId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'indicadores_evaluacion',
      where: 'corteId = ?',
      whereArgs: [corteId],
    );
    final indicators =
        List.generate(maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));

    for (var i = 0; i < indicators.length; i++) {
      final criteriaMaps = await db.query(
        'criterios_evaluacion',
        where: 'indicadorId = ? AND activo = 1',
        whereArgs: [indicators[i].id],
      );
      indicators[i] = indicators[i].copyWith(
        criterios:
            criteriaMaps.map(CriterioEvaluacion.fromMap).toList(),
      );
    }
    return indicators;
  }

  Future<List<IndicadorEvaluacion>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'indicadores_evaluacion',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(
        maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));
  }

  Future<IndicadorEvaluacion?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'indicadores_evaluacion',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return IndicadorEvaluacion.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(IndicadorEvaluacion indicador) async {
    final db = await _dbHelper.database;
    return db.insert('indicadores_evaluacion', indicador.toMap());
  }

  Future<int> actualizar(IndicadorEvaluacion indicador) async {
    final db = await _dbHelper.database;
    return db.update(
      'indicadores_evaluacion',
      indicador.toMap(),
      where: 'id = ?',
      whereArgs: [indicador.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'indicadores_evaluacion',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

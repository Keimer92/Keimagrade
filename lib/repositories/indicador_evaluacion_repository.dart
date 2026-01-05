import '../database/database_helper.dart';
import '../models/indicador_evaluacion.dart';

class IndicadorEvaluacionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<IndicadorEvaluacion>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('indicadores_evaluacion');
    return List.generate(maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));
  }

  Future<List<IndicadorEvaluacion>> obtenerPorCorte(int corteId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'indicadores_evaluacion',
      where: 'corteId = ?',
      whereArgs: [corteId],
    );
    return List.generate(maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));
  }

  Future<List<IndicadorEvaluacion>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'indicadores_evaluacion',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => IndicadorEvaluacion.fromMap(maps[i]));
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

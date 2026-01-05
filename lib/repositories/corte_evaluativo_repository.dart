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
    return db.insert('cortes_evaluativos', corte.toMap());
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
}

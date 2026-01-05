import '../database/database_helper.dart';
import '../models/criterio_evaluacion.dart';

class CriterioEvaluacionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<CriterioEvaluacion>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('criterios_evaluacion');
    return List.generate(maps.length, (i) => CriterioEvaluacion.fromMap(maps[i]));
  }

  Future<List<CriterioEvaluacion>> obtenerPorIndicador(int indicadorId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'criterios_evaluacion',
      where: 'indicadorId = ?',
      whereArgs: [indicadorId],
    );
    return List.generate(maps.length, (i) => CriterioEvaluacion.fromMap(maps[i]));
  }

  Future<List<CriterioEvaluacion>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'criterios_evaluacion',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => CriterioEvaluacion.fromMap(maps[i]));
  }

  Future<CriterioEvaluacion?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'criterios_evaluacion',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CriterioEvaluacion.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(CriterioEvaluacion criterio) async {
    final db = await _dbHelper.database;
    return db.insert('criterios_evaluacion', criterio.toMap());
  }

  Future<int> actualizar(CriterioEvaluacion criterio) async {
    final db = await _dbHelper.database;
    return db.update(
      'criterios_evaluacion',
      criterio.toMap(),
      where: 'id = ?',
      whereArgs: [criterio.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'criterios_evaluacion',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

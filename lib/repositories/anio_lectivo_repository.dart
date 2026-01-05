import '../database/database_helper.dart';
import '../models/anio_lectivo.dart';

class AnioLectivoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<AnioLectivo>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('anos_lectivos');
    return List.generate(maps.length, (i) => AnioLectivo.fromMap(maps[i]));
  }

  Future<List<AnioLectivo>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'anos_lectivos',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => AnioLectivo.fromMap(maps[i]));
  }

  Future<AnioLectivo?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'anos_lectivos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return AnioLectivo.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(AnioLectivo anioLectivo) async {
    final db = await _dbHelper.database;
    return db.insert('anos_lectivos', anioLectivo.toMap());
  }

  Future<int> actualizar(AnioLectivo anioLectivo) async {
    final db = await _dbHelper.database;
    return db.update(
      'anos_lectivos',
      anioLectivo.toMap(),
      where: 'id = ?',
      whereArgs: [anioLectivo.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'anos_lectivos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

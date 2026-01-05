import '../database/database_helper.dart';
import '../models/colegio.dart';

class ColegioRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Colegio>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('colegios');
    return List.generate(maps.length, (i) => Colegio.fromMap(maps[i]));
  }

  Future<List<Colegio>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'colegios',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Colegio.fromMap(maps[i]));
  }

  Future<Colegio?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'colegios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Colegio.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(Colegio colegio) async {
    final db = await _dbHelper.database;
    return db.insert('colegios', colegio.toMap());
  }

  Future<int> actualizar(Colegio colegio) async {
    final db = await _dbHelper.database;
    return db.update(
      'colegios',
      colegio.toMap(),
      where: 'id = ?',
      whereArgs: [colegio.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'colegios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

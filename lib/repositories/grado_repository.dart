import '../database/database_helper.dart';
import '../models/grado.dart';

class GradoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Grado>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('grados', orderBy: 'numero ASC');
    return List.generate(maps.length, (i) => Grado.fromMap(maps[i]));
  }

  Future<List<Grado>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'grados',
      where: 'activo = ?',
      whereArgs: [1],
      orderBy: 'numero ASC',
    );
    return List.generate(maps.length, (i) => Grado.fromMap(maps[i]));
  }

  Future<Grado?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'grados',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Grado.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(Grado grado) async {
    final db = await _dbHelper.database;
    return db.insert('grados', grado.toMap());
  }

  Future<int> actualizar(Grado grado) async {
    final db = await _dbHelper.database;
    return db.update(
      'grados',
      grado.toMap(),
      where: 'id = ?',
      whereArgs: [grado.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'grados',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

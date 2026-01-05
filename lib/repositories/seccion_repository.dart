import '../database/database_helper.dart';
import '../models/seccion.dart';

class SeccionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Seccion>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('secciones', orderBy: 'letra ASC');
    return List.generate(maps.length, (i) => Seccion.fromMap(maps[i]));
  }

  Future<List<Seccion>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'secciones',
      where: 'activo = ?',
      whereArgs: [1],
      orderBy: 'letra ASC',
    );
    return List.generate(maps.length, (i) => Seccion.fromMap(maps[i]));
  }

  Future<Seccion?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'secciones',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Seccion.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(Seccion seccion) async {
    final db = await _dbHelper.database;
    return db.insert('secciones', seccion.toMap());
  }

  Future<int> actualizar(Seccion seccion) async {
    final db = await _dbHelper.database;
    return db.update(
      'secciones',
      seccion.toMap(),
      where: 'id = ?',
      whereArgs: [seccion.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'secciones',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

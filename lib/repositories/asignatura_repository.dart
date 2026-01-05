import '../database/database_helper.dart';
import '../models/asignatura.dart';

class AsignaturaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Asignatura>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('asignaturas');
    return List.generate(maps.length, (i) => Asignatura.fromMap(maps[i]));
  }

  Future<List<Asignatura>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'asignaturas',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Asignatura.fromMap(maps[i]));
  }

  Future<Asignatura?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'asignaturas',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Asignatura.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(Asignatura asignatura) async {
    final db = await _dbHelper.database;
    return db.insert('asignaturas', asignatura.toMap());
  }

  Future<int> actualizar(Asignatura asignatura) async {
    final db = await _dbHelper.database;
    return db.update(
      'asignaturas',
      asignatura.toMap(),
      where: 'id = ?',
      whereArgs: [asignatura.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'asignaturas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

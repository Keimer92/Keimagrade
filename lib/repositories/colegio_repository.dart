import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/colegio.dart';

class ColegioRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Colegio>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final colegios = await database.colegios.select().get();
    return colegios.map(_fromDrift).toList();
  }

  Future<List<Colegio>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final colegios = await (database.colegios.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return colegios.map(_fromDrift).toList();
  }

  Future<Colegio?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final colegios = await (database.colegios.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (colegios.isNotEmpty) {
      return _fromDrift(colegios.first);
    }
    return null;
  }

  Future<int> crear(Colegio colegio) async {
    final database = await _dbHelper.database;
    return database.into(database.colegios).insert(_toCompanion(colegio));
  }

  Future<bool> actualizar(Colegio colegio) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.colegios.update()
      ..where((tbl) => tbl.id.equals(colegio.id!)))
      .write(_toCompanion(colegio));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.colegios.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // Helper methods for conversion
  Colegio _fromDrift(db.Colegio row) => Colegio(
      id: row.id,
      nombre: row.nombre,
      direccion: row.direccion,
      telefono: row.telefono,
      email: row.email,
      director: row.director,
      activo: row.activo,
    );

  db.ColegiosCompanion _toCompanion(Colegio colegio) => db.ColegiosCompanion.insert(
      nombre: colegio.nombre,
      direccion: colegio.direccion,
      telefono: colegio.telefono,
      email: colegio.email,
      director: colegio.director,
      activo: Value(colegio.activo),
    );
}

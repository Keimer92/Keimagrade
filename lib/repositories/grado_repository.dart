import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/grado.dart';

class GradoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Grado>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final grados = await (database.grados.select()
      ..orderBy([(t) => OrderingTerm(expression: t.numero)]))
      .get();
    return grados.map(_fromDrift).toList();
  }

  Future<List<Grado>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final grados = await (database.grados.select()
      ..where((tbl) => tbl.activo.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.numero)]))
      .get();
    return grados.map(_fromDrift).toList();
  }

  Future<Grado?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final grados = await (database.grados.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (grados.isNotEmpty) {
      return _fromDrift(grados.first);
    }
    return null;
  }

  Future<int> crear(Grado grado) async {
    final database = await _dbHelper.database;
    return database.into(database.grados).insert(_toCompanion(grado));
  }

  Future<bool> actualizar(Grado grado) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.grados.update()
      ..where((tbl) => tbl.id.equals(grado.id!)))
      .write(_toCompanion(grado));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.grados.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // Helper methods for conversion
  Grado _fromDrift(db.Grado row) => Grado(
      id: row.id,
      numero: row.numero,
      nombre: row.nombre,
      activo: row.activo,
      cualitativo: row.cualitativo,
    );

  db.GradosCompanion _toCompanion(Grado grado) => db.GradosCompanion.insert(
      id: grado.id != null ? Value(grado.id!) : const Value.absent(),
      numero: grado.numero,
      nombre: grado.nombre,
      activo: Value(grado.activo),
      cualitativo: Value(grado.cualitativo),
    );
}


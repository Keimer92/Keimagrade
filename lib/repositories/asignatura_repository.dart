import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/asignatura.dart';

class AsignaturaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Asignatura>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final asignaturas = await database.asignaturas.select().get();
    return asignaturas.map(_fromDrift).toList();
  }

  Future<List<Asignatura>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final asignaturas = await (database.asignaturas.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return asignaturas.map(_fromDrift).toList();
  }

  Future<Asignatura?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final asignaturas = await (database.asignaturas.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (asignaturas.isNotEmpty) {
      return _fromDrift(asignaturas.first);
    }
    return null;
  }

  Future<int> crear(Asignatura asignatura) async {
    final database = await _dbHelper.database;
    return database.into(database.asignaturas).insert(_toCompanion(asignatura));
  }

  Future<bool> actualizar(Asignatura asignatura) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.asignaturas.update()
      ..where((tbl) => tbl.id.equals(asignatura.id!)))
      .write(_toCompanion(asignatura));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.asignaturas.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // Helper methods for conversion
  Asignatura _fromDrift(db.Asignatura row) => Asignatura(
      id: row.id,
      nombre: row.nombre,
      codigo: row.codigo,
      horas: row.horas,
      activo: row.activo,
      cualitativo: row.cualitativo,
    );

  db.AsignaturasCompanion _toCompanion(Asignatura asignatura) => db.AsignaturasCompanion.insert(
      nombre: asignatura.nombre,
      codigo: asignatura.codigo,
      horas: asignatura.horas,
      activo: Value(asignatura.activo),
      cualitativo: Value(asignatura.cualitativo),
    );
}

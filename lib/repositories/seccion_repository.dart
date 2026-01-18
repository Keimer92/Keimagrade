import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/seccion.dart';

class SeccionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Seccion _fromDrift(db.Seccione row) => Seccion(
        id: row.id,
        letra: row.letra,
        activo: row.activo,
      );

  db.SeccionesCompanion _toCompanion(Seccion seccion) => db.SeccionesCompanion(
        id: seccion.id != null ? Value(seccion.id!) : const Value.absent(),
        letra: Value(seccion.letra),
        activo: Value(seccion.activo),
      );

  Future<List<Seccion>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final secciones = await (database.select(database.secciones)
          ..orderBy([(t) => OrderingTerm(expression: t.letra)]))
        .get();
    return secciones.map(_fromDrift).toList();
  }

  Future<List<Seccion>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final secciones = await (database.select(database.secciones)
          ..where((t) => t.activo.equals(true))
          ..orderBy([(t) => OrderingTerm(expression: t.letra)]))
        .get();
    return secciones.map(_fromDrift).toList();
  }

  Future<Seccion?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final row = await (database.select(database.secciones)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _fromDrift(row) : null;
  }

  Future<int> crear(Seccion seccion) async {
    final database = await _dbHelper.database;
    return database.into(database.secciones).insert(_toCompanion(seccion));
  }

  Future<bool> actualizar(Seccion seccion) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.update(database.secciones)
          ..where((t) => t.id.equals(seccion.id!)))
        .write(_toCompanion(seccion));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.delete(database.secciones)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

import 'package:drift/drift.dart';
import '../database/database.dart';
import '../database/database_helper.dart';
import '../models/anio_lectivo.dart';

class AnioLectivoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<AnioLectivo>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final anosLectivos = await db.anosLectivos.select().get();
    return anosLectivos.map(_fromDrift).toList();
  }

  Future<List<AnioLectivo>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final anosLectivos = await (db.anosLectivos.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return anosLectivos.map(_fromDrift).toList();
  }

  Future<AnioLectivo?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final anosLectivos = await (db.anosLectivos.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (anosLectivos.isNotEmpty) {
      return _fromDrift(anosLectivos.first);
    }
    return null;
  }

  Future<int> crear(AnioLectivo anioLectivo) async {
    final db = await _dbHelper.database;
    return db.into(db.anosLectivos).insert(_toCompanion(anioLectivo));
  }

  Future<bool> actualizar(AnioLectivo anioLectivo) async {
    final db = await _dbHelper.database;
    final affectedRows = await (db.anosLectivos.update()
      ..where((tbl) => tbl.id.equals(anioLectivo.id!)))
      .write(_toCompanion(anioLectivo));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return (db.anosLectivos.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // Helper methods for conversion
  AnioLectivo _fromDrift(AnosLectivo row) => AnioLectivo(
      id: row.id,
      anio: row.anio,
      activo: row.activo,
      porDefecto: row.porDefecto,
    );

  AnosLectivosCompanion _toCompanion(AnioLectivo anioLectivo) => AnosLectivosCompanion.insert(
      anio: anioLectivo.anio,
      activo: Value(anioLectivo.activo),
      porDefecto: Value(anioLectivo.porDefecto),
    );
}

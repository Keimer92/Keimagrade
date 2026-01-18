import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/criterio_evaluacion.dart';

class CriterioEvaluacionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<CriterioEvaluacion>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final criterios = await database.criteriosEvaluacion.select().get();
    return criterios.map(_fromDrift).toList();
  }

  Future<List<CriterioEvaluacion>> obtenerPorIndicador(int indicadorId) async {
    final database = await _dbHelper.database;
    final criterios = await (database.criteriosEvaluacion.select()
      ..where((tbl) => tbl.indicadorId.equals(indicadorId)))
      .get();
    return criterios.map(_fromDrift).toList();
  }

  Future<List<CriterioEvaluacion>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final criterios = await (database.criteriosEvaluacion.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return criterios.map(_fromDrift).toList();
  }

  Future<CriterioEvaluacion?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final criterios = await (database.criteriosEvaluacion.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (criterios.isNotEmpty) {
      return _fromDrift(criterios.first);
    }
    return null;
  }

  Future<int> crear(CriterioEvaluacion criterio) async {
    final database = await _dbHelper.database;
    return database.into(database.criteriosEvaluacion).insert(_toCompanion(criterio));
  }

  Future<bool> actualizar(CriterioEvaluacion criterio) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.criteriosEvaluacion.update()
      ..where((tbl) => tbl.id.equals(criterio.id!)))
      .write(_toCompanion(criterio));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.criteriosEvaluacion.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  Future<int> eliminarPorIndicador(int indicadorId) async {
    final database = await _dbHelper.database;
    return (database.criteriosEvaluacion.delete()
      ..where((tbl) => tbl.indicadorId.equals(indicadorId)))
      .go();
  }

  // Helper methods for conversion
  CriterioEvaluacion _fromDrift(db.CriteriosEvaluacionData row) => CriterioEvaluacion(
      id: row.id,
      anioLectivoId: row.anioLectivoId,
      indicadorId: row.indicadorId,
      numero: row.numero,
      descripcion: row.descripcion,
      puntosMaximos: row.puntosMaximos,
      puntosObtenidos: row.puntosObtenidos,
      activo: row.activo,
    );

  db.CriteriosEvaluacionCompanion _toCompanion(CriterioEvaluacion criterio) => db.CriteriosEvaluacionCompanion.insert(
      id: criterio.id != null ? Value(criterio.id!) : const Value.absent(),
      anioLectivoId: criterio.anioLectivoId,
      indicadorId: criterio.indicadorId,
      numero: criterio.numero,
      descripcion: criterio.descripcion,
      puntosMaximos: Value(criterio.puntosMaximos),
      puntosObtenidos: Value(criterio.puntosObtenidos),
      activo: Value(criterio.activo),
    );
}


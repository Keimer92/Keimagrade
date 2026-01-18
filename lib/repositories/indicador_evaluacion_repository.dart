import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/indicador_evaluacion.dart';
import '../models/criterio_evaluacion.dart';

class IndicadorEvaluacionRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<IndicadorEvaluacion>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final indicadoresRows = await database.indicadoresEvaluacion.select().get();
    
    final indicators = <IndicadorEvaluacion>[];
    for (final row in indicadoresRows) {
      final criteriaRows = await (database.criteriosEvaluacion.select()
        ..where((tbl) => tbl.indicadorId.equals(row.id))
        ..where((tbl) => tbl.activo.equals(true)))
        .get();
      
      indicators.add(_fromDrift(row, criteriaRows));
    }
    return indicators;
  }

  Future<List<IndicadorEvaluacion>> obtenerPorCorte(int corteId) async {
    final database = await _dbHelper.database;
    final indicadoresRows = await (database.indicadoresEvaluacion.select()
      ..where((tbl) => tbl.corteId.equals(corteId)))
      .get();
    
    final indicators = <IndicadorEvaluacion>[];
    for (final row in indicadoresRows) {
      final criteriaRows = await (database.criteriosEvaluacion.select()
        ..where((tbl) => tbl.indicadorId.equals(row.id))
        ..where((tbl) => tbl.activo.equals(true)))
        .get();
      
      indicators.add(_fromDrift(row, criteriaRows));
    }
    return indicators;
  }

  Future<List<IndicadorEvaluacion>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final indicadoresRows = await (database.indicadoresEvaluacion.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return indicadoresRows.map(_fromDrift).toList();
  }

  Future<IndicadorEvaluacion?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final row = await (database.indicadoresEvaluacion.select()
      ..where((tbl) => tbl.id.equals(id)))
      .getSingleOrNull();
    
    if (row != null) {
      final criteriaRows = await (database.criteriosEvaluacion.select()
        ..where((tbl) => tbl.indicadorId.equals(row.id))
        ..where((tbl) => tbl.activo.equals(true)))
        .get();
      return _fromDrift(row, criteriaRows);
    }
    return null;
  }

  Future<int> crear(IndicadorEvaluacion indicador) async {
    final database = await _dbHelper.database;
    return database.into(database.indicadoresEvaluacion).insert(_toCompanion(indicador));
  }

  Future<bool> actualizar(IndicadorEvaluacion indicador) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.indicadoresEvaluacion.update()
      ..where((tbl) => tbl.id.equals(indicador.id!)))
      .write(_toCompanion(indicador));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.indicadoresEvaluacion.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // Helper methods for conversion
  IndicadorEvaluacion _fromDrift(db.IndicadoresEvaluacionData row, [List<db.CriteriosEvaluacionData>? criteriaRows]) => IndicadorEvaluacion(
      id: row.id,
      anioLectivoId: row.anioLectivoId,
      corteId: row.corteId,
      numero: row.numero,
      descripcion: row.descripcion,
      puntosTotales: row.puntosTotales,
      activo: row.activo,
      criterios: criteriaRows?.map((c) => CriterioEvaluacion(
        id: c.id,
        anioLectivoId: c.anioLectivoId,
        indicadorId: c.indicadorId,
        numero: c.numero,
        descripcion: c.descripcion,
        puntosMaximos: c.puntosMaximos,
        puntosObtenidos: c.puntosObtenidos,
        activo: c.activo,
      )).toList() ?? const [],
    );

  db.IndicadoresEvaluacionCompanion _toCompanion(IndicadorEvaluacion indicador) => db.IndicadoresEvaluacionCompanion.insert(
      id: indicador.id != null ? Value(indicador.id!) : const Value.absent(),
      anioLectivoId: indicador.anioLectivoId,
      corteId: indicador.corteId,
      numero: indicador.numero,
      descripcion: indicador.descripcion,
      puntosTotales: Value(indicador.puntosTotales),
      activo: Value(indicador.activo),
    );
}


import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/corte_evaluativo.dart';

class CorteEvaluativoRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<CorteEvaluativo>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final cortes = await database.cortesEvaluativos.select().get();
    return cortes.map(_fromDrift).toList();
  }

  Future<List<CorteEvaluativo>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final cortes = await (database.cortesEvaluativos.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return cortes.map(_fromDrift).toList();
  }

  Future<List<CorteEvaluativo>> obtenerPorAnioLectivo(int anioLectivoId) async {
    final database = await _dbHelper.database;
    final cortes = await (database.cortesEvaluativos.select()
      ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
      ..where((tbl) => tbl.activo.equals(true))
      ..orderBy([(t) => OrderingTerm(expression: t.numero)]))
      .get();
    return cortes.map(_fromDrift).toList();
  }

  Future<CorteEvaluativo?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final cortes = await (database.cortesEvaluativos.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (cortes.isNotEmpty) {
      return _fromDrift(cortes.first);
    }
    return null;
  }

  Future<int> crear(CorteEvaluativo corte) async {
    final database = await _dbHelper.database;
    return database.into(database.cortesEvaluativos).insert(_toCompanion(corte));
  }

  Future<bool> actualizar(CorteEvaluativo corte) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.cortesEvaluativos.update()
      ..where((tbl) => tbl.id.equals(corte.id!)))
      .write(_toCompanion(corte));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.cortesEvaluativos.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  /// Asegura que el año lectivo tenga sus 4 cortes y sus indicadores por defecto
  Future<void> asegurarEstructuraDefault(int anioLectivoId) async {
    final database = await _dbHelper.database;

    // 1. Asegurar cortes
    final cortesDefault = [
      db.CortesEvaluativosCompanion.insert(
        anioLectivoId: anioLectivoId,
        numero: 1,
        nombre: '1er Corte',
        puntosTotales: const Value(100),
        activo: const Value(true),
      ),
      db.CortesEvaluativosCompanion.insert(
        anioLectivoId: anioLectivoId,
        numero: 2,
        nombre: '2do Corte',
        puntosTotales: const Value(100),
        activo: const Value(true),
      ),
      db.CortesEvaluativosCompanion.insert(
        anioLectivoId: anioLectivoId,
        numero: 3,
        nombre: '3er Corte',
        puntosTotales: const Value(100),
        activo: const Value(true),
      ),
      db.CortesEvaluativosCompanion.insert(
        anioLectivoId: anioLectivoId,
        numero: 4,
        nombre: '4to Corte',
        puntosTotales: const Value(100),
        activo: const Value(true),
      ),
    ];

    for (final companion in cortesDefault) {
      // Verificar si ya existe
      final existente = await (database.cortesEvaluativos.select()
        ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
        ..where((tbl) => tbl.numero.equals(companion.numero.value)))
        .getSingleOrNull();

      int corteId;
      if (existente == null) {
        corteId = await database.into(database.cortesEvaluativos).insert(companion);
      } else {
        corteId = existente.id;
      }

      // 2. Asegurar indicadores para cada corte (5 indicadores de 20 pts cada uno)
      for (int i = 1; i <= 5; i++) {
        final indicadorExistente = await (database.indicadoresEvaluacion.select()
          ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
          ..where((tbl) => tbl.corteId.equals(corteId))
          ..where((tbl) => tbl.numero.equals(i)))
          .getSingleOrNull();

        if (indicadorExistente == null) {
          await database.into(database.indicadoresEvaluacion).insert(
            db.IndicadoresEvaluacionCompanion.insert(
              anioLectivoId: anioLectivoId,
              corteId: corteId,
              numero: i,
              descripcion: 'Indicador $i',
              puntosTotales: const Value(20),
              activo: const Value(true),
            ),
          );
        }
      }
    }
  }

  // Helper methods for conversion
  CorteEvaluativo _fromDrift(db.CortesEvaluativo row) => CorteEvaluativo(
      id: row.id,
      anioLectivoId: row.anioLectivoId,
      numero: row.numero,
      nombre: row.nombre,
      puntosTotales: row.puntosTotales,
      activo: row.activo,
    );

  db.CortesEvaluativosCompanion _toCompanion(CorteEvaluativo corte) => db.CortesEvaluativosCompanion.insert(
      id: corte.id != null ? Value(corte.id!) : const Value.absent(),
      anioLectivoId: corte.anioLectivoId,
      numero: corte.numero,
      nombre: corte.nombre,
      puntosTotales: Value(corte.puntosTotales),
      activo: Value(corte.activo),
    );
}

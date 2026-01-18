import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

// Nota: Para que esto funcione en Web, debes colocar 'sqlite3.wasm' y 'drift_worker.js' 
// en la carpeta 'web/' de tu proyecto. 
// Puedes descargarlos de: https://github.com/simolus3/sqlite3.dart/releases
LazyDatabase openDatabase() => LazyDatabase(() async {
      final result = await WasmDatabase.open(
        databaseName: 'keimagrade',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      return result.resolvedExecutor;
    });

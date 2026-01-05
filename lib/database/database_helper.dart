import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Initialize sqflite_common_ffi for desktop platforms
    databaseFactory = databaseFactoryFfi;
    
    final String path = join(await getDatabasesPath(), 'keimagrade.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabla de Anos Lectivos
    await db.execute('''
      CREATE TABLE anos_lectivos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anio INTEGER NOT NULL UNIQUE,
        activo INTEGER NOT NULL DEFAULT 1,
        porDefecto INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tabla de Colegios
    await db.execute('''
      CREATE TABLE colegios (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        direccion TEXT NOT NULL,
        telefono TEXT NOT NULL,
        email TEXT NOT NULL,
        director TEXT NOT NULL,
        activo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Tabla de Asignaturas
    await db.execute('''
      CREATE TABLE asignaturas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        codigo TEXT NOT NULL UNIQUE,
        horas INTEGER NOT NULL,
        activo INTEGER NOT NULL DEFAULT 1,
        cualitativo INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tabla de Grados
    await db.execute('''
      CREATE TABLE grados (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        activo INTEGER NOT NULL DEFAULT 1,
        cualitativo INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // Tabla de Secciones
    await db.execute('''
      CREATE TABLE secciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        letra TEXT NOT NULL UNIQUE,
        activo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Tabla de Cortes Evaluativos
    await db.execute('''
      CREATE TABLE cortes_evaluativos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        numero INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        puntosTotales INTEGER NOT NULL DEFAULT 100,
        activo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Tabla de Indicadores de Evaluación
    await db.execute('''
      CREATE TABLE indicadores_evaluacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        corteId INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        puntosTotales INTEGER NOT NULL DEFAULT 20,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (corteId) REFERENCES cortes_evaluativos(id)
      )
    ''');

    // Tabla de Criterios de Evaluación
    await db.execute('''
      CREATE TABLE criterios_evaluacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        indicadorId INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        puntosMaximos INTEGER NOT NULL DEFAULT 8,
        puntosObtenidos INTEGER NOT NULL DEFAULT 0,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (indicadorId) REFERENCES indicadores_evaluacion(id)
      )
    ''');

    // Tabla de Estudiantes
    await db.execute('''
      CREATE TABLE estudiantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        apellido TEXT NOT NULL,
        numero_identidad TEXT,
        telefono TEXT,
        email TEXT,
        direccion TEXT,
        activo INTEGER NOT NULL DEFAULT 1
      )
    ''');

    // Tabla de Asignaciones de Estudiantes (relación con año, colegio, asignatura, grado, sección)
    await db.execute('''
      CREATE TABLE estudiantes_asignaciones (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudiante_id INTEGER NOT NULL,
        anio_lectivo_id INTEGER NOT NULL,
        colegio_id INTEGER NOT NULL,
        asignatura_id INTEGER NOT NULL,
        grado_id INTEGER NOT NULL,
        seccion_id INTEGER NOT NULL,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
        FOREIGN KEY (anio_lectivo_id) REFERENCES anos_lectivos(id),
        FOREIGN KEY (colegio_id) REFERENCES colegios(id),
        FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id),
        FOREIGN KEY (grado_id) REFERENCES grados(id),
        FOREIGN KEY (seccion_id) REFERENCES secciones(id),
        UNIQUE(estudiante_id, anio_lectivo_id, colegio_id, asignatura_id, grado_id, seccion_id)
      )
    ''');

    // Insertar datos por defecto
    await _insertDefaultData(db);
  }

  Future<void> _insertDefaultData(Database db) async {
    // Insertar grados por defecto (1er a 6to grado)
    final grados = [
      {'numero': 1, 'nombre': '1er Grado', 'cualitativo': 1},
      {'numero': 2, 'nombre': '2do Grado', 'cualitativo': 1},
      {'numero': 3, 'nombre': '3er Grado', 'cualitativo': 1},
      {'numero': 4, 'nombre': '4to Grado', 'cualitativo': 0},
      {'numero': 5, 'nombre': '5to Grado', 'cualitativo': 0},
      {'numero': 6, 'nombre': '6to Grado', 'cualitativo': 0},
    ];

    for (final grado in grados) {
      await db.insert('grados', grado);
    }

    // Insertar secciones por defecto (A, B, C, D)
    final secciones = [
      {'letra': 'A'},
      {'letra': 'B'},
      {'letra': 'C'},
      {'letra': 'D'},
    ];

    for (final seccion in secciones) {
      await db.insert('secciones', seccion);
    }

    // Insertar año lectivo por defecto
    await db.insert('anos_lectivos', {
      'anio': 2026,
      'activo': 1,
      'porDefecto': 1,
    });

    // Insertar colegios por defecto
    await db.insert('colegios', {
      'nombre': 'Candelario Sotelo',
      'direccion': '',
      'telefono': '',
      'email': '',
      'director': '',
      'activo': 1,
    });

    await db.insert('colegios', {
      'nombre': 'Manuel Ignacio Pereira Quintana',
      'direccion': '',
      'telefono': '',
      'email': '',
      'director': '',
      'activo': 1,
    });

    // Insertar asignaturas por defecto
    final asignaturas = [
      {'nombre': 'TAC', 'codigo': 'TAC', 'horas': 2, 'cualitativo': 1},
      {'nombre': 'Derecho & Dignidad de la Mujer', 'codigo': 'DDM', 'horas': 1, 'cualitativo': 1},
      {'nombre': 'Creciendo en Valores', 'codigo': 'CV', 'horas': 1, 'cualitativo': 1},
      {'nombre': 'AEP', 'codigo': 'AEP', 'horas': 1, 'cualitativo': 1},
      {'nombre': 'Matemática', 'codigo': 'MAT', 'horas': 4, 'cualitativo': 0},
      {'nombre': 'Lengua & Literatura', 'codigo': 'LEL', 'horas': 4, 'cualitativo': 0},
      {'nombre': 'Inglés', 'codigo': 'ING', 'horas': 2, 'cualitativo': 0},
      {'nombre': 'Ciencias Sociales', 'codigo': 'CS', 'horas': 2, 'cualitativo': 0},
      {'nombre': 'Ciencias Naturales', 'codigo': 'CN', 'horas': 2, 'cualitativo': 0},
    ];

    for (final asignatura in asignaturas) {
      await db.insert('asignaturas', asignatura);
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('anos_lectivos');
    await db.delete('colegios');
    await db.delete('asignaturas');
    await db.delete('grados');
    await db.delete('secciones');

    // Close the database connection to force a fresh connection on next access
    await close();
  }

  Future<void> resetDatabase() async {
    await clearAllData();
    // Force re-creation of database with new schema
    _database = null;
    await database; // This will trigger _initDatabase again
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Agregar tabla de asignaciones de estudiantes
      await db.execute('''
        CREATE TABLE IF NOT EXISTS estudiantes_asignaciones (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          estudiante_id INTEGER NOT NULL,
          anio_lectivo_id INTEGER NOT NULL,
          colegio_id INTEGER NOT NULL,
          asignatura_id INTEGER NOT NULL,
          grado_id INTEGER NOT NULL,
          seccion_id INTEGER NOT NULL,
          activo INTEGER NOT NULL DEFAULT 1,
          FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
          FOREIGN KEY (anio_lectivo_id) REFERENCES anos_lectivos(id),
          FOREIGN KEY (colegio_id) REFERENCES colegios(id),
          FOREIGN KEY (asignatura_id) REFERENCES asignaturas(id),
          FOREIGN KEY (grado_id) REFERENCES grados(id),
          FOREIGN KEY (seccion_id) REFERENCES secciones(id),
          UNIQUE(estudiante_id, anio_lectivo_id, colegio_id, asignatura_id, grado_id, seccion_id)
        )
      ''');
    }
  }
}

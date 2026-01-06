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
      version: 6,
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
        anio_lectivo_id INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        nombre TEXT NOT NULL,
        puntosTotales INTEGER NOT NULL DEFAULT 100,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (anio_lectivo_id) REFERENCES anos_lectivos(id),
        UNIQUE(anio_lectivo_id, numero)
      )
    ''');

    // Tabla de Indicadores de Evaluación
    await db.execute('''
      CREATE TABLE indicadores_evaluacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anio_lectivo_id INTEGER NOT NULL,
        corteId INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        puntosTotales INTEGER NOT NULL DEFAULT 20,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (anio_lectivo_id) REFERENCES anos_lectivos(id),
        FOREIGN KEY (corteId) REFERENCES cortes_evaluativos(id),
        UNIQUE(anio_lectivo_id, corteId, numero)
      )
    ''');

    // Tabla de Criterios de Evaluación
    await db.execute('''
      CREATE TABLE criterios_evaluacion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anio_lectivo_id INTEGER NOT NULL,
        indicadorId INTEGER NOT NULL,
        numero INTEGER NOT NULL,
        descripcion TEXT NOT NULL,
        puntosMaximos INTEGER NOT NULL DEFAULT 8,
        puntosObtenidos INTEGER NOT NULL DEFAULT 0,
        activo INTEGER NOT NULL DEFAULT 1,
        FOREIGN KEY (anio_lectivo_id) REFERENCES anos_lectivos(id),
        FOREIGN KEY (indicadorId) REFERENCES indicadores_evaluacion(id),
        UNIQUE(anio_lectivo_id, indicadorId, numero)
      )
    ''');

    // Tabla de Estudiantes
    await db.execute('''
      CREATE TABLE estudiantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudiante TEXT NOT NULL,
        numero_identidad TEXT,
        telefono TEXT,
        email TEXT,
        direccion TEXT,
        sexo TEXT,
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

    // Tabla de Notas de Estudiantes (almacena la calificación individual por criterio)
    await db.execute('''
      CREATE TABLE notas_estudiantes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudiante_id INTEGER NOT NULL,
        criterio_id INTEGER NOT NULL,
        valor_cualitativo TEXT, -- AA, AS, AF, AI
        puntos_obtenidos REAL NOT NULL,
        FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
        FOREIGN KEY (criterio_id) REFERENCES criterios_evaluacion(id),
        UNIQUE(estudiante_id, criterio_id)
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
      {
        'nombre': 'Derecho & Dignidad de la Mujer',
        'codigo': 'DDM',
        'horas': 1,
        'cualitativo': 1
      },
      {
        'nombre': 'Creciendo en Valores',
        'codigo': 'CV',
        'horas': 1,
        'cualitativo': 1
      },
      {'nombre': 'AEP', 'codigo': 'AEP', 'horas': 1, 'cualitativo': 1},
      {'nombre': 'Matemática', 'codigo': 'MAT', 'horas': 4, 'cualitativo': 0},
      {
        'nombre': 'Lengua & Literatura',
        'codigo': 'LEL',
        'horas': 4,
        'cualitativo': 0
      },
      {'nombre': 'Inglés', 'codigo': 'ING', 'horas': 2, 'cualitativo': 0},
      {
        'nombre': 'Ciencias Sociales',
        'codigo': 'CS',
        'horas': 2,
        'cualitativo': 0
      },
      {
        'nombre': 'Ciencias Naturales',
        'codigo': 'CN',
        'horas': 2,
        'cualitativo': 0
      },
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

    // Note: Database connection remains open for app continuity
  }

  Future<void> clearAllStudents() async {
    final db = await database;
    // Delete in correct order to respect foreign key constraints
    await db.delete('criterios_evaluacion');
    await db.delete('indicadores_evaluacion');
    await db.delete('cortes_evaluativos');
    await db.delete('estudiantes_asignaciones');
    await db.delete('estudiantes');

    // Note: Database connection remains open for app continuity
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

    if (oldVersion < 3) {
      // Agregar relación con año lectivo a las tablas de evaluación
      // Primero obtener el ID del año lectivo por defecto
      final defaultAnioResult = await db
          .query('anos_lectivos', where: 'porDefecto = ?', whereArgs: [1]);
      final defaultAnioId = defaultAnioResult.isNotEmpty
          ? defaultAnioResult.first['id'] as int
          : 1;

      // Agregar columnas anio_lectivo_id a las tablas existentes usando valores literales
      await db.execute(
          'ALTER TABLE cortes_evaluativos ADD COLUMN anio_lectivo_id INTEGER NOT NULL DEFAULT $defaultAnioId');
      await db.execute(
          'ALTER TABLE indicadores_evaluacion ADD COLUMN anio_lectivo_id INTEGER NOT NULL DEFAULT $defaultAnioId');
      await db.execute(
          'ALTER TABLE criterios_evaluacion ADD COLUMN anio_lectivo_id INTEGER NOT NULL DEFAULT $defaultAnioId');

      // Crear cortes por defecto para el año lectivo por defecto
      final cortesDefault = [
        {
          'anio_lectivo_id': defaultAnioId,
          'numero': 1,
          'nombre': '1er Corte',
          'puntosTotales': 100,
          'activo': 1
        },
        {
          'anio_lectivo_id': defaultAnioId,
          'numero': 2,
          'nombre': '2do Corte',
          'puntosTotales': 100,
          'activo': 1
        },
        {
          'anio_lectivo_id': defaultAnioId,
          'numero': 3,
          'nombre': '3er Corte',
          'puntosTotales': 100,
          'activo': 1
        },
        {
          'anio_lectivo_id': defaultAnioId,
          'numero': 4,
          'nombre': '4to Corte',
          'puntosTotales': 100,
          'activo': 1
        },
      ];

      for (final corte in cortesDefault) {
        await db.insert('cortes_evaluativos', corte);
      }

      // Agregar restricciones de unicidad
      try {
        await db.execute(
            'CREATE UNIQUE INDEX idx_cortes_anio_numero ON cortes_evaluativos(anio_lectivo_id, numero)');
        await db.execute(
            'CREATE UNIQUE INDEX idx_indicadores_anio_corte_numero ON indicadores_evaluacion(anio_lectivo_id, corteId, numero)');
        await db.execute(
            'CREATE UNIQUE INDEX idx_criterios_anio_indicador_numero ON criterios_evaluacion(anio_lectivo_id, indicadorId, numero)');
      } catch (e) {
        // Ignorar errores si los índices ya existen
      }
    }

    if (oldVersion < 4) {
      // Agregar columna sexo a la tabla estudiantes
      try {
        await db.execute('ALTER TABLE estudiantes ADD COLUMN sexo TEXT');
      } catch (e) {
        // Ignorar si la columna ya existe
      }
    }

    if (oldVersion < 5) {
      // Migrar de columnas 'nombre' y 'apellido' a columna 'estudiante'
      try {
        // Primero agregar la nueva columna
        await db
            .execute('ALTER TABLE estudiantes ADD COLUMN estudiante_temp TEXT');

        // Migrar los datos existentes combinando nombre y apellido
        await db.execute('''
          UPDATE estudiantes
          SET estudiante_temp = TRIM(COALESCE(nombre, '') || ' ' || COALESCE(apellido, ''))
          WHERE estudiante_temp IS NULL
        ''');

        // Eliminar las columnas viejas
        await db.execute('ALTER TABLE estudiantes DROP COLUMN nombre');
        await db.execute('ALTER TABLE estudiantes DROP COLUMN apellido');

        // Renombrar la columna temporal
        await db.execute(
            'ALTER TABLE estudiantes RENAME COLUMN estudiante_temp TO estudiante');

        // Hacer la columna NOT NULL
        await db.execute('''
          CREATE TABLE estudiantes_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            estudiante TEXT NOT NULL,
            numero_identidad TEXT,
            telefono TEXT,
            email TEXT,
            direccion TEXT,
            sexo TEXT,
            activo INTEGER NOT NULL DEFAULT 1
          )
        ''');

        // Copiar datos a la nueva tabla
        await db.execute('''
          INSERT INTO estudiantes_new (id, estudiante, numero_identidad, telefono, email, direccion, sexo, activo)
          SELECT id, estudiante, numero_identidad, telefono, email, direccion, sexo, activo
          FROM estudiantes
        ''');

        // Reemplazar la tabla antigua
        await db.execute('DROP TABLE estudiantes');
        await db.execute('ALTER TABLE estudiantes_new RENAME TO estudiantes');
      } catch (e) {
        print('Error durante migración a estudiante único: $e');
        // Si hay error, intentar crear la columna estudiante si no existe
        try {
          await db.execute(
              'ALTER TABLE estudiantes ADD COLUMN estudiante TEXT NOT NULL DEFAULT \'\'');
        } catch (e2) {
          // Ignorar si ya existe
        }
      }
    }

    if (oldVersion < 6) {
      // Agregar tabla de notas de estudiantes
      await db.execute('''
        CREATE TABLE IF NOT EXISTS notas_estudiantes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          estudiante_id INTEGER NOT NULL,
          criterio_id INTEGER NOT NULL,
          valor_cualitativo TEXT,
          puntos_obtenidos REAL NOT NULL,
          FOREIGN KEY (estudiante_id) REFERENCES estudiantes(id),
          FOREIGN KEY (criterio_id) REFERENCES criterios_evaluacion(id),
          UNIQUE(estudiante_id, criterio_id)
        )
      ''');
    }
  }
}

import 'package:drift/drift.dart';

// Conditional imports for different platforms
import 'database_web.dart' if (dart.library.io) 'database_mobile.dart';

part 'database.g.dart';

// Tabla de Años Lectivos
class AnosLectivos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get anio => integer()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  BoolColumn get porDefecto => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [{anio}];
}

// Tabla de Colegios
class Colegios extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get direccion => text()();
  TextColumn get telefono => text()();
  TextColumn get email => text()();
  TextColumn get director => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

// Tabla de Asignaturas
class Asignaturas extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nombre => text()();
  TextColumn get codigo => text()();
  IntColumn get horas => integer()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  BoolColumn get cualitativo => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [{codigo}];
}

// Tabla de Grados
class Grados extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get numero => integer()();
  TextColumn get nombre => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  BoolColumn get cualitativo => boolean().withDefault(const Constant(false))();
}

// Tabla de Secciones
class Secciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get letra => text()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{letra}];
}

// Tabla de Cortes Evaluativos
class CortesEvaluativos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get anioLectivoId => integer().references(AnosLectivos, #id)();
  IntColumn get numero => integer()();
  TextColumn get nombre => text()();
  IntColumn get puntosTotales => integer().withDefault(const Constant(100))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{anioLectivoId, numero}];
}

// Tabla de Indicadores de Evaluación
class IndicadoresEvaluacion extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get anioLectivoId => integer().references(AnosLectivos, #id)();
  IntColumn get corteId => integer().references(CortesEvaluativos, #id)();
  IntColumn get numero => integer()();
  TextColumn get descripcion => text()();
  RealColumn get puntosTotales => real().withDefault(const Constant(20))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{anioLectivoId, corteId, numero}];
}

// Tabla de Criterios de Evaluación
class CriteriosEvaluacion extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get anioLectivoId => integer().references(AnosLectivos, #id)();
  IntColumn get indicadorId => integer().references(IndicadoresEvaluacion, #id)();
  IntColumn get numero => integer()();
  TextColumn get descripcion => text()();
  RealColumn get puntosMaximos => real().withDefault(const Constant(8))();
  RealColumn get puntosObtenidos => real().withDefault(const Constant(0))();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{anioLectivoId, indicadorId, numero}];
}

// Tabla de Estudiantes
class Estudiantes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get estudiante => text()();
  TextColumn get numeroIdentidad => text().nullable()();
  TextColumn get telefono => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get direccion => text().nullable()();
  TextColumn get sexo => text().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
}

// Tabla de Asignaciones de Estudiantes
class EstudiantesAsignaciones extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get estudianteId => integer().references(Estudiantes, #id)();
  IntColumn get anioLectivoId => integer().references(AnosLectivos, #id)();
  IntColumn get colegioId => integer().references(Colegios, #id)();
  IntColumn get asignaturaId => integer().references(Asignaturas, #id)();
  IntColumn get gradoId => integer().references(Grados, #id)();
  IntColumn get seccionId => integer().references(Secciones, #id)();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();

  @override
  List<Set<Column>> get uniqueKeys => [{
    estudianteId, anioLectivoId, colegioId, asignaturaId, gradoId, seccionId
  }];
}

// Tabla de Notas de Estudiantes
class NotasEstudiantes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get estudianteId => integer().references(Estudiantes, #id)();
  IntColumn get criterioId => integer().references(CriteriosEvaluacion, #id)();
  TextColumn get valorCualitativo => text().nullable()();
  RealColumn get puntosObtenidos => real()();

  @override
  List<Set<Column>> get uniqueKeys => [{estudianteId, criterioId}];
}

@DriftDatabase(tables: [
  AnosLectivos,
  Colegios,
  Asignaturas,
  Grados,
  Secciones,
  CortesEvaluativos,
  IndicadoresEvaluacion,
  CriteriosEvaluacion,
  Estudiantes,
  EstudiantesAsignaciones,
  NotasEstudiantes,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _insertDefaultData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Migration logic for version 2
        }
        if (from < 3) {
          // Migration logic for version 3
        }
        if (from < 4) {
          // Migration logic for version 4
        }
        if (from < 5) {
          // Migration logic for version 5
        }
        if (from < 6) {
          // Migration logic for version 6
        }
      },
    );

  Future<void> _insertDefaultData() async {
    // Insertar grados por defecto
    final gradosData = [
      GradosCompanion.insert(
        numero: 1,
        nombre: '1er Grado',
        cualitativo: const Value(true),
      ),
      GradosCompanion.insert(
        numero: 2,
        nombre: '2do Grado',
        cualitativo: const Value(true),
      ),
      GradosCompanion.insert(
        numero: 3,
        nombre: '3er Grado',
        cualitativo: const Value(true),
      ),
      GradosCompanion.insert(
        numero: 4,
        nombre: '4to Grado',
        cualitativo: const Value(false),
      ),
      GradosCompanion.insert(
        numero: 5,
        nombre: '5to Grado',
        cualitativo: const Value(false),
      ),
      GradosCompanion.insert(
        numero: 6,
        nombre: '6to Grado',
        cualitativo: const Value(false),
      ),
    ];

    for (final grado in gradosData) {
      await into(grados).insert(grado);
    }

    // Insertar secciones por defecto
    final secciones = ['A', 'B', 'C', 'D'];
    for (final seccion in secciones) {
      await into(this.secciones).insert(
        SeccionesCompanion.insert(letra: seccion),
      );
    }

    // Nota: El año lectivo por defecto se crea a través del AnioLectivoProvider
    // para asegurar que también se creen los cortes, indicadores y criterios correspondientes.

    // Insertar colegios por defecto
    await into(colegios).insert(
      ColegiosCompanion.insert(
        nombre: 'Candelario Sotelo',
        direccion: '',
        telefono: '',
        email: '',
        director: '',
      ),
    );

    await into(colegios).insert(
      ColegiosCompanion.insert(
        nombre: 'Manuel Ignacio Pereira Quintana',
        direccion: '',
        telefono: '',
        email: '',
        director: '',
      ),
    );

    // Insertar asignaturas por defecto
    final asignaturas = [
      AsignaturasCompanion.insert(
        nombre: 'TAC',
        codigo: 'TAC',
        horas: 2,
        cualitativo: const Value(true),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Derecho & Dignidad de la Mujer',
        codigo: 'DDM',
        horas: 1,
        cualitativo: const Value(true),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Creciendo en Valores',
        codigo: 'CV',
        horas: 1,
        cualitativo: const Value(true),
      ),
      AsignaturasCompanion.insert(
        nombre: 'AEP',
        codigo: 'AEP',
        horas: 1,
        cualitativo: const Value(true),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Matemática',
        codigo: 'MAT',
        horas: 4,
        cualitativo: const Value(false),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Lengua & Literatura',
        codigo: 'LEL',
        horas: 4,
        cualitativo: const Value(false),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Inglés',
        codigo: 'ING',
        horas: 2,
        cualitativo: const Value(false),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Ciencias Sociales',
        codigo: 'CS',
        horas: 2,
        cualitativo: const Value(false),
      ),
      AsignaturasCompanion.insert(
        nombre: 'Ciencias Naturales',
        codigo: 'CN',
        horas: 2,
        cualitativo: const Value(false),
      ),
    ];

    for (final asignatura in asignaturas) {
      await into(this.asignaturas).insert(asignatura);
    }
  }

  // Helper methods for clearing data
  Future<void> clearAllData() async {
    await delete(anosLectivos).go();
    await delete(colegios).go();
    await delete(asignaturas).go();
    await delete(grados).go();
    await delete(secciones).go();
  }

  Future<void> clearAllStudents() async {
    await delete(criteriosEvaluacion).go();
    await delete(indicadoresEvaluacion).go();
    await delete(cortesEvaluativos).go();
    await delete(estudiantesAsignaciones).go();
    await delete(estudiantes).go();
  }

  Future<void> resetDatabase() async {
    await clearAllData();
    await close();
    // Database will be recreated on next access
  }
}

LazyDatabase _openConnection() => openDatabase();

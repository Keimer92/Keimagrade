import 'package:drift/drift.dart';
import '../database/database.dart' as db;
import '../database/database_helper.dart';
import '../models/estudiante.dart';

class EstudianteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Estudiante>> obtenerTodos() async {
    final database = await _dbHelper.database;
    final estudiantes = await database.estudiantes.select().get();
    return estudiantes.map(_fromDrift).toList();
  }

  Future<List<Estudiante>> obtenerActivos() async {
    final database = await _dbHelper.database;
    final estudiantes = await (database.estudiantes.select()
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return estudiantes.map(_fromDrift).toList();
  }

  Future<Estudiante?> obtenerPorId(int id) async {
    final database = await _dbHelper.database;
    final estudiantes = await (database.estudiantes.select()
      ..where((tbl) => tbl.id.equals(id)))
      .get();
    if (estudiantes.isNotEmpty) {
      return _fromDrift(estudiantes.first);
    }
    return null;
  }

  /// Busca un estudiante por nombre completo
  Future<Estudiante?> buscarPorNombreCompleto(String nombreCompleto) async {
    final database = await _dbHelper.database;
    final estudiante = await (database.estudiantes.select()
      ..where((tbl) => tbl.estudiante.lower().equals(nombreCompleto.toLowerCase().trim())))
      .getSingleOrNull();
    return estudiante != null ? _fromDrift(estudiante) : null;
  }

  Future<int> crear(Estudiante estudiante) async {
    final database = await _dbHelper.database;
    return database.into(database.estudiantes).insert(_toCompanion(estudiante));
  }

  Future<bool> actualizar(Estudiante estudiante) async {
    final database = await _dbHelper.database;
    final affectedRows = await (database.estudiantes.update()
      ..where((tbl) => tbl.id.equals(estudiante.id!)))
      .write(_toCompanion(estudiante));
    return affectedRows > 0;
  }

  Future<int> eliminar(int id) async {
    final database = await _dbHelper.database;
    return (database.estudiantes.delete()
      ..where((tbl) => tbl.id.equals(id)))
      .go();
  }

  // ============== MÉTODOS PARA ASIGNACIONES ==============

  /// Verifica si existe una asignación específica
  Future<bool> existeAsignacion({
    required int estudianteId,
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final database = await _dbHelper.database;
    final asignacion = await (database.estudiantesAsignaciones.select()
      ..where((tbl) => tbl.estudianteId.equals(estudianteId))
      ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
      ..where((tbl) => tbl.colegioId.equals(colegioId))
      ..where((tbl) => tbl.asignaturaId.equals(asignaturaId))
      ..where((tbl) => tbl.gradoId.equals(gradoId))
      ..where((tbl) => tbl.seccionId.equals(seccionId)))
      .getSingleOrNull();
    return asignacion != null;
  }

  /// Crea una asignación de estudiante
  Future<int> crearAsignacion({
    required int estudianteId,
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final database = await _dbHelper.database;
    return database.into(database.estudiantesAsignaciones).insert(
      db.EstudiantesAsignacionesCompanion.insert(
        estudianteId: estudianteId,
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
        gradoId: gradoId,
        seccionId: seccionId,
        activo: const Value(true),
      ),
    );
  }

  /// Obtiene los IDs de estudiantes asignados a un grupo específico
  Future<List<int>> obtenerEstudiantesAsignados({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final database = await _dbHelper.database;
    final asignaciones = await (database.estudiantesAsignaciones.select()
      ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
      ..where((tbl) => tbl.colegioId.equals(colegioId))
      ..where((tbl) => tbl.asignaturaId.equals(asignaturaId))
      ..where((tbl) => tbl.gradoId.equals(gradoId))
      ..where((tbl) => tbl.seccionId.equals(seccionId))
      ..where((tbl) => tbl.activo.equals(true)))
      .get();
    return asignaciones.map((a) => a.estudianteId).toList();
  }

  /// Obtiene los objetos Estudiante asignados a un grupo específico con filtro opcional de sexo
  Future<List<Estudiante>> obtenerPorAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
    String? sexo,
  }) async {
    final database = await _dbHelper.database;

    final query = database.select(database.estudiantes).join([
      innerJoin(
        database.estudiantesAsignaciones,
        database.estudiantesAsignaciones.estudianteId
            .equalsExp(database.estudiantes.id),
      ),
    ])
      ..where(
          database.estudiantesAsignaciones.anioLectivoId.equals(anioLectivoId))
      ..where(database.estudiantesAsignaciones.colegioId.equals(colegioId))
      ..where(
          database.estudiantesAsignaciones.asignaturaId.equals(asignaturaId))
      ..where(database.estudiantesAsignaciones.gradoId.equals(gradoId))
      ..where(database.estudiantesAsignaciones.seccionId.equals(seccionId))
      ..where(database.estudiantesAsignaciones.activo.equals(true));

    if (sexo != null && sexo.isNotEmpty) {
      query.where(database.estudiantes.sexo.equals(sexo));
    }

    query.orderBy([OrderingTerm(expression: database.estudiantes.estudiante)]);

    final rows = await query.get();
    return rows
        .map((row) => _fromDrift(row.readTable(database.estudiantes)))
        .toList();
  }

  /// Obtiene los objetos Estudiante asignados a un grupo específico
  Future<List<Estudiante>> obtenerEstudiantesDetalleAsignados({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) =>
      obtenerPorAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
        gradoId: gradoId,
        seccionId: seccionId,
      );

  /// Elimina una asignación
  Future<int> eliminarAsignacion({
    required int estudianteId,
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final database = await _dbHelper.database;
    return (database.estudiantesAsignaciones.delete()
      ..where((tbl) => tbl.estudianteId.equals(estudianteId))
      ..where((tbl) => tbl.anioLectivoId.equals(anioLectivoId))
      ..where((tbl) => tbl.colegioId.equals(colegioId))
      ..where((tbl) => tbl.asignaturaId.equals(asignaturaId))
      ..where((tbl) => tbl.gradoId.equals(gradoId))
      ..where((tbl) => tbl.seccionId.equals(seccionId)))
      .go();
  }

  // Helper methods for conversion
  Estudiante _fromDrift(db.Estudiante row) => Estudiante(
      id: row.id,
      estudiante: row.estudiante,
      numeroIdentidad: row.numeroIdentidad,
      telefono: row.telefono,
      email: row.email,
      direccion: row.direccion,
      sexo: row.sexo,
      activo: row.activo,
    );

  db.EstudiantesCompanion _toCompanion(Estudiante estudiante) => db.EstudiantesCompanion.insert(
      id: estudiante.id != null ? Value(estudiante.id!) : const Value.absent(),
      estudiante: estudiante.estudiante,
      numeroIdentidad: Value(estudiante.numeroIdentidad),
      telefono: Value(estudiante.telefono),
      email: Value(estudiante.email),
      direccion: Value(estudiante.direccion),
      sexo: Value(estudiante.sexo),
      activo: Value(estudiante.activo),
    );

  // ============== MÉTODOS AUXILIARES PARA IMPORTACIÓN ==============

  /// Busca o crea un año lectivo por su número de año
  Future<int> buscarOCrearAnioLectivo(int anio) async {
    final database = await _dbHelper.database;
    final row = await (database.select(database.anosLectivos)
          ..where((t) => t.anio.equals(anio)))
        .getSingleOrNull();

    if (row != null) {
      return row.id;
    }
    // Crear nuevo año lectivo
    return database.into(database.anosLectivos).insert(
          db.AnosLectivosCompanion.insert(
            anio: anio,
            activo: const Value(true),
            porDefecto: const Value(false),
          ),
        );
  }

  /// Busca o crea un colegio por nombre
  Future<int> buscarOCrearColegio(String nombre) async {
    final database = await _dbHelper.database;
    final row = await (database.select(database.colegios)
          ..where((t) => t.nombre.lower().equals(nombre.toLowerCase().trim())))
        .getSingleOrNull();

    if (row != null) {
      return row.id;
    }
    // Crear nuevo colegio
    return database.into(database.colegios).insert(
          db.ColegiosCompanion.insert(
            nombre: nombre.trim(),
            direccion: '',
            telefono: '',
            email: '',
            director: '',
            activo: const Value(true),
          ),
        );
  }

  /// Busca o crea una asignatura por nombre
  Future<int> buscarOCrearAsignatura(String nombre) async {
    final database = await _dbHelper.database;
    final row = await (database.select(database.asignaturas)
          ..where((t) => t.nombre.lower().equals(nombre.toLowerCase().trim())))
        .getSingleOrNull();

    if (row != null) {
      return row.id;
    }
    // Generar código único
    final codigo = nombre.trim().toUpperCase().substring(0, nombre.length > 3 ? 3 : nombre.length) +
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    // Crear nueva asignatura
    return database.into(database.asignaturas).insert(
          db.AsignaturasCompanion.insert(
            nombre: nombre.trim(),
            codigo: codigo,
            horas: 2,
            activo: const Value(true),
            cualitativo: const Value(false),
          ),
        );
  }

  /// Busca o crea un grado por nombre
  Future<int> buscarOCrearGrado(String nombre) async {
    final database = await _dbHelper.database;
    final row = await (database.select(database.grados)
          ..where((t) => t.nombre.lower().equals(nombre.toLowerCase().trim())))
        .getSingleOrNull();

    if (row != null) {
      return row.id;
    }
    // Intentar extraer número del nombre (ej: "1er Grado" -> 1)
    final numeroMatch = RegExp(r'\d+').firstMatch(nombre);
    final numero = numeroMatch != null ? int.parse(numeroMatch.group(0)!) : 0;
    // Crear nuevo grado
    return database.into(database.grados).insert(
          db.GradosCompanion.insert(
            numero: numero,
            nombre: nombre.trim(),
            activo: const Value(true),
            cualitativo: const Value(false),
          ),
        );
  }

  /// Busca o crea una sección por letra
  Future<int> buscarOCrearSeccion(String letra) async {
    final database = await _dbHelper.database;
    final letraLimpia = letra.trim().toUpperCase();
    final row = await (database.select(database.secciones)
          ..where((t) => t.letra.upper().equals(letraLimpia)))
        .getSingleOrNull();

    if (row != null) {
      return row.id;
    }
    // Crear nueva sección
    return database.into(database.secciones).insert(
          db.SeccionesCompanion.insert(
            letra: letraLimpia,
            activo: const Value(true),
          ),
        );
  }

  // ============== MÉTODOS PARA FILTROS EN CASCADA ==============

  /// Obtiene los IDs de años lectivos que tienen asignaciones para un colegio
  Future<List<int>> obtenerAniosConAsignacion({required int colegioId}) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect(
      'SELECT DISTINCT anio_lectivo_id FROM estudiantes_asignaciones WHERE colegio_id = ? AND activo = 1 ORDER BY anio_lectivo_id DESC',
      variables: [Variable.withInt(colegioId)],
    ).get();
    return rows.map((row) => row.read<int>('anio_lectivo_id')).toList();
  }

  /// Obtiene los IDs de colegios que tienen asignaciones para un año lectivo
  Future<List<int>> obtenerColegiosConAsignacion({required int anioLectivoId}) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect(
      'SELECT DISTINCT colegio_id FROM estudiantes_asignaciones WHERE anio_lectivo_id = ? AND activo = 1',
      variables: [Variable.withInt(anioLectivoId)],
    ).get();
    return rows.map((row) => row.read<int>('colegio_id')).toList();
  }

  /// Obtiene los IDs de asignaturas que tienen asignaciones para un año y colegio
  Future<List<int>> obtenerAsignaturasConAsignacion({
    required int anioLectivoId,
    required int colegioId,
  }) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect(
      'SELECT DISTINCT asignatura_id FROM estudiantes_asignaciones WHERE anio_lectivo_id = ? AND colegio_id = ? AND activo = 1',
      variables: [Variable.withInt(anioLectivoId), Variable.withInt(colegioId)],
    ).get();
    return rows.map((row) => row.read<int>('asignatura_id')).toList();
  }

  /// Obtiene los IDs de grados que tienen asignaciones para un año, colegio y asignatura
  Future<List<int>> obtenerGradosConAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
  }) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect(
      'SELECT DISTINCT grado_id FROM estudiantes_asignaciones WHERE anio_lectivo_id = ? AND colegio_id = ? AND asignatura_id = ? AND activo = 1',
      variables: [
        Variable.withInt(anioLectivoId),
        Variable.withInt(colegioId),
        Variable.withInt(asignaturaId)
      ],
    ).get();
    return rows.map((row) => row.read<int>('grado_id')).toList();
  }

  /// Obtiene los IDs de secciones que tienen asignaciones para un año, colegio, asignatura y grado
  Future<List<int>> obtenerSeccionesConAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
  }) async {
    final database = await _dbHelper.database;
    final rows = await database.customSelect(
      'SELECT DISTINCT seccion_id FROM estudiantes_asignaciones WHERE anio_lectivo_id = ? AND colegio_id = ? AND asignatura_id = ? AND grado_id = ? AND activo = 1',
      variables: [
        Variable.withInt(anioLectivoId),
        Variable.withInt(colegioId),
        Variable.withInt(asignaturaId),
        Variable.withInt(gradoId)
      ],
    ).get();
    return rows.map((row) => row.read<int>('seccion_id')).toList();
  }
}

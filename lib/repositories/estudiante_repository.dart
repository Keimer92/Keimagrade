import '../database/database_helper.dart';
import '../models/estudiante.dart';

class EstudianteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<List<Estudiante>> obtenerTodos() async {
    final db = await _dbHelper.database;
    final maps = await db.query('estudiantes');
    return List.generate(maps.length, (i) => Estudiante.fromMap(maps[i]));
  }

  Future<List<Estudiante>> obtenerActivos() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'estudiantes',
      where: 'activo = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Estudiante.fromMap(maps[i]));
  }

  Future<Estudiante?> obtenerPorId(int id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'estudiantes',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Estudiante.fromMap(maps.first);
    }
    return null;
  }

  /// Busca un estudiante por nombre y apellido
  Future<Estudiante?> buscarPorNombreApellido(String nombre, String apellido) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'estudiantes',
      where: 'LOWER(nombre) = ? AND LOWER(apellido) = ?',
      whereArgs: [nombre.toLowerCase().trim(), apellido.toLowerCase().trim()],
    );
    if (maps.isNotEmpty) {
      return Estudiante.fromMap(maps.first);
    }
    return null;
  }

  Future<int> crear(Estudiante estudiante) async {
    final db = await _dbHelper.database;
    return db.insert('estudiantes', estudiante.toMap());
  }

  Future<int> actualizar(Estudiante estudiante) async {
    final db = await _dbHelper.database;
    return db.update(
      'estudiantes',
      estudiante.toMap(),
      where: 'id = ?',
      whereArgs: [estudiante.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _dbHelper.database;
    return db.delete(
      'estudiantes',
      where: 'id = ?',
      whereArgs: [id],
    );
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
    final db = await _dbHelper.database;
    final maps = await db.query(
      'estudiantes_asignaciones',
      where: 'estudiante_id = ? AND anio_lectivo_id = ? AND colegio_id = ? AND asignatura_id = ? AND grado_id = ? AND seccion_id = ?',
      whereArgs: [estudianteId, anioLectivoId, colegioId, asignaturaId, gradoId, seccionId],
    );
    return maps.isNotEmpty;
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
    final db = await _dbHelper.database;
    return db.insert('estudiantes_asignaciones', {
      'estudiante_id': estudianteId,
      'anio_lectivo_id': anioLectivoId,
      'colegio_id': colegioId,
      'asignatura_id': asignaturaId,
      'grado_id': gradoId,
      'seccion_id': seccionId,
      'activo': 1,
    });
  }

  /// Obtiene estudiantes filtrados por asignación
  Future<List<Estudiante>> obtenerPorAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
    required int seccionId,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT e.* FROM estudiantes e
      INNER JOIN estudiantes_asignaciones ea ON e.id = ea.estudiante_id
      WHERE ea.anio_lectivo_id = ? 
        AND ea.colegio_id = ? 
        AND ea.asignatura_id = ? 
        AND ea.grado_id = ? 
        AND ea.seccion_id = ?
        AND e.activo = 1
        AND ea.activo = 1
      ORDER BY e.apellido, e.nombre
    ''', [anioLectivoId, colegioId, asignaturaId, gradoId, seccionId]);
    return List.generate(maps.length, (i) => Estudiante.fromMap(maps[i]));
  }

  // ============== MÉTODOS AUXILIARES PARA IMPORTACIÓN ==============

  /// Busca o crea un año lectivo por su número de año
  Future<int> buscarOCrearAnioLectivo(int anio) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'anos_lectivos',
      where: 'anio = ?',
      whereArgs: [anio],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    // Crear nuevo año lectivo
    return db.insert('anos_lectivos', {
      'anio': anio,
      'activo': 1,
      'porDefecto': 0,
    });
  }

  /// Busca o crea un colegio por nombre
  Future<int> buscarOCrearColegio(String nombre) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'colegios',
      where: 'LOWER(nombre) = ?',
      whereArgs: [nombre.toLowerCase().trim()],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    // Crear nuevo colegio
    return db.insert('colegios', {
      'nombre': nombre.trim(),
      'direccion': '',
      'telefono': '',
      'email': '',
      'director': '',
      'activo': 1,
    });
  }

  /// Busca o crea una asignatura por nombre
  Future<int> buscarOCrearAsignatura(String nombre) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'asignaturas',
      where: 'LOWER(nombre) = ?',
      whereArgs: [nombre.toLowerCase().trim()],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    // Generar código único
    final codigo = nombre.trim().toUpperCase().substring(0, nombre.length > 3 ? 3 : nombre.length) +
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    // Crear nueva asignatura
    return db.insert('asignaturas', {
      'nombre': nombre.trim(),
      'codigo': codigo,
      'horas': 2,
      'activo': 1,
      'cualitativo': 0,
    });
  }

  /// Busca o crea un grado por nombre
  Future<int> buscarOCrearGrado(String nombre) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'grados',
      where: 'LOWER(nombre) = ?',
      whereArgs: [nombre.toLowerCase().trim()],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    // Intentar extraer número del nombre (ej: "1er Grado" -> 1)
    final numeroMatch = RegExp(r'\d+').firstMatch(nombre);
    final numero = numeroMatch != null ? int.parse(numeroMatch.group(0)!) : 0;
    // Crear nuevo grado
    return db.insert('grados', {
      'numero': numero,
      'nombre': nombre.trim(),
      'activo': 1,
      'cualitativo': 0,
    });
  }

  /// Busca o crea una sección por letra
  Future<int> buscarOCrearSeccion(String letra) async {
    final db = await _dbHelper.database;
    final letraLimpia = letra.trim().toUpperCase();
    final maps = await db.query(
      'secciones',
      where: 'UPPER(letra) = ?',
      whereArgs: [letraLimpia],
    );
    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }
    // Crear nueva sección
    return db.insert('secciones', {
      'letra': letraLimpia,
      'activo': 1,
    });
  }

  // ============== MÉTODOS PARA FILTROS EN CASCADA ==============

  /// Obtiene los IDs de colegios que tienen asignaciones para un año lectivo
  Future<List<int>> obtenerColegiosConAsignacion({required int anioLectivoId}) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT colegio_id FROM estudiantes_asignaciones 
      WHERE anio_lectivo_id = ? AND activo = 1
    ''', [anioLectivoId]);
    return maps.map((m) => m['colegio_id'] as int).toList();
  }

  /// Obtiene los IDs de asignaturas que tienen asignaciones para un año y colegio
  Future<List<int>> obtenerAsignaturasConAsignacion({
    required int anioLectivoId,
    required int colegioId,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT asignatura_id FROM estudiantes_asignaciones 
      WHERE anio_lectivo_id = ? AND colegio_id = ? AND activo = 1
    ''', [anioLectivoId, colegioId]);
    return maps.map((m) => m['asignatura_id'] as int).toList();
  }

  /// Obtiene los IDs de grados que tienen asignaciones para un año, colegio y asignatura
  Future<List<int>> obtenerGradosConAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT grado_id FROM estudiantes_asignaciones 
      WHERE anio_lectivo_id = ? AND colegio_id = ? AND asignatura_id = ? AND activo = 1
    ''', [anioLectivoId, colegioId, asignaturaId]);
    return maps.map((m) => m['grado_id'] as int).toList();
  }

  /// Obtiene los IDs de secciones que tienen asignaciones para un año, colegio, asignatura y grado
  Future<List<int>> obtenerSeccionesConAsignacion({
    required int anioLectivoId,
    required int colegioId,
    required int asignaturaId,
    required int gradoId,
  }) async {
    final db = await _dbHelper.database;
    final maps = await db.rawQuery('''
      SELECT DISTINCT seccion_id FROM estudiantes_asignaciones 
      WHERE anio_lectivo_id = ? AND colegio_id = ? AND asignatura_id = ? AND grado_id = ? AND activo = 1
    ''', [anioLectivoId, colegioId, asignaturaId, gradoId]);
    return maps.map((m) => m['seccion_id'] as int).toList();
  }
}

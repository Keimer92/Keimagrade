import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../models/estudiante.dart';
import '../repositories/estudiante_repository.dart';
import '../database/database_helper.dart';

/// Clase para almacenar datos de importación desde Excel
class DatosImportacionExcel {
  const DatosImportacionExcel({
    required this.nombre,
    required this.apellido,
    required this.anioLectivo,
    required this.colegio,
    required this.asignatura,
    required this.grado,
    required this.seccion,
  });

  final String nombre;
  final String apellido;
  final int anioLectivo;
  final String colegio;
  final String asignatura;
  final String grado;
  final String seccion;
}

/// Clase para almacenar el resultado de la importación
class ResultadoImportacion {
  const ResultadoImportacion({
    required this.nuevosEstudiantes,
    required this.asignacionesCreadas,
    required this.duplicadosOmitidos,
    required this.errores,
  });

  final int nuevosEstudiantes;
  final int asignacionesCreadas;
  final int duplicadosOmitidos;
  final int errores;

  bool get sinCambios => nuevosEstudiantes == 0 && asignacionesCreadas == 0;
}

class EstudianteProvider extends ChangeNotifier {
  final EstudianteRepository _repository = EstudianteRepository();
  List<Estudiante> _estudiantes = [];
  List<Estudiante> _estudiantesFiltrados = [];
  Estudiante? _selectedEstudiante;
  bool _isLoading = false;

  // Filtros actuales
  int? _anioLectivoIdFiltro;
  int? _colegioIdFiltro;
  int? _asignaturaIdFiltro;
  int? _gradoIdFiltro;
  int? _seccionIdFiltro;
  String? _sexoFiltro;

  List<Estudiante> get estudiantes => _estudiantesFiltrados;
  List<Estudiante> get todosEstudiantes => _estudiantes;
  Estudiante? get selectedEstudiante => _selectedEstudiante;
  bool get isLoading => _isLoading;
  bool get tieneFiltrosActivos =>
      _anioLectivoIdFiltro != null ||
      _colegioIdFiltro != null ||
      _asignaturaIdFiltro != null ||
      _gradoIdFiltro != null ||
      _seccionIdFiltro != null;

  // Encabezados requeridos para importación
  static const List<String> encabezadosRequeridos = [
    'estudiante',
    'año lectivo',
    'colegio',
    'asignatura',
    'grado',
    'seccion'
  ];

  Future<void> cargarEstudiantes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _estudiantes = await _repository.obtenerActivos();

      // Si hay filtros activos, aplicarlos
      if (tieneFiltrosActivos && _todosLosFiltrosCompletos()) {
        _estudiantesFiltrados = await _repository.obtenerPorAsignacion(
          anioLectivoId: _anioLectivoIdFiltro!,
          colegioId: _colegioIdFiltro!,
          asignaturaId: _asignaturaIdFiltro!,
          gradoId: _gradoIdFiltro!,
          seccionId: _seccionIdFiltro!,
          sexo: _sexoFiltro,
        );
      } else {
        _estudiantesFiltrados = _estudiantes;
      }

      if (_estudiantesFiltrados.isNotEmpty) {
        _selectedEstudiante = _estudiantesFiltrados.first;
      } else {
        _selectedEstudiante = null;
      }
    } catch (e) {
      debugPrint('Error al cargar estudiantes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _todosLosFiltrosCompletos() =>
      _anioLectivoIdFiltro != null &&
      _colegioIdFiltro != null &&
      _asignaturaIdFiltro != null &&
      _gradoIdFiltro != null &&
      _seccionIdFiltro != null;

  /// Aplica filtros por año lectivo, colegio, asignatura, grado, sección y sexo
  Future<void> aplicarFiltros({
    int? anioLectivoId,
    int? colegioId,
    int? asignaturaId,
    int? gradoId,
    int? seccionId,
    String? sexo,
  }) async {
    _anioLectivoIdFiltro = anioLectivoId;
    _colegioIdFiltro = colegioId;
    _asignaturaIdFiltro = asignaturaId;
    _gradoIdFiltro = gradoId;
    _seccionIdFiltro = seccionId;
    _sexoFiltro = sexo;

    await cargarEstudiantes();
  }

  /// Limpia todos los filtros y muestra todos los estudiantes
  Future<void> limpiarFiltros() async {
    _anioLectivoIdFiltro = null;
    _colegioIdFiltro = null;
    _asignaturaIdFiltro = null;
    _gradoIdFiltro = null;
    _seccionIdFiltro = null;

    await cargarEstudiantes();
  }

  // ============== MÉTODOS PARA FILTROS EN CASCADA ==============

  /// Obtiene los IDs de años lectivos disponibles para el colegio seleccionado
  Future<List<int>> obtenerAniosDisponiblesDesdeColegio(int colegioId) async =>
      _repository.obtenerAniosConAsignacion(colegioId: colegioId);

  /// Obtiene los IDs de colegios disponibles para el año lectivo seleccionado
  Future<List<int>> obtenerColegiosDisponibles(int anioLectivoId) async =>
      _repository.obtenerColegiosConAsignacion(anioLectivoId: anioLectivoId);

  /// Obtiene los IDs de asignaturas disponibles para el año y colegio seleccionados
  Future<List<int>> obtenerAsignaturasDisponibles(
          int anioLectivoId, int colegioId) async =>
      _repository.obtenerAsignaturasConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
      );

  /// Obtiene los IDs de grados disponibles para el año, colegio y asignatura seleccionados
  Future<List<int>> obtenerGradosDisponibles(
          int anioLectivoId, int colegioId, int asignaturaId) async =>
      _repository.obtenerGradosConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
      );

  /// Obtiene los IDs de secciones disponibles para el año, colegio, asignatura y grado seleccionados
  Future<List<int>> obtenerSeccionesDisponibles(int anioLectivoId,
          int colegioId, int asignaturaId, int gradoId) async =>
      _repository.obtenerSeccionesConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
        gradoId: gradoId,
      );

  void seleccionarEstudiante(Estudiante estudiante) {
    _selectedEstudiante = estudiante;
    notifyListeners();
  }

  Future<void> crearEstudiante(Estudiante estudiante) async {
    try {
      await _repository.crear(estudiante);
      await cargarEstudiantes();
    } catch (e) {
      debugPrint('Error al crear estudiante: $e');
    }
  }

  Future<void> actualizarEstudiante(Estudiante estudiante) async {
    try {
      await _repository.actualizar(estudiante);
      await cargarEstudiantes();
    } catch (e) {
      debugPrint('Error al actualizar estudiante: $e');
    }
  }

  Future<void> eliminarEstudiante(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarEstudiantes();
    } catch (e) {
      debugPrint('Error al eliminar estudiante: $e');
    }
  }

  /// Crea un estudiante y sus asignaciones académicas
  Future<void> crearEstudianteConAsignaciones(
    Estudiante estudiante,
    int anioLectivoId,
    int colegioId,
    List<int> asignaturasIds,
    int gradoId,
    int seccionId,
  ) async {
    try {
      // Crear el estudiante
      final estudianteId = await _repository.crear(estudiante);

      // Crear asignaciones para cada asignatura seleccionada
      for (final asignaturaId in asignaturasIds) {
        await _repository.crearAsignacion(
          estudianteId: estudianteId,
          anioLectivoId: anioLectivoId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
        );
      }

      await cargarEstudiantes();
    } catch (e) {
      debugPrint('Error al crear estudiante con asignaciones: $e');
      rethrow;
    }
  }

  /// Obtiene las asignaciones académicas de un estudiante
  Future<List<Map<String, dynamic>>> obtenerAsignacionesEstudiante(
      int estudianteId) async {
    final db = await DatabaseHelper().database;
    final rows = await db.customSelect('''
      SELECT ea.* FROM estudiantes_asignaciones ea
      WHERE ea.estudiante_id = ? AND ea.activo = 1
    ''', variables: [Variable.withInt(estudianteId)]).get();
    
    return rows.map((row) => row.data).toList();
  }

  // ============== MÉTODOS DE IMPORTACIÓN EXCEL ==============

  /// Normaliza un encabezado para comparación
  String normalizarHeader(String header) => header
      .toLowerCase()
      .trim()
      .replaceAll('ó', 'o')
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ú', 'u')
      .replaceAll('ñ', 'n')
      .replaceAll('año', 'anio')
      .replaceAll('sección', 'seccion');

  /// Valida si los encabezados del Excel contienen los campos requeridos
  bool validarEncabezados(List<String> headers) {
    final headersLower = headers.map((h) => h.toLowerCase().trim()).toList();
    return encabezadosRequeridos.every((required) => headersLower
        .any((h) => normalizarHeader(h) == normalizarHeader(required)));
  }

  /// Extrae los datos de importación de una fila
  DatosImportacionExcel? extraerDatosDeFilaExcel({
    required Map<String, String?> fila,
    required List<String> headers,
  }) {
    try {
      // Obtener valores por nombre de columna
      final estudianteCompleto = _obtenerValorPorNombre(
          fila, headers, ['estudiante', 'nombre completo', 'alumno']);
      final anioLectivo = _obtenerValorPorNombre(
          fila, headers, ['año lectivo', 'anio lectivo', 'año', 'anio']);
      final colegio = _obtenerValorPorNombre(
          fila, headers, ['colegio', 'escuela', 'institucion']);
      final asignatura = _obtenerValorPorNombre(
          fila, headers, ['asignatura', 'materia', 'curso']);
      final grado = _obtenerValorPorNombre(
          fila, headers, ['grado', 'nivel', 'año escolar']);
      final seccion = _obtenerValorPorNombre(
          fila, headers, ['seccion', 'sección', 'grupo', 'paralelo']);

      // Validar campos requeridos
      if (estudianteCompleto == null ||
          anioLectivo == null ||
          colegio == null ||
          asignatura == null ||
          grado == null ||
          seccion == null) {
        return null;
      }

      // Separar nombre y apellido del estudiante
      final partes = estudianteCompleto.split(' ');
      String nombre;
      String apellido;

      if (partes.length >= 2) {
        nombre = partes.first;
        apellido = partes.sublist(1).join(' ');
      } else {
        nombre = estudianteCompleto;
        apellido = '';
      }

      // Parsear año lectivo
      final anioMatch = RegExp(r'\d{4}').firstMatch(anioLectivo);
      if (anioMatch == null) {
        return null;
      }
      final anio = int.parse(anioMatch.group(0)!);

      return DatosImportacionExcel(
        nombre: nombre.trim(),
        apellido: apellido.trim(),
        anioLectivo: anio,
        colegio: colegio.trim(),
        asignatura: asignatura.trim(),
        grado: grado.trim(),
        seccion: seccion.trim(),
      );
    } catch (e) {
      return null;
    }
  }

  String? _obtenerValorPorNombre(Map<String, String?> fila,
      List<String> headers, List<String> posiblesNombres) {
    for (final nombre in posiblesNombres) {
      final headerEncontrado = headers.firstWhere(
        (h) => normalizarHeader(h) == normalizarHeader(nombre),
        orElse: () => '',
      );
      if (headerEncontrado.isNotEmpty) {
        final valor = fila[headerEncontrado]?.trim();
        if (valor != null && valor.isNotEmpty) {
          return valor;
        }
      }
    }
    return null;
  }

  /// Importa los datos de una lista de registros extraídos del Excel
  Future<ResultadoImportacion> importarDatosExcel(
      List<DatosImportacionExcel> datosImportacion) async {
    int nuevosEstudiantes = 0;
    int asignacionesCreadas = 0;
    int duplicadosOmitidos = 0;
    int errores = 0;

    for (final datos in datosImportacion) {
      try {
        // 1. Buscar o crear el Año Lectivo (primero porque es el inicio de todo)
        final anioLectivoId =
            await _repository.buscarOCrearAnioLectivo(datos.anioLectivo);

        // 2. Buscar o crear el Colegio
        final colegioId = await _repository.buscarOCrearColegio(datos.colegio);

        // 3. Buscar o crear la Asignatura
        final asignaturaId =
            await _repository.buscarOCrearAsignatura(datos.asignatura);

        // 4. Buscar o crear el Grado
        final gradoId = await _repository.buscarOCrearGrado(datos.grado);

        // 5. Buscar o crear la Sección
        final seccionId = await _repository.buscarOCrearSeccion(datos.seccion);

        // 6. Buscar si el estudiante ya existe
        final Estudiante? estudianteExistente =
            await _repository.buscarPorNombreCompleto(
          '${datos.nombre} ${datos.apellido}'.trim(),
        );

        int estudianteId;

        if (estudianteExistente == null) {
          // Crear nuevo estudiante
          estudianteId = await _repository.crear(Estudiante(
            estudiante: '${datos.nombre} ${datos.apellido}'.trim(),
            sexo: null, // Sexo no viene del Excel por ahora
          ));
          nuevosEstudiantes++;
        } else {
          estudianteId = estudianteExistente.id!;
        }

        // 7. Verificar si ya existe esta asignación específica
        final existeAsignacion = await _repository.existeAsignacion(
          estudianteId: estudianteId,
          anioLectivoId: anioLectivoId,
          colegioId: colegioId,
          asignaturaId: asignaturaId,
          gradoId: gradoId,
          seccionId: seccionId,
        );

        if (existeAsignacion) {
          duplicadosOmitidos++;
        } else {
          await _repository.crearAsignacion(
            estudianteId: estudianteId,
            anioLectivoId: anioLectivoId,
            colegioId: colegioId,
            asignaturaId: asignaturaId,
            gradoId: gradoId,
            seccionId: seccionId,
          );
          asignacionesCreadas++;
        }
      } catch (e) {
        errores++;
      }
    }

    // Recargar lista de estudiantes
    await cargarEstudiantes();

    return ResultadoImportacion(
      nuevosEstudiantes: nuevosEstudiantes,
      asignacionesCreadas: asignacionesCreadas,
      duplicadosOmitidos: duplicadosOmitidos,
      errores: errores,
    );
  }
}

import 'package:flutter/material.dart';
import '../models/nota.dart';
import '../models/nota_detalle.dart';
import '../repositories/notas_repository.dart';
import '../repositories/estudiante_repository.dart';

class NotasProvider extends ChangeNotifier {
  final NotasRepository _repository = NotasRepository();
  final EstudianteRepository _estudianteRepository = EstudianteRepository();
  List<Nota> _notasFiltradas = [];
  List<NotaDetalle> _notasDetalladas = [];
  bool _isLoading = false;

  // Filtros actuales
  int? _anioLectivoIdFiltro;
  int? _colegioIdFiltro;
  int? _asignaturaIdFiltro;
  int? _gradoIdFiltro;
  int? _seccionIdFiltro;
  int? _corteIdFiltro;
  String? _searchQuery;

  List<Nota> get notas => _notasFiltradas;
  List<NotaDetalle> get notasDetalladas => _notasDetalladas;
  bool get isLoading => _isLoading;
  bool get tieneFiltrosActivos =>
      _anioLectivoIdFiltro != null ||
      _colegioIdFiltro != null ||
      _asignaturaIdFiltro != null ||
      _gradoIdFiltro != null ||
      _seccionIdFiltro != null ||
      _corteIdFiltro != null;

  // ============== MÉTODOS PARA FILTROS EN CASCADA ==============

  /// Obtiene los IDs de años lectivos disponibles para el colegio seleccionado
  Future<List<int>> obtenerAniosDisponiblesDesdeColegio(int colegioId) async =>
      _repository.obtenerAniosConNotasDesdeColegio(colegioId);

  /// Obtiene los IDs de colegios disponibles para el año lectivo seleccionado
  Future<List<int>> obtenerColegiosDisponibles(int anioLectivoId) async =>
      _estudianteRepository.obtenerColegiosConAsignacion(
          anioLectivoId: anioLectivoId);

  /// Obtiene los IDs de asignaturas disponibles para el año y colegio seleccionados
  Future<List<int>> obtenerAsignaturasDisponibles(
          int anioLectivoId, int colegioId) async =>
      _estudianteRepository.obtenerAsignaturasConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
      );

  /// Obtiene los IDs de grados disponibles para el año, colegio y asignatura seleccionados
  Future<List<int>> obtenerGradosDisponibles(
          int anioLectivoId, int colegioId, int asignaturaId) async =>
      _estudianteRepository.obtenerGradosConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
      );

  /// Obtiene los IDs de secciones disponibles para el año, colegio, asignatura y grado seleccionados
  Future<List<int>> obtenerSeccionesDisponibles(int anioLectivoId,
          int colegioId, int asignaturaId, int gradoId) async =>
      _estudianteRepository.obtenerSeccionesConAsignacion(
        anioLectivoId: anioLectivoId,
        colegioId: colegioId,
        asignaturaId: asignaturaId,
        gradoId: gradoId,
      );

  Future<void> cargarNotas() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Si hay filtros completos, obtener notas filtradas
      if (tieneFiltrosActivos && _todosLosFiltrosCompletos()) {
        if (_searchQuery != null && _searchQuery!.isNotEmpty) {
          _notasFiltradas = await _repository.buscarPorAsignacion(
            anioLectivoId: _anioLectivoIdFiltro!,
            colegioId: _colegioIdFiltro!,
            asignaturaId: _asignaturaIdFiltro!,
            gradoId: _gradoIdFiltro!,
            seccionId: _seccionIdFiltro!,
            query: _searchQuery!,
          );
        } else {
          _notasFiltradas = await _repository.obtenerPorAsignacion(
            anioLectivoId: _anioLectivoIdFiltro!,
            colegioId: _colegioIdFiltro!,
            asignaturaId: _asignaturaIdFiltro!,
            gradoId: _gradoIdFiltro!,
            seccionId: _seccionIdFiltro!,
          );
        }
      } else if (_searchQuery != null && _searchQuery!.isNotEmpty) {
        // Solo búsqueda sin filtros
        _notasFiltradas = await _repository.buscar(_searchQuery!);
      } else {
        // Todas las notas
        _notasFiltradas = await _repository.obtenerTodas();
      }
    } catch (e) {
      debugPrint('Error al cargar notas: $e');
      _notasFiltradas = [];
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

  /// Aplica filtros por año lectivo, colegio, asignatura, grado y sección
  Future<void> aplicarFiltros({
    int? anioLectivoId,
    int? colegioId,
    int? asignaturaId,
    int? gradoId,
    int? seccionId,
  }) async {
    _anioLectivoIdFiltro = anioLectivoId;
    _colegioIdFiltro = colegioId;
    _asignaturaIdFiltro = asignaturaId;
    _gradoIdFiltro = gradoId;
    _seccionIdFiltro = seccionId;

    await cargarNotas();
    await cargarNotasDetalladas();
  }

  /// Limpia todos los filtros y muestra todas las notas
  Future<void> limpiarFiltros() async {
    _anioLectivoIdFiltro = null;
    _colegioIdFiltro = null;
    _asignaturaIdFiltro = null;
    _gradoIdFiltro = null;
    _seccionIdFiltro = null;

    await cargarNotas();
    await cargarNotasDetalladas();
  }

  /// Actualiza la búsqueda
  Future<void> buscar(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    await cargarNotas();
  }

  /// Limpia la búsqueda
  Future<void> limpiarBusqueda() async {
    _searchQuery = null;
    await cargarNotas();
  }

  /// Aplica filtro de corte evaluativo
  Future<void> aplicarFiltroCorte(int? corteId) async {
    _corteIdFiltro = corteId;
    await cargarNotasDetalladas();
  }

  /// Carga notas detalladas para tabla Excel
  Future<void> cargarNotasDetalladas({bool silent = false}) async {
    if (_corteIdFiltro == null || !_todosLosFiltrosCompletos()) {
      _notasDetalladas = [];
      notifyListeners();
      return;
    }

    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      _notasDetalladas = await _repository.obtenerNotasDetalladasPorCorte(
        anioLectivoId: _anioLectivoIdFiltro!,
        colegioId: _colegioIdFiltro!,
        asignaturaId: _asignaturaIdFiltro!,
        gradoId: _gradoIdFiltro!,
        seccionId: _seccionIdFiltro!,
        corteId: _corteIdFiltro!,
        searchQuery: _searchQuery,
      );
    } catch (e) {
      debugPrint('Error al cargar notas detalladas: $e');
      _notasDetalladas = [];
    } finally {
      if (!silent) {
        _isLoading = false;
      }
      notifyListeners();
    }
  }

  /// Busca en notas detalladas
  Future<void> buscarDetalladas(String query) async {
    _searchQuery = query.isEmpty ? null : query;
    await cargarNotasDetalladas();
  }

  /// Verifica si todos los filtros incluyendo corte están completos
  bool todosLosFiltrosCompletosConCorte() =>
      _todosLosFiltrosCompletos() && _corteIdFiltro != null;

  /// Guarda o actualiza una nota de estudiante
  Future<void> guardarNotaManual({
    required int estudianteId,
    required int criterioId,
    required String valorCualitativo,
    required double puntosObtenidos,
  }) async {
    // ACTUALIZACIÓN OPTIMISTA: Actualizar en memoria inmediatamente
    bool updatedInMemory = false;
    for (int i = 0; i < _notasDetalladas.length; i++) {
      if (_notasDetalladas[i].estudianteId == estudianteId) {
        final notaOrig = _notasDetalladas[i];
        final nuevosIndicadores = <IndicadorDetalle>[];

        for (final ind in notaOrig.indicadores) {
          final nuevosCriterios = <CriterioDetalle>[];
          bool criteriaFoundInThisIndicator = false;

          for (final cri in ind.criterios) {
            if (cri.id == criterioId) {
              nuevosCriterios.add(cri.copyWith(
                puntosObtenidos: puntosObtenidos,
                valorCualitativo: valorCualitativo,
              ));
              criteriaFoundInThisIndicator = true;
              updatedInMemory = true;
            } else {
              nuevosCriterios.add(cri);
            }
          }

          if (criteriaFoundInThisIndicator) {
            final nuevoTotalPuntosInd = nuevosCriterios.fold<double>(
                0, (sum, c) => sum + c.puntosObtenidos);
            nuevosIndicadores.add(ind.copyWith(
              criterios: nuevosCriterios,
              totalPuntos: nuevoTotalPuntosInd,
            ));
          } else {
            nuevosIndicadores.add(ind);
          }
        }

        if (updatedInMemory) {
          final nuevoTotalPuntosNota = nuevosIndicadores.fold<double>(
              0, (sum, ind) => sum + ind.totalPuntos);
          final nuevoPorcentaje = notaOrig.totalMaximo > 0
              ? (nuevoTotalPuntosNota / notaOrig.totalMaximo) * 100
              : 0.0;
          final nuevaCalificacion = _calcularCalificacion(nuevoPorcentaje);

          _notasDetalladas[i] = notaOrig.copyWith(
            indicadores: nuevosIndicadores,
            totalPuntos: nuevoTotalPuntosNota,
            porcentaje: nuevoPorcentaje,
            calificacion: nuevaCalificacion,
          );
          notifyListeners();
          break;
        }
      }
    }

    try {
      await _repository.guardarNotaEstudiante(
        estudianteId: estudianteId,
        criterioId: criterioId,
        valorCualitativo: valorCualitativo,
        puntosObtenidos: puntosObtenidos,
      );

      // Recarga silenciosa para asegurar sincronización total con lógica de DB (si existe)
      await cargarNotasDetalladas(silent: true);
    } catch (e) {
      debugPrint('Error al guardar nota manual: $e');
      // En caso de error, forzar recarga con estado de carga para mostrar inconsistencia
      await cargarNotasDetalladas();
    }
  }

  String _calcularCalificacion(double porcentaje) {
    if (porcentaje >= 90) return 'AA';
    if (porcentaje >= 80) return 'AS';
    if (porcentaje >= 60) return 'AF';
    if (porcentaje >= 40) return 'AI';
    return '-';
  }
}

import 'package:flutter/material.dart';
import '../models/anio_lectivo.dart';
import '../repositories/anio_lectivo_repository.dart';
import '../repositories/corte_evaluativo_repository.dart';

class AnioLectivoProvider extends ChangeNotifier {
  final AnioLectivoRepository _repository = AnioLectivoRepository();
  List<AnioLectivo> _anios = [];
  AnioLectivo? _selectedAnio;
  bool _isLoading = false;

  List<AnioLectivo> get anios => _anios;
  AnioLectivo? get selectedAnio => _selectedAnio;
  bool get isLoading => _isLoading;

  Future<void> cargarAnios() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _anios = await _repository.obtenerActivos();
      if (_anios.isNotEmpty) {
        // Seleccionar el año por defecto si existe, sino el primero
        _selectedAnio = _anios.firstWhere(
          (anio) => anio.porDefecto,
          orElse: () => _anios.first,
        );
      } else {
        // Si no hay años, cargar datos por defecto
        await _cargarDatosPorDefecto();
        _anios = await _repository.obtenerActivos();
        if (_anios.isNotEmpty) {
          // Después de crear datos por defecto, seleccionar el año por defecto
          _selectedAnio = _anios.firstWhere(
            (anio) => anio.porDefecto,
            orElse: () => _anios.first,
          );
        }
      }
    } catch (e) {
      debugPrint('Error al cargar años: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarTodosLosAnios() async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      _anios = await _repository.obtenerTodos();
      if (_anios.isNotEmpty) {
        _selectedAnio = _anios.firstWhere(
          (a) => a.porDefecto,
          orElse: () => _anios.first,
        );
      }
    } catch (e) {
      debugPrint('Error al cargar años: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Verificar si ya existe el año 2026
      final todos = await _repository.obtenerTodos();
      final existe2026 = todos.any((a) => a.anio == 2026);

      if (!existe2026) {
        // Crear año lectivo por defecto
        final anioDefecto = AnioLectivo(
          anio: 2026,
          porDefecto: true,
          activo: true,
        );
        try {
          final anioId = await _repository.crear(anioDefecto);
          // Crear cortes por defecto para el año por defecto
          await _crearCortesPorDefecto(anioId);
        } catch (e) {
          // Si falla por restricción UNIQUE, es que otro proceso lo creó justo ahora
          if (e.toString().contains('UNIQUE constraint failed')) {
            debugPrint('El año 2026 ya fue creado por otro proceso.');
          } else {
            rethrow;
          }
        }
      } else {
        // Si existe pero no estaba activo (por eso llegamos aquí), activarlo
        final anioExistente = todos.firstWhere((a) => a.anio == 2026);
        if (!anioExistente.activo) {
          await _repository.actualizar(anioExistente.copyWith(activo: true));
        }
      }
    } catch (e) {
      debugPrint('Error al cargar datos por defecto: $e');
    }
  }

  Future<void> _crearCortesPorDefecto(int anioLectivoId) async {
    try {
      final corteRepository = CorteEvaluativoRepository();
      await corteRepository.asegurarEstructuraDefault(anioLectivoId);
      debugPrint(
          'Cortes, indicadores y criterios por defecto creados para el año lectivo $anioLectivoId');
    } catch (e) {
      debugPrint('Error al crear estructura por defecto: $e');
    }
  }

  void seleccionarAnio(AnioLectivo anio) {
    _selectedAnio = anio;
    notifyListeners();
  }

  Future<void> crearAnio(AnioLectivo anio) async {
    if (_isLoading) return;
    try {
      _isLoading = true;
      notifyListeners();

      // Verificar si ya existe un año con el mismo número
      final todosLosAnios = await _repository.obtenerTodos();
      final existeAnio = todosLosAnios.any((a) => a.anio == anio.anio);

      if (existeAnio) {
        debugPrint('Ya existe un año lectivo con el año ${anio.anio}');
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Por defecto, el nuevo año estará activo para que aparezca en los filtros
      final anioParaCrear = AnioLectivo(
        anio: anio.anio,
        activo: true,
      );
      final nuevoAnioId = await _repository.crear(anioParaCrear);

      // Crear cortes por defecto para el nuevo año
      await _crearCortesPorDefecto(nuevoAnioId);

      // Recargar la lista de años
      _anios = await _repository.obtenerTodos();
      
      // Seleccionar el nuevo año automáticamente
      _selectedAnio = _anios.firstWhere((a) => a.id == nuevoAnioId);
      
    } catch (e) {
      debugPrint('Error al crear año: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> actualizarAnio(AnioLectivo anio) async {
    if (_isLoading) return;
    try {
      _isLoading = true;
      notifyListeners();

      // Si se está intentando desactivar el único año activo, impedirlo
      if (!anio.activo) {
        final otrosActivos = await _repository.obtenerActivos();
        final otrosActivosSinEste =
            otrosActivos.where((a) => a.id != anio.id).length;

        if (otrosActivosSinEste == 0) {
          debugPrint('No se puede desactivar el único año lectivo activo');
          _isLoading = false;
          notifyListeners();
          return;
        }
      }

      await _repository.actualizar(anio);
      _anios = await _repository.obtenerTodos();
      
      // Actualizar el año seleccionado si es el mismo
      if (_selectedAnio?.id == anio.id) {
        _selectedAnio = _anios.firstWhere((a) => a.id == anio.id);
      }
    } catch (e) {
      debugPrint('Error al actualizar año: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> eliminarAnio(int id) async {
    if (_isLoading) return false;
    try {
      _isLoading = true;
      notifyListeners();

      final resultado = await _repository.eliminar(id);
      if (resultado > 0) {
        _anios = await _repository.obtenerTodos();
        
        // Si el año eliminado era el seleccionado, seleccionar otro
        if (_selectedAnio?.id == id) {
          if (_anios.isNotEmpty) {
            _selectedAnio = _anios.firstWhere(
              (a) => a.porDefecto,
              orElse: () => _anios.first,
            );
          } else {
            _selectedAnio = null;
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error al eliminar año: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

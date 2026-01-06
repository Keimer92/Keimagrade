import 'package:flutter/material.dart';
import '../models/anio_lectivo.dart';
import '../repositories/anio_lectivo_repository.dart';
import '../repositories/corte_evaluativo_repository.dart';
import '../repositories/estudiante_repository.dart';

class AnioLectivoProvider extends ChangeNotifier {
  final AnioLectivoRepository _repository = AnioLectivoRepository();
  List<AnioLectivo> _anios = [];
  AnioLectivo? _selectedAnio;
  bool _isLoading = false;

  List<AnioLectivo> get anios => _anios;
  AnioLectivo? get selectedAnio => _selectedAnio;
  bool get isLoading => _isLoading;

  Future<void> cargarAnios() async {
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
      print('Error al cargar años: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarTodosLosAnios() async {
    _isLoading = true;
    notifyListeners();
    try {
      _anios = await _repository.obtenerTodos();
      if (_anios.isNotEmpty) {
        _selectedAnio = _anios.first;
      }
    } catch (e) {
      print('Error al cargar años: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Crear año lectivo por defecto
      final anioDefecto = AnioLectivo(
        anio: 2026,
        porDefecto: true,
      );
      final anioId = await _repository.crear(anioDefecto);
      // Crear cortes por defecto para el año por defecto
      await _crearCortesPorDefecto(anioId);
    } catch (e) {
      print('Error al crear año por defecto: $e');
    }
  }

  Future<void> _crearCortesPorDefecto(int anioLectivoId) async {
    try {
      final corteRepository = CorteEvaluativoRepository();
      await corteRepository.asegurarEstructuraDefault(anioLectivoId);
      print(
          'Cortes, indicadores y criterios por defecto creados para el año lectivo $anioLectivoId');
    } catch (e) {
      print('Error al crear estructura por defecto: $e');
    }
  }

  void seleccionarAnio(AnioLectivo anio) {
    _selectedAnio = anio;
    notifyListeners();
  }

  Future<void> crearAnio(AnioLectivo anio) async {
    try {
      // Verificar si ya existe un año con el mismo número
      final todosLosAnios = await _repository.obtenerTodos();
      final existeAnio = todosLosAnios.any((a) => a.anio == anio.anio);

      if (existeAnio) {
        print('Ya existe un año lectivo con el año ${anio.anio}');
        return;
      }

      // Asegurar que el nuevo año no esté activo por defecto
      final anioParaCrear = AnioLectivo(
        anio: anio.anio,
        activo: false,
      );
      final nuevoAnioId = await _repository.crear(anioParaCrear);

      // Crear cortes por defecto para el nuevo año
      await _crearCortesPorDefecto(nuevoAnioId);

      await cargarTodosLosAnios();
    } catch (e) {
      print('Error al crear año: $e');
    }
  }

  Future<void> actualizarAnio(AnioLectivo anio) async {
    try {
      // Si se está intentando desactivar el único año activo, impedirlo
      if (!anio.activo) {
        final otrosActivos = await _repository.obtenerActivos();
        final otrosActivosSinEste =
            otrosActivos.where((a) => a.id != anio.id).length;

        if (otrosActivosSinEste == 0) {
          print('No se puede desactivar el único año lectivo activo');
          return;
        }
      }

      // Si se está activando un año, desactivar todos los demás
      if (anio.activo) {
        final todosLosAnios = await _repository.obtenerTodos();
        for (final otroAnio in todosLosAnios) {
          if (otroAnio.id != anio.id && otroAnio.activo) {
            final otroActualizado = otroAnio.copyWith(activo: false);
            await _repository.actualizar(otroActualizado);
          }
        }
      }

      await _repository.actualizar(anio);
      await cargarTodosLosAnios();
    } catch (e) {
      print('Error al actualizar año: $e');
    }
  }

  Future<bool> eliminarAnio(int id) async {
    try {
      // Verificar si el año tiene asignaciones de estudiantes
      final estudianteRepository = EstudianteRepository();
      final colegiosConAsignacion = await estudianteRepository
          .obtenerColegiosConAsignacion(anioLectivoId: id);

      if (colegiosConAsignacion.isNotEmpty) {
        // El año tiene datos relacionados, no se puede eliminar
        return false;
      }

      // No hay datos relacionados, proceder con la eliminación
      await _repository.eliminar(id);
      await cargarTodosLosAnios();
      return true;
    } catch (e) {
      print('Error al eliminar año: $e');
      return false;
    }
  }
}

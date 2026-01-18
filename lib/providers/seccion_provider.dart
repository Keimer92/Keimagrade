import 'package:flutter/material.dart';
import '../models/seccion.dart';
import '../repositories/seccion_repository.dart';

class SeccionProvider extends ChangeNotifier {
  final SeccionRepository _repository = SeccionRepository();
  List<Seccion> _secciones = [];
  Seccion? _selectedSeccion;
  bool _isLoading = false;

  List<Seccion> get secciones => _secciones;
  Seccion? get selectedSeccion => _selectedSeccion;
  bool get isLoading => _isLoading;

  Future<void> cargarSecciones() async {
    _isLoading = true;
    notifyListeners();
    try {
      _secciones = await _repository.obtenerActivos();
      if (_secciones.isNotEmpty) {
        _selectedSeccion = _secciones.first;
      } else {
        // Si no hay secciones, cargar datos por defecto
        await _cargarDatosPorDefecto();
        _secciones = await _repository.obtenerActivos();
        if (_secciones.isNotEmpty) {
          _selectedSeccion = _secciones.first;
        }
      }
    } catch (e) {
      debugPrint('Error al cargar secciones: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Crear secciones por defecto (A, B, C, D)
      final seccionesDefecto = [
        Seccion(letra: 'A'),
        Seccion(letra: 'B'),
        Seccion(letra: 'C'),
        Seccion(letra: 'D'),
      ];

      for (final seccion in seccionesDefecto) {
        await _repository.crear(seccion);
      }
    } catch (e) {
      debugPrint('Error al crear secciones por defecto: $e');
    }
  }

  void seleccionarSeccion(Seccion seccion) {
    _selectedSeccion = seccion;
    notifyListeners();
  }

  Future<void> crearSeccion(Seccion seccion) async {
    try {
      await _repository.crear(seccion);
      await cargarSecciones();
    } catch (e) {
      debugPrint('Error al crear sección: $e');
    }
  }

  Future<void> actualizarSeccion(Seccion seccion) async {
    try {
      await _repository.actualizar(seccion);
      await cargarSecciones();
    } catch (e) {
      debugPrint('Error al actualizar sección: $e');
    }
  }

  Future<void> eliminarSeccion(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarSecciones();
    } catch (e) {
      debugPrint('Error al eliminar sección: $e');
    }
  }
}

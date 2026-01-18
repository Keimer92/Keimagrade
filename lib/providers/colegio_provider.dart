import 'package:flutter/material.dart';
import '../models/colegio.dart';
import '../repositories/colegio_repository.dart';

class ColegioProvider extends ChangeNotifier {
  final ColegioRepository _repository = ColegioRepository();
  List<Colegio> _colegios = [];
  Colegio? _selectedColegio;
  bool _isLoading = false;

  List<Colegio> get colegios => _colegios;
  Colegio? get selectedColegio => _selectedColegio;
  bool get isLoading => _isLoading;

  Future<void> cargarColegios() async {
    _isLoading = true;
    notifyListeners();
    try {
      _colegios = await _repository.obtenerActivos();
      if (_colegios.isNotEmpty) {
        _selectedColegio = _colegios.first;
      } else {
        // Si no hay colegios, cargar datos por defecto
        await _cargarDatosPorDefecto();
        _colegios = await _repository.obtenerActivos();
        if (_colegios.isNotEmpty) {
          _selectedColegio = _colegios.first;
        }
      }
    } catch (e) {
      debugPrint('Error al cargar colegios: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Crear colegios por defecto
      final colegiosDefecto = [
        Colegio(
          nombre: 'Candelario Sotelo',
          direccion: 'Direccion del colegio',
          telefono: '0000-0000',
          email: 'candelario@email.com',
          director: 'Director',
        ),
        Colegio(
          nombre: 'Manuel Ignacio Pereira',
          direccion: 'Direccion del colegio',
          telefono: '0000-0000',
          email: 'manuel@email.com',
          director: 'Director',
        ),
      ];

      for (final colegio in colegiosDefecto) {
        await _repository.crear(colegio);
      }
    } catch (e) {
      debugPrint('Error al crear colegios por defecto: $e');
    }
  }

  void seleccionarColegio(Colegio colegio) {
    _selectedColegio = colegio;
    notifyListeners();
  }

  Future<void> crearColegio(Colegio colegio) async {
    try {
      await _repository.crear(colegio);
      await cargarColegios();
    } catch (e) {
      debugPrint('Error al crear colegio: $e');
    }
  }

  Future<void> actualizarColegio(Colegio colegio) async {
    try {
      await _repository.actualizar(colegio);
      await cargarColegios();
    } catch (e) {
      debugPrint('Error al actualizar colegio: $e');
    }
  }

  Future<void> eliminarColegio(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarColegios();
    } catch (e) {
      debugPrint('Error al eliminar colegio: $e');
    }
  }
}

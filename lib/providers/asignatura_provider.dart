import 'package:flutter/material.dart';
import '../models/asignatura.dart';
import '../repositories/asignatura_repository.dart';

class AsignaturaProvider extends ChangeNotifier {
  final AsignaturaRepository _repository = AsignaturaRepository();
  List<Asignatura> _asignaturas = [];
  Asignatura? _selectedAsignatura;
  bool _isLoading = false;

  List<Asignatura> get asignaturas => _asignaturas;
  Asignatura? get selectedAsignatura => _selectedAsignatura;
  bool get isLoading => _isLoading;

  Future<void> cargarAsignaturas() async {
    _isLoading = true;
    notifyListeners();
    try {
      _asignaturas = await _repository.obtenerActivos();
      if (_asignaturas.isNotEmpty) {
        _selectedAsignatura = _asignaturas.first;
      } else {
        // Si no hay asignaturas, cargar datos por defecto
        await _cargarDatosPorDefecto();
        _asignaturas = await _repository.obtenerActivos();
        if (_asignaturas.isNotEmpty) {
          _selectedAsignatura = _asignaturas.first;
        }
      }
    } catch (e) {
      print('Error al cargar asignaturas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Crear asignaturas por defecto
      final asignaturasDefecto = [
        Asignatura(nombre: 'TAC', codigo: 'TAC', horas: 2, cualitativo: true),
        Asignatura(nombre: 'Derecho & Dignidad de la Mujer', codigo: 'DDM', horas: 1, cualitativo: true),
        Asignatura(nombre: 'Creciendo en Valores', codigo: 'CV', horas: 1, cualitativo: true),
        Asignatura(nombre: 'AEP', codigo: 'AEP', horas: 1, cualitativo: true),
        Asignatura(nombre: 'Matemática', codigo: 'MAT', horas: 4, cualitativo: false),
        Asignatura(nombre: 'Lengua & Literatura', codigo: 'LEL', horas: 4, cualitativo: false),
        Asignatura(nombre: 'Inglés', codigo: 'ING', horas: 2, cualitativo: false),
        Asignatura(nombre: 'Ciencias Sociales', codigo: 'CS', horas: 2, cualitativo: false),
        Asignatura(nombre: 'Ciencias Naturales', codigo: 'CN', horas: 2, cualitativo: false),
      ];

      for (final asignatura in asignaturasDefecto) {
        await _repository.crear(asignatura);
      }
    } catch (e) {
      print('Error al crear asignaturas por defecto: $e');
    }
  }

  void seleccionarAsignatura(Asignatura asignatura) {
    _selectedAsignatura = asignatura;
    notifyListeners();
  }

  Future<void> crearAsignatura(Asignatura asignatura) async {
    try {
      await _repository.crear(asignatura);
      await cargarAsignaturas();
    } catch (e) {
      print('Error al crear asignatura: $e');
    }
  }

  Future<void> actualizarAsignatura(Asignatura asignatura) async {
    try {
      await _repository.actualizar(asignatura);
      await cargarAsignaturas();
    } catch (e) {
      print('Error al actualizar asignatura: $e');
    }
  }

  Future<void> eliminarAsignatura(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarAsignaturas();
    } catch (e) {
      print('Error al eliminar asignatura: $e');
    }
  }
}

import 'package:flutter/material.dart';
import '../models/grado.dart';
import '../repositories/grado_repository.dart';

class GradoProvider extends ChangeNotifier {
  final GradoRepository _repository = GradoRepository();
  List<Grado> _grados = [];
  Grado? _selectedGrado;
  bool _isLoading = false;

  List<Grado> get grados => _grados;
  Grado? get selectedGrado => _selectedGrado;
  bool get isLoading => _isLoading;

  Future<void> cargarGrados() async {
    _isLoading = true;
    notifyListeners();
    try {
      _grados = await _repository.obtenerActivos();
      if (_grados.isNotEmpty) {
        _selectedGrado = _grados.first;
      } else {
        // Si no hay grados, cargar datos por defecto
        await _cargarDatosPorDefecto();
        _grados = await _repository.obtenerActivos();
        if (_grados.isNotEmpty) {
          _selectedGrado = _grados.first;
        }
      }
    } catch (e) {
      print('Error al cargar grados: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _cargarDatosPorDefecto() async {
    try {
      // Crear grados por defecto (1er a 6to grado)
      final gradosDefecto = [
        Grado(numero: 1, nombre: '1er Grado', cualitativo: true),
        Grado(numero: 2, nombre: '2do Grado', cualitativo: true),
        Grado(numero: 3, nombre: '3er Grado', cualitativo: true),
        Grado(numero: 4, nombre: '4to Grado', cualitativo: false),
        Grado(numero: 5, nombre: '5to Grado', cualitativo: false),
        Grado(numero: 6, nombre: '6to Grado', cualitativo: false),
      ];

      for (final grado in gradosDefecto) {
        await _repository.crear(grado);
      }
    } catch (e) {
      print('Error al crear grados por defecto: $e');
    }
  }

  void seleccionarGrado(Grado grado) {
    _selectedGrado = grado;
    notifyListeners();
  }

  Future<bool> crearGrado(Grado grado) async {
    try {
      // Verificar si ya existe un grado con el mismo número o nombre
      final todosLosGrados = await _repository.obtenerTodos();
      final existeNumero = todosLosGrados.any((g) => g.numero == grado.numero);
      final existeNombre = todosLosGrados.any((g) => g.nombre.toLowerCase().trim() == grado.nombre.toLowerCase().trim());

      if (existeNumero) {
        print('Ya existe un grado con el número ${grado.numero}');
        return false;
      }

      if (existeNombre) {
        print('Ya existe un grado con el nombre "${grado.nombre}"');
        return false;
      }

      await _repository.crear(grado);
      await cargarGrados();
      return true;
    } catch (e) {
      print('Error al crear grado: $e');
      return false;
    }
  }

  Future<void> actualizarGrado(Grado grado) async {
    try {
      await _repository.actualizar(grado);
      await cargarGrados();
    } catch (e) {
      print('Error al actualizar grado: $e');
    }
  }

  Future<void> eliminarGrado(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarGrados();
    } catch (e) {
      print('Error al eliminar grado: $e');
    }
  }
}

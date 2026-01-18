import 'package:flutter/material.dart';
import '../models/criterio_evaluacion.dart';
import '../repositories/criterio_evaluacion_repository.dart';

class CriterioEvaluacionProvider extends ChangeNotifier {
  final CriterioEvaluacionRepository _repository = CriterioEvaluacionRepository();
  List<CriterioEvaluacion> _criterios = [];
  CriterioEvaluacion? _selectedCriterio;
  bool _isLoading = false;

  List<CriterioEvaluacion> get criterios => _criterios;
  CriterioEvaluacion? get selectedCriterio => _selectedCriterio;
  bool get isLoading => _isLoading;

  Future<void> cargarCriterios() async {
    _isLoading = true;
    notifyListeners();
    try {
      _criterios = await _repository.obtenerActivos();
      if (_criterios.isNotEmpty) {
        _selectedCriterio = _criterios.first;
      }
    } catch (e) {
      debugPrint('Error al cargar criterios: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarCriteriosPorIndicador(int indicadorId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _criterios = await _repository.obtenerPorIndicador(indicadorId);
      if (_criterios.isNotEmpty) {
        _selectedCriterio = _criterios.first;
      }
    } catch (e) {
      debugPrint('Error al cargar criterios por indicador: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void seleccionarCriterio(CriterioEvaluacion criterio) {
    _selectedCriterio = criterio;
    notifyListeners();
  }

  Future<void> crearCriterio(CriterioEvaluacion criterio) async {
    try {
      await _repository.crear(criterio);
      await cargarCriterios();
    } catch (e) {
      debugPrint('Error al crear criterio: $e');
    }
  }

  Future<void> actualizarCriterio(CriterioEvaluacion criterio) async {
    try {
      await _repository.actualizar(criterio);
      await cargarCriterios();
    } catch (e) {
      debugPrint('Error al actualizar criterio: $e');
    }
  }

  Future<void> eliminarCriterio(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarCriterios();
    } catch (e) {
      debugPrint('Error al eliminar criterio: $e');
    }
  }

  Future<void> eliminarCriteriosPorIndicador(int indicadorId) async {
    try {
      await _repository.eliminarPorIndicador(indicadorId);
    } catch (e) {
      debugPrint('Error al eliminar criterios por indicador: $e');
    }
  }
}

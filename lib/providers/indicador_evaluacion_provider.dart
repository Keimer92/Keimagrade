import 'package:flutter/material.dart';
import '../models/indicador_evaluacion.dart';
import '../repositories/indicador_evaluacion_repository.dart';

class IndicadorEvaluacionProvider extends ChangeNotifier {
  final IndicadorEvaluacionRepository _repository =
      IndicadorEvaluacionRepository();
  List<IndicadorEvaluacion> _indicadores = [];
  IndicadorEvaluacion? _selectedIndicador;
  bool _isLoading = false;

  List<IndicadorEvaluacion> get indicadores => _indicadores;
  IndicadorEvaluacion? get selectedIndicador => _selectedIndicador;
  bool get isLoading => _isLoading;

  Future<void> cargarIndicadores() async {
    _isLoading = true;
    notifyListeners();
    try {
      _indicadores = await _repository.obtenerActivos();
      if (_indicadores.isNotEmpty) {
        _selectedIndicador = _indicadores.first;
      }
    } catch (e) {
      debugPrint('Error al cargar indicadores: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cargarIndicadoresPorCorte(int corteId,
      {bool showLoading = false}) async {
    if (showLoading) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      _indicadores = await _repository.obtenerPorCorte(corteId);
      if (_indicadores.isNotEmpty) {
        _selectedIndicador = _indicadores.first;
      }
    } catch (e) {
      debugPrint('Error al cargar indicadores por corte: $e');
    } finally {
      if (showLoading) {
        _isLoading = false;
        notifyListeners();
      } else {
        notifyListeners();
      }
    }
  }

  void seleccionarIndicador(IndicadorEvaluacion? indicador) {
    _selectedIndicador = indicador;
    notifyListeners();
  }

  Future<void> crearIndicador(IndicadorEvaluacion indicador) async {
    try {
      await _repository.crear(indicador);
      await cargarIndicadores();
    } catch (e) {
      debugPrint('Error al crear indicador: $e');
    }
  }

  Future<void> actualizarIndicador(IndicadorEvaluacion indicador) async {
    try {
      await _repository.actualizar(indicador);
      await cargarIndicadores();
    } catch (e) {
      debugPrint('Error al actualizar indicador: $e');
    }
  }

  Future<void> eliminarIndicador(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarIndicadores();
    } catch (e) {
      debugPrint('Error al eliminar indicador: $e');
    }
  }
}

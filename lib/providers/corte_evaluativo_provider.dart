import 'package:flutter/material.dart';
import '../models/corte_evaluativo.dart';
import '../repositories/corte_evaluativo_repository.dart';

class CorteEvaluativoProvider extends ChangeNotifier {
  final CorteEvaluativoRepository _repository = CorteEvaluativoRepository();
  List<CorteEvaluativo> _cortes = [];
  CorteEvaluativo? _selectedCorte;
  bool _isLoading = false;

  List<CorteEvaluativo> get cortes => _cortes;
  CorteEvaluativo? get selectedCorte => _selectedCorte;
  bool get isLoading => _isLoading;

  Future<void> cargarCortes() async {
    _isLoading = true;
    notifyListeners();
    try {
      _cortes = await _repository.obtenerActivos();
      if (_cortes.isNotEmpty) {
        _selectedCorte = _cortes.first;
      }
    } catch (e) {
      print('Error al cargar cortes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void seleccionarCorte(CorteEvaluativo? corte) {
    _selectedCorte = corte;
    notifyListeners();
  }

  Future<void> crearCorte(CorteEvaluativo corte) async {
    try {
      await _repository.crear(corte);
      await cargarCortes();
    } catch (e) {
      print('Error al crear corte: $e');
    }
  }

  Future<void> actualizarCorte(CorteEvaluativo corte) async {
    try {
      await _repository.actualizar(corte);
      await cargarCortes();
    } catch (e) {
      print('Error al actualizar corte: $e');
    }
  }

  Future<void> eliminarCorte(int id) async {
    try {
      await _repository.eliminar(id);
      await cargarCortes();
    } catch (e) {
      print('Error al eliminar corte: $e');
    }
  }
}

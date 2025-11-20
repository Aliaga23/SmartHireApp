import 'package:flutter/material.dart';
import '../models/vacante.dart';
import '../models/postulacion.dart';
import '../services/vacante_service.dart';

class VacanteProvider with ChangeNotifier {
  final VacanteService _vacanteService = VacanteService();

  List<Vacante> _vacantes = [];
  List<Postulacion> _postulaciones = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Vacante> get vacantes => _vacantes;
  List<Postulacion> get postulaciones => _postulaciones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadVacantes(String empresaId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _vacantes = await _vacanteService.getVacantesByEmpresa(empresaId, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPostulaciones(String vacanteId, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _postulaciones = await _vacanteService.getPostulacionesByVacante(vacanteId, token);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createVacante(Map<String, dynamic> data, String token) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nuevaVacante = await _vacanteService.createVacante(data, token);
      _vacantes.insert(0, nuevaVacante);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEstadoPostulacion(String postulacionId, String estado, String token) async {
    try {
      await _vacanteService.updateEstadoPostulacion(postulacionId, estado, token);
      
      // Actualizar localmente
      final index = _postulaciones.indexWhere((p) => p.id == postulacionId);
      if (index != -1) {
        _postulaciones[index] = Postulacion(
          id: _postulaciones[index].id,
          estado: estado,
          fechaPostulacion: _postulaciones[index].fechaPostulacion,
          candidatoId: _postulaciones[index].candidatoId,
          vacanteId: _postulaciones[index].vacanteId,
          candidato: _postulaciones[index].candidato,
          vacante: _postulaciones[index].vacante,
        );
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

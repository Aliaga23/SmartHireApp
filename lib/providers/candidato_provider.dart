import 'package:flutter/foundation.dart';
import '../models/candidato.dart';
import '../models/postulacion_candidato.dart';
import '../services/candidato_service.dart';
import '../services/storage_service.dart';

class CandidatoProvider with ChangeNotifier {
  final CandidatoService _candidatoService = CandidatoService();
  final StorageService _storageService = StorageService();

  Candidato? _candidato;
  List<PostulacionCandidato> _postulaciones = [];
  List<Habilidad> _availableSkills = [];
  List<Lenguaje> _availableLanguages = [];

  bool _isLoading = false;
  String? _error;
  
  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreApplications = true;

  // Getters
  Candidato? get candidato => _candidato;
  List<PostulacionCandidato> get postulaciones => _postulaciones;
  List<Habilidad> get availableSkills => _availableSkills;
  List<Lenguaje> get availableLanguages => _availableLanguages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMoreApplications => _hasMoreApplications;

  // Load candidate profile
  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      // Profile endpoint already includes experiencias and educaciones
      _candidato = await _candidatoService.getProfile(token);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update candidate profile
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      _candidato = await _candidatoService.updateProfile(token, data);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Parse CV with OCR
  Future<bool> parseCv(String imageData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      _candidato = await _candidatoService.parseCv(token, imageData);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error parsing CV: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load applications
  Future<void> loadApplications({bool loadMore = false}) async {
    if (loadMore && !_hasMoreApplications) return;

    if (!loadMore) {
      _currentPage = 1;
      _postulaciones.clear();
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      final response = await _candidatoService.getMyApplications(
        token,
        page: loadMore ? _currentPage + 1 : _currentPage,
      );

      final List<PostulacionCandidato> newPostulaciones = response['data'];
      final pagination = response['pagination'];

      if (loadMore) {
        _postulaciones.addAll(newPostulaciones);
        _currentPage++;
      } else {
        _postulaciones = newPostulaciones;
      }

      _totalPages = pagination['totalPages'];
      _hasMoreApplications = _currentPage < _totalPages;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading applications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Apply to vacancy
  Future<bool> applyToVacancy(String vacanteId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.applyToVacancy(token, vacanteId);
      await loadApplications(); // Reload applications
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error applying to vacancy: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cancel application
  Future<bool> cancelApplication(String postulacionId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.cancelApplication(token, postulacionId);
      _postulaciones.removeWhere((p) => p.id == postulacionId);
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error canceling application: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load available skills
  Future<void> loadAvailableSkills() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      _availableSkills = await _candidatoService.getAllSkills(token);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading skills: $e');
    }
  }

  // Load available languages
  Future<void> loadAvailableLanguages() async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      _availableLanguages = await _candidatoService.getAllLanguages(token);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading languages: $e');
    }
  }

  // Add skill
  Future<bool> addSkill(String habilidadId, int nivel) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.addSkill(token, habilidadId, nivel);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding skill: $e');
      notifyListeners();
      return false;
    }
  }

  // Update skill
  Future<bool> updateSkill(String habilidadId, int nivel) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.updateSkill(token, habilidadId, nivel);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating skill: $e');
      notifyListeners();
      return false;
    }
  }

  // Remove skill
  Future<bool> removeSkill(String habilidadId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.removeSkill(token, habilidadId);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error removing skill: $e');
      notifyListeners();
      return false;
    }
  }

  // Add language
  Future<bool> addLanguage(String lenguajeId, int nivel) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.addLanguage(token, lenguajeId, nivel);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error adding language: $e');
      notifyListeners();
      return false;
    }
  }

  // Update language
  Future<bool> updateLanguage(String lenguajeId, int nivel) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.updateLanguage(token, lenguajeId, nivel);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating language: $e');
      notifyListeners();
      return false;
    }
  }

  // Remove language
  Future<bool> removeLanguage(String lenguajeId) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) throw Exception('No token found');

      await _candidatoService.removeLanguage(token, lenguajeId);
      await loadProfile(); // Reload profile
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error removing language: $e');
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

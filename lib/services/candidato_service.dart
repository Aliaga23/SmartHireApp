import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/candidato.dart';
import '../models/postulacion_candidato.dart';
import '../utils/api_config.dart';

class CandidatoService {
  // Get candidate profile
  Future<Candidato> getProfile(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Candidato.fromJson(jsonData);
    } else {
      throw Exception('Error al obtener perfil del candidato');
    }
  }

  // Update candidate profile
  Future<Candidato> updateProfile(String token, Map<String, dynamic> data) async {
    final response = await http.patch(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return Candidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar perfil');
    }
  }

  // Parse CV with OCR
  Future<Candidato> parseCv(String token, String imageData) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/parse-cv'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'imageData': imageData}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return Candidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al procesar el CV');
    }
  }

  // Get candidate applications
  Future<Map<String, dynamic>> getMyApplications(String token, {int page = 1, int limit = 10}) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/postulaciones/mis-postulaciones?page=$page&limit=$limit'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return {
        'data': (jsonData['data'] as List)
            .map((e) => PostulacionCandidato.fromJson(e))
            .toList(),
        'pagination': jsonData['pagination'],
      };
    } else {
      throw Exception('Error al obtener postulaciones');
    }
  }

  // Apply to a job vacancy
  Future<void> applyToVacancy(String token, String vacanteId) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/postulaciones'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'vacanteId': vacanteId}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al postular a la vacante');
    }
  }

  // Cancel application
  Future<void> cancelApplication(String token, String postulacionId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/postulaciones/$postulacionId'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al cancelar postulación');
    }
  }

  // Get candidate experiences
  Future<List<ExperienciaCandidato>> getExperiences(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/experiencia'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List;
      return jsonData.map((e) => ExperienciaCandidato.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener experiencias');
    }
  }

  // Add skill
  Future<HabilidadCandidato> addSkill(String token, String habilidadId, int nivel) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/habilidades'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'habilidadId': habilidadId, 'nivel': nivel}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return HabilidadCandidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al agregar habilidad');
    }
  }

  // Update skill level
  Future<HabilidadCandidato> updateSkill(String token, String habilidadId, int nivel) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/habilidades/$habilidadId'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'nivel': nivel}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return HabilidadCandidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar habilidad');
    }
  }

  // Remove skill
  Future<void> removeSkill(String token, String habilidadId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/habilidades/$habilidadId'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al eliminar habilidad');
    }
  }

  // Add language
  Future<LenguajeCandidato> addLanguage(String token, String lenguajeId, int nivel) async {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/lenguajes'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'lenguajeId': lenguajeId, 'nivel': nivel}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LenguajeCandidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al agregar lenguaje');
    }
  }

  // Update language level
  Future<LenguajeCandidato> updateLanguage(String token, String lenguajeId, int nivel) async {
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/lenguajes/$lenguajeId'),
      headers: ApiConfig.getAuthHeaders(token),
      body: json.encode({'nivel': nivel}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return LenguajeCandidato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar lenguaje');
    }
  }

  // Remove language
  Future<void> removeLanguage(String token, String lenguajeId) async {
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/candidatos/profile/lenguajes/$lenguajeId'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Error al eliminar lenguaje');
    }
  }

  // Get all available skills
  Future<List<Habilidad>> getAllSkills(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/habilidades'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Habilidad.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener habilidades');
    }
  }

  // Get all available languages
  Future<List<Lenguaje>> getAllLanguages(String token) async {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/lenguajes'),
      headers: ApiConfig.getAuthHeaders(token),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => Lenguaje.fromJson(e)).toList();
    } else {
      throw Exception('Error al obtener lenguajes');
    }
  }
}

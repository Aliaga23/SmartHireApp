import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vacante.dart';
import '../models/postulacion.dart';
import '../utils/api_config.dart';

class VacanteService {
  Future<List<Vacante>> getVacantesByEmpresa(String empresaId, String token) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/vacantes/empresa/$empresaId');
      
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Vacante.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada');
      } else {
        throw Exception('Error al obtener vacantes: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Error de conexión');
      }
      rethrow;
    }
  }

  Future<List<Postulacion>> getPostulacionesByVacante(String vacanteId, String token) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/postulaciones/vacante/$vacanteId');
      
      final response = await http.get(
        url,
        headers: ApiConfig.getAuthHeaders(token),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return jsonData.map((json) => Postulacion.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada');
      } else {
        throw Exception('Error al obtener postulaciones: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Error de conexión');
      }
      rethrow;
    }
  }

  Future<Vacante> createVacante(Map<String, dynamic> data, String token) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/vacantes');
      
      final response = await http.post(
        url,
        headers: ApiConfig.getAuthHeaders(token),
        body: jsonEncode(data),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return Vacante.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Sesión expirada');
      } else {
        throw Exception('Error al crear vacante: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Error de conexión');
      }
      rethrow;
    }
  }

  Future<void> updateEstadoPostulacion(String postulacionId, String estado, String token) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}/postulaciones/$postulacionId');
      
      final response = await http.patch(
        url,
        headers: ApiConfig.getAuthHeaders(token),
        body: jsonEncode({'estado': estado}),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          throw Exception('Sesión expirada');
        } else {
          throw Exception('Error al actualizar postulación: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Error de conexión');
      }
      rethrow;
    }
  }
}

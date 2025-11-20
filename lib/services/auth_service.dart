import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response.dart';
import '../utils/api_config.dart';

class AuthService {
  Future<LoginResponse> login(String correo, String password) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}');
      
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'correo': correo,
          'password': password,
        }),
      ).timeout(ApiConfig.timeoutDuration);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        return LoginResponse.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw Exception('Credenciales incorrectas');
      } else if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || 
          e.toString().contains('TimeoutException')) {
        throw Exception('Error de conexión. Verifica tu conexión a internet.');
      }
      rethrow;
    }
  }
}

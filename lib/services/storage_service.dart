import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/login_response.dart';

class StorageService {
  static const String _keyToken = 'auth_token';
  static const String _keyUserData = 'user_data';
  static const String _keyUserType = 'user_type';

  Future<void> saveLoginData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, loginResponse.token);
    await prefs.setString(_keyUserType, loginResponse.tipoUsuario);
    await prefs.setString(_keyUserData, jsonEncode(loginResponse.usuario.toJson()));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserType);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_keyUserData);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUserType);
    await prefs.remove(_keyUserData);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

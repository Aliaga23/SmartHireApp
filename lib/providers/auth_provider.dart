import 'package:flutter/material.dart';
import '../models/login_response.dart';
import '../services/auth_service.dart';
import '../services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();

  bool _isLoading = false;
  String? _errorMessage;
  LoginResponse? _loginResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isAuthenticated => _loginResponse != null;

  Future<bool> login(String correo, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _loginResponse = await _authService.login(correo, password);
      await _storageService.saveLoginData(_loginResponse!);
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      _loginResponse = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _storageService.clearLoginData();
    _loginResponse = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    return await _storageService.isLoggedIn();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

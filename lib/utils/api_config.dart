class ApiConfig {
  static const String baseUrl = 'https://api.sw2ficct.lat/api';
  static const String loginEndpoint = '/auth/login';
  
  static const Duration timeoutDuration = Duration(seconds: 30);
  
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}

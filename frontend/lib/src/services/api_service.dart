import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://127.0.0.1:5000',
  );

  static Future<http.Response> login(String identifier, String password) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'identifier': identifier, 'password': password}),
    );
  }

  static Future<http.Response> register({
    required String fullName,
    required String identifier,
    required String password,
    required String role,
  }) {
    final isPhone = RegExp(r'^[+0-9][0-9 ()-]{6,}$').hasMatch(identifier);
    return http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullName,
        if (isPhone) 'phone': identifier else 'email': identifier,
        'password': password,
        'role': role,
      }),
    );
  }

  static Map<String, String> authHeaders(String token) {
    return {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
  }
}

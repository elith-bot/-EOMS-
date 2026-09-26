import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  bool _initialized = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get initialized => _initialized;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.login(identifier, password);
      if (response.statusCode == 200) {
        await _saveSession(jsonDecode(response.body));
        return true;
      }
      _errorMessage = _messageFrom(response.body, 'تعذر تسجيل الدخول.');
    } catch (_) {
      _errorMessage = 'تعذر الاتصال بالخادم، حاول مرة أخرى.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register({required String fullName, required String identifier, required String password, required String role}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final response = await ApiService.register(
        fullName: fullName,
        identifier: identifier,
        password: password,
        role: role,
      );
      if (response.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = _messageFrom(response.body, 'تعذر إنشاء الحساب.');
    } catch (_) {
      _errorMessage = 'تعذر الاتصال بالخادم، حاول مرة أخرى.';
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    _token = data['access_token'];
    _user = User.fromJson(data['user'] ?? {});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    await prefs.setString('user', jsonEncode(data['user'] ?? {}));
    _isLoading = false;
    notifyListeners();
  }

  String _messageFrom(String body, String fallback) {
    try {
      return (jsonDecode(body)['error'] as String?) ?? fallback;
    } catch (_) {
      return fallback;
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    final userJson = prefs.getString('user');
    if (userJson != null && userJson.isNotEmpty) _user = User.fromJson(jsonDecode(userJson));
    _initialized = true;
    notifyListeners();
  }
}

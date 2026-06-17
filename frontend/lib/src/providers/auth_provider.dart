import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _authenticated = false;
  String _token = '';

  bool get authenticated => _authenticated;
  String get token => _token;

  void login(String token) {
    _token = token;
    _authenticated = true;
    notifyListeners();
  }

  void logout() {
    _token = '';
    _authenticated = false;
    notifyListeners();
  }
}

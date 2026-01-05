import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _token;
  Map<String, dynamic>? _admin;

  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;
  Map<String, dynamic>? get admin => _admin;

  Future<bool> login(String username, String password) async {
    try {
      final response = await AuthService.login(username, password);
      _token = response['token'];
      _admin = response['admin'];
      _isLoggedIn = true;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    _isLoggedIn = false;
    _token = null;
    _admin = null;
    notifyListeners();
  }
}

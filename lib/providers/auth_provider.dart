import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;

  AuthProvider() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName') ?? '';
    _userEmail = prefs.getString('userEmail') ?? '';
    notifyListeners();
  }

  Future<void> login(String email, String password, String name) async {
    // Mock login - in real app, this would call an API
    await Future.delayed(Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);

    notifyListeners();
  }

  Future<void> register(String email, String password, String name) async {
    // Mock registration
    await Future.delayed(Duration(seconds: 1));
    
    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);

    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userName');
    await prefs.remove('userEmail');

    notifyListeners();
  }

  // Check if user is authenticated
  bool get isAuthenticated => _isLoggedIn;
}
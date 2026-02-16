import 'package:flutter/material.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _user; // Add user state

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get user => _user; // Expose user

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.login(email, password);
      // TODO: Ideally fetch user profile here
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _setLoading(true);
    try {
      await _authRepository.register(name, email, password);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> checkAuth() async {
    final token = await _authRepository.getToken();
    return token != null;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}

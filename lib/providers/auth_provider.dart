import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/auth_services.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  String? get currentUserId => _currentUser?.id;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _currentUser = _authService.currentUser;

    _authService.authStateChanges.listen((AuthState authState) {
      _currentUser = authState.session?.user;
      notifyListeners();
    });
  }

  Future<bool> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signIn(
        email: email,
        password: password,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Login error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (result['success']) {
        _currentUser = result['user'];
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Registration error: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      await _authService.signOut();
      _currentUser = null;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Logout error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword({required String email}) async {
    try {
      final result = await _authService.resetPassword(email: email);
      if (result['success']) {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Password reset error: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

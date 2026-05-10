import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:business_assistant/core/services/auth_service.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  unauthenticated,
  authenticating,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  AuthStatus _status = AuthStatus.uninitialized;
  String? _error;

  AuthProvider() {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // Getters
  User? get user => _user;
  AuthStatus get status => _status;
  String? get error => _error;
  bool get isLoading => _status == AuthStatus.authenticating;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      if (_status != AuthStatus.authenticated) {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _user = firebaseUser;
      _status = AuthStatus.authenticated;
    }
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Sign in with Email
  Future<bool> signIn(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();

      if (!_authService.isFirebaseAvailable) {
        await Future.delayed(const Duration(seconds: 1));
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      await _authService.signInWithEmail(email, password);
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Sign up with Email
  Future<bool> signUp(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();

      if (!_authService.isFirebaseAvailable) {
        await Future.delayed(const Duration(seconds: 1));
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      await _authService.signUpWithEmail(email, password);
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Google Sign In
  Future<bool> signInWithGoogle() async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();

      if (!_authService.isFirebaseAvailable) {
        await Future.delayed(const Duration(seconds: 1));
        _status = AuthStatus.authenticated;
        notifyListeners();
        return true;
      }

      final userCred = await _authService.signInWithGoogle();
      if (userCred == null) {
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      }
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Apple Sign In
  Future<bool> signInWithApple() async {
    try {
      _status = AuthStatus.authenticating;
      _error = null;
      notifyListeners();
      await _authService.signInWithApple();
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _authService.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }

  // Password Reset
  Future<bool> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

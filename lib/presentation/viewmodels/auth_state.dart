import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/services/auth_service.dart';

class AuthState extends ChangeNotifier {
  final AuthService _authService;

  AuthState(this._authService) {
    _loadFromPrefs();
  }

  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _isInitialized = false; // 👈 importante

  String? _token;
  String? _userName;
  String? _email;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;

  String? get token => _token;
  String? get userName => _userName;
  String? get email => _email;

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    final savedUserName = prefs.getString('auth_user_name');
    final savedEmail = prefs.getString('auth_email');

    if (savedToken != null) {
      _token = savedToken;
      _userName = savedUserName;
      _email = savedEmail;
      _isAuthenticated = true;
      print('Sessão restaurada com token: $_token');
    } else {
      _isAuthenticated = false;
      print('Nenhuma sessão encontrada');
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);

      _token = response.token;
      _userName = response.userName;
      _email = response.email;
      _isAuthenticated = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('auth_user_name', _userName ?? '');
      await prefs.setString('auth_email', _email ?? '');

      print('LOGIN OK, TOKEN: $_token');

      return null;
    } on AuthException catch (e) {
      print('LOGIN FALHOU: ${e.message}');
      _isAuthenticated = false;
      _token = null;
      _userName = null;
      _email = null;
      return e.message;
    } catch (e) {
      print('ERRO INESPERADO NO LOGIN: $e');
      _isAuthenticated = false;
      return 'Erro inesperado. Tente novamente.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _token = null;
    _userName = null;
    _email = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_user_name');
    await prefs.remove('auth_email');

    notifyListeners();
  }
}

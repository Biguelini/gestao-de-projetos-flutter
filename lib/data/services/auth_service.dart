class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == 'admin@teste.com' && password == '123456') {
      return LoginResponse(
        token: 'fake-jwt-token-123',
        userName: 'Admin',
        email: email,
      );
    }

    throw AuthException('Credenciais inválidas');
  }
}

class LoginResponse {
  final String token;
  final String userName;
  final String email;

  LoginResponse({
    required this.token,
    required this.userName,
    required this.email,
  });
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

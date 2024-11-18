import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString('token');
    return token != null && token.isNotEmpty;
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final result = await apiService.login(email: email, password: password);
    if (!result['error']) {
      final token = result['loginResult']['token'];
      await _saveToken(token);
    }
    return result;
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final result = await apiService.register(
      name: name,
      email: email,
      password: password,
    );
    return result;
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    await preferences.remove('token');
  }

  Future<void> _saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
  }
}

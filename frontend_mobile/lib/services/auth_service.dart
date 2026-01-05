import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String username,
    String password,
  ) async {
    return await ApiService.post('/api/admin/login', {
      'username': username,
      'password': password,
    });
  }
}

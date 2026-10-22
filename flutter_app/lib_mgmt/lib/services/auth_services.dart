import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class AuthService {
  // Use 10.0.2.2 for Android Emulator or your local IP/domain for real devices
  // final String baseUrl = 'http://10.0.2.2:8080/api';

  final String baseUrl = ApiConfig.baseUrl;

  final _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String userName, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_name': userName,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Securely store token
        await _secureStorage.write(key: 'auth_token', value: token);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
  }
}

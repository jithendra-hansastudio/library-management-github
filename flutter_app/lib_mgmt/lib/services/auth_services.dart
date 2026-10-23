import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/api_config.dart';

class AuthService {
  // Use 10.0.2.2 for Android Emulator or your local IP/domain for real devices
  // final String baseUrl = 'http://10.0.2.2:8080/api';

  final String baseUrl = ApiConfig.baseUrl;

  final _secureStorage = const FlutterSecureStorage();
  String userRole = 'not loaded';

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
        // Adjust key based on your API response structure (e.g., data['role'] or data['user']['role'])
        final role = data['role'] ?? data['user']?['role'] ?? '';
        userRole =  data['user']?['role'];

        // Securely store token and role
        await _secureStorage.write(key: 'auth_token', value: token);
        await _secureStorage.write(key: 'user_role', value: role);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Equivalent to auth()->user()->role ?? ''
  Future<String> getUserRole() async{
    print('called');
    print('$userRole');

    print(_secureStorage.read(key: 'user_role'));
    return await _secureStorage.read(key: 'user_role') ?? '';
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'auth_token');
    await _secureStorage.delete(key: 'user_role');
  }
}

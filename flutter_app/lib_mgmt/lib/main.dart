import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lib_mgmt_task/screens/books/index.dart';
import 'package:lib_mgmt_task/screens/home.dart';
import 'package:lib_mgmt_task/services/api_client.dart';
import 'config/api_config.dart';
import 'services/auth_services.dart';
import 'screens/login_screen.dart'; // Make sure this points to your LoginScreen widget

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const MyHomePage(title: 'Library Dashboard'),

      },
    );
  }
}

final ApiClient _apiClient = ApiClient(); // Make sure to import your ApiClient

// Data fetching helper functions using ApiConfig
// Future<List<dynamic>> fetchDesign() async {
//   final response = await _apiClient.get('/settings');
//
//   if (response.statusCode == 200) {
//
//     final dynamic decodedData = jsonDecode(response.body);
//     print(decodedData);
//     if (decodedData is List) {
//       return decodedData;
//     } else if (decodedData is Map<String, dynamic>) {
//       if (decodedData['data'] is List) {
//         return decodedData['data'];
//       } else if (decodedData['data'] is Map &&
//           decodedData['data']['data'] is List) {
//         return decodedData['data']['data'];
//       }
//     }
//     return [];
//   } else {
//     throw Exception('Failed to load design settings: ${response.statusCode}');
//   }
// }

Future<Map<String, dynamic>> fetchDesign() async {
  final response = await _apiClient.get('/settings');

  if (response.statusCode == 200) {
    final dynamic decodedData = jsonDecode(response.body);

    // Handle standard API resource wrappers if any (e.g. { "data": {...} })
    if (decodedData is Map<String, dynamic>) {
      if (decodedData.containsKey('data') && decodedData['data'] is Map<String, dynamic>) {
        return decodedData['data'];
      }
      return decodedData;
    }
  }

  // Safe default fallback if it fails or returns empty
  return {
    'theme_preset': 'ocean',
    'corner_style': 'smooth',
    'font_scale': 1,
    'is_dark_mode': false,
  };
}

Future<List<dynamic>> fetchBooks() async {
  final response = await _apiClient.get('/books');

  if (response.statusCode == 200) {
    final dynamic decodedData = jsonDecode(response.body);
    if (decodedData is List) {
      return decodedData;
    } else if (decodedData is Map<String, dynamic>) {
      if (decodedData['data'] is List) {
        return decodedData['data'];
      } else if (decodedData['data'] is Map &&
          decodedData['data']['data'] is List) {
        return decodedData['data']['data'];
      }
    }
    return [];
  } else {
    throw Exception('Failed to load books: ${response.statusCode}');
  }
}

Future<List<dynamic>> fetchAuthors() async {
  final response = await http.get(
    Uri.parse('${ApiConfig.baseUrl}/authors'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final dynamic decodedData = jsonDecode(response.body);
    if (decodedData is List) {
      return decodedData;
    } else if (decodedData is Map<String, dynamic>) {
      if (decodedData['data'] is List) {
        return decodedData['data'];
      } else if (decodedData['data'] is Map &&
          decodedData['data']['data'] is List) {
        return decodedData['data']['data'];
      }
    }
    return [];
  } else {
    throw Exception('Failed to load authors: ${response.statusCode}');
  }
}


// lib/config/api_config.dart
import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    // Check for Web platform first
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }

    // Check for Android (using defaultTargetPlatform instead of dart:io)
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }

    // iOS, Windows, macOS, Linux
    return 'http://localhost:8080/api';
  }
}
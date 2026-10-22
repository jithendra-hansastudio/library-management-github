import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // Chrome / Web
      return 'http://localhost:8080/api';
    } else if (Platform.isAndroid) {
      // Android Emulator
      return 'http://10.0.2.2:8080/api';
    } else if (Platform.isIOS) {
      // iOS Simulator
      return 'http://localhost:8080/api';
    } else {
      // Windows, macOS, Linux desktop, or physical devices
      // Note: For physical devices, replace localhost with your PC's local IP (e.g., 192.168.1.50)
      return 'http://localhost:8080/api';
    }
  }
}

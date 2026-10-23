import 'dart:convert';
import 'package:flutter/material.dart';

class ThemeConfig {
  static const Map<String, Map<String, Color>> presetPalettes = {
    'ocean': {
      'primary': Color(0xFF0d6efd),
      'secondary': Color(0xFF6c757d),
      'bg': Color(0xFFf4f6f9),
      'text': Color(0xFF212529),
    },
    'emerald': {
      'primary': Color(0xFF059669),
      'secondary': Color(0xFF64748b),
      'bg': Color(0xFFf0fdf4),
      'text': Color(0xFF064e3b),
    },
    'sunset': {
      'primary': Color(0xFF7c3aed),
      'secondary': Color(0xFFdb2777),
      'bg': Color(0xFFfaf5ff),
      'text': Color(0xFF4c1d95),
    },
    'slate': {
      'primary': Color(0xFF334155),
      'secondary': Color(0xFF64748b),
      'bg': Color(0xFFf8fafc),
      'text': Color(0xFF0f172a),
    },
    'amber': {
      'primary': Color(0xFFd97706),
      'secondary': Color(0xFF78350f),
      'bg': Color(0xFFfffbeb),
      'text': Color(0xFF451a03),
    },
    'cyber': {
      'primary': Color(0xFF06b6d4),
      'secondary': Color(0xFFf43f5e),
      'bg': Color(0xFFecfeff),
      'text': Color(0xFF0e7490),
    },
  };

  static Future<Map<String, dynamic>> fetchDesign(apiClient) async {
    try {
      final response = await apiClient.get('/settings');
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          if (decoded.containsKey('data') && decoded['data'] is Map<String, dynamic>) {
            return decoded['data'];
          }
          return decoded;
        }
      }
    } catch (_) {}

    return {
      'theme_preset': 'ocean',
      'corner_style': 'smooth',
      'font_scale': 1.0,
      'is_dark_mode': false,
    };
  }

  static ThemeData buildTheme(Map<String, dynamic> settings) {
    final String presetKey = settings['theme_preset'] ?? 'amber';
    final String cornerKey = settings['corner_style'] ?? 'smooth';
    final double fontScale = double.tryParse(settings['font_scale']?.toString() ?? '1') ?? 1.0;
    final bool isDarkMode = settings['is_dark_mode'] ?? false;

    final palette = presetPalettes[presetKey] ?? presetPalettes['amber']!;
    final primaryColor = palette['primary']!;
    final secondaryColor = palette['secondary']!;
    final backgroundColor = palette['bg']!;
    final textColor = palette['text']!;

    double radiusValue = 10.0;
    if (cornerKey == 'sharp') radiusValue = 0.0;
    if (cornerKey == 'pill') radiusValue = 30.0;

    final brightness = isDarkMode ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDarkMode ? const Color(0xFF121212) : backgroundColor,
      primaryColor: primaryColor,
      // Explicit ColorScheme using your exact custom values (No seeding/blending)
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        surface: isDarkMode ? const Color(0xFF1e1e1e) : Colors.white,
        onSurface: isDarkMode ? Colors.white70 : textColor,
        error: Colors.red.shade700,
        onError: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDarkMode ? const Color(0xFF1e1e1e) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusValue),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusValue),
          ),
        ),
      ),
      textTheme: Typography.material2021().black.apply(
        fontSizeFactor: fontScale,
        bodyColor: isDarkMode ? Colors.white70 : textColor,
        displayColor: isDarkMode ? Colors.white : textColor,
      ),
    );
  }
}

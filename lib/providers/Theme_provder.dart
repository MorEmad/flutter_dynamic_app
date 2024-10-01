import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(_lightTheme);

  // Default Light Theme
  static final _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.cyan,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
    ),
  );

  // Default Dark Theme
  static final _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Colors.orange,
      secondary: Colors.teal,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
    ),
  );

  // Load theme from JSON
  Future<void> loadTheme() async {
    try {
      final themeData = await fetchThemeFromLocalJson(); // or fetchThemeFromApi();
      final isDarkMode = state.brightness == Brightness.dark; // Detect current mode
      final theme = isDarkMode ? themeData['dark'] : themeData['light'];
      updateThemeFromJson(theme);
    } catch (e) {
      // Fallback to default light theme if fetching fails
      state = _lightTheme;
    }
  }

  // Toggle between light and dark mode manually
  void toggleTheme(bool isDark) {
    state = isDark ? _darkTheme : _lightTheme;
  }

  // Update the theme dynamically from a specific JSON theme
  void updateThemeFromJson(Map<String, dynamic> jsonTheme) {
    state = ThemeData(
      brightness: jsonTheme['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
      colorScheme: ColorScheme(
        brightness: jsonTheme['brightness'] == 'dark' ? Brightness.dark : Brightness.light,
        primary: _parseColor(jsonTheme['primaryColor']),
        secondary: _parseColor(jsonTheme['accentColor']),
        background: _parseColor(jsonTheme['backgroundColor']),
        surface: _parseColor(jsonTheme['backgroundColor']),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: _parseColor(jsonTheme['textColor']),
        onSurface: _parseColor(jsonTheme['textColor']),
        error: Colors.red,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _parseColor(jsonTheme['backgroundColor']),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: _parseColor(jsonTheme['textColor'])),
      ),
    );
  }

  // Helper method to parse hex color strings
  Color _parseColor(String colorString) {
    String hex = colorString.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex'; // Add alpha if missing
    return Color(int.parse(hex, radix: 16));
  }
}

Future<Map<String, dynamic>> fetchThemeFromLocalJson() async {
  String jsonString = await rootBundle.loadString('assets/json/themes.json');
  return json.decode(jsonString);
}
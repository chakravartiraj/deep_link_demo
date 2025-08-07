import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Keep this import for Riverpod

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    // static ThemeData lightTheme() { // commented out the old method definition
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.latoTextTheme(),
    );
  // } // commented out the old method definition

  static final ThemeData darkTheme = ThemeData(
    // static ThemeData darkTheme() { // commented out the old method definition
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.latoTextTheme().apply(
        bodyColor: Colors.white70,
        displayColor: Colors.white70,
      ),
  );
  // } // commented out the old method definition
}

enum ThemeModeType { system, light, dark }

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeModeType>((ref) {
 return ThemeNotifier();
});
class ThemeNotifier extends StateNotifier<ThemeModeType> {
  ThemeNotifier() : super(ThemeModeType.system);

  void toggleTheme() {
    state = state == ThemeModeType.light ? ThemeModeType.dark : ThemeModeType.light;
  }

  ThemeMode get materialThemeMode {
    switch (state) {
      case ThemeModeType.light:
        return ThemeMode.light;
      case ThemeModeType.dark:
        return ThemeMode.dark;
      case ThemeModeType.system:
        return systemBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    }
  }

  Brightness get systemBrightness {
    return PlatformDispatcher.instance.platformBrightness;
  }
}
import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFF27023); // Naranja corporativo
  static const Color backgroundLight = Colors.white;
  static const Color backgroundDark = Color(0xFF232323); // Gris oscuro real
  static const Color accent = Color(0xFF565656); // Gris oscuro para texto
  static const Color secondary = Color(0xFFD8D4CF); // Gris claro corporativo
  static const Color surface = Color(0xFFF5F5F5);
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);
}

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white, // Texto blanco sobre naranja
      background: AppColors.backgroundLight,
      onBackground: AppColors.accent, // Texto gris oscuro sobre fondo blanco
      surface: AppColors.backgroundLight,
      onSurface: AppColors.accent,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary, // Fondo naranja
      foregroundColor: Colors.white, // Texto blanco
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.accent),
      bodyMedium: TextStyle(color: AppColors.accent),
      titleLarge: TextStyle(
        color: AppColors.accent,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.backgroundDark, // Gris oscuro real
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.backgroundDark, // Texto gris oscuro sobre naranja
      background: AppColors.backgroundDark,
      onBackground: AppColors.primary, // Texto naranja sobre fondo gris oscuro
      surface: AppColors.backgroundDark,
      onSurface: AppColors.primary,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.backgroundDark, // Fondo gris oscuro
      foregroundColor: AppColors.primary, // Texto naranja
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primary),
      bodyMedium: TextStyle(color: AppColors.primary),
      titleLarge: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

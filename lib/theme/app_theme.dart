import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales - Paleta elegante dark con acentos dorados
  static const Color primaryColor = Color(0xFFD4AF37); // Gold - elegante y sofisticado
  static const Color secondaryColor = Color(0xFFC0C0C0); // Silver - complemento elegante
  static const Color accentColor = Color(0xFF8B4513); // Saddle Brown - tierra elegante
  static const Color backgroundColor = Color(0xFF1A1A1A); // Negro carbón elegante
  static const Color surfaceColor = Color(0xFF2D2D2D); // Gris oscuro sofisticado
  static const Color cardColor = Color(0xFF3A3A3A); // Gris medio para cards

  // Colores de texto - refinados
  static const Color textPrimary = Color(0xFFF5F5F5); // Blanco marfil elegante
  static const Color textSecondary = Color(0xFFB8B8B8); // Gris plateado
  static const Color textTertiary = Color(0xFF808080); // Gris medio

  // Colores de estado - con acentos elegantes
  static const Color successColor = Color(0xFF228B22); // Forest Green - natural y elegante
  static const Color warningColor = Color(0xFFDAA520); // Goldenrod - dorado cálido
  static const Color errorColor = Color(0xFF8B0000); // Dark Red - elegante y no agresivo

  // Colores adicionales para efectos visuales
  static const Color shadowColor = Color(0x40000000); // Negro con opacidad para sombras
  static const Color borderColor = Color(0xFF555555); // Gris medio para bordes
  static const Color highlightColor = Color(0xFFE6B800); // Gold más claro para highlights

  static ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cardColor.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
        hintStyle: const TextStyle(color: textTertiary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textTertiary,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 3),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: cardColor,
        selectedColor: primaryColor,
        labelStyle: const TextStyle(color: textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
}

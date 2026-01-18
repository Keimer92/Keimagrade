import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales - Paleta elegante dark con acentos dorados
  static const Color primaryColor =
      Color(0xFFD4AF37); // Gold - elegante y sofisticado
  static const Color secondaryColor =
      Color(0xFFC0C0C0); // Silver - complemento elegante
  static const Color accentColor =
      Color(0xFF8B4513); // Saddle Brown - tierra elegante
  static const Color backgroundColor =
      Color(0xFF1A1A1A); // Negro carbón elegante
  static const Color surfaceColor =
      Color(0xFF2D2D2D); // Gris oscuro sofisticado
  static const Color cardColor = Color(0xFF3A3A3A); // Gris medio para cards

  // Colores de texto - refinados
  static const Color textPrimary = Color(0xFFF5F5F5); // Blanco marfil elegante
  static const Color textSecondary = Color(0xFFB8B8B8); // Gris plateado
  static const Color textTertiary = Color(0xFF808080); // Gris medio

  // Colores de estado - con acentos elegantes
  static const Color successColor =
      Color(0xFF228B22); // Forest Green - natural y elegante
  static const Color warningColor =
      Color(0xFFDAA520); // Goldenrod - dorado cálido
  static const Color errorColor =
      Color(0xFF8B0000); // Dark Red - elegante y no agresivo

  // Colores adicionales para efectos visuales
  static const Color shadowColor =
      Color(0x40000000); // Negro con opacidad para sombras
  static const Color borderColor = Color(0xFF555555); // Gris medio para bordes
  static const Color highlightColor =
      Color(0xFFE6B800); // Gold más claro para highlights

  static ThemeData buildTheme(Color primaryColor, Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    // Configuración de colores basada en brillo
    final Color background =
        isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final Color surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final Color card = isDark ? const Color(0xFF252525) : Colors.white;
    final Color textP =
        isDark ? const Color(0xFFF5F5F5) : const Color(0xFF1A1A1A);
    final Color textS =
        isDark ? const Color(0xFFB8B8B8) : const Color(0xFF4A4A4A);
    final Color textT =
        isDark ? const Color(0xFF808080) : const Color(0xFF757575);
    final Color border =
        isDark ? const Color(0xFF333333) : const Color(0xFFE0E0E0);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: brightness,
        primary: primaryColor,
        surface: surface,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: textP,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: isDark ? 4 : 2,
        shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side:
              isDark ? BorderSide.none : BorderSide(color: border, width: 0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? surface : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? border : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: TextStyle(color: textS, fontWeight: FontWeight.w500),
        hintStyle: TextStyle(color: textT),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: isDark ? const Color(0xFF121212) : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryColor,
        unselectedLabelColor: textT,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryColor, width: 3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? card : Colors.grey[200],
        selectedColor: primaryColor.withValues(alpha: 0.2),
        labelStyle: TextStyle(color: isDark ? textP : textP, fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
              color: isDark ? border : Colors.grey[300]!, width: 0.5),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: border,
        space: 1,
        thickness: 0.5,
      ),
    );
  }

  // Keep original static definitions for convenience in widgets if needed
  static Color getBackgroundColor(BuildContext context) =>
      Theme.of(context).scaffoldBackgroundColor;
  static Color getSurfaceColor(BuildContext context) =>
      Theme.of(context).cardColor;
  static Color getPrimaryColor(BuildContext context) =>
      Theme.of(context).primaryColor;
  static Color getTextPrimary(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge?.color ??
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87);
  static Color getTextSecondary(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.color ??
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[400]!
          : Colors.black54);
  static Color getTextTertiary(BuildContext context) =>
      (Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[600]!
          : Colors.grey[500]!);
  static Color getErrorColor(BuildContext context) =>
      Theme.of(context).colorScheme.error;
}

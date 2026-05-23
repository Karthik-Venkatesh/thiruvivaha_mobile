import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThiruvivahaTheme {
  // Colors from DESIGN.md
  static const Color primary = Color(0xFF7b001f); // Heritage Crimson
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF9e1b32);
  static const Color onPrimaryContainer = Color(0xFFffb0b3);

  static const Color secondary = Color(0xFF864e5a); // Petal Rose
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFfeb6c3);
  static const Color onSecondaryContainer = Color(0xFF7b4450);

  static const Color tertiary = Color(0xFF4e3700); // Champagne Gold
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF694d0c);
  static const Color onTertiaryContainer = Color(0xFFe7bf75);

  static const Color surface = Color(0xFFf9f9f9); // Alabaster White
  static const Color onSurface = Color(0xFF1a1c1c);
  static const Color surfaceVariant = Color(0xFFe2e2e2); // Mist Grey
  static const Color onSurfaceVariant = Color(0xFF594141);

  static const Color error = Color(0xFFba1a1a);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFffdad6);
  static const Color onErrorContainer = Color(0xFF93000a);

  static const Color outline = Color(0xFF8c7071);
  static const Color outlineVariant = Color(0xFFe0bfbf);

  static const Color inverseSurface = Color(0xFF2f3131);
  static const Color inverseOnSurface = Color(0xFFf1f1f1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        outline: outline,
        outlineVariant: outlineVariant,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: onSurface),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.02,
        ),
        headlineLarge: GoogleFonts.playfairDisplay(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.manrope(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.manrope(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.6,
        ),
        bodySmall: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelMedium: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.08,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFdadada), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFdadada), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error, width: 2),
        ),
        hintStyle: GoogleFonts.manrope(color: Color(0xFF8c7071), fontSize: 16),
        labelStyle: GoogleFonts.manrope(color: onSurface, fontSize: 14),
        errorStyle: GoogleFonts.manrope(color: error, fontSize: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryContainer.withValues(alpha: 0.3),
        labelStyle: GoogleFonts.manrope(
          color: secondary,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

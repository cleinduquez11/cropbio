import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildSubtleTheme(BuildContext context) {
  const seedColor = Color(0xFF0B3C5D); // deep teal/blue

  final ColorScheme baseScheme = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  // Create a "subtle" variant by adjusting a few colors
  final ColorScheme subtleScheme = baseScheme.copyWith(
    primary: baseScheme.primary, // keep seed color
    onPrimary: Colors.white, // readable text on primary
    secondary: baseScheme.primaryContainer, // soft secondary
    onSecondary: baseScheme.onPrimary,
    surface: baseScheme.surface.withOpacity(0.95), // slightly softer surfaces
    onSurface: Colors.black87,
    background: baseScheme.background.withOpacity(0.97), // soft background
    onBackground: Colors.black87,
    surfaceVariant: baseScheme.primary.withOpacity(0.08), // gentle surface variant
    outline: baseScheme.primary.withOpacity(0.3), // subtle outlines
  );

  // Text theme using Nunito Sans
  final baseTextTheme = GoogleFonts.nunitoSansTextTheme(
    Theme.of(context).textTheme,
  ).apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black87,
  );

  final textTheme = baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(fontSize: 36),
    displayMedium: baseTextTheme.displayMedium?.copyWith(fontSize: 32),
    displaySmall: baseTextTheme.displaySmall?.copyWith(fontSize: 28),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(fontSize: 24),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(fontSize: 22),
    titleLarge: baseTextTheme.titleLarge?.copyWith(fontSize: 20),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(fontSize: 16),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(fontSize: 14),
    titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16),
    titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 14),
    labelLarge: baseTextTheme.labelLarge?.copyWith(fontSize: 14),
    bodySmall: baseTextTheme.bodySmall?.copyWith(fontSize: 12),
    labelSmall: baseTextTheme.labelSmall?.copyWith(fontSize: 10),
  );

  return ThemeData(
    colorScheme: subtleScheme,
    useMaterial3: true,
    textTheme: textTheme,
    scaffoldBackgroundColor: subtleScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: subtleScheme.primary,
      foregroundColor: subtleScheme.onPrimary,
      elevation: 0,
    ),
    cardTheme: CardTheme(
      color: subtleScheme.surface,
      margin: const EdgeInsets.all(8),
      elevation: 2,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: subtleScheme.primary,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

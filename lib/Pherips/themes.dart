import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData buildAppTheme(BuildContext context) {
  final base = Theme.of(context);

  // Start with GoogleFonts Nunito Sans
  TextTheme textTheme = GoogleFonts.nunitoSansTextTheme(base.textTheme).apply(
    bodyColor: Colors.black87,
    displayColor: Colors.black87,
  );

  // Customize font sizes
  textTheme = textTheme.copyWith(
    displayLarge: textTheme.displayLarge?.copyWith(fontSize: 36),
    displayMedium: textTheme.displayMedium?.copyWith(fontSize: 32),
    displaySmall: textTheme.displaySmall?.copyWith(fontSize: 28),
    headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 24),
    headlineSmall: textTheme.headlineSmall?.copyWith(fontSize: 22),
    titleLarge: textTheme.titleLarge?.copyWith(fontSize: 20),
    bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16),
    bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14),
    titleMedium: textTheme.titleMedium?.copyWith(fontSize: 16),
    titleSmall: textTheme.titleSmall?.copyWith(fontSize: 14),
    labelLarge: textTheme.labelLarge?.copyWith(fontSize: 14),
    bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12),
    labelSmall: textTheme.labelSmall?.copyWith(fontSize: 10),
  );

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B3C5D)),
    useMaterial3: true,
    
    textTheme: textTheme,
    scaffoldBackgroundColor: Colors.white,
  );
}

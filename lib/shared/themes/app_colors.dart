import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF7F2F3A);
  static const Color primaryLight = Color(0xFF9A4A54);
  static const Color primaryDark = Color(0xFF5A1F28);

  // White (Base Color)
  static const Color white = Color(0xFFFFFFFF);
  static const Color whiteLight = Color(0xFFF8F9FA);
  static const Color whiteDark = Color(0xFFE9ECEF);

  // Secondary Colors
  static const Color secondary = Color(0xFF6B7AED);
  static const Color secondaryLight = Color(0xFF8B9AFF);
  static const Color secondaryDark = Color(0xFF4B5AD8);

  // Accent Colors
  static const Color accent = Color(0xFFEE544A);
  static const Color accentLight = Color(0xFFFF6B61);
  static const Color accentDark = Color(0xFFD63D35);

  // Additional Colors
  static const Color orange = Color(0xFFFF8D5D);
  static const Color purple = Color(0xFF7D67EE);
  static const Color green = Color(0xFF29D697);
  static const Color blue = Color(0xFF39D1F2);
  static const Color cyan = Color(0xFF00F8FF);

  // Surface Colors
  static const Color surface = white;
  static const Color surfaceVariant = whiteLight;
  static const Color surfaceDark = Color(0xFF121212);

  // Background Colors
  static const Color background = whiteLight;
  static const Color backgroundDark = Color(0xFF000000);

  // Text Colors
  static const Color onPrimary = white;
  static const Color onSecondary = white;
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color onSurfaceVariant = Color(0xFF666666);
  static const Color onBackground = Color(0xFF1A1A1A);
  static const Color onBackgroundDark = white;

  // Error Colors
  static const Color error = accent;
  static const Color errorLight = accentLight;

  // Success Colors
  static const Color success = green;
  static const Color successLight = Color(0xFF4CE4A8);

  // Warning Colors
  static const Color warning = orange;
  static const Color warningLight = Color(0xFFFFA375);

  // Info Colors
  static const Color info = blue;
  static const Color infoLight = Color(0xFF5DD9F5);

  // Outline Colors
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineDark = Color(0xFF424242);

  // Map Colors
  static const Color mapPrimary = primary;
  static const Color mapSecondary = secondary;
  static const Color mapBackground = background;

  // Light Color Scheme
  static ColorScheme get lightColorScheme => const ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
    secondary: secondary,
    onSecondary: onSecondary,
    error: error,
    onError: onPrimary,
    background: background,
    onBackground: onBackground,
    surface: surface,
    onSurface: onSurface,
    surfaceVariant: surfaceVariant,
    onSurfaceVariant: onSurfaceVariant,
    outline: outline,
  );

  // Dark Color Scheme
  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLight,
    onPrimary: onPrimary,
    secondary: secondaryLight,
    onSecondary: onSecondary,
    error: errorLight,
    onError: onPrimary,
    background: backgroundDark,
    onBackground: onBackgroundDark,
    surface: surfaceDark,
    onSurface: onBackgroundDark,
    surfaceVariant: Color(0xFF1E1E1E),
    onSurfaceVariant: Color(0xFFCCCCCC),
    outline: outlineDark,
  );
}

import 'package:flutter/material.dart';

class AppColors {
  static const Color purple = Color(0xFF4C1D95);
  static const Color purpleSoft = Color(0xFFB180FF);

  static const Color orange = Color(0xFFFF8A2A);
  static const Color orangeSoft = Color(0xFFFFB066);

  static const Color lightBg = Color(0xFFF7F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF111827);
  static const Color lightMuted = Color(0xFF6B7280);

  static const Color darkBg = Color(0xFF0B0B0D);
  static const Color darkSurface = Color(0xFF141417);
  static const Color darkText = Color(0xFFE5E7EB);
  static const Color darkMuted = Color(0xFF9CA3AF);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: purple,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEDE9FE),
    onPrimaryContainer: purple,

    secondary: orange,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFFFFE5D3),
    onSecondaryContainer: Colors.black,

    background: lightBg,
    onBackground: lightText,

    surface: lightSurface,
    onSurface: lightText,

    surfaceVariant: Color(0xFFE5E7EB),
    onSurfaceVariant: lightMuted,

    outline: Color(0xFFD1D5DB),
    outlineVariant: Color(0xFFE5E7EB),

    error: danger,
    onError: Colors.white,

    inverseSurface: Color(0xFF111827),
    onInverseSurface: Color(0xFFF9FAFB),
    inversePrimary: purpleSoft,

    shadow: Colors.black,
    scrim: Colors.black54,
  );

  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,

    primary: purpleSoft,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF312E81),
    onPrimaryContainer: Colors.white,

    secondary: orange,
    onSecondary: Colors.black,
    secondaryContainer: Color(0xFF3A1D07),
    onSecondaryContainer: Colors.white,

    background: darkBg,
    onBackground: darkText,

    surface: darkSurface,
    onSurface: darkText,

    surfaceVariant: Color(0xFF1F1F23),
    onSurfaceVariant: darkMuted,

    outline: Color(0xFF2E2E33),
    outlineVariant: Color(0xFF1F1F23),

    error: danger,
    onError: Colors.white,

    inverseSurface: Color(0xFFE5E7EB),
    onInverseSurface: Color(0xFF0B0B0D),
    inversePrimary: purple,

    shadow: Colors.black,
    scrim: Colors.black87,
  );
}

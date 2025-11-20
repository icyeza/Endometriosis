import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Flo Rose/Pink with Lavender accents
  static const Color primary =
      Color(0xFFE8839D); // Flo Rose/Pink (primary action)
  static const Color primaryLight = Color(0xFFF5C7D8); // Flo Light Pink
  static const Color primaryDark = Color(0xFFD4526B); // Flo Dark Pink

  // Lavender accent colors
  static const Color lavender = Color(0xFFC7B6FF); // Soft Lavender
  static const Color lavenderLight = Color(0xFFE4D9FF); // Lilac
  static const Color lavenderDark = Color(0xFFB39AFF); // Darker Lavender

  // Secondary colors - Flo Purple
  static const Color secondary = Color(0xFF6B5B95); // Flo Purple
  static const Color secondaryLight = Color(0xFFC8B5D4); // Light Purple

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyLight = Color(0xFFF3F4F6);
  static const Color greyDark = Color(0xFF4B5563);

  // Status colors
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Gradient colors - Flo + Lavender blend
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lavenderGradient = LinearGradient(
    colors: [lavender, lavenderLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient floLavenderGradient = LinearGradient(
    colors: [primary, lavender],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF6EE7B7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppBorderRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double full = 999;
}

class AppShadow {
  static final BoxShadow light = BoxShadow(
    color: Colors.black.withOpacity(0.05),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  static final BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );

  static final BoxShadow heavy = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 16,
    offset: const Offset(0, 8),
  );
}

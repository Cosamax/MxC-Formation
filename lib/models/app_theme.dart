// ============================================================
// LEGAL QUEST — Thème & Constantes de design (Navy Blue & Or)
// ============================================================

import 'package:flutter/material.dart';

class AppTheme {
  // ── Couleurs principales ─────────────────────────────────
  static const Color navyDark    = Color(0xFF0A1628);
  static const Color navyMid     = Color(0xFF142244);
  static const Color navyLight   = Color(0xFF1E3264);
  static const Color navyAccent  = Color(0xFF243B70);

  static const Color gold        = Color(0xFFF4C430);
  static const Color goldLight   = Color(0xFFFFD966);
  static const Color goldDark    = Color(0xFFD4A017);

  static const Color success     = Color(0xFF27AE60);
  static const Color error       = Color(0xFFE74C3C);
  static const Color warning     = Color(0xFFF39C12);
  static const Color info        = Color(0xFF2980B9);

  static const Color textLight   = Color(0xFFF5F5F5);
  static const Color textMuted   = Color(0xFFB0BEC5);
  static const Color cardBg      = Color(0xFF1A2E52);
  static const Color divider     = Color(0xFF2D4A7A);

  // ── Gradient principal ───────────────────────────────────
  static const LinearGradient navyGradient = LinearGradient(
    colors: [navyDark, navyMid, navyLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldDark, gold, goldLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [navyAccent, cardBg],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Thème Flutter ────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.dark(
          primary: gold,
          secondary: goldLight,
          surface: navyMid,
          error: error,
        ),
        scaffoldBackgroundColor: navyDark,
        appBarTheme: const AppBarTheme(
          backgroundColor: navyDark,
          foregroundColor: textLight,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
          headlineLarge: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w800,
          ),
          headlineMedium: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w700,
          ),
          titleLarge: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w700,
          ),
          titleMedium: TextStyle(
            color: textLight,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(color: textLight),
          bodyMedium: TextStyle(color: textMuted),
          labelLarge: TextStyle(
            color: navyDark,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          shadowColor: Colors.black45,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: gold,
            foregroundColor: navyDark,
            elevation: 4,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: gold,
            side: BorderSide(color: gold, width: 1.5),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: divider,
          thickness: 1,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: gold,
          linearTrackColor: navyAccent,
        ),
      );
}

// ── Modules metadata ─────────────────────────────────────
class ModuleColors {
  static const Map<int, Color> colors = {
    0: Color(0xFF1565C0), // bleu foncé
    1: Color(0xFF00695C), // vert teal
    2: Color(0xFF6A1B9A), // violet
    3: Color(0xFFE65100), // orange
    4: Color(0xFF1B5E20), // vert foncé
    5: Color(0xFFC62828), // rouge — Grand Final
  };

  static Color forModule(int index) =>
      colors[index] ?? AppTheme.navyLight;
}

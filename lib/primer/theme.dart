import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// The small visual vocabulary shared by the Primer journey.
///
/// This intentionally does not use Material component styling as the product
/// language. Screens can use [primerTheme] for text defaults, while widgets
/// below use these tokens directly so they read like book furniture.
abstract final class PrimerTheme {
  static const paper = Color(0xFFF4E9D5);
  static const paperLight = Color(0xFFFBF4E7);
  static const parchment = Color(0xFFE7D5B8);
  static const ink = Color(0xFF332B26);
  static const inkSoft = Color(0xFF67584B);
  static const pencil = Color(0xFF8A8780);
  static const line = Color(0xFFBBA689);
  static const lamp = Color(0xFFE0A04D);
  static const lampPale = Color(0xFFF4D497);
  static const berry = Color(0xFF9D4D55);
  static const berryPale = Color(0xFFE5B4AB);
  static const night = Color(0xFF1E2424);
  static const nightInk = Color(0xFFF2E8D5);
  static const field = Color(0xFFC2B49A);

  static const space1 = 4.0;
  static const space2 = 8.0;
  static const space3 = 12.0;
  static const space4 = 16.0;
  static const space5 = 24.0;
  static const space6 = 32.0;
  static const space7 = 48.0;
  static const space8 = 64.0;

  static TextStyle get display => GoogleFonts.baloo2(
        color: ink,
        fontSize: 38,
        height: 1.05,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get story => GoogleFonts.baloo2(
        color: ink,
        fontSize: 21,
        height: 1.55,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get affordance => GoogleFonts.baloo2(
        color: inkSoft,
        fontSize: 15,
        height: 1.3,
        fontWeight: FontWeight.w700,
      );

  static TextStyle get label => GoogleFonts.baloo2(
        color: inkSoft,
        fontSize: 11,
        height: 1.2,
        letterSpacing: 1.5,
        fontWeight: FontWeight.w800,
      );
}

ThemeData primerTheme() {
  final base = ThemeData.light(useMaterial3: false);
  return base.copyWith(
    scaffoldBackgroundColor: PrimerTheme.parchment,
    canvasColor: PrimerTheme.paper,
    primaryColor: PrimerTheme.lamp,
    colorScheme: const ColorScheme.light(
      primary: PrimerTheme.berry,
      secondary: PrimerTheme.lamp,
      surface: PrimerTheme.paper,
      onSurface: PrimerTheme.ink,
      onPrimary: PrimerTheme.paperLight,
    ),
    textTheme: GoogleFonts.baloo2TextTheme(base.textTheme).apply(
      bodyColor: PrimerTheme.ink,
      displayColor: PrimerTheme.ink,
    ),
    cardTheme: const CardThemeData(
      color: PrimerTheme.paper,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
  );
}

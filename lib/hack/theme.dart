import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette + font lifted from HabitCrafts `FlutterFlowTheme.LightModeTheme`
/// (lib/flutter_flow/flutter_flow_theme.dart). Values only — the generated
/// theme class drags in flutter_flow_util and Firebase, which we don't want.
abstract final class HC {
  static const primary = Color(0xFF507598);
  static const secondary = Color(0xFF325171);
  static const tertiary = Color(0xFFE6EEF8);
  static const accent1 = Color(0xFFEFC530);
  static const accent2 = Color(0xFF80BBC8);
  static const primaryText = Color(0xFF325171);
  static const success = Color(0xFF4DC360);
  static const grayDark = Color(0xFF57636C);
  static const surface = Color(0xFFFFFFFF);
}

ThemeData habitCraftsTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: HC.primary,
      primary: HC.primary,
      secondary: HC.secondary,
      surface: HC.surface,
    ),
    scaffoldBackgroundColor: HC.tertiary,
    textTheme: GoogleFonts.poppinsTextTheme(base.textTheme)
        .apply(bodyColor: HC.primaryText, displayColor: HC.primaryText),
    appBarTheme: const AppBarTheme(
      backgroundColor: HC.primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: const CardThemeData(
      color: HC.surface,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: HC.primary,
        minimumSize: const Size.fromHeight(52),
      ),
    ),
  );
}

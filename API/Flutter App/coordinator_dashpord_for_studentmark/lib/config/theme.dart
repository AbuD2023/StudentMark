import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'constants.dart';

const String MOBILE = 'MOBILE';
const String TABLET = 'TABLET';
const String DESKTOP = 'DESKTOP';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: Colors.blue,
        secondary: Colors.blueAccent,
        surface: Colors.white,
        background: Colors.grey[100]!,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static List<Breakpoint> get responsiveBreakpoints => [
        const Breakpoint(
            start: 0, end: AppConstants.mobileBreakpoint, name: MOBILE),
        const Breakpoint(
            start: AppConstants.mobileBreakpoint + 1,
            end: AppConstants.tabletBreakpoint,
            name: TABLET),
        const Breakpoint(
            start: AppConstants.tabletBreakpoint + 1,
            end: AppConstants.desktopBreakpoint,
            name: DESKTOP),
        const Breakpoint(
            start: AppConstants.desktopBreakpoint + 1,
            end: double.infinity,
            name: '4K'),
      ];
}

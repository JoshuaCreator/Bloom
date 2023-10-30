import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      // centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    dividerColor: Colors.black.withOpacity(0.3),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      // centerTitle: true,
      surfaceTintColor: Colors.transparent,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
    ),
    dividerColor: Colors.white.withOpacity(0.3),
  );
}

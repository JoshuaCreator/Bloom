import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themePrefsKey = 'selectedThemeKey';

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError(),
);

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier({
    required this.prefs,
    required ThemeMode initialThemeMode,
  }) : super(initialThemeMode);

  final SharedPreferences prefs;

  Future<void> changeAndSave(ThemeMode theme) async {
    await prefs.setInt(_themePrefsKey, theme.index);
    state = theme;
  }
}

final themeSelectorProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    final index = prefs.getInt(_themePrefsKey) ?? ThemeMode.system.index;
    final themeMode = ThemeMode.values.firstWhere(
      (element) => element.index == index,
      orElse: () => ThemeMode.system,
    );

    return ThemeNotifier(
      prefs: prefs,
      initialThemeMode: themeMode,
    );
  },
);

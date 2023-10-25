import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:basic_board/configs/consts.dart';

import '../../providers/theme_provider.dart';

class ThemeSelectorScreen extends ConsumerWidget {
  static String id = 'theme-selector';
  const ThemeSelectorScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSelector = ref.watch(themeSelectorProvider.notifier);
    final currentTheme = ref.watch(themeSelectorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Change app theme')),
      body: ListView.separated(
        itemCount: ThemeMode.values.length,
        padding: EdgeInsets.all(ten),
        separatorBuilder: (context, index) => height10,
        itemBuilder: (_, index) {
          final themeMode = ThemeMode.values[index];
          return RadioListTile(
            shape: RoundedRectangleBorder(borderRadius: defaultBorderRadius),
            value: themeMode,
            groupValue: currentTheme,
            onChanged: (newTheme) => themeSelector.changeAndSave(newTheme!),
            title: Text(
              describeEnum(themeMode).substring(0, 1).toUpperCase() +
                  describeEnum(themeMode).substring(1).toLowerCase(),
            ),
            subtitle: Text('Use ${themeMode.name} theme'),
          );
        },
      ),
    );
  }
}

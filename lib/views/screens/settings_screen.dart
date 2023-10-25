import 'package:basic_board/views/screens/home_screen.dart';
import 'package:basic_board/views/screens/theme_selector_screen.dart';
import 'package:basic_board/views/widgets/settings_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  static String id = 'settings';
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SettingTile(
            title: 'App theme',
            subtitle: 'Change app theme according to your preference',
            leading: Icons.light_mode_rounded,
            onTap: () {
              context.push(
                '${HomeScreen.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
              );
            },
          ),
        ],
      ),
    );
  }
}

// import 'package:basic_board/views/screens/home_screen.dart';
// import 'package:basic_board/views/screens/theme_selector_screen.dart';
// import 'package:basic_board/views/widgets/settings_tile.dart';
// import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
          // children: [
          //   SettingTile(
          //     title: 'App theme',
          //     subtitle: 'Change app theme according to your preference',
          //     leading: Icons.light_mode_rounded,
          //     onTap: () {
          //       context.push(
          //         '${HomeScreen.id}/${SettingsScreen.id}/${ThemeSelectorScreen.id}',
          //       );
          //     },
          //   ),
          // ],
          ),
    );
  }
}

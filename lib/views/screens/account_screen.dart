import 'package:basic_board/configs/consts.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: EdgeInsets.only(top: ten),
        children: [
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: const Text('Change email'),
            onTap: () {
              //! Do something awesome
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Delete account'),
            onTap: () {
              //! Do something awesome
            },
          ),
        ],
      ),
    );
  }
}

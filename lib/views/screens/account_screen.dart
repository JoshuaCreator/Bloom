import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth.dart';

class AccountScreen extends StatelessWidget {
  static String id = 'account';
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          IconButton(
            onPressed: () {
              Auth().signOut(context);
              context.pop();
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}

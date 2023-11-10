import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/services/auth.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';

import '../widgets/app_button.dart';

class PasswordResetScreen extends StatefulWidget {
  static String id = '/password-reset';
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Reset Password'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(ten),
          child: Form(
            key: PasswordResetScreen._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  controller: emailController,
                ),
                height40,
                AppButton(
                  label: 'Proceed',
                  onTap: () => Auth().sendPasswordResetLink(
                    context,
                    email: emailController.text.trim(),
                  ),
                ),
                height20,
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => context.go(LoginScreen.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

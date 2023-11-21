import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/services/auth.dart';

import '../widgets/app_button.dart';
import '../widgets/app_text_buttons.dart';
import '../widgets/app_text_field.dart';
import 'password_reset_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ten),
          child: Form(
            key: LoginScreen._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Email',
                  hintText: 'Enter your email address',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                ),
                height20,
                AppTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  obscureText: obscureText,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      obscureText = !obscureText;
                    }),
                    icon: Icon(
                      obscureText
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                    ),
                    color: Colors.purple[300],
                  ),
                ),
                height5,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppTextButton(
                      onPressed: () => context.go(PasswordResetScreen.id),
                      label: 'Reset password',
                    ),
                  ],
                ),
                height30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppOutlinedButton(
                      label: 'Register',
                      onTap: () => context.go(RegisterScreeen.id),
                    ),
                    AppButton(
                      label: 'Log In',
                      onTap: () => Auth().logIn(
                        context,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

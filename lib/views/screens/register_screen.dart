import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/services/auth.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';

import '../../models/user.dart';

class RegisterScreeen extends StatefulWidget {
  static String id = '/register';
  const RegisterScreeen({super.key});

  @override
  State<RegisterScreeen> createState() => _RegisterScreeenState();
}

class _RegisterScreeenState extends State<RegisterScreeen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final fNameController = TextEditingController();
  // final lNameController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ten),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextField(
                  label: 'Display name',
                  hintText: 'e.g. Joshua Ewaoche',
                  textInputAction: TextInputAction.next,
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  validate: false,
                ),
                height20,
                AppTextField(
                  label: 'Phone number*',
                  hintText: 'Enter your phone number',
                  textInputAction: TextInputAction.next,
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                ),
                height20,
                AppTextField(
                  label: 'Email*',
                  hintText: 'Enter your email address',
                  textInputAction: TextInputAction.next,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                height20,
                AppTextField(
                  label: 'Password*',
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
                SizedBox(height: size * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppOutlinedButton(
                      label: 'Login',
                      onTap: () => context.go(LoginScreen.id),
                    ),
                    AppButton(
                      label: 'Register',
                      onTap: () {
                        AppUser user = AppUser(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: int.parse(phoneController.text),
                        );
                        if (_formKey.currentState!.validate()) {
                          Auth().register(
                            context,
                            email: user.email!,
                            password: passwordController.text.trim(),
                            user: user,
                          );
                        }
                      },
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
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

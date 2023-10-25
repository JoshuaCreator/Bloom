import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:basic_board/configs/consts.dart';
import 'package:basic_board/services/auth.dart';
import 'package:basic_board/views/screens/login_screen.dart';
import 'package:basic_board/views/widgets/app_button.dart';
import 'package:basic_board/views/widgets/app_text_field.dart';

import '../../models/user.dart';
import '../widgets/app_dropdown.dart';

class RegisterScreeen extends StatefulWidget {
  static String id = '/register';
  const RegisterScreeen({super.key});

  @override
  State<RegisterScreeen> createState() => _RegisterScreeenState();
}

class _RegisterScreeenState extends State<RegisterScreeen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final oNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;
  List titles = ['Mr', 'Mrs', 'Miss', 'Sir'];
  @override
  Widget build(BuildContext context) {
    String? title = titles[0];
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
                AppDropdownField(
                  value: title,
                  hintText: 'How would you like to be addressed',
                  items: List.generate(
                    titles.length,
                    (index) => DropdownMenuItem(
                      value: '${titles[index]}',
                      child: Text('${titles[index]}'),
                    ),
                  ),
                  onChanged: (newTitle) {
                    title = newTitle;
                  },
                ),
                height20,
                AppTextField(
                  label: 'First name*',
                  hintText: 'Enter your first name',
                  textInputAction: TextInputAction.next,
                  controller: fNameController,
                  keyboardType: TextInputType.name,
                ),
                height20,
                AppTextField(
                  label: 'Last name*',
                  hintText: 'Enter your last name',
                  textInputAction: TextInputAction.next,
                  controller: lNameController,
                  keyboardType: TextInputType.name,
                ),
                height20,
                AppTextField(
                  label: 'Other name',
                  hintText: 'e.g. middle name',
                  textInputAction: TextInputAction.next,
                  controller: oNameController,
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
                height40,
                AppButton(
                  title: 'Register',
                  onTap: () {
                    AppUser user = AppUser(
                      title: title,
                      fName: fNameController.text.trim(),
                      lName: lNameController.text.trim(),
                      oName: lNameController.text.trim(),
                      phone: int.parse(phoneController.text),
                    );
                    if (_formKey.currentState!.validate()) {
                      Auth().register(
                        context,
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                        user: user,
                      );
                    }
                  },
                ),
                height20,
                TextButton(
                  child: const Text('Login'),
                  onPressed: () => context.go(LoginScreen.id),
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
    fNameController.dispose();
    lNameController.dispose();
    oNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

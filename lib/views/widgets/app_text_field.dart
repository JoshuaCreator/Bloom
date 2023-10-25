import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.validate = true,
  });
  final String label;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool validate;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field cannot be empty';
              }
              return null;
            }
          : null,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ten,
          vertical: ten + five,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: defaultBorderRadius),
        label: Text(label),
        hintText: hintText,
        focusedBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(
            color: Colors.purple.shade300,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: BorderSide(
            color: Colors.purple.shade300,
          ),
        ),
      ),
      maxLines: maxLines,
      minLines: minLines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      textInputAction: textInputAction,
      initialValue: initialValue,
    );
  }
}

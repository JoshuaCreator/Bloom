import 'package:flutter/material.dart';

import '../../configs/consts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label = '',
    required this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction = TextInputAction.done,
    this.controller,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.validate = true,
    this.borderless = false,
    this.autofocus = false,
  });
  final String? label;
  final String hintText;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final void Function(String)? onChanged, onFieldSubmitted;
  final String? initialValue;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final bool validate;
  final bool borderless;
  final bool autofocus;

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
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ten,
          vertical: ten + five,
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: defaultBorderRadius),
        label: borderless ? null : Text(label!),
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        filled: borderless,
        fillColor: Colors.grey.withOpacity(0.3),
        focusedBorder: borderless
            ? OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: Colors.purple.shade300,
                  width: 2,
                ),
              ),
        enabledBorder: borderless
            ? OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(
                borderRadius: defaultBorderRadius,
                borderSide: BorderSide(
                  color: Colors.purple.shade300,
                ),
              ),
      ),
      autofocus: autofocus,
      maxLines: maxLines,
      minLines: minLines,
      onTapOutside: (event) => FocusManager.instance.primaryFocus!.unfocus(),
      textInputAction: textInputAction,
      initialValue: initialValue,
    );
  }
}

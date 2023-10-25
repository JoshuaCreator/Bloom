import 'package:flutter/material.dart';
import 'package:basic_board/configs/consts.dart';

class AppDropdownField extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.hintText,
    required this.value,
    this.items,
    this.onChanged,
  });

  final String hintText;
  final String? value;
  final List<DropdownMenuItem<Object>>? items;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      // validator: (value) {
      //   if (value == null) {
      //     return 'This field cannot be empty';
      //   }
      //   return null;
      // },
      value: value,
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        hintText: hintText,
        contentPadding: EdgeInsets.symmetric(
          horizontal: ten,
          vertical: ten + five,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: defaultBorderRadius,
          borderSide: const BorderSide(color: Colors.red),
        ),
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
      items: items,
      onChanged: (value) {},
    );
  }
}

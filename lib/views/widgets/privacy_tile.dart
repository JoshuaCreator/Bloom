import 'package:flutter/material.dart';

class PrivacySwitch extends StatelessWidget {
  const PrivacySwitch({
    super.key,
    required this.value,
    required this.text,
    this.onChanged,
  });
  final bool value;
  final String text;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(fontSize: 16.0)),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

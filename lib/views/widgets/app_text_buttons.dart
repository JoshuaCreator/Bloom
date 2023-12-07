import 'package:basic_board/utils/imports.dart';
import 'package:flutter/material.dart';

class AppTextButtonIcon extends StatelessWidget {
  const AppTextButtonIcon({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
  });
  final String label;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label),
      icon: Icon(icon),
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    this.onPressed,
    this.colour,
  });
  final String label;
  final void Function()? onPressed;
  final Color? colour;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(color: colour ?? ColourConfig.button),
      ),
    );
  }
}

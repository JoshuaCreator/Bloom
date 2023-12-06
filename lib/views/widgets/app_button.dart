import 'package:flutter/material.dart';
import '../../configs/consts.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onTap});
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(
        Colors.purple.shade50.withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onTap,
      child: Ink(
        height: size * 1.3,
        padding: EdgeInsets.symmetric(horizontal: thirty, vertical: ten),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: Colors.purple,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({super.key, required this.label, this.onTap});
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStatePropertyAll(
        Colors.purple.shade50.withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onTap,
      child: Ink(
        height: size * 1.3,
        padding: EdgeInsets.symmetric(horizontal: thirty, vertical: ten),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: Colors.purple,
            width: 2.0,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.purple,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

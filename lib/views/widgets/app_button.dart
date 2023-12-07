import 'package:basic_board/utils/imports.dart';
import 'package:flutter/material.dart';
import '../../configs/consts.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onTap});
  final String label;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor:
          MaterialStatePropertyAll(ColourConfig.white.withOpacity(0.5)),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onTap,
      child: Ink(
        height: size * 1.3,
        padding: EdgeInsets.symmetric(horizontal: thirty, vertical: ten),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: ColourConfig.button,
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColourConfig.white,
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
        ColourConfig.white.withOpacity(0.5),
      ),
      borderRadius: BorderRadius.circular(50.0),
      onTap: onTap,
      child: Ink(
        height: size * 1.3,
        padding: EdgeInsets.symmetric(horizontal: thirty, vertical: ten),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          border: Border.all(
            color: ColourConfig.button,
            width: 2.0,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: ColourConfig.button,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

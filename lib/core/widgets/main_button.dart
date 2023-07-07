import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.enabled),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
                side: const BorderSide(color: AppColors.enabled))),
      ),
      child: Container(
        height: 52,
        alignment: Alignment.center,
        child: Text(
          title,
          style: AppFonts.button,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class MainButtion extends StatelessWidget {
  const MainButtion({
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
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        )),
        backgroundColor: MaterialStateProperty.all(AppColors.main),
      ),
      child: Text(
        title,
        style: AppFonts.mainButtonText.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

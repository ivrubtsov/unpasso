import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class ErrorPresentor {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 900),
      content: Text(message),
    ));
  }
}

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    if (message == '') {
      return Container();
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        color: AppColors.errorBg,
        height: 64,
        child: Center(
          child: Text(
            message,
            style: AppFonts.error,
          ),
        ),
      );
    }
  }
}

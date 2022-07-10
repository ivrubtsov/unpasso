import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class MainTextField extends StatelessWidget {
  const MainTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final String hintText;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 187, 187, 187),
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.main,
            width: 1,
          ),
        ),
        hintText: hintText,
      ),
    );
  }
}

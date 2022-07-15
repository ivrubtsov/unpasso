import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.isPassword = false,
  }) : super(key: key);

  final String hintText;
  final Function(String value) onChanged;
  final bool isPassword;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool isHidden = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPassword && isHidden,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        suffixIcon: widget.isPassword
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() {
                    isHidden = !isHidden;
                  }),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: isHidden ? Colors.grey : AppColors.main,
                  ),
                ),
              )
            : null,
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
        hintText: widget.hintText,
      ),
    );
  }
}

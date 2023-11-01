import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class MainTextField extends StatefulWidget {
  const MainTextField({
    Key? key,
    required this.hintText,
    this.defaultValue = '',
    required this.onChanged,
    this.isPassword = false,
    this.isUsername = false,
  }) : super(key: key);

  final String hintText;
  final String defaultValue;
  final Function(String value) onChanged;
  final bool isPassword;
  final bool isUsername;

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool isHidden = true;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.defaultValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      obscureText: widget.isPassword && isHidden,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.inputBg,
        prefixIcon: widget.isUsername
            ? const Icon(
                Icons.alternate_email,
                color: AppColors.disabled,
              )
            : null,
        suffixIcon: widget.isPassword
            ? Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => setState(() {
                    isHidden = !isHidden;
                  }),
                  child: Icon(
                    Icons.remove_red_eye,
                    color: isHidden ? AppColors.disabled : AppColors.enabled,
                  ),
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.border,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.enabled,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: widget.hintText,
      ),
      style: AppFonts.input,
    );
  }

  @override
  void dispose() {
    // dispose it here
    _controller.dispose();
    super.dispose();
  }
}

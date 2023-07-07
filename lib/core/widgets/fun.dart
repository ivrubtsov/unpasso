import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class FunFront extends StatelessWidget {
  const FunFront({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey(true),
      alignment: Alignment.center,
      height: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: AppColors.funBg,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Image.asset('assets/fun.png'),
          const Text(
            'Fun task',
            style: AppFonts.funHeader,
          ),
          const Text(
            'Flip to view',
            style: AppFonts.funText,
          ),
        ],
      ),
    );
  }
}

class FunBack extends StatelessWidget {
  const FunBack({
    Key? key,
    required this.funText,
  }) : super(key: key);

  final String funText;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey(false),
      alignment: Alignment.center,
      height: 200.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: AppColors.funBg,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Center(
        child: Text(
          funText,
          style: AppFonts.funText,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

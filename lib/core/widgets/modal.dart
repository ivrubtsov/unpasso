import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class Modal extends StatelessWidget {
  const Modal({
    Key? key,
    required this.onPressedOk,
    required this.onPressedCancel,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.buttonOkText,
    required this.buttonCancelText,
  }) : super(key: key);

  final VoidCallback onPressedOk;
  final VoidCallback onPressedCancel;
  final String title;
  final String content;
  final String buttonText;
  final String buttonOkText;
  final String buttonCancelText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(AppColors.modalButtonOk),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: AppColors.modalButtonOk))),
      ),
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: AppColors.modalBg,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text(title),
          titleTextStyle: AppFonts.modalHeader,
          content: Text(content),
          contentTextStyle: AppFonts.modalContent,
          actionsOverflowAlignment: OverflowBarAlignment.center,
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.modalButtonCancel),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(
                            color: AppColors.modalButtonCancel))),
              ),
              onPressed: onPressedCancel,
              child: Text(
                buttonCancelText,
                style: AppFonts.modalButtonCancel,
              ),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(AppColors.modalButtonOk),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side:
                            const BorderSide(color: AppColors.modalButtonOk))),
              ),
              onPressed: onPressedOk,
              child: Text(
                buttonOkText,
                style: AppFonts.modalButtonOk,
              ),
            ),
          ],
        ),
      ),
      child: Text(
        buttonText,
        style: AppFonts.modalButtonOk,
      ),
    );
  }
}

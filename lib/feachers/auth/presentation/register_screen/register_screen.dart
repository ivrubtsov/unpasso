import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/consts/app_fonts.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/main_text_field.dart';
import 'cubit/register_screen_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // ЗАГОЛОВОК
              const Text(
                'Authentication',
                style: AppFonts.header1,
              ),
              const SizedBox(height: 30),
              // ТЕКСТОВОЕ ПОЛЕ ИМЯ
              _TextField(
                title: 'name',
                hintText: 'Enter your name',
                onChanged: model.changeName,
              ),
              const SizedBox(height: 15),
              // ТЕКСТОВОЕ ПОЛЕ EMAIL
              _TextField(
                title: 'e-mail',
                hintText: 'Enter e-mail',
                onChanged: model.changeEmail,
              ),
              const SizedBox(height: 15),
              // ТЕКСТОВОЕ ПОЛЕ ПАРОЛЬ
              _TextField(
                title: 'password',
                hintText: 'Enter password',
                onChanged: model.changePassword,
              ),
              const SizedBox(height: 5),
              const _PrivacyPolicyWidget(),
              const SizedBox(height: 15),
              // КНОПКА LOGIN
              Align(
                alignment: Alignment.center,
                child: MainButtion(
                  onPressed: () => model.onSignUpTapped(context),
                  title: 'Sign Up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    Key? key,
    required this.title,
    required this.hintText,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final String hintText;
  final Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.header2,
        ),
        const SizedBox(height: 5),
        MainTextField(
          hintText: hintText,
          onChanged: onChanged,
        )
      ],
    );
  }
}

class _PrivacyPolicyWidget extends StatelessWidget {
  const _PrivacyPolicyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenCubit>();
    return BlocBuilder<RegisterScreenCubit, RegisterScreenState>(
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.isTermsAccepted,
              onChanged: (value) {
                model.changeTermsAcception(value ?? false);
              },
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'I agree to ',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Terms and Privacy policy',
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => model.onPolicyPrivacyTapped(context),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

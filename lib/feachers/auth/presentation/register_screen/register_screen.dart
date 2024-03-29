import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/main_button.dart';
import 'package:goal_app/core/widgets/main_text_field.dart';
import 'cubit/register_screen_cubit.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenCubit>();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.altBg,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30.0),
                // HEADER
                const Center(
                  child: Column(children: [
                    Text(
                      'Create Account',
                      style: AppFonts.header,
                    ),
                    Text(
                      'First step towards a big goal',
                      style: AppFonts.subHeader,
                    ),
                  ]),
                ),
                // FORM
                const SizedBox(height: 30.0),
                // TEXT FIELD NAME
                _TextField(
                  title: 'name',
                  hintText: 'Your name',
                  onChanged: model.changeName,
                ),
                const SizedBox(height: 15.0),
                // TEXT FIELD USERNAME
                _TextField(
                  title: 'username',
                  hintText: 'username - how others can find you',
                  isUsername: true,
                  onChanged: model.changeUserName,
                ),
                const SizedBox(height: 15.0),
                // TEXT FIELD EMAIL
                _TextField(
                  title: 'e-mail',
                  hintText: 'E-mail',
                  onChanged: model.changeEmail,
                ),
                const SizedBox(height: 15.0),
                // TEXT FIELD ПАРОЛЬ
                _TextField(
                  title: 'password',
                  hintText: 'Password',
                  isPassword: true,
                  onChanged: model.changePassword,
                ),
                const SizedBox(height: 5.0),
                const _PrivacyPolicyWidget(),
                const SizedBox(height: 15.0),
                // REGISTRATION BUTTON
                Align(
                  alignment: Alignment.center,
                  child: MainButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      model.onSignUpTapped(context);
                    },
                    title: 'Create account',
                  ),
                ),
                const SizedBox(height: 15.0),
                // LOG IN BUTTON
                const Align(
                  alignment: Alignment.center,
                  child: _LogInButton(),
                ),
                Expanded(child: Container()),
              ],
            ),
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
    this.isPassword = false,
    this.isUsername = false,
  }) : super(key: key);

  final String title;
  final String hintText;
  final Function(String value) onChanged;
  final bool isPassword;
  final bool isUsername;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*
        Text(
          title,
          style: AppFonts.inputText,
        ),
        */
        MainTextField(
          isPassword: isPassword,
          isUsername: isUsername,
          hintText: hintText,
          onChanged: onChanged,
        ),
        const SizedBox(height: 5.0),
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
              checkColor: AppColors.enabled,
              fillColor: MaterialStateProperty.all(AppColors.bg),
            ),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'I agree to ',
                    style: AppFonts.inputText,
                  ),
                  TextSpan(
                    text: 'Terms and Privacy policy',
                    style: AppFonts.inputLink,
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

class _LogInButton extends StatelessWidget {
  const _LogInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<RegisterScreenCubit>();
    return Row(
      children: [
        const Text(
          'Have an account? ',
          style: AppFonts.inputText,
        ),
        TextButton(
          onPressed: () => model.onLogInTapped(context),
          child: const Text(
            'Log in',
            style: AppFonts.inputLink,
          ),
        )
      ],
    );
  }
}

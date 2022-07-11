import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/main_button.dart';
import 'package:goal_app/core/widgets/main_text_field.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/cubit/auth_screen_cubit.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthScreenCubit>();
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
              // КНОПКА ЗАБЫЛИ ПАРОЛЬ
              const Align(
                alignment: Alignment.centerRight,
                child: _ForgotPasswordButton(),
              ),
              const SizedBox(height: 30),
              // КНОПКА LOGIN
              Align(
                alignment: Alignment.center,
                child: MainButtion(
                  onPressed: () => model.onLoginTapped(context),
                  title: 'Log in',
                ),
              ),
              Expanded(child: Container()),
              // КНОПКА SIGN UP
              const Align(
                alignment: Alignment.center,
                child: _SignUpButton(),
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

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthScreenCubit>();
    return TextButton(
        onPressed: () => model.onForgotPasswordTapped(context),
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        child: Text(
          'Forgot password?',
          style: AppFonts.header2.copyWith(
            color: AppColors.links,
          ),
        ));
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthScreenCubit>();
    return TextButton(
      onPressed: () => model.onSignUpTapped(context),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

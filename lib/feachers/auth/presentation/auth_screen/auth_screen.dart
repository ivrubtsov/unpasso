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
      backgroundColor: AppColors.altBg,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0),
              // HEADER
              Center(
                child: Column(children: const [
                  Text(
                    'Log In',
                    style: AppFonts.header,
                  ),
                  Text(
                    'First step towards a big goal',
                    style: AppFonts.subHeader,
                  ),
                ]),
              ),
              const SizedBox(height: 30.0),
              // FORM
              const SizedBox(height: 30.0),
              // TEXT FIELD EMAIL
              _TextField(
                title: 'username',
                hintText: 'Username',
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
              // FORGET PASSWORD BUTTON
              const Align(
                alignment: Alignment.centerRight,
                child: _ForgotPasswordButton(),
              ),
              const SizedBox(height: 30.0),
              // LOGIN BUTTON
              Align(
                alignment: Alignment.center,
                child: MainButton(
                  onPressed: () => model.onLoginTapped(context),
                  title: 'Log in',
                ),
              ),
              const SizedBox(height: 15.0),
              // SIGN UP BUTTON
              const Align(
                alignment: Alignment.center,
                child: _SignUpButton(),
              ),
              Expanded(child: Container()),
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
    this.isPassword = false,
  }) : super(key: key);

  final String title;
  final String hintText;
  final Function(String value) onChanged;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*
        Text(
          title,
          style: AppFonts.header2,
        ),
        */
        MainTextField(
          isPassword: isPassword,
          hintText: hintText,
          onChanged: onChanged,
        ),
        const SizedBox(height: 5),
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
        child: const Text(
          'Forgot password?',
          style: AppFonts.inputLink,
        ));
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<AuthScreenCubit>();
    return Row(
      children: [
        const Text(
          'Don\'t have an account? ',
          style: AppFonts.inputText,
        ),
        TextButton(
          onPressed: () => model.onSignUpTapped(context),
          child: const Text(
            'Sign up',
            style: AppFonts.inputLink,
          ),
        )
      ],
    );
  }
}

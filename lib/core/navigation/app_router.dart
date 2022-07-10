import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/injection_container.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/auth_screen.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/cubit/auth_screen_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/cubit/register_screen_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/register_screen.dart';
import 'package:goal_app/feachers/goals/presentation/history_screen/cubit/history_screen_cubit.dart';
import 'package:goal_app/feachers/goals/presentation/history_screen/goals_history_screen.dart';
import 'package:goal_app/feachers/goals/presentation/set_goal_screen/cubit/set_goal_screen_cubit.dart';
import 'package:goal_app/feachers/goals/presentation/set_goal_screen/set_goal_screen.dart';

import '../../feachers/auth/presentation/auth_cubit/auth_cubit.dart';

abstract class AuthRoutes {
  static const authScreen = '/authScreen';
  static const registerScreen = '/registerScreen';
}

abstract class MainRoutes {
  static const setGoalScreen = '/setGoalScreen';
  static const goalsHistoryScreen = '/goalsHistoryScreen';
}

class AppRouter {
  final _authCubit = sl<AuthCubit>();

  String get initialRoute {
    if (_authCubit.state.status == AuthStatus.logOut) {
      return AuthRoutes.authScreen;
    } else {
      return MainRoutes.setGoalScreen;
    }
  }

  Route onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthRoutes.authScreen:
        return _buildAuthScreen();
      case AuthRoutes.registerScreen:
        return _buildRegisterScreen();
      case MainRoutes.setGoalScreen:
        return _buildSetGoalScreen();
      case MainRoutes.goalsHistoryScreen:
        return _buildGoalsHistoryScreen();
      default:
        return _buildNavigationUnkwown();
    }
  }

  Route _buildAuthScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: AuthScreenCubit(
                authRepo: sl(),
                sessionRepo: sl(),
              ),
              child: const AuthScreen(),
            ));
  }

  Route _buildRegisterScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: RegisterScreenCubit(
                authRepo: sl(),
                sessionRepo: sl(),
              ),
              child: const RegisterScreen(),
            ));
  }

  Route _buildGoalsHistoryScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: HistoryScreenCubit(sl()),
              child: const HistoryScreen(),
            ));
  }

  Route _buildSetGoalScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: SetGoalScreenCubit(sl()),
              child: const SetGoalScreen(),
            ));
  }

  Route _buildNavigationUnkwown() {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Center(child: Text('Ошибка навигации')),
            ));
  }

  void dispose() {
    _authCubit.close();
  }
}

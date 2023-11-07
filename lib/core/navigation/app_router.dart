import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/feachers/profile/presentation/profile_screen/avatar_screen.dart';
import 'package:goal_app/injection_container.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/auth_screen.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/cubit/auth_screen_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/cubit/register_screen_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/register_screen.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/home_screen.dart';
import 'package:goal_app/feachers/friends/presentation/friends_screen/cubit/friends_screen_cubit.dart';
import 'package:goal_app/feachers/friends/presentation/friends_screen/friends_screen.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/cubit/goal_screen_cubit.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/goal_screen.dart';
import 'package:goal_app/feachers/games/presentation/games_screen/cubit/games_screen_cubit.dart';
import 'package:goal_app/feachers/games/presentation/games_screen/games_screen.dart';
import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';
import 'package:goal_app/feachers/profile/presentation/profile_screen/profile_screen.dart';

import 'package:goal_app/feachers/auth/presentation/auth_cubit/auth_cubit.dart';

abstract class AuthRoutes {
  static const authScreen = '/authScreen';
  static const registerScreen = '/registerScreen';
}

abstract class MainRoutes {
  static const homeScreen = '/homeScreen';
  static const friendsScreen = '/friendsScreen';
  static const goalScreen = '/goalScreen';
  static const gamesScreen = '/gamesScreen';
  static const profileScreen = '/profileScreen';
  static const avatarScreen = '/avatarsScreen';
}

class AppRouter {
  final _authCubit = sl<AuthCubit>();

  String get initialRoute {
    if (_authCubit.state.status == AuthStatus.logOut) {
      return AuthRoutes.authScreen;
    } else {
      return MainRoutes.goalScreen;
    }
  }

  Route onGenerateRoutes(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AuthRoutes.authScreen:
        return _buildAuthScreen();
      case AuthRoutes.registerScreen:
        return _buildRegisterScreen();
      case MainRoutes.homeScreen:
        return _buildHomeScreen();
      case MainRoutes.friendsScreen:
        return _buildFriendsScreen();
      case MainRoutes.goalScreen:
        return _buildGoalScreen();
      case MainRoutes.gamesScreen:
        return _buildGamesScreen();
      case MainRoutes.profileScreen:
        return _buildProfileScreen();
      case MainRoutes.avatarScreen:
        return _buildAvatarScreen();
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
              ),
              child: const RegisterScreen(),
            ));
  }

  Route _buildHomeScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: HomeScreenCubit(
                homeRepo: sl(),
                sessionRepo: sl(),
              )..initHomeScreen(),
              child: const HomeScreen(),
            ));
  }

  Route _buildFriendsScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: FriendsScreenCubit(
                friendsRepo: sl(),
              )..initFriendsScreen(),
              child: const FriendsScreen(),
            ));
  }

  Route _buildGoalScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: GoalScreenCubit(
                goalsRepo: sl(),
                sessionRepo: sl(),
                profileRepo: sl(),
              )..initGoalsScreen(),
              child: const GoalScreen(),
            ));
  }

  Route _buildGamesScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: GamesScreenCubit()..initGamesScreen(),
              child: const GamesScreen(),
            ));
  }

  Route _buildProfileScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: ProfileScreenCubit(
                profileRepo: sl(),
                authRepo: sl(),
              )..initProfileScreen(),
              child: const ProfileScreen(),
            ));
  }

  Route _buildAvatarScreen() {
    return MaterialPageRoute(
        builder: (context) => BlocProvider.value(
              value: ProfileScreenCubit(
                profileRepo: sl(),
                authRepo: sl(),
              )..initAvatarScreen(),
              child: const AvatarScreen(),
            ));
  }

  Route _buildNavigationUnkwown() {
    return MaterialPageRoute(
        builder: (context) => const Scaffold(
              body: Center(child: Text('Internal navigation error')),
            ));
  }

  void dispose() {
    _authCubit.close();
  }
}

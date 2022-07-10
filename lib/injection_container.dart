import 'package:get_it/get_it.dart';
import 'package:goal_app/feachers/auth/data/repos/auth_repo_impl.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/auth_screen.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/cubit/register_screen_cubit.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/goals/presentation/history_screen/cubit/history_screen_cubit.dart';
import 'package:goal_app/feachers/goals/presentation/set_goal_screen/cubit/set_goal_screen_cubit.dart';

import 'feachers/auth/data/repos/session_repo_impl.dart';
import 'feachers/auth/domain/repos/session_repo.dart';
import 'feachers/auth/presentation/auth_screen/cubit/auth_screen_cubit.dart';
import 'feachers/goals/data/repos/goals_repo_impl.dart';

final sl = GetIt.instance;
void init() {
  //! Cubits
  // Cubit - только factory, потому что нужно закрывать стримы

  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sessionRepo: sl()));

  sl.registerLazySingleton<AuthScreenCubit>(() => AuthScreenCubit(
        authRepo: sl(),
        sessionRepo: sl(),
      ));

  sl.registerLazySingleton<RegisterScreenCubit>(() => RegisterScreenCubit(
        authRepo: sl(),
        sessionRepo: sl(),
      ));

  sl.registerLazySingleton<SetGoalScreenCubit>(() => SetGoalScreenCubit(sl()));

  sl.registerLazySingleton<HistoryScreenCubit>(() => HistoryScreenCubit(sl()));
  //! Экраны

  sl.registerLazySingleton<AuthScreen>(
    () => const AuthScreen(),
  );

  //! Репозитории

  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));

  sl.registerLazySingleton<SessionRepo>(() => SessionRepoImpl());

  sl.registerLazySingleton<GoalsRepo>(() => GoalsRepoImpl());
}

import 'package:get_it/get_it.dart';
import 'package:goal_app/feachers/auth/data/repos/email_auth_repo_impl.dart';
import 'package:goal_app/feachers/auth/domain/repos/auth_repo.dart';
import 'package:goal_app/feachers/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:goal_app/feachers/auth/presentation/auth_screen/auth_screen.dart';
import 'package:goal_app/feachers/auth/presentation/register_screen/cubit/register_screen_cubit.dart';
import 'package:goal_app/feachers/friends/data/repos/friends_repo_impl.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/friends/presentation/friends_screen/cubit/friends_screen_cubit.dart';
import 'package:goal_app/feachers/games/presentation/games_screen/cubit/games_screen_cubit.dart';
import 'package:goal_app/feachers/goals/domain/repos/goals_repo.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/cubit/goal_screen_cubit.dart';
import 'package:goal_app/feachers/home/data/repos/home_repo_impl.dart';
import 'package:goal_app/feachers/home/domain/repos/home_repo.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/cubit/home_screen_cubit.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';
import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

import 'feachers/auth/data/repos/session_repo_impl.dart';
import 'feachers/auth/domain/repos/session_repo.dart';
import 'feachers/auth/presentation/auth_screen/cubit/auth_screen_cubit.dart';
import 'feachers/goals/data/repos/goals_repo_impl.dart';
import 'feachers/profile/data/repos/profile_repo_impl.dart';

final sl = GetIt.instance;
void init() {
  //! Cubits
  // Cubit - только factory, потому что нужно закрывать стримы

  sl.registerLazySingleton<AuthCubit>(() => AuthCubit(sessionRepo: sl()));

  sl.registerFactory<AuthScreenCubit>(() => AuthScreenCubit(
        authRepo: sl(),
        sessionRepo: sl(),
      ));

  sl.registerFactory<RegisterScreenCubit>(() => RegisterScreenCubit(
        authRepo: sl(),
      ));

  sl.registerFactory<HomeScreenCubit>(
    () => HomeScreenCubit(
      homeRepo: sl(),
      sessionRepo: sl(),
    ),
  );

  sl.registerFactory<FriendsScreenCubit>(
    () => FriendsScreenCubit(
      friendsRepo: sl(),
    ),
  );

  sl.registerFactory<GoalScreenCubit>(
    () => GoalScreenCubit(
      sessionRepo: sl(),
      goalsRepo: sl(),
      profileRepo: sl(),
    ),
  );

  sl.registerFactory<GamesScreenCubit>(
    () => GamesScreenCubit(),
  );

  sl.registerFactory<ProfileScreenCubit>(
    () => ProfileScreenCubit(
      authRepo: sl(),
      profileRepo: sl(),
    ),
  );

  //! Screen

  sl.registerLazySingleton<AuthScreen>(
    () => const AuthScreen(),
  );

  //! Repositories

  sl.registerLazySingleton<AuthRepo>(() => EmailAuthRepoImpl(sl()));

  sl.registerLazySingleton<SessionRepo>(() => SessionRepoImpl());

  sl.registerLazySingleton<HomeRepo>(() => HomeRepoImpl(sessionRepo: sl()));

  sl.registerLazySingleton<FriendsRepo>(
      () => FriendsRepoImpl(sessionRepo: sl()));

  sl.registerLazySingleton<GoalsRepo>(() => GoalsRepoImpl(sessionRepo: sl()));

  sl.registerLazySingleton<ProfileRepo>(
      () => ProfileRepoImpl(sessionRepo: sl()));
}

import 'package:flutter/material.dart';
import 'package:goal_app/core/navigation/app_router.dart';
import 'package:goal_app/feachers/auth/presentation/auth_cubit/auth_cubit.dart';
import 'package:goal_app/injection_container.dart' as di;
import 'package:goal_app/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  di.init();
  await sl<AuthCubit>().checkAuth();
  runApp(GoalsApp(
    appRouter: AppRouter(),
  ));
}

class GoalsApp extends StatelessWidget {
  const GoalsApp({Key? key, required this.appRouter}) : super(key: key);

  final AppRouter appRouter;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: appRouter.initialRoute,
      onGenerateRoute: appRouter.onGenerateRoutes,
    );
  }
}

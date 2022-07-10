import 'package:flutter/material.dart';
import 'package:goal_app/core/navigation/app_router.dart';

void main() {
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

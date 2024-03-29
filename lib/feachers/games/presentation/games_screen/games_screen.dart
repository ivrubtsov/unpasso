import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/widgets/fun.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/feachers/games/presentation/games_screen/cubit/games_screen_cubit.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Enjoy your time!',
          style: AppFonts.header,
        ),
        actions: const [],
      ),
      backgroundColor: AppColors.bg,
      body: const GamesScreenContent(),
    );
  }
}

class GamesScreenContent extends StatefulWidget {
  const GamesScreenContent({Key? key}) : super(key: key);

  @override
  State<GamesScreenContent> createState() => GamesScreenContentState();
}

class GamesScreenContentState extends State<GamesScreenContent>
    with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    setState(() {
      currentDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesScreenCubit, GamesScreenState>(
      builder: (context, state) {
        if (state.status == GamesScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                child: const Text(
                  'To progress and complete your goals, you need strength and energy. Playing games with friends helps to replenish it. This game has cards with fun random tasks that you can do with friends and family.',
                  style: AppFonts.funSubHeader,
                )),
            const Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Games(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: QuoteWidget(),
            ),
            const MegaMenu(active: 4),
          ],
        );
      },
    );
  }
}

class Games extends StatelessWidget {
  const Games({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GamesScreenCubit, GamesScreenState>(
      builder: (context, state) {
        return const FunFlipAnimation();
      },
    );
  }
}

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '"A journey of a thousand miles begins with a single step"',
          style: AppFonts.goal,
        ),
        SizedBox(height: 20.0),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            'Lao Tzu',
            style: AppFonts.goalHint,
          ),
        ),
      ],
    );
  }
}

class FunFlipAnimation extends StatelessWidget {
  const FunFlipAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GamesScreenCubit>();

    return BlocBuilder<GamesScreenCubit, GamesScreenState>(
        builder: (context, state) {
      return GestureDetector(
        onTap: () => model.flipFunCard(),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: __transitionBuilder,
          layoutBuilder: (widget, list) =>
              Stack(children: [widget ?? const FunFront(), ...list]),
          switchInCurve: Curves.easeInBack,
          switchOutCurve: Curves.easeInBack.flipped,
          child: model.getFunGoalWidget(),
        ),
      );
    });
  }
}

Widget __transitionBuilder(Widget widget, Animation<double> animation) {
  final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
  return AnimatedBuilder(
    animation: rotateAnim,
    child: widget,
    builder: (context, widget) {
      final model = context.read<GamesScreenCubit>();
      final isUnder = (ValueKey(model.getDisplayFunFront()) != widget?.key);
      var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
      tilt *= isUnder ? -1.0 : 1.0;
      final value = isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
      return Transform(
        transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
        alignment: Alignment.center,
        child: widget,
      );
    },
  );
}

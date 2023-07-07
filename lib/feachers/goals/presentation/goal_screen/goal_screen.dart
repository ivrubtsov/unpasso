import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/widgets/fun.dart';
import 'package:goal_app/feachers/goals/data/models/goal_model/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/cubit/goal_screen_cubit.dart';

ScrollController dateListScrollController = ScrollController();
ScrollController goalsListScrollController = ScrollController();

class GoalScreen extends StatelessWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'My goals',
          style: AppFonts.header,
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<GoalScreenCubit>().onProfileTapped(context),
            icon: const Icon(Icons.person),
            color: AppColors.headerIcon,
          )
        ],
      ),
      backgroundColor: AppColors.bg,
      body: const GoalScreenContent(),
    );
  }
}

class GoalScreenContent extends StatelessWidget {
  const GoalScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        if (state.status == GoalScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final goals = state.goals;
        return Column(
          children: [
            DatesListView(goals: goals),
            GoalsMainContainer(goals: goals),
            FunFlipAnimation(),
            /* Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: QuoteWidget(),
              ),
            ),*/
          ],
        );
      },
    );
  }
}

class DatesListView extends StatelessWidget {
  const DatesListView({Key? key, required this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        final goals = state.goals;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: SizedBox(
            height: 62.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              reverse: true,
              controller: dateListScrollController,
              itemCount: goals.length,
              itemBuilder: (BuildContext context, int index) {
                return DateListViewItem(goal: goals[index]);
              },
            ),
          ),
        );
      },
    );
  }
}

class DateListViewItem extends StatelessWidget {
  const DateListViewItem({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(children: [
        /*
        Container(
          width: 24.0,
          height: 24.0,
          alignment: Alignment.center,
          child: DateButton(goal: goal),
        ),
        Container(
          width: 24.0,
          height: 14.0,
          alignment: Alignment.center,
          child: DateStatus(goal: goal),
        ),
        */
        DateButton(goal: goal),
        DateStatus(goal: goal),
      ]),
    );
  }
}

class DateButton extends StatelessWidget {
  const DateButton({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        final selectedDate = state.date;
        if (selectedDate.year == goal.createdAt.year &&
            selectedDate.month == goal.createdAt.month &&
            selectedDate.day == goal.createdAt.day) {
          return FloatingActionButton.small(
            onPressed: () {},
            backgroundColor: AppColors.selectedDateBg,
            child: Text(
              DateFormat('dd').format(goal.createdAt),
              style: AppFonts.dateSelected,
            ),
          );
        } else {
          final double winWidth = MediaQuery.of(context).size.width;
          return FloatingActionButton.small(
            onPressed: () {
              model.setSelectedDate(goal.createdAt, winWidth);
            },
            backgroundColor: AppColors.dateBg,
            child: Text(
              DateFormat('dd').format(goal.createdAt),
              style: AppFonts.date,
            ),
          );
        }
      },
    );
  }
}

class DateStatus extends StatelessWidget {
  const DateStatus({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    if (goal.isCompleted) {
      return const Icon(
        Icons.check,
        color: AppColors.dateIcon,
        size: 14.0,
      );
    }
    if (goal.isExist) {
      return const Icon(
        Icons.close,
        color: AppColors.dateIcon,
        size: 14.0,
      );
    }
    return const Icon(
      Icons.fiber_new,
      color: AppColors.dateBg,
      size: 14.0,
    );
  }
}

class GoalsMainContainer extends StatelessWidget {
  const GoalsMainContainer({Key? key, required this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        final double goalBoxSize = MediaQuery.of(context).size.width - 40;
        return SizedBox(
            height: goalBoxSize,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                controller: goalsListScrollController,
                reverse: true,
                itemCount: goals.length,
                itemBuilder: (BuildContext context, int index) {
                  /*WidgetsBinding.instance.addPostFrameCallback((_) => {
                        goalsListScrollController.jumpTo(
                            goalsListScrollController.position.maxScrollExtent)
                      });*/
                  final model = context.read<GoalScreenCubit>();
                  final DateTime today = DateTime.now();
                  // WIDGET FOR ENTERING A NEW GOAL
                  if (goals[index].text == '%%!!-!!%%') {
                    return Container(
                      key: ValueKey<Goal>(goals[index]),
                      width: goalBoxSize,
                      height: goalBoxSize,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      decoration: BoxDecoration(
                        color: AppColors.goalBg,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 0.0),
                      child: Column(
                        children: [
                          // CARD HEADER WITH A BUTTON
                          Row(
                            children: [
                              const Expanded(
                                child: SizedBox(
                                  child: Text(
                                    'Today',
                                    style: AppFonts.goalHeader,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: OutlinedButton(
                                  onPressed: () {
                                    model.submitGoal(context);
                                    // final id = state.goal.id;
                                    // final g = state.goal;
                                    goals.removeAt(index);
                                    goals.insert(
                                        0,
                                        GoalModel(
                                          createdAt: today,
                                          text: state.goal.text,
                                          authorId: state.goal.authorId,
                                          isCompleted: false,
                                          isExist: true,
                                        ));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        AppColors.enabled),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: const BorderSide(
                                                color: AppColors.enabled))),
                                  ),
                                  child: Container(
                                    height: 30.0,
                                    width: 40.0,
                                    alignment: Alignment.center,
                                    child: const Text(
                                      'Done',
                                      style: AppFonts.button,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // GOAL TEXT INPUT FIELD
                          GoalTextField(),
                        ],
                      ),
                    );

                    // return EnterGoal();
                  }
                  // The goal for today is set but it isn't completed yet, we should create
                  // a dismissive widget so a user can swipe the goal to complete it
                  final bool isToday;
                  if (today.year == goals[index].createdAt.year &&
                      today.month == goals[index].createdAt.month &&
                      today.day == goals[index].createdAt.day) {
                    isToday = true;
                  } else {
                    isToday = false;
                  }
                  // WIDGET FOR SHOWING THE TODAY'S GOAL WITH A FUNCTION TO COMPLETE IT WITH SWIPE
                  if (!goals[index].isCompleted && isToday) {
                    return Dismissible(
                      key: ValueKey<Goal>(goals[index]),
                      direction: DismissDirection.down,
                      onDismissed: (DismissDirection direction) {
                        model.completeGoal(context);
                        goals.removeAt(index);
                        goals.insert(
                            0,
                            GoalModel(
                              createdAt: today,
                              text: state.goal.text,
                              authorId: state.goal.authorId,
                              isCompleted: true,
                              isExist: true,
                            ));
                      },
                      background: const CompleteGoalBG(),
                      child: GoalItem(
                        goal: goals[index],
                        isToday: isToday,
                      ),
                    );
                  }
                  // GENERAL WIDGET FOR ALL THE PAST GOALS
                  return Container(
                      key: ValueKey<Goal>(goals[index]),
                      child: GoalItem(
                        goal: goals[index],
                        isToday: isToday,
                      ));
                }));
      },
    );
  }
}

/*
class GoalListViewItem extends StatelessWidget {
  const GoalListViewItem({Key? key, required this.goal, required this.index})
      : super(key: key);
  final Goal goal;
  final ValueKey<Goal> index;
  @override
  Widget build(BuildContext context) {
    final String goalDate;
    final bool isToday;
    // The goal for today isn't set, we should make a placeholder for it
    if (goal.text == '%%!!-!!%%') {
      return EnterGoal();
    }
    // The goal for today is set but it isn't completed yet, we should create
    // a dismissive widget so a user can swipe the goal to complete it
    final DateTime today = DateTime.now();
    if (today.year == goal.createdAt.year &&
        today.month == goal.createdAt.month &&
        today.day == goal.createdAt.day) {
      goalDate = 'Today';
      isToday = true;
    } else {
      goalDate = DateFormat.yMd().format(goal.createdAt);
      isToday = false;
    }
    /*
    final model = context.read<GoalScreenCubit>();
    if (!goal.isCompleted &&
        today.year == goal.createdAt.year &&
        today.month == goal.createdAt.month &&
        today.day == goal.createdAt.day) {
      return Dismissible(
        key: index,
        direction: DismissDirection.down,
        onDismissed: (_) => model.completeGoal(context),
        background: const CompleteGoalBG(),
        child: GoalItem(goal: goal, goalDate: goalDate, isToday: isToday),
      );
    }
    */
    return GoalItem(
      goal: goal,
      isToday: isToday,
    );
  }
}
*/

// WIDGET TO SHOW EXISTING GOAL
class GoalItem extends StatelessWidget {
  const GoalItem({
    Key? key,
    required this.goal,
    required this.isToday,
  }) : super(key: key);
  final Goal goal;
  final bool isToday;
  @override
  Widget build(BuildContext context) {
    final String goalDate;
    if (isToday) {
      goalDate = 'Today';
    } else {
      goalDate = DateFormat.yMMMd().format(goal.createdAt);
    }
    final double goalBoxSize = MediaQuery.of(context).size.width - 40;
    return Container(
      width: goalBoxSize,
      height: goalBoxSize,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: AppColors.goalBg,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Column(
        children: [
          Text(
            goalDate,
            style: AppFonts.goalHeader,
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: Text(
              goal.text,
              style: AppFonts.goal,
              textAlign: TextAlign.left,
            ),
          ),
          Center(
            child: CompletedStatus(
              isCompleted: goal.isCompleted,
              isToday: isToday,
            ),
          ),
        ],
      ),
    );
  }
}

class CompletedStatus extends StatelessWidget {
  const CompletedStatus(
      {Key? key, required this.isCompleted, required this.isToday})
      : super(key: key);
  final bool isCompleted;
  final bool isToday;
  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        height: 40.0,
        alignment: Alignment.center,
        child: Column(children: const [
          Icon(
            Icons.check_circle,
            color: AppColors.goalCompleted,
            size: 20.0,
          ),
          Text(
            'The goal is completed!',
            style: AppFonts.goalCompleted,
          ),
        ]),
      );
    } else {
      if (isToday) {
        return Container(
          height: 40.0,
          alignment: Alignment.center,
          child: Column(children: const [
            Icon(
              Icons.arrow_circle_down,
              color: AppColors.goalHint,
              size: 20.0,
            ),
            Text(
              'Swipe down to complete!',
              style: AppFonts.goalHint,
            ),
          ]),
        );
      } else {
        return Container(
          height: 40.0,
          alignment: Alignment.center,
          child: Column(children: const [
            Icon(
              Icons.unpublished,
              color: AppColors.goalInCompleted,
              size: 20.0,
            ),
            Text(
              'The goal is not completed :(',
              style: AppFonts.goalInCompleted,
            ),
          ]),
        );
      }
    }
  }
}

class CompleteGoalBG extends StatelessWidget {
  const CompleteGoalBG({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.0,
      alignment: Alignment.center,
      child: Image.asset('assets/goodjob.png'),
    );
  }
}

/*
class QuoteWidget extends StatelessWidget {
  const QuoteWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
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
*/
class GoalTextField extends StatelessWidget {
  const GoalTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();
    return TextFormField(
      initialValue: '',
      onChanged: model.changeGoal,
      style: AppFonts.goal,
      decoration: const InputDecoration(
        hintText: 'Enter your goal here',
        hintStyle: AppFonts.goal,
        border: InputBorder.none,
      ),
    );
  }
}

class FunFlipAnimation extends StatelessWidget {
  const FunFlipAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();

    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
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
      final model = context.read<GoalScreenCubit>();
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:goal_app/core/consts/app_colors.dart';

import '../../domain/entities/goal.dart';

import 'package:goal_app/feachers/goals/presentation/goal_screen/cubit/goal_screen_cubit.dart';

ScrollController dateListScrollController = ScrollController();

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
        title: const Text('Your goals',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500,
              color: AppColors.header,
              fontSize: 32,
            )),
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
      /* body: Padding(
        padding: const EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 50,
        ),
        child: Stack(
          children: [
            BlocBuilder<SetGoalScreenCubit, SetGoalScreenState>(
              builder: (context, state) {
                if (state.status == SetGoalScreenStateStatus.goalCompleted) {
                  return const _GoalCompletedWidget();
                }
                return Container();
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Center(child: _GoalWidget()),
              ],
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: QuoteWidget(),
            )
          ],
        ),
      ), */
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
            Expanded(
              child: Align(
                alignment: Alignment.bottomLeft,
                child: QuoteWidget(),
              ),
            ),
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: dateListScrollController,
            itemCount: goals.length,
            itemBuilder: (BuildContext context, int index) =>
                DateListViewItem(goal: goals[index]),
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
      width: 24,
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          child: DateButton(goal: goal),
        ),
        Container(
          width: 24,
          height: 14,
          alignment: Alignment.center,
          child: DateStatus(goal: goal),
        ),
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
          return FloatingActionButton(
            onPressed: () {},
            backgroundColor: AppColors.selectedDateBg,
            child: Text(
              DateFormat('dd').format(goal.createdAt),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.selectedDateText,
              ),
            ),
          );
        } else {
          return FloatingActionButton(
            onPressed: () {
              model.setSelectedDate(goal.createdAt);
            },
            backgroundColor: AppColors.dateBg,
            child: Text(
              DateFormat('dd').format(goal.createdAt),
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.dateText,
              ),
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
        size: 14,
      );
    }
    if (goal.isExist) {
      return const Icon(
        Icons.circle,
        color: AppColors.dateIcon,
        size: 4,
      );
    }
    return const Text('');
  }
}

class GoalsMainContainer extends StatelessWidget {
  const GoalsMainContainer({Key? key, required this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        if (goals.length == 0 ||
            !(goals[goals.length - 1].createdAt.year == DateTime.now().year &&
                goals[goals.length - 1].createdAt.month ==
                    DateTime.now().month &&
                goals[goals.length - 1].createdAt.day == DateTime.now().day)) {
          final model = context.read<GoalScreenCubit>();
          final authorId = model.getUserId();
          goals.add(Goal(
            createdAt: DateTime.now().toUtc(),
            text: '%%-%%',
            authorId: authorId,
            isCompleted: false,
          ));
        }
        return ListView.builder(
          itemCount: goals.length,
          itemBuilder: (BuildContext context, int index) =>
              GoalListViewItem(goal: goals[index]),
        );
      },
    );
  }
}

class GoalListViewItem extends StatelessWidget {
  const GoalListViewItem({Key? key, required this.goal}) : super(key: key);
  final Goal goal;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        child: DateButton(goal: goal),
      ),
    );
  }
}

/*
            Expanded(child: Stack(
              children: [
                BlocBuilder<SetGoalScreenCubit, SetGoalScreenState>(
                  builder: (context, state) {
                    if (state.status == SetGoalScreenStateStatus.goalCompleted) {
                      return const _GoalCompletedWidget();
                    }
                    return Container();
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Center(child: _GoalWidget()),
                  ],
                ),
                const Align(
                  alignment: Alignment.bottomLeft,
                  child: QuoteWidget(),
                )
              ],

            ))
*/

class _GoalCompletedWidget extends StatelessWidget {
  const _GoalCompletedWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: SizedBox(
        child: Column(
          children: const [
            Align(
                alignment: Alignment(0, -0.6),
                child: Icon(
                  Icons.check,
                  size: 60,
                  color: AppColors.ok,
                )),
            Align(
                alignment: Alignment(0, -0.4),
                child: Text(
                  'Well done!\nYou did it!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}

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
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.bottomRight,
          child: Text(
            'Lao Tzu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalWidget extends StatelessWidget {
  const _GoalWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        if (state.status == GoalScreenStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Goal for today',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CheckBox(
                  readOnly: !state.isCheckboxActive,
                  onChanged: (_) => model.completeGoal(context),
                  isChecked: state.goal.isCompleted,
                ),
                const SizedBox(width: 10),
                const Expanded(child: GoalTextField()),
              ],
            ),
          ],
        );
      },
    );
  }
}

class GoalTextField extends StatelessWidget {
  const GoalTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();

    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.goal.text,
          readOnly:
              state.status == GoalScreenStateStatus.noGoalSet ? false : true,
          onChanged: model.changeGoal,
          onFieldSubmitted: (value) =>
              model.onSubmittedComplete(value, context),
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(
            hintText: 'Set a goal',
            hintStyle: TextStyle(fontSize: 22),
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}

class CheckboxItem extends StatelessWidget {
  const CheckboxItem({Key? key, required this.isComleted}) : super(key: key);

  final bool isComleted;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 1.2,
      child: Checkbox(
        fillColor: MaterialStateProperty.all(AppColors.checkbox),
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        value: isComleted,
        onChanged: (bool? value) {},
      ),
    );
  }
}

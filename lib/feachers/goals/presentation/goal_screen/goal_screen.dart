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
        if (goals.isEmpty ||
            !(goals[goals.length - 1].createdAt.year == DateTime.now().year &&
                goals[goals.length - 1].createdAt.month ==
                    DateTime.now().month &&
                goals[goals.length - 1].createdAt.day == DateTime.now().day)) {
          final model = context.read<GoalScreenCubit>();
          final authorId = model.getUserId();
          goals.add(Goal(
            createdAt: DateTime.now().toUtc(),
            text: '%%!!-!!%%',
            authorId: authorId,
            isCompleted: false,
          ));
        }
        return ListView.builder(
          itemCount: goals.length,
          itemBuilder: (BuildContext context, int index) => GoalListViewItem(
            goal: goals[index],
            // index: ValueKey<int>(goals[index]),
            index: ValueKey<int>(index),
          ),
        );
      },
    );
  }
}

class GoalListViewItem extends StatelessWidget {
  const GoalListViewItem({Key? key, required this.goal, required this.index})
      : super(key: key);
  final Goal goal;
  final ValueKey<int> index;
  @override
  Widget build(BuildContext context) {
    String goalDate;
    // The goal for today isn't set, we should make a placeholder for it
    if (goal.text == '%%!!-!!%%') {
      return EnterGoal();
    }
    // The goal for today is set but it isn't completed yet, we should create
    // a dismissive widget so a user can swipe the goal to complete it
    DateTime today = DateTime.now();
    if (today.year == goal.createdAt.year &&
        today.month == goal.createdAt.month &&
        today.day == goal.createdAt.day) {
      goalDate = 'Today';
    } else {
      goalDate = DateFormat.yMEd().format(goal.createdAt);
    }
    final model = context.read<GoalScreenCubit>();
    if (!goal.isCompleted &&
        today.year == goal.createdAt.year &&
        today.month == goal.createdAt.month &&
        today.day == goal.createdAt.day) {
      return Dismissible(
        direction: DismissDirection.up,
        onDismissed: (_) => model.completeGoal(context),
        background: const CompleteGoalBG(),
        key: index,
        child: GoalItem(goal: goal, goalDate: goalDate),
      );
    }
    return GoalItem(goal: goal, goalDate: goalDate);
  }
}

class GoalItem extends StatelessWidget {
  const GoalItem({Key? key, required this.goal, required this.goalDate})
      : super(key: key);
  final Goal goal;
  final String goalDate;
  @override
  Widget build(BuildContext context) {
    double goalBoxSize = const BoxConstraints().maxWidth - 40;
    return Container(
      width: goalBoxSize,
      height: goalBoxSize,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      color: AppColors.goalBg,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Text(
            goalDate,
            style: const TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500,
              fontSize: 48,
              color: AppColors.goalDate,
            ),
          ),
          Expanded(
            child: Text(
              goal.text,
              style: const TextStyle(
                fontFamily: 'Fredoka',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: AppColors.goalText,
              ),
            ),
          ),
          Center(
            child: CompletedStatus(isCompleted: goal.isCompleted),
          ),
        ],
      ),
    );
  }
}

class EnterGoal extends StatelessWidget {
  const EnterGoal({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double goalBoxSize = const BoxConstraints().maxWidth - 40;
    return Container(
      width: goalBoxSize,
      height: goalBoxSize,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      color: AppColors.goalBg,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Text(
            'Today',
            style: const TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w500,
              fontSize: 48,
              color: AppColors.goalDate,
            ),
          ),
          Expanded(
            child: GoalTextField(),
          ),
        ],
      ),
    );
  }
}

class CompletedStatus extends StatelessWidget {
  const CompletedStatus({Key? key, required this.isCompleted})
      : super(key: key);
  final bool isCompleted;
  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        height: 40,
        alignment: Alignment.center,
        child: Column(children: const [
          Icon(
            Icons.check_circle,
            color: AppColors.goalCompleted,
            size: 20,
          ),
          Text(
            'The goal is completed!',
            style: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: AppColors.goalCompleted,
            ),
          ),
        ]),
      );
    } else {
      return Container(
        height: 40,
        alignment: Alignment.center,
        child: const Text(
          'Swipe down to complete!',
          style: TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: AppColors.goalCompleted,
          ),
        ),
      );
    }
  }
}

class CompleteGoalBG extends StatelessWidget {
  const CompleteGoalBG({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      alignment: Alignment.center,
      child: Image.asset('assets/goodjob.png'),
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
          initialValue: '',
          readOnly:
              state.status == GoalScreenStateStatus.noGoalSet ? false : true,
          onChanged: model.changeGoal,
          onFieldSubmitted: (value) =>
              model.onSubmittedComplete(value, context),
          style: const TextStyle(
            fontFamily: 'Fredoka',
            fontWeight: FontWeight.w400,
            fontSize: 24,
            color: AppColors.goalText,
          ),
          decoration: const InputDecoration(
            hintText: 'Set a goal',
            hintStyle: TextStyle(
              fontFamily: 'Fredoka',
              fontWeight: FontWeight.w400,
              fontSize: 24,
              color: AppColors.goalText,
            ),
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}

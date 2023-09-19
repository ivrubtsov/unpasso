import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/feachers/home/presentation/home_screen/cubit/home_screen_cubit.dart';

ScrollController homeListScrollController = ScrollController();

enum HomeScreenStatus {
  loading,
  error,
  ready,
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Unpasso community',
          style: AppFonts.header,
        ),
        actions: [],
      ),
      backgroundColor: AppColors.bg,
      body: const HomeScreenContent(),
    );
  }
}

class HomeScreenContent extends StatefulWidget {
  const HomeScreenContent({Key? key}) : super(key: key);

  @override
  State<HomeScreenContent> createState() => HomeScreenContentState();
}

class HomeScreenContentState extends State<HomeScreenContent>
    with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      currentDate = DateTime.now();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {
          currentDate = DateTime.now();
        });
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        if (state.currentDate.day != currentDate.day) {
          final model = context.read<HomeScreenCubit>();
          model.getAllGoals();
        }
        if (state.status == HomeScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return GoalsMainContainer(goals: state.goals);
      },
    );
  }
}

class GoalsMainContainer extends StatelessWidget {
  const GoalsMainContainer({Key? key, required this.goals}) : super(key: key);
  final List<Goal> goals;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        return ListView.builder(
            scrollDirection: Axis.vertical,
            controller: homeListScrollController,
            reverse: false,
            itemCount: goals.length,
            itemBuilder: (BuildContext context, int index) {
              return GoalItem(
                key: ValueKey<Goal>(goals[index]),
                goal: goals[index],
                goalId: index,
              );
            });
      },
    );
  }
}

// WIDGET TO SHOW A GOAL
class GoalItem extends StatelessWidget {
  const GoalItem({
    Key? key,
    required this.goal,
    required this.goalId,
  }) : super(key: key);
  final Goal goal;
  final int goalId;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          AppAvatars.getAvatarImage(goal.authorAvatar),
          Expanded(
            child: Column(
              children: [
                Text(
                  goal.text,
                  style: AppFonts.homeGoalTitle,
                  textAlign: TextAlign.left,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        goal.authorName,
                        style: AppFonts.homeGoalAuthor,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(
                      width: 56.0,
                      child: Row(children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.homeGoalAuthorRating,
                        ),
                        Text(
                          goal.authorRating.toString(),
                          style: AppFonts.homeGoalAuthorRating,
                          textAlign: TextAlign.left,
                        )
                      ]),
                    )
                  ],
                )
              ],
            ),
          ),
          GoalLike(
            goal: goal,
            goalId: goalId,
          ),
        ],
      ),
    );
  }
}

// WIDGET TO LIKE A GOAL
class GoalLike extends StatelessWidget {
  const GoalLike({
    Key? key,
    required this.goal,
    required this.goalId,
  }) : super(key: key);
  final Goal goal;
  final int goalId;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        goal.like
            ? GoalLikeActive(
                goal: goal,
                goalId: goalId,
              )
            : GoalLikeInActive(
                goal: goal,
                goalId: goalId,
              ),
        Text(
          goal.likes.toString(),
          style: AppFonts.homeGoalLikeNumber,
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}

class GoalLikeActive extends StatelessWidget {
  const GoalLikeActive({
    Key? key,
    required this.goal,
    required this.goalId,
  }) : super(key: key);
  final Goal goal;
  final int goalId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () => context.read<HomeScreenCubit>().unLikeGoal(goalId),
        icon: Icon(
          Icons.thumb_up,
          color: AppColors.homeGoalLikeIconActive,
          size: 32.0,
        ),
      );
    });
  }
}

class GoalLikeInActive extends StatelessWidget {
  const GoalLikeInActive({
    Key? key,
    required this.goal,
    required this.goalId,
  }) : super(key: key);
  final Goal goal;
  final int goalId;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
      return IconButton(
        onPressed: () => context.read<HomeScreenCubit>().likeGoal(goalId),
        icon: Icon(
          Icons.thumb_up_outlined,
          color: AppColors.homeGoalLikeIcon,
          size: 32.0,
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';
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
        actions: const [],
      ),
      backgroundColor: AppColors.bg,
      body: const Column(
        children: [
          Expanded(
//            child: SingleChildScrollView(
            child: HomeScreenContent(),
//            ),
          ),
          MegaMenu(active: 1),
        ],
      ),
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
    // homeListScrollController = new ScrollController();
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
    // homeListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
      builder: (context, state) {
        final model = context.read<HomeScreenCubit>();
        final timeDiff = currentDate.difference(state.currentDate).inMinutes;
        if (timeDiff > Keys.refreshTimeoutHome) {
          model.getFirstGoals();
        }
        if (state.status == HomeScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final List<Goal> goals = state.goals;
        final bool hasMore = state.goalsHasMore;
        return Column(children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => model.getFirstGoals(),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  controller: homeListScrollController,
                  reverse: false,
                  itemCount: goals.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index < goals.length) {
                      return GoalListItem(
                        goal: goals[index],
                      );
                      // return GoalItem(
                      //   key: ValueKey<Goal>(goals[index]),
                      //   goal: goals[index],
                      //   goalId: index,
                      // );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: hasMore
                                ? const CircularProgressIndicator()
                                : const Text(
                                    'No more goals to load',
                                    style: AppFonts.homeEndOfList,
                                  ),
                          ));
                    }
                  }),
            ),
          ),
          ErrorMessage(message: state.errorMessage),
        ]);
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
          const SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    goal.text,
                    style: AppFonts.homeGoalTitle,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    goal.authorName,
                    style: AppFonts.homeGoalAuthorName,
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '@${goal.authorUserName}',
                    style: AppFonts.homeGoalAuthorUserName,
                  ),
                ),
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
        const SizedBox(
          height: 5.0,
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            goal.likes.toString(),
            style: AppFonts.homeGoalLikeNumber,
          ),
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
        icon: const Icon(
          Icons.star,
          color: AppColors.homeGoalLikeIconActive,
          size: 32.0,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
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
        icon: const Icon(
          Icons.star_outline,
          color: AppColors.homeGoalLikeIcon,
          size: 32.0,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    });
  }
}

class GoalListItem extends StatefulWidget {
  const GoalListItem({Key? key, required this.goal}) : super(key: key);

  final Goal goal;
  @override
  State<GoalListItem> createState() => GoalListItemState();
}

class GoalListItemState extends State<GoalListItem> {
  Goal goal = Goal(
    authorId: 0,
    text: '',
    createdAt: DateTime.now(),
  );
  int userId = 0;
  bool like = false;
  List<int> likeUsers = [];
  int likes = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      goal = widget.goal;
      likeUsers = widget.goal.likeUsers;
      likes = likeUsers.length;
    });
  }

  void _likeMe() {
    setState(() {
      likeUsers.add(userId);
      likes++;
      like = true;
    });
  }

  void _unLikeMe() {
    setState(() {
      likeUsers.remove(userId);
      likes--;
      like = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
      final model = context.read<HomeScreenCubit>();
      userId = model.getUserId();
      like = likeUsers.contains(userId);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          children: [
            AppAvatars.getAvatarImage(goal.authorAvatar),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      goal.text,
                      style: AppFonts.homeGoalTitle,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      goal.authorName,
                      style: AppFonts.homeGoalAuthorName,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '@${goal.authorUserName}',
                      style: AppFonts.homeGoalAuthorUserName,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                like
                    ? IconButton(
                        onPressed: () {
                          model.setUnLikeGoal(goal);
                          _unLikeMe();
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: AppColors.homeGoalLikeIconActive,
                          size: 32.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    : IconButton(
                        onPressed: () {
                          model.setLikeGoal(goal);
                          _likeMe();
                        },
                        icon: const Icon(
                          Icons.favorite_outline,
                          color: AppColors.homeGoalLikeIcon,
                          size: 32.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                const SizedBox(
                  height: 5.0,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    likes.toString(),
                    style: AppFonts.homeGoalLikeNumber,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

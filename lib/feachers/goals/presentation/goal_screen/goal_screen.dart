import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';
import 'package:goal_app/feachers/goals/data/models/goal_model/goal_model.dart';
import 'package:intl/intl.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/feachers/goals/domain/entities/goal.dart';
import 'package:goal_app/feachers/goals/presentation/goal_screen/cubit/goal_screen_cubit.dart';

ScrollController dateListScrollController = ScrollController();
ScrollController goalsListScrollController = ScrollController();
TextEditingController textFieldController = TextEditingController();

enum GoalScreenStatus {
  loading,
  error,
  ready,
}

class GoalScreen extends StatelessWidget {
  const GoalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.bg,
          elevation: 0,
          title: const Text(
            'My goals',
            style: AppFonts.header,
          ),
          actions: const [
            /*
          IconButton(
            onPressed: () =>
                context.read<GoalScreenCubit>().onProfileTapped(context),
            icon: const Icon(Icons.person),
            color: AppColors.headerIcon,
          )
          */
          ],
        ),
        backgroundColor: AppColors.bg,
        body: const Column(
          children: [
            Expanded(
              child: GoalScreenContent(),
            ),
            MegaMenu(active: 3),
          ],
        ),
      ),
    );
  }
}

class GoalScreenContent extends StatefulWidget {
  const GoalScreenContent({Key? key}) : super(key: key);

  @override
  State<GoalScreenContent> createState() => GoalScreenContentState();
}

class GoalScreenContentState extends State<GoalScreenContent>
    with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setState(() {
      currentDate = DateTime.now();
    });
    textFieldController = TextEditingController(
      text: '',
    );
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
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        final model = context.read<GoalScreenCubit>();
        if (state.currentDate.day != currentDate.day) {
          model.getAllGoals();
          model.setSelectedDateToday();
        }
        if (state.status == GoalScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          model.checkLikedGoalsAchs(context);
        }
        return Column(
          children: [
            DatesListView(goals: state.goals),
            GoalsMainContainer(goals: state.goals),
            const Expanded(
              child: AIGoalGenerator(),
            ),
            ErrorMessage(message: state.errorMessage),
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
        final selectedDate = state.selectedDate;
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
              FocusManager.instance.primaryFocus?.unfocus();
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
                                  // child: TextButton(
                                  //   onPressed: (() => FocusManager
                                  //       .instance.primaryFocus
                                  //       ?.unfocus()),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Today',
                                      style: AppFonts.goalHeader,
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  // ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: state.status ==
                                        GoalScreenStateStatus.goalIsGenerating
                                    ? Container(
                                        height: 30.0,
                                        width: 30.0,
                                        alignment: Alignment.center,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.enabled,
                                          ),
                                        ))
                                    : OutlinedButton(
                                        onPressed: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          model.submitGoal(context);
                                          // final id = state.goal.id;
                                          // final g = state.goal;
                                          goals.removeAt(index);
                                          goals.insert(
                                              0,
                                              GoalModel(
                                                createdAt: DateTime.now(),
                                                text: state.goal.text,
                                                authorId: state.goal.authorId,
                                                authorName: state.profile.name,
                                                authorUserName:
                                                    state.profile.userName,
                                                authorAvatar:
                                                    state.profile.avatar,
                                                isCompleted: false,
                                                isExist: true,
                                                isPublic: true,
                                                isFriends: false,
                                                isPrivate: false,
                                                likeUsers: const [],
                                                likes: 0,
                                                isGenerated: false,
                                                isAccepted: false,
                                              ));
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  AppColors.enabled),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: const BorderSide(
                                                      color:
                                                          AppColors.enabled))),
                                        ),
                                        child: Container(
                                          height: 30.0,
                                          width: 40.0,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Save',
                                            style: AppFonts.button,
                                          ),
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          // GOAL TEXT INPUT FIELD
                          const Expanded(
                            child: GoalTextField(),
                          ),
                          // GOAL PRIVACY (VISIBILITY) BUTTONS
                          SizedBox(
                            height: 40.0,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                state.goal.isPrivate
                                    ? const Column(children: [
                                        Icon(
                                          Icons.person,
                                          color: AppColors.goalPrivacyActive,
                                          size: 20.0,
                                        ),
                                        Text(
                                          'Private',
                                          style: AppFonts.goalPrivacyActive,
                                        ),
                                      ])
                                    : Column(children: [
                                        IconButton(
                                          onPressed: () {
                                            model.changePrivacy(
                                                Privacy.isPrivate);
                                          },
                                          icon: const Icon(
                                            Icons.person,
                                            color: AppColors.goalPrivacy,
                                            size: 20.0,
                                          ),
                                          iconSize: 20.0,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const Text(
                                          'Private',
                                          style: AppFonts.goalPrivacy,
                                        ),
                                        /*
                                        TextButton(
                                          onPressed: () => model
                                              .changePrivacy(Privacy.isPrivate),
                                          child: const Text(
                                            'Private',
                                            style: AppFonts.goalPrivacy,
                                          ),
                                        ),
                                        */
                                      ]),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                state.goal.isFriends
                                    ? const Column(children: [
                                        Icon(
                                          Icons.people,
                                          color: AppColors.goalPrivacyActive,
                                          size: 20.0,
                                        ),
                                        Text(
                                          'Friends',
                                          style: AppFonts.goalPrivacyActive,
                                        ),
                                      ])
                                    : Column(children: [
                                        IconButton(
                                          onPressed: () {
                                            model.changePrivacy(
                                                Privacy.isFriends);
                                          },
                                          icon: const Icon(
                                            Icons.people,
                                            color: AppColors.goalPrivacy,
                                            size: 20.0,
                                          ),
                                          iconSize: 20.0,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const Text(
                                          'Friends',
                                          style: AppFonts.goalPrivacy,
                                        ),
                                      ]),
                                const SizedBox(
                                  width: 20.0,
                                ),
                                state.goal.isPublic
                                    ? const Column(children: [
                                        Icon(
                                          Icons.public,
                                          color: AppColors.goalPrivacyActive,
                                          size: 20.0,
                                        ),
                                        Text(
                                          'Public',
                                          style: AppFonts.goalPrivacyActive,
                                        ),
                                      ])
                                    : Column(children: [
                                        IconButton(
                                          onPressed: () {
                                            model.changePrivacy(
                                                Privacy.isPublic);
                                          },
                                          icon: const Icon(
                                            Icons.public,
                                            color: AppColors.goalPrivacy,
                                            size: 20.0,
                                          ),
                                          iconSize: 20.0,
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        const Text(
                                          'Public',
                                          style: AppFonts.goalPrivacy,
                                        ),
                                      ]),
                                Expanded(child: Container()),
                              ],
                            ),
                          ),
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
                  if (!goals[index].isCompleted &&
                      isToday &&
                      state.status == GoalScreenStateStatus.ready) {
                    return Dismissible(
                      key: ValueKey<Goal>(goals[index]),
                      direction: DismissDirection.down,
                      onDismissed: (DismissDirection direction) {
                        model.completeGoal(context);
                        goals.removeAt(index);
                        goals.insert(
                            0,
                            GoalModel(
                              createdAt: state.goal.createdAt,
                              text: state.goal.text,
                              authorId: state.goal.authorId,
                              authorName: state.goal.authorName,
                              authorUserName: state.goal.authorUserName,
                              authorAvatar: state.goal.authorAvatar,
                              isCompleted: true,
                              isExist: true,
                              isPublic: state.goal.isPublic,
                              isFriends: state.goal.isFriends,
                              isPrivate: state.goal.isPrivate,
                              likeUsers: state.goal.likeUsers,
                              likes: state.goal.likes,
                              isGenerated: false,
                              isAccepted: false,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  goalDate,
                  style: AppFonts.goalHeader,
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.favorite,
                    color: goal.likes > 0
                        ? AppColors.goalLikeIconActive
                        : AppColors.goalLikeIcon,
                    size: 32.0,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      goal.likes.toString(),
                      style: AppFonts.goalLikeNumber,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Expanded(
            child: Text(
              goal.text,
              style: AppFonts.goal,
              textAlign: TextAlign.center,
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
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
        builder: (context, state) {
      if (state.status != GoalScreenStateStatus.ready) {
        return Container(
          height: 40.0,
          alignment: Alignment.center,
          child: const Column(children: [
            Icon(
              Icons.update,
              color: AppColors.goalHint,
              size: 20.0,
            ),
            Text(
              'The goal is being updated...',
              style: AppFonts.goalHint,
            ),
          ]),
        );
      }
      if (isCompleted) {
        return Container(
          height: 40.0,
          alignment: Alignment.center,
          child: const Column(children: [
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
            child: const Column(children: [
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
            child: const Column(children: [
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
    });
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

class GoalTextField extends StatelessWidget {
  const GoalTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<GoalScreenCubit>();
    return TextFormField(
      controller: textFieldController,
      onChanged: model.changeGoal,
      style: AppFonts.goal,
      decoration: const InputDecoration(
        hintText: 'Enter your goal here',
        hintStyle: AppFonts.goal,
        border: InputBorder.none,
      ),
      maxLines: Keys.goalInputFieldMaxLines,
    );
  }
}

class AIGoalGenerator extends StatelessWidget {
  const AIGoalGenerator({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GoalScreenCubit, GoalScreenState>(
      builder: (context, state) {
        if ((state.status == GoalScreenStateStatus.ready ||
                state.status == GoalScreenStateStatus.goalIsGenerating) &&
            Keys.aiGeneratorEnabled == true &&
            (state.goal.id == 0 || state.goal.id == null)) {
          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            alignment: Alignment.topCenter,
            height: 70.0,
            child: Center(
              child: OutlinedButton(
                onPressed: () =>
                    context.read<GoalScreenCubit>().generateAIGoal(context),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(AppColors.goalGenerateBg),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: const BorderSide(
                              color: AppColors.goalGenerateBg))),
                ),
                child: SizedBox(
                  height: 50.0,
                  //width: 200.0,
                  child: Row(
                    children: [
                      state.status == GoalScreenStateStatus.goalIsGenerating
                          ? Container(
                              height: 32.0,
                              width: 32.0,
                              alignment: Alignment.center,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.goalGenerateIcon,
                                ),
                              ))
                          : const Icon(
                              Icons.psychology,
                              size: 32.0,
                              color: AppColors.goalGenerateIcon,
                            ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Generate a new goal for me \n(~1 min)',
                            textAlign: TextAlign.center,
                            style: AppFonts.goalGenerateText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

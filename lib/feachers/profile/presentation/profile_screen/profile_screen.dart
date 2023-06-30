import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:goal_app/core/consts/app_colors.dart';

import '../../domain/entities/profile.dart';

import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
        body: Column(
          children: [
            const ProfilesListView(),
            const ProfilesMainContainer(),
            Expanded(child: const Align(
              alignment: Alignment.bottomLeft,
              child: QuoteWidget(),
            ))
          ],
        )
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

class ProfilesMainContainer extends StatelessWidget {
  const ProfilesMainContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryScreenCubit, HistoryScreenState>(
      builder: (context, state) {
        if (state.status == HistoryScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final goals = state.goals;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (BuildContext context, int index) =>
                  ListViewItem(goal: goals[index]),
        );
      },
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

class _ProfileCompletedWidget extends StatelessWidget {
  const _ProfileCompletedWidget({
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

class _ProfileWidget extends StatelessWidget {
  const _ProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProfileScreenCubit>();
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        if (state.status == ProfileScreenStateStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Profile for today',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                CheckBox(
                  readOnly: !state.isCheckboxActive,
                  onChanged: (_) => model.completeProfile(context),
                  isChecked: state.goal.isCompleted,
                ),
                const SizedBox(width: 10),
                const Expanded(child: ProfileTextField()),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ProfileTextField extends StatelessWidget {
  const ProfileTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProfileScreenCubit>();

    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.goal.text,
          readOnly:
              state.status == ProfileScreenStateStatus.noGoalSet ? false : true,
          onChanged: model.changeProfile,
          onFieldSubmitted: (value) =>
              model.onSubmittedComplete(value, context),
          style: const TextStyle(fontSize: 22),
          decoration: const InputDecoration(
            hintText: 'Set a Profile',
            hintStyle: TextStyle(fontSize: 22),
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}

class ProfilesListView extends StatelessWidget {
  const ProfilesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryScreenCubit, HistoryScreenState>(
      builder: (context, state) {
        if (state.status == HistoryScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final goals = state.goals;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (BuildContext context, int index) =>
                  ListViewItem(goal: goals[index]),
        );
      },
    );
  }
}

class ListViewItem extends StatelessWidget {
  const ListViewItem({Key? key, required this.goal}) : super(key: key);
  final Profile goal;
  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd.MM.yyyy').format(goal.createdAt);
    return Row(
      children: [
        Text(
          date,
        ),
        const SizedBox(width: 10),
        CheckboxItem(isComleted: goal.isCompleted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            goal.text,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ],
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

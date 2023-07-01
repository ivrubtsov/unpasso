import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<ProfileScreenCubit>();
    model.getAchieves();
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: AppColors.profileBg,
          elevation: 0,
          title: const Text(
            'Profile',
            style: AppFonts.header,
          ),
          actions: [
            IconButton(
              onPressed: () =>
                  context.read<ProfileScreenCubit>().onProfileTapped(context),
              icon: const Icon(Icons.person),
              color: AppColors.headerIcon,
            )
          ],
        ),
        backgroundColor: AppColors.profileBg,
        body: Column(
          children: [
            PersonalData(),
            AchievementsView(),
            Settings(),
          ],
        ));
  }
}

class PersonalData extends StatelessWidget {
  const PersonalData({
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

class AchievementsView extends StatelessWidget {
  const AchievementsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        if (state.status == ProfileScreenStateStatus.loading) {
          return Container(
            alignment: Alignment.center,
            height: 256,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: const CircularProgressIndicator(),
          );
        } else {
          return Container(
            // width: max,
            // height: 256,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: AppColors.profileAchBg,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Text(
                  'Achievements',
                  style: AppFonts.goalHeader,
                ),
                Text(
                  state.profile.achievements.length.toString(),
                  style: AppFonts.goal,
                ),
                AchievementsList(),
              ],
            ),
          );
        }
      },
    );
  }
}

class AchievementsList extends StatelessWidget {
  const AchievementsList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = context.read<ProfileScreenCubit>();
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        final achs = model.showAchieves();
        return ListView.builder(
          itemCount: achs.length,
          itemBuilder: (BuildContext context, int index) =>
              AchievementListViewItem(
            ach: achs[index],
          ),
        );
      },
    );
  }
}

class AchievementListViewItem extends StatelessWidget {
  const AchievementListViewItem({Key? key, required this.ach})
      : super(key: key);
  final Widget ach;
  @override
  Widget build(BuildContext context) {
    return ach;
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('');
  }
}

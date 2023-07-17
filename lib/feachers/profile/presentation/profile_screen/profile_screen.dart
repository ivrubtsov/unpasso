import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/modal.dart';

import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  context.read<ProfileScreenCubit>().onLogOutTapped(context),
              icon: const Icon(Icons.logout),
              color: AppColors.headerIcon,
            )
          ],
          leading: IconButton(
            onPressed: () =>
                context.read<ProfileScreenCubit>().onBackTapped(context),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppColors.headerIcon,
          ),
        ),
        backgroundColor: AppColors.profileBg,
        body: Column(
          children: [
            PersonalData(),
            AchievementsView(),
            // Settings(),
            Container(
              height: 30.0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              alignment: Alignment.center,
              child: Modal(
                buttonText: 'Delete account',
                title: 'Delete account',
                content:
                    'Are you sure you want to erase your account and all the data associated with it?',
                buttonOkText: 'Yes, delete',
                buttonCancelText: 'Cancel',
                onPressedOk: () => context
                    .read<ProfileScreenCubit>()
                    .onDeleteAccountTapped(context),
                onPressedCancel: () => Navigator.pop(context),
              ),
            ),
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
    final model = context.read<ProfileScreenCubit>();
    final name = model.getName();
    final username = model.getUsername();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        children: [
          const Icon(
            Icons.person,
            size: 56.0,
          ),
          Column(
            children: [
              Text(
                name,
                style: AppFonts.profileName,
              ),
              Text(
                username,
                style: AppFonts.profileUsername,
              ),
            ],
          ),
        ],
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
            height: 340.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: const CircularProgressIndicator(),
          );
        } else {
          const achTotal = Achievements.length;
          final achCollected = state.profile.achievements.length;
          final achShare = (achCollected / achTotal * 100).round().toString();
          return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Container(
                height: 340.0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                  color: AppColors.profileAchBg,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    Text(
                      'Achievements: $achShare%',
                      style: AppFonts.achHeader,
                    ),
                    Text(
                      '$achCollected of $achTotal collected',
                      style: AppFonts.achText,
                    ),
                    SizedBox(
                      height: 240,
                      child: AchievementsList(),
                    ),
                  ],
                ),
              ));
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
        return ListView(
          scrollDirection: Axis.horizontal,
          children: achs,
        );
      },
    );
  }
}

class Settings extends StatelessWidget {
  const Settings({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

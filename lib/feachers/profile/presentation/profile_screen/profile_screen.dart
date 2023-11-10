import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/achievements.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/core/widgets/main_text_field.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';
import 'package:goal_app/core/widgets/modal.dart';

import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
          /*
          leading: IconButton(
            onPressed: () =>
                context.read<ProfileScreenCubit>().onBackTapped(context),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppColors.headerIcon,
          ),
          */
        ),
        backgroundColor: AppColors.profileBg,
        body: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const PersonalData(),
                  const AchievementsView(),
                  // Settings(),
                  Container(
                    height: 70.0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 0.0),
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
              ),
            ),
            const MegaMenu(active: 5),
          ],
        ),
      ),
    );
  }
}

class PersonalData extends StatefulWidget {
  const PersonalData({
    Key? key,
  }) : super(key: key);

  @override
  State<PersonalData> createState() => PersonalDataState();
}

class PersonalDataState extends State<PersonalData> {
  bool isChangeName = false;
  String name = '';
  bool isChangeUsername = false;

  @override
  void initState() {
    super.initState();
  }

  void _changeName(bool changeState) {
    setState(() {
      isChangeName = changeState;
    });
  }

  void _changeNameText(String value) {
    if (name == value) return;
    name = value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, state) {
      final model = context.read<ProfileScreenCubit>();
      name = state.profile.name ?? state.profile.userName ?? 'Unknown';
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: Row(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const LinearBorder(),
                side: const BorderSide(width: 0),
                backgroundColor: AppColors.profileBg,
              ),
              onPressed: () => model.onAvatarOpenTapped(context),
              child: AppAvatars.getAvatarImage(state.profile.avatar, true),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: isChangeName
                        ? SizedBox(
                            height: 64.0,
                            child: Row(
                              children: [
                                Expanded(
                                  child: _TextField(
                                    title: 'name',
                                    defaultValue: state.profile.name ??
                                        state.profile.userName ??
                                        '',
                                    onChanged: _changeNameText,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                IconButton(
                                  onPressed: () {
                                    model.submitName(name, context);
                                    _changeName(false);
                                  },
                                  icon: const Icon(
                                    Icons.done,
                                    color: AppColors.profileButtonSave,
                                    size: 24.0,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(
                            height: 64.0,
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () => _changeName(true),
                                  child: Text(
                                    state.profile.name ??
                                        state.profile.userName ??
                                        'Unknown',
                                    style: AppFonts.profileName,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _changeName(true);
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: AppColors.profileButtonEdit,
                                    size: 24.0,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '@${state.profile.userName}',
                            style: AppFonts.friendsUsername,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 56.0,
                        child: Row(children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.friendsIconRating,
                          ),
                          Text(
                            state.profile.rating.toString(),
                            style: AppFonts.friendsRating,
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
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
            height: 300.0,
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
                height: 300.0,
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
                    const SizedBox(
                      height: 200,
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

class _TextField extends StatelessWidget {
  const _TextField({
    Key? key,
    required this.title,
    this.hintText = '',
    this.defaultValue = '',
    required this.onChanged,
    this.isPassword = false,
    this.isUsername = false,
  }) : super(key: key);

  final String title;
  final String hintText;
  final String defaultValue;
  final Function(String value) onChanged;
  final bool isPassword;
  final bool isUsername;

  @override
  Widget build(BuildContext context) {
    return MainTextField(
      isPassword: isPassword,
      isUsername: isUsername,
      hintText: hintText,
      defaultValue: defaultValue,
      onChanged: onChanged,
    );
  }
}

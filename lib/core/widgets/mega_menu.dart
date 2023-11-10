import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/consts/app_texts.dart';
import 'package:goal_app/core/navigation/app_router.dart';

class MegaMenu extends StatelessWidget {
  const MegaMenu({
    Key? key,
    required this.active,
  }) : super(key: key);

  final int active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      color: AppColors.megaMenuBg,
      height: 64.0,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: MegaButtonHome(
                active: active == 1,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: MegaButtonFriends(
                active: active == 2,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: MegaButtonMy(
                active: active == 3,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: MegaButtonGames(
                active: active == 4,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: MegaButtonProfile(
                active: active == 5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MegaButtonHome extends StatelessWidget {
  const MegaButtonHome({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> language =
        AppTexts.texts['en'] ?? {'buttonHome': 'Home'};
    final String label = language['buttonHome'] ?? 'Home';
    IconData buttonIcon;
    if (active) {
      buttonIcon = Icons.home;
    } else {
      buttonIcon = Icons.home_outlined;
    }
    return MegaButton(
      active: active,
      label: label,
      buttonIcon: buttonIcon,
      link: MainRoutes.homeScreen,
    );
  }
}

class MegaButtonFriends extends StatelessWidget {
  const MegaButtonFriends({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> language =
        AppTexts.texts['en'] ?? {'buttonFriends': 'Friends'};
    final String label = language['buttonFriends'] ?? 'Friends';
    IconData buttonIcon;
    if (active) {
      buttonIcon = Icons.people_alt;
    } else {
      buttonIcon = Icons.people_alt_outlined;
    }
    return MegaButton(
      active: active,
      label: label,
      buttonIcon: buttonIcon,
      link: MainRoutes.friendsScreen,
    );
  }
}

class MegaButtonMy extends StatelessWidget {
  const MegaButtonMy({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> language =
        AppTexts.texts['en'] ?? {'buttonMy': 'My goals'};
    final String label = language['buttonMy'] ?? 'My goals';
    IconData buttonIcon;
    if (active) {
      buttonIcon = Icons.task;
    } else {
      buttonIcon = Icons.task_outlined;
    }
    return MegaButton(
      active: active,
      label: label,
      buttonIcon: buttonIcon,
      link: MainRoutes.goalScreen,
    );
  }
}

class MegaButtonGames extends StatelessWidget {
  const MegaButtonGames({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> language =
        AppTexts.texts['en'] ?? {'buttonGames': 'Games'};
    final String label = language['buttonGames'] ?? 'Games';
    IconData buttonIcon;
    if (active) {
      buttonIcon = Icons.games;
    } else {
      buttonIcon = Icons.games_outlined;
    }
    return MegaButton(
      active: active,
      label: label,
      buttonIcon: buttonIcon,
      link: MainRoutes.gamesScreen,
    );
  }
}

class MegaButtonProfile extends StatelessWidget {
  const MegaButtonProfile({
    Key? key,
    required this.active,
  }) : super(key: key);

  final bool active;

  @override
  Widget build(BuildContext context) {
    final Map<String, String> language =
        AppTexts.texts['en'] ?? {'buttonProfile': 'Profile'};
    final String label = language['buttonProfile'] ?? 'Profile';
    IconData buttonIcon;
    if (active) {
      buttonIcon = Icons.person;
    } else {
      buttonIcon = Icons.person_outlined;
    }
    return MegaButton(
      active: active,
      label: label,
      buttonIcon: buttonIcon,
      link: MainRoutes.profileScreen,
    );
  }
}

class MegaButton extends StatelessWidget {
  const MegaButton({
    Key? key,
    required this.active,
    required this.label,
    required this.buttonIcon,
    required this.link,
  }) : super(key: key);

  final bool active;
  final String label;
  final IconData buttonIcon;
  final String link;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return Column(
        children: [
          Icon(
            buttonIcon,
            color: AppColors.megaMenuActive,
            size: 32.0,
          ),
          Text(
            label,
            style: AppFonts.megaMenuActive,
          ),
        ],
      );
    } else {
      return Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(link);
            },
            icon: Icon(
              buttonIcon,
              color: AppColors.megaMenu,
              size: 32.0,
            ),
            iconSize: 32.0,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(
            label,
            style: AppFonts.megaMenu,
          ),
        ],
      );
    }
  }
}

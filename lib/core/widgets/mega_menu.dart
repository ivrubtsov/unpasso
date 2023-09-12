import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
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
      color: AppColors.megaMenuBg,
      height: 64,
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
    if (active) {
      return const Icon(
        Icons.home,
        color: AppColors.megaMenuIconsHomeActive,
      );
    } else {}
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(MainRoutes.homeScreen);
      },
      icon: const Icon(
        Icons.home_outlined,
        color: AppColors.megaMenuIconsHome,
      ),
      iconSize: 32.0,
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
    if (active) {
      return const Icon(
        Icons.people_alt,
        color: AppColors.megaMenuIconsFriendsActive,
      );
    } else {}
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(MainRoutes.friendsScreen);
      },
      icon: const Icon(
        Icons.people_alt_outlined,
        color: AppColors.megaMenuIconsFriends,
      ),
      iconSize: 32.0,
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
    if (active) {
      return const Icon(
        Icons.task,
        color: AppColors.megaMenuIconsMyActive,
      );
    } else {}
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(MainRoutes.goalScreen);
      },
      icon: const Icon(
        Icons.task_outlined,
        color: AppColors.megaMenuIconsMy,
      ),
      iconSize: 32.0,
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
    if (active) {
      return const Icon(
        Icons.games,
        color: AppColors.megaMenuIconsGamesActive,
      );
    } else {}
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(MainRoutes.gamesScreen);
      },
      icon: const Icon(
        Icons.games_outlined,
        color: AppColors.megaMenuIconsGames,
      ),
      iconSize: 32.0,
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
    if (active) {
      return const Icon(
        Icons.person,
        color: AppColors.megaMenuIconsProfileActive,
      );
    } else {
      return IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(MainRoutes.profileScreen);
        },
        icon: const Icon(
          Icons.person_outlined,
          color: AppColors.megaMenuIconsProfile,
        ),
        iconSize: 32.0,
      );
    }
  }
}

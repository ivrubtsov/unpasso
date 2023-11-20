import 'package:flutter/material.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';

class Achievements {
  Achievements._();

  static const length = 23;

  static List<String> congrats = [
    // 0
    'This is the beginning of an amazing journey to perfection',
    // 1
    'Do you feel it? You have just become a better version of yourself',
    // 2
    'Some people are just one step ahead of monkey. But you are two steps ahead of you previous self',
    // 3
    'Sacred Trinity gives you its power to succeed',
    // 4
    'You are bold as a four-wheel-drive truck. Have one?',
    // 5
    'Give me five! You\'ve done it!',
    // 6
    'Indians work harder probably because they have 6 working days a week. And you are better than many Indians.',
    // 7
    'The whole week of success! This is a difficult but important achievment on a long journey to perfection.',
    // 8
    'Do you know that you\'re much better than an average person?',
    // 9
    'WOW! The whole month! You\'ve done it! Keep progressing!',
    // 10
    'Almost done! What aan amazing progress!!!',
    // 11
    'You are the best!!! Take a look back and see what a great journey you have passed.',
    // 12
    'Give yourself a break! Sometimes you just need to refill the energy.',
    // 13
    'Let\'s hope that AI is not a threat to humanity, but a helper and a tool for development',
    // 14
    'Amazing! You are not alone anymore. Friendship gives us strength and support.',
    // 15
    'This is the first step to the power.',
    // 16
    'You have five friends. What a great team!',
    // 17
    'You\'re a true team player! Congratulations!',
    // 18
    'Thank you for the first support you have just given. It will make the world a better place.',
    // 19
    'Congratulation! Your goal inspires others to go further towards success.',
    // 20
    'You\'re such a great person! Thank you for your participation and support!',
    // 21
    'You\'re a true superstar!',
    // 22
    'The magic is here',
  ];

  static List<String> descriptions = [
    // 0
    'The first goal is set',
    // 1
    'The first step to success: the first goal is completed',
    // 2
    'Two steps ahead: two goals are completed in a row',
    // 3
    'Three goals in one week',
    // 4
    'Four goals in one week',
    // 5
    'Business week: five goals are completed in one week',
    // 6
    'Indian week: six goals are completed in one week',
    // 7
    'Full week: you did it! Seven days in a row!',
    // 8
    'Crescent: 15 goals in a month',
    // 9
    'Full moon: 30 days in a row',
    // 10
    'Demigod: 100 completed goals',
    // 11
    'Champion: 365 completed goals',
    // 12
    'A weekend without a backward thought',
    // 13
    'A new goal was generated by AI',
    // 14
    'A request for a friendship is accepted',
    // 15
    'A request for a friendship is sent',
    // 16
    'Five friends',
    // 17
    'Football team: eleven friends',
    // 18
    'Like a goal',
    // 19
    'Your goal was liked by others',
    // 20
    'You have liked 11 goals',
    // 21
    'Eleven your goals are liked by others',
    // 22
    'A secret achievement from Dasha',
  ];

  static List<IconData> icons = [
    // 0
    Icons.plus_one,
    // 1
    Icons.task_alt,
    // 2
    Icons.done_all,
    // 3
    Icons.date_range,
    // 4
    Icons.pets,
    // 5
    Icons.grade,
    // 6
    Icons.hotel_class,
    // 7
    Icons.switch_access_shortcut_add,
    // 8
    Icons.brightness_4,
    // 9
    Icons.brightness_5,
    // 10
    Icons.emoji_people,
    // 11
    Icons.emoji_events,
    // 12
    Icons.cruelty_free,
    // 13
    Icons.psychology,
    // 14
    Icons.person_add,
    // 15
    Icons.handshake,
    // 16
    Icons.groups_2,
    // 17
    Icons.diversity_1,
    // 18
    Icons.thumb_up,
    // 19
    Icons.sentiment_very_satisfied,
    // 20
    Icons.sign_language,
    // 21
    Icons.hotel_class,
    // 22
    Icons.error,
  ];

  static Widget getNewAchievement(int ach) {
    if (ach == 23) {
      return Image.asset('assets/achievements/ach13_128.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconActive,
        size: 128.0,
      );
    }
  }

  static Widget getActiveIcon(int ach) {
    if (ach == 23) {
      return Image.asset('assets/achievements/ach13_64.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconActive,
        size: 64.0,
      );
    }
  }

  static Widget getNonActiveIcon(int ach) {
    if (ach == 23) {
      return Image.asset('assets/achievements/ach13_64_off.png');
    } else {
      return Icon(
        icons[ach],
        color: AppColors.achIconNonActive,
        size: 64.0,
      );
    }
  }

  static Widget getIcon(int ach, bool isActive) {
    if (isActive) {
      return getActiveIcon(ach);
    } else {
      return getNonActiveIcon(ach);
    }
  }

  // SHOW MODAL WINDOW WITH AN ACHIEVEMENT
  static void showAchieveModal(int ach, BuildContext parentContext) {
    showModalBottomSheet<void>(
      context: parentContext,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          decoration: const BoxDecoration(
            color: AppColors.achBg,
            // borderRadius: BorderRadius.circular(30.0),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Congratulations!!!',
                      style: AppFonts.achModalHeader,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                        icon: const Icon(Icons.close),
                        color: AppColors.achCloseIcon),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: getNewAchievement(ach),
                ),
              ),
              Text(
                congrats[ach],
                style: AppFonts.achModalText,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}

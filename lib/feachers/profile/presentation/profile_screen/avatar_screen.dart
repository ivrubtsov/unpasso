import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/error_presentor.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';

import 'package:goal_app/feachers/profile/presentation/profile_screen/cubit/profile_screen_cubit.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.avatarBg,
          elevation: 0,
          title: const Text(
            'Choose avatar',
            style: AppFonts.header,
          ),
          actions: [
            IconButton(
              onPressed: () => context
                  .read<ProfileScreenCubit>()
                  .onAvatarAcceptTapped(context),
              icon: const Icon(Icons.check),
              color: AppColors.headerIcon,
            )
          ],
          /*
          leading: IconButton(
            onPressed: () =>
                context.read<ProfileScreenCubit>().onAvatarBackTapped(context),
            icon: const Icon(Icons.arrow_back_ios),
            color: AppColors.headerIcon,
          ),
          */
        ),
        backgroundColor: AppColors.avatarBg,
        body: const Column(
          children: [
            Expanded(
              child: Avatars(),
            ),
            /*
              child: AvatarSelection(
                  currentAvatar:
                      context.read<ProfileScreenCubit>().getCurrentAvatar()),
            ),
            */
            MegaMenu(active: 5),
          ],
        ));
  }
}

class Avatars extends StatelessWidget {
  const Avatars({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, state) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: AppAvatars.headers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Text(
                        AppAvatars.headers[index],
                        style: AppFonts.avatarHeader,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      AvatarBlock(block: index),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  );
                }),
          ),
          ErrorMessage(message: state.errorMessage),
        ],
      );
    });
    /*
    List<Widget> avatarBlocks = [];
    for (var i = 0; i < AppAvatars.headers.length; i++) {
      avatarBlocks.add(Column(
        children: [
          Text(
            AppAvatars.headers[i],
            style: AppFonts.avatarHeader,
            textAlign: TextAlign.left,
          ),
          const SizedBox(
            height: 10.0,
          ),
          AvatarBlock(block: i),
        ],
      ));
    }
    avatarBlocks.add(Expanded(
      child: Container(),
    ));
    return ListView(
      scrollDirection: Axis.vertical,
      children: avatarBlocks,
    );
    */
  }
}

class AvatarBlock extends StatelessWidget {
  const AvatarBlock({Key? key, required this.block}) : super(key: key);
  final int block;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
      builder: (context, state) {
        final model = context.read<ProfileScreenCubit>();
        return SizedBox(
          height: 80.0,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: AppAvatars.length,
              itemBuilder: (BuildContext context, int index) {
                final avatar = block * AppAvatars.length + index + 1;
                if (state.profile.avatar == avatar) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 10.0),
                    child: AppAvatars.getAvatarImage(avatar, true),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: const LinearBorder(),
                        side: const BorderSide(width: 0),
                        backgroundColor: AppColors.avatarBg,
                      ),
//                      onPressed: (() => model.changeAvatar(avatar)),
                      onPressed: (() => model.submitAvatar(context, avatar)),
                      child: AppAvatars.getAvatarImage(avatar, false),
                    ),
                  );
                }
              }),
        );
      },
    );
  }
}

/*
class AvatarSelection extends StatefulWidget {
  const AvatarSelection({Key? key, required this.currentAvatar})
      : super(key: key);
  final int currentAvatar;

  @override
  State<AvatarSelection> createState() => AvatarSelectionState();
}

class AvatarSelectionState extends State<AvatarSelection> {
  int selectedBlock = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedBlock = widget.currentAvatar ~/ AppAvatars.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenCubit, ProfileScreenState>(
        builder: (context, state) {
      final model = context.read<ProfileScreenCubit>();
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
            child: SizedBox(
              height: 80.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: AppAvatars.headers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(children: [
                      selectedBlock == index
                          ? Column(
                              children: [
                                AppAvatars.getAvatarImage(
                                    index * AppAvatars.length + 1, true),
                                SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  AppAvatars.headers[index],
                                  style: AppFonts.avatarHint,
                                ),
                              ],
                            )
                          : OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  selectedBlock = index;
                                });
                              },
                              child: Column(
                                children: [
                                  AppAvatars.getAvatarImage(
                                      index * AppAvatars.length + 1, false),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text(
                                    AppAvatars.headers[index],
                                    style: AppFonts.avatarHint,
                                  ),
                                ],
                              ),
                            ),
                    ]),
                  );
                },
              ),
            ),
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 76.0,
              mainAxisSpacing: 10.0, // spacing between rows
              crossAxisSpacing: 10.0, // spacing between columns
            ),
            padding: EdgeInsets.all(20.0), // padding around the grid
            itemCount: AppAvatars.length, // total number of items
            itemBuilder: (context, index) {
              final avatar = selectedBlock * AppAvatars.length + index;
              if (widget.currentAvatar == avatar) {
                return AppAvatars.getAvatarImage(avatar, true);
              } else {
                return OutlinedButton(
                  onPressed: (() => model.changeAvatar(avatar)),
                  child: AppAvatars.getAvatarImage(avatar, false),
                );
              }
            },
          )
        ],
      );
    });
  }
}
*/

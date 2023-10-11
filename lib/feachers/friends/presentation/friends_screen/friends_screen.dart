import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/consts/app_colors.dart';
import 'package:goal_app/core/consts/app_fonts.dart';
import 'package:goal_app/core/widgets/mega_menu.dart';
import 'package:goal_app/feachers/friends/presentation/friends_screen/cubit/friends_screen_cubit.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

enum FriendsScreenStatus {
  loading,
  error,
  ready,
}

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.friendsBg,
        elevation: 0,
        title: const Text(
          'My dear friends',
          style: AppFonts.header,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<FriendsScreenCubit>().openSearchBar();
              showSearch(
                context: context,
                delegate: FriendsSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search),
            color: AppColors.headerIcon,
          ),
        ],
      ),
      backgroundColor: AppColors.friendsBg,
      body: const Column(
        children: [
          Expanded(
            child: FriendsScreenContent(),
          ),
          MegaMenu(active: 2),
        ],
      ),
    );
  }
}

class FriendsSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query == '') {
            context.read<FriendsScreenCubit>().closeSearchBar();
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        context.read<FriendsScreenCubit>().closeSearchBar();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Profile>>(
      future: context.read<FriendsScreenCubit>().searchFriends(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return ListView.builder(
              //itemCount: suggestions.length,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return FriendSearchProfile(profile: snapshot.data![index]);
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class FriendsScreenContent extends StatefulWidget {
  const FriendsScreenContent({Key? key}) : super(key: key);

  @override
  State<FriendsScreenContent> createState() => FriendsScreenContentState();
}

class FriendsScreenContentState extends State<FriendsScreenContent>
    with WidgetsBindingObserver {
  DateTime currentDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
      builder: (context, state) {
        final model = context.read<FriendsScreenCubit>();
        final timeDiff = currentDate.difference(state.currentDate).inMinutes;
        if (timeDiff > Keys.refreshTimeoutFriends) {
          model.getFriendsnRequests();
        }
        if (state.status == FriendsScreenStateStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          onRefresh: () => model.getFriendsnRequests(),
          child: Column(
            children: [
              //SearchFriends(),
              state.friendsRequestsReceived.isNotEmpty
                  ? const Expanded(
                      flex: 2,
                      child: FriendsRequests(),
                    )
                  : Container(),
              state.friends.isNotEmpty
                  ? const Expanded(
                      flex: 2,
                      child: FriendsList(),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }
}

// WIDGET TO SHOW SEARCH BAR AND RESULTS
/*
class SearchFriends extends StatelessWidget {
  const SearchFriends({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      if (state.friendsRequestsReceived.isNotEmpty) {
        final friendsRequests = state.friendsRequestsReceived;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Friend requests',
                style: AppFonts.friendsHeader,
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10.0,
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: false,
                  itemCount: friendsRequests.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return FriendRequest(
                      key: ValueKey<Profile>(friendsRequests[index]),
                      profile: friendsRequests[index],
                    );
                  }),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}
*/

// WIDGET TO SHOW ONE USER TO SEND A FRIEND REQUEST
class FriendSearchProfile extends StatelessWidget {
  const FriendSearchProfile({
    Key? key,
    required this.profile,
  }) : super(key: key);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final model = context.read<FriendsScreenCubit>();
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      final isAlreadySent = model.checkInviteSent(profile);
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          children: [
            AppAvatars.getAvatarImage(profile.avatar),
            Expanded(
              child: Column(
                children: [
                  Text(
                    profile.name ?? profile.userName ?? 'Unknown',
                    style: AppFonts.friendsName,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '@${profile.userName}',
                          style: AppFonts.friendsUsername,
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
                            profile.rating.toString(),
                            style: AppFonts.friendsRating,
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Center(
                child: isAlreadySent
                    ? const Icon(
                        Icons.add,
                        color: AppColors.friendsInvite,
                        size: 32.0,
                      )
                    : IconButton(
                        onPressed: () => model.inviteFriend(profile, context),
                        icon: const Icon(
                          Icons.add,
                          color: AppColors.friendsInviteActive,
                          size: 32.0,
                        ),
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// WIDGET TO SHOW ALL FRIENDS REQUESTS
class FriendsRequests extends StatelessWidget {
  const FriendsRequests({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      if (!state.searchOpen && state.friendsRequestsReceived.isNotEmpty) {
        final friendsRequests = state.friendsRequestsReceived;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Friend requests (${friendsRequests.length})',
                style: AppFonts.friendsHeader,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemCount: friendsRequests.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FriendProfile(
                        key: ValueKey<Profile>(friendsRequests[index]),
                        profile: friendsRequests[index],
                        isFriend: false,
                        isRequest: true,
                      );
                    }),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

// WIDGET TO SHOW ONE FRIEND REQUEST
/*
class FriendRequest extends StatelessWidget {
  const FriendRequest({
    Key? key,
    required this.profile,
  }) : super(key: key);
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final model = context.read<FriendsScreenCubit>();
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          children: [
            AppAvatars.getAvatarImage(profile.avatar),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      profile.name ?? profile.userName ?? 'Unknown',
                      style: AppFonts.friendsName,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '@${profile.userName}',
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
                            profile.rating.toString(),
                            style: AppFonts.friendsRating,
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            SizedBox(
              width: 32.0,
              child: Center(
                child: IconButton(
                  onPressed: () => model.acceptRequest(profile),
                  icon: const Icon(
                    Icons.check_box,
                    color: AppColors.friendsApprove,
                    size: 32.0,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            SizedBox(
              width: 32.0,
              child: Center(
                child: IconButton(
                  onPressed: () => model.rejectRequest(profile),
                  icon: const Icon(
                    Icons.cancel,
                    color: AppColors.friendsReject,
                    size: 32.0,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
*/

// WIDGET TO SHOW ALL FRIENDS
class FriendsList extends StatelessWidget {
  const FriendsList({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      if (!state.searchOpen && state.friends.isNotEmpty) {
        final friends = state.friends;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              Text(
                'Friends (${friends.length})',
                style: AppFonts.friendsHeader,
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    reverse: false,
                    itemCount: friends.length,
                    itemBuilder: (BuildContext context, int index) {
                      return FriendProfile(
                        key: ValueKey<Profile>(friends[index]),
                        profile: friends[index],
                        isFriend: true,
                        isRequest: false,
                      );
                    }),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

// WIDGET TO SHOW ONE FRIEND
class FriendProfile extends StatelessWidget {
  const FriendProfile({
    Key? key,
    required this.profile,
    required this.isFriend,
    required this.isRequest,
  }) : super(key: key);
  final Profile profile;
  final bool isFriend;
  final bool isRequest;

  @override
  Widget build(BuildContext context) {
    final model = context.read<FriendsScreenCubit>();
    return BlocBuilder<FriendsScreenCubit, FriendsScreenState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Row(
          children: [
            AppAvatars.getAvatarImage(profile.avatar),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      profile.name ?? profile.userName ?? 'Unknown',
                      style: AppFonts.friendsName,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '@${profile.userName}',
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
                            profile.rating.toString(),
                            style: AppFonts.friendsRating,
                            textAlign: TextAlign.left,
                          ),
                        ]),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            isFriend
                ? SizedBox(
                    width: 32.0,
                    child: Center(
                      child: IconButton(
                        onPressed: () => model.removeFriend(profile, context),
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.friendsRemove,
                          size: 32.0,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  )
                : Container(),
            isRequest
                ? Row(
                    children: [
                      SizedBox(
                        width: 32.0,
                        child: Center(
                          child: IconButton(
                            onPressed: () =>
                                model.acceptRequest(profile, context),
                            icon: const Icon(
                              Icons.check_box,
                              color: AppColors.friendsApprove,
                              size: 32.0,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      SizedBox(
                        width: 32.0,
                        child: Center(
                          child: IconButton(
                            onPressed: () =>
                                model.rejectRequest(profile, context),
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColors.friendsReject,
                              size: 32.0,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      );
    });
  }
}

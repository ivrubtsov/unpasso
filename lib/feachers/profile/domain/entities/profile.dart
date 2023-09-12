class Profile {
  int id;
  int avatar;
  List<int> achievements;
  List<int> friends;
  List<int> friendsRequests;

  Profile({
    required this.id,
    required this.avatar,
    this.achievements = const [],
    this.friends = const [],
    this.friendsRequests = const [],
  });

  Profile copyWith({
    int? id,
    int? avatar,
    List<int>? achievements,
    List<int>? friends,
    List<int>? friendsRequests,
  }) {
    return Profile(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      achievements: achievements ?? this.achievements,
      friends: friends ?? this.friends,
      friendsRequests: friendsRequests ?? this.friendsRequests,
    );
  }

  Profile addAchievement(int newAch) {
    if (!achievements.contains(newAch)) {
      achievements.add(newAch);
    }
    return this;
  }

  List<Object?> get props => [
        id,
        avatar,
        achievements,
        friends,
        friendsRequests,
      ];
}

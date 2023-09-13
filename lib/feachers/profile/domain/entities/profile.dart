class Profile {
  int id;
  String? name;
  String? userName;
  int? avatar;
  List<int> achievements;
  List<int> friends;
  List<int> friendsRequests;

  Profile({
    required this.id,
    this.name,
    this.userName,
    this.avatar,
    this.achievements = const [],
    this.friends = const [],
    this.friendsRequests = const [],
  });

  Profile copyWith({
    int? id,
    String? name,
    String? userName,
    int? avatar,
    List<int>? achievements,
    List<int>? friends,
    List<int>? friendsRequests,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
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
        name,
        userName,
        avatar,
        achievements,
        friends,
        friendsRequests,
      ];
}

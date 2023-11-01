class Profile {
  int id;
  String? name;
  String? userName;
  int? avatar;
  List<int> achievements;
  int? rating;
  bool? isPaid;
  List<int> friends;
  List<int> friendsRequestsReceived;
  List<int> friendsRequestsSent;

  Profile({
    required this.id,
    this.name,
    this.userName,
    this.avatar,
    this.achievements = const [],
    this.rating = 0,
    this.isPaid = false,
    this.friends = const [],
    this.friendsRequestsReceived = const [],
    this.friendsRequestsSent = const [],
  });

  Profile copyWith({
    int? id,
    String? name,
    String? userName,
    int? avatar,
    List<int>? achievements,
    int? rating,
    bool? isPaid,
    List<int>? friends,
    List<int>? friendsRequestsReceived,
    List<int>? friendsRequestsSent,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      userName: userName ?? this.userName,
      avatar: avatar ?? this.avatar,
      achievements: achievements ?? this.achievements,
      rating: rating ?? this.rating,
      isPaid: isPaid ?? this.isPaid,
      friends: friends ?? this.friends,
      friendsRequestsReceived:
          friendsRequestsReceived ?? this.friendsRequestsReceived,
      friendsRequestsSent: friendsRequestsSent ?? this.friendsRequestsSent,
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
        rating,
        isPaid,
        friends,
        friendsRequestsReceived,
        friendsRequestsSent,
      ];
}

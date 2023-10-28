class Goal {
  final int? id;
  final String text;
  final DateTime createdAt;
  final int authorId;
  final String authorName;
  final String authorUserName;
  final int authorAvatar;
  final int authorRating;
  bool isCompleted;
  bool isExist;
  bool isPublic;
  bool isFriends;
  List<int> friendsUsers;
  bool isPrivate;
  bool like;
  List<int> likeUsers;
  int likes;
  bool isGenerated;
  bool isAccepted;

  Goal({
    this.id,
    required this.text,
    required this.createdAt,
    required this.authorId,
    this.authorName = '',
    this.authorUserName = '',
    this.authorAvatar = 0,
    this.authorRating = 0,
    this.isCompleted = false,
    this.isExist = true,
    this.isPublic = false,
    this.isFriends = false,
    this.friendsUsers = const [],
    this.isPrivate = true,
    this.like = false,
    this.likeUsers = const [],
    this.likes = 0,
    this.isGenerated = false,
    this.isAccepted = false,
  });

  Goal copyWith({
    int? id,
    String? text,
    DateTime? createdAt,
    int? authorId,
    String? authorName,
    String? authorUserName,
    int? authorAvatar,
    int? authorRating,
    bool? isCompleted,
    bool? isExist,
    bool? isPublic,
    bool? isFriends,
    List<int>? friendsUsers,
    bool? isPrivate,
    bool? like,
    List<int>? likeUsers,
    int? likes,
    bool? isGenerated,
    bool? isAccepted,
  }) {
    return Goal(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUserName: authorUserName ?? this.authorUserName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      authorRating: authorRating ?? this.authorRating,
      isCompleted: isCompleted ?? this.isCompleted,
      isExist: isExist ?? this.isExist,
      isPublic: isPublic ?? this.isPublic,
      isFriends: isFriends ?? this.isFriends,
      friendsUsers: friendsUsers ?? this.friendsUsers,
      isPrivate: isPrivate ?? this.isPrivate,
      like: like ?? this.like,
      likeUsers: likeUsers ?? this.likeUsers,
      likes: likes ?? this.likes,
      isGenerated: isGenerated ?? this.isGenerated,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  List<Object?> get props => [
        id,
        text,
        createdAt,
        authorId,
        authorName,
        authorUserName,
        authorAvatar,
        authorRating,
        isCompleted,
        isExist,
        isPublic,
        isFriends,
        friendsUsers,
        isPrivate,
        like,
        likeUsers,
        likes,
        isGenerated,
        isAccepted,
      ];
}

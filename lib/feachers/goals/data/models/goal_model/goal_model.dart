import '../../../domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel({
    int? id,
    required String text,
    required DateTime createdAt,
    required int authorId,
    String? authorName,
    String? authorUserName,
    int? authorAvatar,
    int? authorRating,
    required bool isCompleted,
    required bool isExist,
    bool? isPublic,
    bool? isFriends,
    List<int>? friendsUsers,
    bool? isPrivate,
    bool? like,
    List<int>? likeUsers,
    int? likes,
    bool? isGenerated,
    bool? isAccepted,
  }) : super(
          id: id,
          text: text,
          createdAt: createdAt,
          authorId: authorId,
          authorName: authorName ?? '',
          authorUserName: authorUserName ?? '',
          authorAvatar: authorAvatar ?? 0,
          authorRating: authorRating ?? 0,
          isCompleted: isCompleted,
          isExist: isExist,
          isPublic: isPublic ?? false,
          isFriends: isFriends ?? false,
          friendsUsers: friendsUsers ?? [],
          isPrivate: isPrivate ?? true,
          like: like ?? false,
          likeUsers: likeUsers ?? [],
          likes: likes ?? 0,
          isGenerated: isGenerated ?? false,
          isAccepted: isAccepted ?? false,
        );
  factory GoalModel.fromGoal(Goal goal) => GoalModel(
        id: goal.id,
        text: goal.text,
        createdAt: goal.createdAt,
        authorId: goal.authorId,
        authorName: goal.authorName,
        authorUserName: goal.authorUserName,
        authorAvatar: goal.authorAvatar,
        authorRating: goal.authorRating,
        isCompleted: goal.isCompleted,
        isExist: goal.isExist,
        isPublic: goal.isPublic,
        isFriends: goal.isFriends,
        friendsUsers: goal.friendsUsers,
        isPrivate: goal.isPrivate,
        like: goal.like,
        likeUsers: goal.likeUsers,
        likes: goal.likes,
        isGenerated: goal.isGenerated,
        isAccepted: goal.isAccepted,
      );

  factory GoalModel.fromJson(Map<String, dynamic> json, [int? id]) {
    final jsonDate = json['date'] + 'Z';
    final createdDate = DateTime.parse(jsonDate).toLocal();
    bool checkIsCompleted;
    bool checkIsGenerated;
    bool checkIsAccepted;
    bool checkIsPublic;
    bool checkIsFriends;
    List<int> friendsUsers;
    bool checkIsPrivate;
    String authorName;
    String authorUserName;
    int authorAvatar;
    int authorRating;
    List<int> likeUsers;
    bool like = false;
    final tags = json['tags'] as List<dynamic>?;
    // If tag == 8, then the goal is completed
    if (tags == null || tags.isEmpty) {
      checkIsCompleted = false;
      checkIsGenerated = false;
      checkIsAccepted = false;
      checkIsPublic = false;
      checkIsFriends = false;
      checkIsPrivate = true;
    } else {
      checkIsCompleted = tags.contains(8) ? true : false;
      checkIsGenerated = tags.contains(29) ? true : false;
      checkIsAccepted = tags.contains(30) ? true : false;
      if (!tags.contains(26) && !tags.contains(27) && !tags.contains(28)) {
        checkIsPublic = false;
        checkIsFriends = false;
        checkIsPrivate = true;
      } else {
        checkIsPublic = tags.contains(26) ? true : false;
        checkIsFriends = tags.contains(27) ? true : false;
        checkIsPrivate = tags.contains(28) ? true : false;
      }
    }
    if (json['content'] != null &&
        json['content'] != '' &&
        json['content']['rendered'] != null &&
        json['content']['rendered'] != '') {
      final description = json['content']['rendered'] as Map<String, dynamic>?;
      if (description == null || description.isEmpty || description == {}) {
        // TODO: Update author's name and username
        authorName = '';
        authorUserName = '';
        authorAvatar = 0;
        authorRating = 0;
        friendsUsers = [];
        likeUsers = [];
      } else {
        friendsUsers = [];
        likeUsers = [];
        if (description['authorUserName'] != null &&
            description['authorUserName'] != '') {
          authorUserName = description['authorUserName'];
        } else {
          authorUserName = '';
        }
        if (description['authorName'] != null &&
            description['authorName'] != '') {
          authorName = description['authorName'];
        } else {
          authorName = authorUserName;
        }
        if (description['authorAvatar'] != null &&
            description['authorAvatar'] != '') {
          authorAvatar = description['authorAvatar'] as int;
        } else {
          authorAvatar = 0;
        }
        if (description['authorRating'] != null &&
            description['authorRating'] == '') {
          authorRating = description['authorRating'] as int;
        } else {
          authorRating = 0;
        }
        if (description['friendsUsers'].isNotEmpty) {
          final List<int> idsList = List<int>.from(description['friendsUsers']);
          for (int user in idsList) {
            friendsUsers.add(user);
          }
        }
        if (description['likeUsers'].isNotEmpty) {
          final List<int> idsList = List<int>.from(description['likeUsers']);
          for (int user in idsList) {
            likeUsers.add(user);
          }
        }
      }
    } else {
      authorName = '';
      authorUserName = '';
      authorAvatar = 0;
      authorRating = 0;
      friendsUsers = [];
      likeUsers = [];
    }
    if (id != null && likeUsers.contains(id)) {
      like = true;
    }
    return GoalModel(
      id: json['id'],
      text: json['title']['rendered'],
      createdAt: createdDate,
      authorId: json['author'],
      authorName: authorName,
      authorUserName: authorUserName,
      authorAvatar: authorAvatar,
      authorRating: authorRating,
      isCompleted: checkIsCompleted,
      isExist: true,
      isPublic: checkIsPublic,
      isFriends: checkIsFriends,
      friendsUsers: friendsUsers,
      isPrivate: checkIsPrivate,
      like: like,
      likeUsers: likeUsers,
      likes: likeUsers.length,
      isGenerated: checkIsGenerated,
      isAccepted: checkIsAccepted,
    );
  }

  Map<String, dynamic> toJson() {
    final List<int> tags = isCompleted ? [8] : [];
    if (isPublic) tags.add(26);
    if (isFriends) tags.add(27);
    if (isPrivate) tags.add(28);
    if (isGenerated) tags.add(29);
    if (isAccepted) tags.add(30);
    final createdDate = createdAt.toUtc();
    final Map<String, dynamic> description = {
      'authorName': authorName,
      'authorUserName': authorUserName,
      'authorAvatar': authorAvatar,
      'authorRating': authorRating,
      'friendsUsers': friendsUsers,
      'likeUsers': likeUsers,
      'likes': likeUsers.length,
    };
    return {
      'title': text,
      'date_gmt': createdDate.toIso8601String(),
      'author': authorId,
      'tags': tags,
      'content': description,
      'status': 'publish',
      'categories': 6,
    };
  }
}

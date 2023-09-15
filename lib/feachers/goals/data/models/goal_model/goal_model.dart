import '../../../domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel({
    int? id,
    required String text,
    required DateTime createdAt,
    required int authorId,
    final String? authorName,
    final String? authorUserName,
    final int? authorAvatar,
    required bool isCompleted,
    required bool isExist,
    final bool? isPublic,
    final bool? isFriends,
    final List<int>? friendsUsers,
    final bool? isPrivate,
    final bool? like,
    final List<int>? likeUsers,
    final int? likes,
  }) : super(
          id: id,
          text: text,
          createdAt: createdAt,
          authorId: authorId,
          authorName: authorName ?? '',
          authorUserName: authorUserName ?? '',
          authorAvatar: authorAvatar ?? 0,
          isCompleted: isCompleted,
          isExist: isExist,
          isPublic: isPublic ?? false,
          isFriends: isFriends ?? false,
          friendsUsers: friendsUsers ?? [],
          isPrivate: isPrivate ?? true,
          like: like ?? false,
          likeUsers: likeUsers ?? [],
          likes: likes ?? 0,
        );
  factory GoalModel.fromGoal(Goal goal) => GoalModel(
        id: goal.id,
        text: goal.text,
        createdAt: goal.createdAt,
        authorId: goal.authorId,
        authorName: goal.authorName,
        authorUserName: goal.authorUserName,
        authorAvatar: goal.authorAvatar,
        isCompleted: goal.isCompleted,
        isExist: goal.isExist,
        isPublic: goal.isPublic,
        isFriends: goal.isFriends,
        friendsUsers: goal.friendsUsers,
        isPrivate: goal.isPrivate,
        like: goal.like,
        likeUsers: goal.likeUsers,
        likes: goal.likes,
      );

  factory GoalModel.fromJson(Map<String, dynamic> json, [int? id]) {
    final jsonDate = json['date'] + 'Z';
    final createdDate = DateTime.parse(jsonDate).toLocal();
    bool checkIsCompleted;
    bool checkIsPublic;
    bool checkIsFriends;
    List<int> friendsUsers;
    bool checkIsPrivate;
    String authorName;
    String authorUserName;
    int authorAvatar;
    List<int> likeUsers;
    bool like = false;
    final tags = json['tags'] as List<dynamic>?;
    // Если тэг == 8, то цель выполнена
    // С другой стороны если массив с тэгами пустой, тогда она не выполнена
    if (tags == null || tags.isEmpty) {
      checkIsCompleted = false;
      checkIsPublic = false;
      checkIsFriends = false;
      checkIsPrivate = true;
    } else {
      checkIsCompleted = tags.contains(8) ? true : false;
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
    final description = json['content']['rendered'] as Map<String, dynamic>?;
    if (description == null || description == {}) {
      // TODO: Update author's name and username
      authorName = '';
      authorUserName = '';
      authorAvatar = 0;
      friendsUsers = [];
      likeUsers = [];
    } else {
      authorName = description['authorName'];
      authorUserName = description['authorUserName'];
      authorAvatar = description['authorAvatar'];
      friendsUsers = description['friendsUsers'];
      likeUsers = description['likeUsers'];
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
      isCompleted: checkIsCompleted,
      isExist: true,
      isPublic: checkIsPublic,
      isFriends: checkIsFriends,
      friendsUsers: friendsUsers,
      isPrivate: checkIsPrivate,
      like: like,
      likeUsers: likeUsers,
      likes: likeUsers.length + 1,
    );
  }

  Map<String, dynamic> toJson() {
    final List<int> tags = isCompleted ? [8] : [];
    if (isPublic) tags.add(26);
    if (isFriends) tags.add(27);
    if (isPrivate) tags.add(28);
    final createdDate = createdAt.toUtc();
    final Map<String, dynamic> description = {
      'authorName': authorName,
      'authorUserName': authorUserName,
      'authorAvatar': authorAvatar,
      'friendsUsers': friendsUsers,
      'likeUsers': likeUsers,
      'likes': likeUsers.length + 1,
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

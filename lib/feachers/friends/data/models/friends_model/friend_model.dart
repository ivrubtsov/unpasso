import '../../../domain/entities/friend.dart';

class FriendModel extends Friend {
  FriendModel({
    required String text,
    required DateTime createdAt,
    required int authorId,
    required bool isCompleted,
    required bool isExist,
    int? id,
  }) : super(
          text: text,
          createdAt: createdAt,
          authorId: authorId,
          isCompleted: isCompleted,
          isExist: isExist,
          id: id,
        );
  factory FriendModel.fromFriend(Friend Friend) => FriendModel(
        text: Friend.text,
        createdAt: Friend.createdAt,
        authorId: Friend.authorId,
        id: Friend.id,
        isCompleted: Friend.isCompleted,
        isExist: Friend.isExist,
      );

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    bool isCompleted;
    final tags = json['tags'] as List<dynamic>?;
    // Если тэг == 8, то цель выполнена
    // С другой стороны если массив с тэгами пустой, тогда она не выполнена
    // Если нет, то выполнена
    // Поэтому не делаю проверку, есть ли 8 в массиве или нет
    tags == null || tags.isEmpty ? isCompleted = false : isCompleted = true;
    final jsonDate = json['date'] + 'Z';
    final createdDate = DateTime.parse(jsonDate).toLocal();
    return FriendModel(
      text: json['title']['rendered'],
      createdAt: createdDate,
      authorId: json['author'],
      isCompleted: isCompleted,
      isExist: true,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final tag = isCompleted ? [8] : null;
    final createdDate = createdAt.toUtc();
    return {
      'title': {
        'rendered': text,
      },
      'date': createdDate.toIso8601String(),
      'author': authorId,
      'tags': tag,
      'id': id,
    };
  }
}
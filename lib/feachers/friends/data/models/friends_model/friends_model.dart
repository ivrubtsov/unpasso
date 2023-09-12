import '../../../domain/entities/friends.dart';

class FriendsModel extends Friends {
  FriendsModel({
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
  factory FriendsModel.fromFriends(Friends Friends) => FriendsModel(
        text: Friends.text,
        createdAt: Friends.createdAt,
        authorId: Friends.authorId,
        id: Friends.id,
        isCompleted: Friends.isCompleted,
        isExist: Friends.isExist,
      );

  factory FriendsModel.fromJson(Map<String, dynamic> json) {
    bool isCompleted;
    final tags = json['tags'] as List<dynamic>?;
    // Если тэг == 8, то цель выполнена
    // С другой стороны если массив с тэгами пустой, тогда она не выполнена
    // Если нет, то выполнена
    // Поэтому не делаю проверку, есть ли 8 в массиве или нет
    tags == null || tags.isEmpty ? isCompleted = false : isCompleted = true;
    final jsonDate = json['date'] + 'Z';
    final createdDate = DateTime.parse(jsonDate).toLocal();
    return FriendsModel(
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

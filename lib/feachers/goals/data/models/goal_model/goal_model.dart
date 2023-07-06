import '../../../domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel({
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
  factory GoalModel.fromGoal(Goal goal) => GoalModel(
        text: goal.text,
        createdAt: goal.createdAt,
        authorId: goal.authorId,
        id: goal.id,
        isCompleted: goal.isCompleted,
        isExist: goal.isExist,
      );

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    bool isCompleted;
    final tags = json['tags'] as List<dynamic>?;
    // Если тэг == 8, то цель выполнена
    // С другой стороны если массив с тэгами пустой, тогда она не выполнена
    // Если нет, то выполнена
    // Поэтому не делаю проверку, есть ли 8 в массиве или нет
    tags == null || tags.isEmpty ? isCompleted = false : isCompleted = true;
    final jsonDate = json['date'] + 'Z';
    final createdDate = DateTime.parse(jsonDate).toLocal();
    return GoalModel(
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

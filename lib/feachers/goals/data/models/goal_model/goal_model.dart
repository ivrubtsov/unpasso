import '../../../domain/entities/goal.dart';

class GoalModel extends Goal {
  GoalModel({
    required String text,
    required DateTime createdAt,
    required int authorId,
    required bool isCompleted,
    int? id,
  }) : super(
          text: text,
          createdAt: createdAt,
          authorId: authorId,
          isCompleted: isCompleted,
          id: id,
        );
  factory GoalModel.fromGoal(Goal goal) => GoalModel(
        text: goal.text,
        createdAt: goal.createdAt,
        authorId: goal.authorId,
        id: goal.id,
        isCompleted: goal.isCompleted,
      );

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    bool isCompleted;
    final tags = json['tags'] as List<dynamic>?;
    // Если тэг == 8, то цель выполнена
    // С другой стороны если массив с тэгами пустой, тогда она не выполнена
    // Если нет, то выполнена
    // Поэтому не делаю проверку, есть ли 8 в массиве или нет
    tags == null || tags.isEmpty ? isCompleted = false : isCompleted = true;

    return GoalModel(
      text: json['title']['rendered'],
      createdAt: DateTime.parse(json['date']),
      authorId: json['author'],
      isCompleted: isCompleted,
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final tag = isCompleted ? [8] : null;
    return {
      'title': {
        'rendered': text,
      },
      'date': createdAt.toIso8601String(),
      'author': authorId,
      'tags': tag,
      'id': id
    };
  }
}

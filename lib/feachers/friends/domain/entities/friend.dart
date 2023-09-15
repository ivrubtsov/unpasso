import 'package:equatable/equatable.dart';

class Friend extends Equatable {
  final String text;
  final int authorId;
  final bool isCompleted;
  final bool isExist;
  final DateTime createdAt;
  final int? id;

  const Friend({
    required this.text,
    required this.createdAt,
    required this.authorId,
    this.id,
    this.isCompleted = false,
    this.isExist = true,
  });

  Friend copyWith({
    String? text,
    int? authorId,
    bool? isCompleted,
    bool? isExist,
    DateTime? createdAt,
    int? id,
  }) {
    return Friend(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      isCompleted: isCompleted ?? this.isCompleted,
      isExist: isExist ?? this.isExist,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
    );
  }

  @override
  List<Object?> get props => [
        text,
        authorId,
        createdAt,
        isCompleted,
        isExist,
        id,
      ];
}

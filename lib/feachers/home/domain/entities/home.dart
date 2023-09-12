import 'package:equatable/equatable.dart';

class Home extends Equatable {
  final String text;
  final int authorId;
  final bool isCompleted;
  final bool isExist;
  final DateTime createdAt;
  final int? id;

  const Home({
    required this.text,
    required this.createdAt,
    required this.authorId,
    this.id,
    this.isCompleted = false,
    this.isExist = true,
  });

  Home copyWith({
    String? text,
    int? authorId,
    bool? isCompleted,
    bool? isExist,
    DateTime? createdAt,
    int? id,
  }) {
    return Home(
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

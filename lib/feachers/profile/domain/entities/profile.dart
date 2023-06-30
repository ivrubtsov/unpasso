import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String text;
  final int authorId;
  final bool isCompleted;
  final DateTime createdAt;
  final int? id;

  const Profile({
    required this.text,
    required this.createdAt,
    required this.authorId,
    this.id,
    this.isCompleted = false,
  });

  Profile copyWith({
    String? text,
    int? authorId,
    bool? isCompleted,
    DateTime? createdAt,
    int? id,
  }) {
    return Profile(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      isCompleted: isCompleted ?? this.isCompleted,
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
        id,
      ];
}

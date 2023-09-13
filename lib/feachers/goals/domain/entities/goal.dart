import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final int? id;
  final String text;
  final DateTime createdAt;
  final int authorId;
  final String authorName;
  final String authorUserName;
  final bool isCompleted;
  final bool isExist;
  final bool isPublic;
  final bool isFriends;
  final bool isPrivate;
  final List<int> likeUsers;
  final int likes;

  const Goal({
    this.id,
    required this.text,
    required this.createdAt,
    required this.authorId,
    this.authorName = '',
    this.authorUserName = '',
    this.isCompleted = false,
    this.isExist = true,
    this.isPublic = false,
    this.isFriends = false,
    this.isPrivate = true,
    this.likeUsers = const [],
    this.likes = 0,
  });

  Goal copyWith({
    int? id,
    String? text,
    DateTime? createdAt,
    int? authorId,
    String? authorName,
    String? authorUserName,
    bool? isCompleted,
    bool? isExist,
    bool? isPublic,
    bool? isFriends,
    bool? isPrivate,
    List<int>? likeUsers,
    int? likes,
  }) {
    return Goal(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorUserName: authorUserName ?? this.authorUserName,
      isCompleted: isCompleted ?? this.isCompleted,
      isExist: isExist ?? this.isExist,
      isPublic: isPublic ?? this.isPublic,
      isFriends: isFriends ?? this.isFriends,
      isPrivate: isPrivate ?? this.isPrivate,
      likeUsers: likeUsers ?? this.likeUsers,
      likes: likes ?? this.likes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        createdAt,
        authorId,
        authorName,
        authorUserName,
        isCompleted,
        isExist,
        isPublic,
        isFriends,
        isPrivate,
        likeUsers,
        likes,
      ];
}

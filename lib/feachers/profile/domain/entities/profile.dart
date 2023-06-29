import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final int id;
  final List<int> achievements;

  const Profile({
    required this.id,
    this.achievements = const [],
  });

  Profile copyWith({
    int? id,
    List<int>? achievements,
  }) {
    return Profile(
      id: id ?? this.id,
      achievements: achievements ?? this.achievements,
    );
  }

  Profile addAchievement(int newAch) {
    this.achievements.add(newAch);
    return this;
  }

  @override
  List<Object?> get props => [
        id,
        achievements,
      ];
}

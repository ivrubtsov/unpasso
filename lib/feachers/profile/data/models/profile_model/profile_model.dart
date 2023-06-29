import 'dart:convert';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required int id,
    List<int> achievements = const [],
  }) : super(
          id: id,
          achievements: achievements,
        );
  factory ProfileModel.fromProfile(Profile profile) => ProfileModel(
        id: profile.id,
        achievements: profile.achievements,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final description = jsonDecode(json['description']);
    final achievements = description['achievements'] as List<int>;
    return ProfileModel(
      id: json['id'],
      achievements: achievements,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'achievements': achievements,
    };
  }

  String submitUrlString() {
    final desc = achievements.join(',');
    return ApiConsts.setAchievements('{"achievements":[$desc]}', id);
  }
}

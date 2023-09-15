import 'dart:convert';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required int id,
    String? name,
    String? userName,
    int? avatar,
    List<int> achievements = const [],
    List<int> friends = const [],
    List<int> friendsRequests = const [],
  }) : super(
          id: id,
          name: name,
          userName: userName,
          avatar: avatar,
          achievements: achievements,
          friends: friends,
          friendsRequests: friendsRequests,
        );
  factory ProfileModel.fromProfile(Profile profile) => ProfileModel(
        id: profile.id,
        name: profile.name,
        userName: profile.userName,
        avatar: profile.avatar,
        achievements: profile.achievements,
        friends: profile.friends,
        friendsRequests: profile.friendsRequests,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String name;
    int avatar;
    List<int> achievements;
    List<int> friends;
    List<int> friendsRequests;
    avatar = 0;
    achievements = [];
    friends = [];
    friendsRequests = [];

    final Map description = jsonDecode(json['description']);
    if (!(json['description'] == null || json['description'] == '')) {
      if (!(description['avatar'] == null ||
          description['avatar'] == '' ||
          description['avatar'] == 0)) {
        avatar = description['avatar'] as int;
      }
      if (!(description['achievements'] == null ||
          description['achievements'] == '' ||
          description['achievements'] == [])) {
      } else {
        achievements = List<int>.from(description['achievements']);
      }
      if (!(description['friends'] == null ||
          description['friends'] == '' ||
          description['friends'] == [])) {
        friends = List<int>.from(description['friends']);
      }
      if (!(description['friendsRequests'] == null ||
          description['friendsRequests'] == '' ||
          description['friendsRequests'] == [])) {
        friendsRequests = List<int>.from(description['friendsRequests']);
      }
    }
    if (json['name'] == null || json['name'] == '') {
      name = 'Unknown';
    } else {
      name = json['name'];
    }
    return ProfileModel(
      id: json['id'] as int,
      name: name,
      userName: json['username'] ?? '',
      avatar: avatar,
      achievements: achievements,
      friends: friends,
      friendsRequests: friendsRequests,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': userName,
      'avatar': avatar,
      'achievements': achievements,
      'friends': friends,
      'friendsRequests': friendsRequests,
    };
  }

  String submitUrlString() {
    final achievementsString = achievements.join(',');
    final friendsString = friends.join(',');
    final friendsRequestsString = friendsRequests.join(',');
    return ApiConsts.updateUser(
      id,
      name ?? 'Unknown',
      userName ?? '',
      '{"avatar":$avatar,"achievements":[$achievementsString],"friends":[$friendsString],"friendsRequests":[$friendsRequestsString]}',
    );
  }
}

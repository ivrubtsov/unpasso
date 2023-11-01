import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  ProfileModel({
    required int id,
    String? name,
    String? userName,
    int? avatar,
    List<int> achievements = const [],
    int? rating,
    bool? isPaid,
    List<int> friends = const [],
    List<int> friendsRequestsReceived = const [],
    List<int> friendsRequestsSent = const [],
  }) : super(
          id: id,
          name: name,
          userName: userName,
          avatar: avatar,
          achievements: achievements,
          rating: rating,
          isPaid: isPaid,
          friends: friends,
          friendsRequestsReceived: friendsRequestsReceived,
          friendsRequestsSent: friendsRequestsSent,
        );
  factory ProfileModel.fromProfile(Profile profile) => ProfileModel(
        id: profile.id,
        name: profile.name,
        userName: profile.userName,
        avatar: profile.avatar,
        achievements: profile.achievements,
        rating: profile.rating,
        isPaid: profile.isPaid,
        friends: profile.friends,
        friendsRequestsReceived: profile.friendsRequestsReceived,
        friendsRequestsSent: profile.friendsRequestsSent,
      );

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    String name;
    int avatar;
    List<int> achievements;
    int rating;
    bool isPaid;
    List<int> friends;
    List<int> friendsRequestsReceived;
    List<int> friendsRequestsSent;
    avatar = 0;
    achievements = [];
    rating = 0;
    isPaid = false;
    friends = [];
    friendsRequestsReceived = [];
    friendsRequestsSent = [];

    if (!(json['description'] == null || json['description'] == '')) {
      final Map<String, dynamic> description = json['description'];
      if (!(description['avatar'] == null ||
          description['avatar'] == '' ||
          description['avatar'] == 0)) {
        avatar = description['avatar'] as int;
      }
      if (!(description['achievements'] == null ||
          description['achievements'] == '' ||
          description['achievements'] == [])) {
        achievements = List<int>.from(description['achievements']);
      }
      if (!(description['rating'] == null ||
          description['rating'] == '' ||
          description['rating'] == 0)) {
        rating = description['rating'] as int;
      }
      if (!(description['isPaid'] == null ||
          description['isPaid'] == '' ||
          description['isPaid'] == false ||
          description['isPaid'] == 'false')) {
        isPaid = true;
      }
      if (!(description['friends'] == null ||
          description['friends'] == '' ||
          description['friends'] == [])) {
        friends = List<int>.from(description['friends']);
      }
      if (!(description['friendsRequestsReceived'] == null ||
          description['friendsRequestsReceived'] == '' ||
          description['friendsRequestsReceived'] == [])) {
        friendsRequestsReceived =
            List<int>.from(description['friendsRequestsReceived']);
      }
      if (!(description['friendsRequestsSent'] == null ||
          description['friendsRequestsSent'] == '' ||
          description['friendsRequestsSent'] == [])) {
        friendsRequestsSent =
            List<int>.from(description['friendsRequestsSent']);
      }
    }
    if (json['name'] == null || json['name'] == '') {
      name = json['username'] ?? 'Unknown';
    } else {
      name = json['name'];
    }
    return ProfileModel(
      id: json['id'] as int,
      name: name,
      userName: json['username'] ?? '',
      avatar: avatar,
      achievements: achievements,
      rating: rating,
      isPaid: isPaid,
      friends: friends,
      friendsRequestsReceived: friendsRequestsReceived,
      friendsRequestsSent: friendsRequestsSent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': userName,
      'avatar': avatar,
      'achievements': achievements,
      'rating': rating,
      'isPaid': isPaid,
      'friends': friends,
      'friendsRequestsReceived': friendsRequestsReceived,
      'friendsRequestsSent': friendsRequestsSent,
    };
  }

  String submitUrlString() {
    final achievementsString = achievements.join(',');
    final friendsString = friends.join(',');
    final friendsRequestsReceivedString = friendsRequestsReceived.join(',');
    final friendsRequestsSentString = friendsRequestsSent.join(',');
    return ApiConsts.updateUser(
      id,
      name ?? 'Unknown',
      userName ?? '',
      '{"avatar":$avatar,"achievements":[$achievementsString],"rating":$rating,"isPaid":$isPaid,"friends":[$friendsString],"friendsRequestsReceived":[$friendsRequestsReceivedString],"friendsRequestsSent":[$friendsRequestsSentString]}',
    );
  }

  Map<String, dynamic> submitJSON() {
    return {
      'id': id,
      'name': name ?? userName ?? 'Unknown',
      'userName': userName ?? '',
      'description': {
        'avatar': avatar,
        'achievements': achievements,
        'rating': rating,
        'isPaid': isPaid,
        'friends': friends,
        'friendsRequestsReceived': friendsRequestsReceived,
        'friendsRequestsSent': friendsRequestsSent,
      },
    };
  }
}

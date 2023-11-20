import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/friends/domain/repos/friends_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';

class FriendsRepoImpl implements FriendsRepo {
  FriendsRepoImpl({
    required SessionRepo sessionRepo,
  }) : _sessionRepo = sessionRepo;
  final SessionRepo _sessionRepo;
  Dio _dio() {
    final username = _sessionRepo.sessionData?.username;
    final password = _sessionRepo.sessionData?.password;
    if (password == null && username == null) return Dio();
    return Dio(BaseOptions(
      headers: {
        'authorization':
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      },
    ));
  }

  @override
  Future<List<Profile>> getFriends() async {
    try {
      final response = await _dio().get<List<dynamic>>(ApiConsts.getFriends());

      if (response.data == null) throw ServerException();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> getFriendsRequestsReceived() async {
    try {
      final response = await _dio()
          .get<List<dynamic>>(ApiConsts.getFriendsRequestsReceived());

      if (response.data == null) throw ServerException();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> getFriendsRequestsSent() async {
    try {
      final response =
          await _dio().get<List<dynamic>>(ApiConsts.getFriendsRequestsSent());

      if (response.data == null) throw ServerException();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> getFriendsData() async {
    try {
      final id = _sessionRepo.sessionData!.id;
      final response = await _dio().get(ApiConsts.getFriendsData(id));

      if (response.data == null || response.data!.isEmpty) {
        throw ServerException();
      }

      String name;
      int avatar;
      List<int> achievements;
      int rating;
      bool isPaid;
      avatar = 0;
      achievements = [];
      rating = 0;
      isPaid = false;

      final json = response.data;
      if (json['name'] == null || json['name'] == '') {
        name = json['username'] ?? 'Unknown';
      } else {
        name = json['name'];
      }

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
        if (avatar == 0) {
          avatar = AppAvatars.chooseAvatar();
        }

        return {
          'profile': {
            'id': json['id'] as int,
            'name': name,
            'userName': json['username'] ?? '',
            'avatar': avatar,
            'achievements': achievements,
            'rating': rating,
            'isPaid': isPaid,
          },
          'friends': description['friends'],
          'friendsRequestsReceived': description['friendsRequestsReceived'],
          'friendsRequestsSent': description['friendsRequestsSent'],
        };
      } else {
        return {
          'profile': {
            'id': json['id'] as int,
            'name': name,
            'userName': json['username'] ?? '',
            'avatar': AppAvatars.chooseAvatar(),
            'achievements': [],
            'rating': 0,
            'isPaid': false,
          },
          'friends': [],
          'friendsRequestsReceived': [],
          'friendsRequestsSent': [],
        };
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Map<String, dynamic>> processRequest(
      Profile profile, String action) async {
    try {
      final data = {
        'action': action,
      };
      final response = await _dio().post(
        ApiConsts.processFriendsRequestJSON(profile.id),
        data: jsonEncode(data),
      );

      if (response.data == null) throw ServerException();
      if (response.data['description'] == null ||
          response.data['description'] == '') {
        return {
          'friends': [],
          'friendsRequestsReceived': [],
          'friendsRequestsSent': [],
        };
      } else {
        return response.data['description'];
      }
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<Profile>> searchFriends(String text) async {
    try {
      final response =
          await _dio().get<List<dynamic>>(ApiConsts.searchFriends(text));

      if (response.data == null) throw ServerException();

      final users = response.data!.map((e) {
        return ProfileModel.fromJson(e);
      }).toList();

      return users;
    } on DioError {
      throw ServerException();
    }
  }
}

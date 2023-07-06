import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
import 'package:goal_app/feachers/profile/domain/repos/profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  ProfileRepoImpl({required SessionRepo sessionRepo})
      : _sessionRepo = sessionRepo;
  final SessionRepo _sessionRepo;
  Dio _dio() {
    final username = _sessionRepo.sessionData?.username;
    final password = _sessionRepo.sessionData?.password;
    if (password == null && username == null) {
      throw ServerException();
      // return Dio();
    }
    return Dio(BaseOptions(
      headers: {
        'authorization':
            'Basic ${base64.encode(utf8.encode('$username:$password'))}',
      },
    ));
  }

  @override
  Future<void> setAchievements(List<int> achievements) async {
    try {
      final profile = ProfileModel(
        id: _sessionRepo.sessionData!.id,
        achievements: achievements,
      );
      await _dio().post(profile.submitUrlString());
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<int>> getAchievements() async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      final url = ApiConsts.getAchievements(
        _sessionRepo.sessionData!.id,
      );
      final response = await _dio().get(url);
      if (response.data == null || response.data!.isEmpty) {
        return [];
      }

      final json = response.data;
      final Map description = await jsonDecode(json['description']);
      final achievements = description['achievements'];
      //final achs = description["achievements"].cast<int>();
      List<int> achs = new List<int>.from(achievements);
      return achs;
    } on DioError {
      throw ServerException();
    }
  }
}

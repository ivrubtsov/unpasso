import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:goal_app/core/consts/api_consts.dart';
import 'package:goal_app/core/consts/app_avatars.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';
import 'package:goal_app/feachers/profile/data/models/profile_model/profile_model.dart';
import 'package:goal_app/feachers/profile/domain/entities/profile.dart';
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
      final url = ApiConsts.getUser(
        _sessionRepo.sessionData!.id,
      );
      final response = await _dio().get(url);
      if (response.data == null || response.data!.isEmpty) {
        throw ServerException();
      }
      final json = response.data;
      ProfileModel profile = ProfileModel.fromJson(json);
      profile.achievements = achievements;
      await _dio().post(
        ApiConsts.updateUserJSON(profile.id),
        data: jsonEncode(profile.submitJSON()),
      );
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<List<int>> getAchievements() async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      final url = ApiConsts.getUser(
        _sessionRepo.sessionData!.id,
      );
      final response = await _dio().get(url);
      if (response.data == null || response.data!.isEmpty) {
        return [];
      }
      final json = response.data;
      if (json['description'] == null || json['description'] == '') {
        return [];
      }
      final Map description = await jsonDecode(json['description']);
      final achievements = description['achievements'];
      if (achievements == null || achievements == '' || achievements == []) {
        return [];
      }
      //final achs = description["achievements"].cast<int>();
      List<int> achs = List<int>.from(achievements);
      return achs;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<Profile> getUserData() async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      final url = ApiConsts.getUser(
        _sessionRepo.sessionData!.id,
      );
      final response = await _dio().get(url);
      if (response.data == null || response.data!.isEmpty) {
        throw ServerException();
      }

      final json = response.data;
      final Profile profile = ProfileModel.fromJson(json);
      if (profile.avatar == 0) {
        profile.avatar = AppAvatars.chooseAvatar();
      }
      return profile;
    } on DioError {
      throw ServerException();
    }
  }

  @override
  Future<void> updateUserData(Profile profile) async {
    if (_sessionRepo.sessionData == null) throw ServerException();
    try {
      /*
      final url = ApiConsts.updateUserJSON(
        _sessionRepo.sessionData!.id,
      );
      */
      await _dio().post(
        ApiConsts.updateUserJSON(profile.id),
        data: jsonEncode(ProfileModel.fromProfile(profile).submitJSON()),
      );
    } on DioError {
      throw ServerException();
    }
  }
}

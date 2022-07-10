import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:goal_app/core/consts/keys.dart';
import 'package:goal_app/core/exceptions/exceptions.dart';

import 'package:goal_app/feachers/auth/data/models/session_data_model/session_data_model.dart';
import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';
import 'package:goal_app/feachers/auth/domain/repos/session_repo.dart';

class SessionRepoImpl extends SessionRepo {
  SessionRepoImpl();
  static const _storage = FlutterSecureStorage();
  @override
  Future<void> saveSessionData(SessionData data) async {
    const storage = FlutterSecureStorage();

    final model = SessionDataModel.fromSessionData(data);
    sessionData = data;
    await storage.write(
        key: Keys.sessionData, value: jsonEncode(model.toJson()));
  }

  @override
  Future<SessionData> getSessionData() async {
    try {
      final jsonStr = await _storage.read(key: Keys.sessionData);
      if (jsonStr == null) throw SessionDataException();
      final savedSessionData = SessionDataModel.fromJson(jsonDecode(jsonStr));
      sessionData = savedSessionData;
      return savedSessionData;
    } catch (e) {
      throw SessionDataException();
    }
  }

  @override
  Future<void> removeSessionData() async {
    _storage.delete(key: Keys.sessionData);
  }
}

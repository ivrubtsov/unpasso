import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';

/// Throws [SessionDataException] if data is null
abstract class SessionRepo {
  bool get isAuth => sessionData != null;

  SessionData? sessionData;

  Future<SessionData> getSessionData();

  Future<void> saveSessionData(SessionData data);

  Future<void> removeSessionData();
}

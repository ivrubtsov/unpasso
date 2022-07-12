import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'session_data_model.g.dart';

@JsonSerializable()
class SessionDataModel extends SessionData {
  SessionDataModel({
    required int id,
    required String password,
    required String username,
  }) : super(
          id: id,
          password: password,
          username: username,
        );

  factory SessionDataModel.fromSessionData(SessionData data) =>
      SessionDataModel(
          id: data.id, password: data.password, username: data.username);
  factory SessionDataModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionDataModelToJson(this);
}

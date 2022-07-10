import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_data_model.g.dart';

@JsonSerializable()
class SessionDataModel extends SessionData {
  SessionDataModel({
    required String id,
    required String email,
  }) : super(id: id, email: email);

  factory SessionDataModel.fromSessionData(SessionData data) =>
      SessionDataModel(
        email: data.email,
        id: data.id,
      );
  factory SessionDataModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionDataModelToJson(this);
}

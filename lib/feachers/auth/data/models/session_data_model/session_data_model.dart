import 'package:goal_app/feachers/auth/domain/entities/session_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'session_data_model.g.dart';

@JsonSerializable()
class SessionDataModel extends SessionData {
  SessionDataModel({
    required int id,
  }) : super(id: id);

  factory SessionDataModel.fromSessionData(SessionData data) =>
      SessionDataModel(
        id: data.id,
      );
  factory SessionDataModel.fromJson(Map<String, dynamic> json) =>
      _$SessionDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionDataModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionDataModel _$SessionDataModelFromJson(Map<String, dynamic> json) =>
    SessionDataModel(
      id: json['id'] as int,
      password: json['password'] as String,
      username: json['username'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$SessionDataModelToJson(SessionDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'password': instance.password,
    };

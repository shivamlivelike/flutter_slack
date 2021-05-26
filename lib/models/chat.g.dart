// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
    json['id'] as String,
    json['message'] as String,
    SenderUser.fromJson(json['sender'] as Map<String, dynamic>),
    DateTime.parse(json['created'] as String),
    DateTime.parse(json['updated'] as String),
  );
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'message': instance.message,
      'sender': instance.sender.toJson(),
    };

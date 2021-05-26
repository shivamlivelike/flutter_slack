// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slackuser.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlackUser _$SlackUserFromJson(Map<String, dynamic> json) {
  return SlackUser(
    json['id'] as String,
    json['email'] as String,
    json['name'] as String,
    json['online'] as bool,
    json['pic'] as String,
    DateTime.parse(json['created'] as String),
    DateTime.parse(json['updated'] as String),
  );
}

Map<String, dynamic> _$SlackUserToJson(SlackUser instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'name': instance.name,
      'email': instance.email,
      'pic': instance.pic,
      'online': instance.online,
    };

SenderUser _$SenderUserFromJson(Map<String, dynamic> json) {
  return SenderUser(
    json['senderId'] as String,
    json['pic'] as String,
    json['name'] as String,
  );
}

Map<String, dynamic> _$SenderUserToJson(SenderUser instance) =>
    <String, dynamic>{
      'senderId': instance.senderId,
      'name': instance.name,
      'pic': instance.pic,
    };

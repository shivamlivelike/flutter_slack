// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroom.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) {
  return ChatRoom(
    json['id'] as String,
    json['title'] as String,
    json['isPrivate'] as bool,
    (json['members'] as List<dynamic>)
        .map((e) => SenderUser.fromJson(e as Map<String, dynamic>))
        .toList(),
    _$enumDecode(_$ChatRoomTypeEnumMap, json['chatRoomType']),
    DateTime.parse(json['created'] as String),
    DateTime.parse(json['updated'] as String),
  );
}

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created.toIso8601String(),
      'updated': instance.updated.toIso8601String(),
      'title': instance.title,
      'isPrivate': instance.isPrivate,
      'chatRoomType': _$ChatRoomTypeEnumMap[instance.chatRoomType],
      'members': instance.members.map((e) => e.toJson()).toList(),
    };

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

const _$ChatRoomTypeEnumMap = {
  ChatRoomType.direct: 'direct',
  ChatRoomType.channel: 'channel',
};

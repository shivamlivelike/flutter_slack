import 'package:flutter_slack/models/basemodel.dart';
import 'package:flutter_slack/models/slackuser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chatroom.g.dart';

@JsonSerializable(explicitToJson: true)
class ChatRoom extends BaseModel {
  String title;
  bool isPrivate;
  ChatRoomType chatRoomType;
  List<SenderUser> members;

  ChatRoom(String id, this.title, this.isPrivate, this.members,
      this.chatRoomType, DateTime created, DateTime updated)
      : super(id, created, updated);

  factory ChatRoom.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);
}

enum ChatRoomType { direct, channel }

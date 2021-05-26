import 'package:flutter_slack/models/basemodel.dart';
import 'package:flutter_slack/models/slackuser.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable(explicitToJson: true)
class Chat extends BaseModel {
  String message;
  SenderUser sender;

  Chat(String id, this.message, this.sender, DateTime created, DateTime updated)
      : super(id, created, updated);

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  Map<String, dynamic> toJson() => _$ChatToJson(this);
}

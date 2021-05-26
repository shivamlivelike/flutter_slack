import 'package:flutter_slack/models/basemodel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'slackuser.g.dart';

@JsonSerializable(explicitToJson: true)
class SlackUser extends BaseModel {
  String name;
  String email;
  String pic;
  bool online;

  SlackUser(String id, this.email, this.name, this.online, this.pic,
      DateTime created, DateTime updated)
      : super(id, created, updated);

  factory SlackUser.fromJson(Map<String, dynamic> json) =>
      _$SlackUserFromJson(json);

  Map<String, dynamic> toJson() => _$SlackUserToJson(this);

  @JsonKey(ignore: true)
  SenderUser toSenderUser() {
    return SenderUser(id, pic, name);
  }
}

@JsonSerializable()
class SenderUser {
  String senderId;
  String name;
  String pic;

  SenderUser(this.senderId, this.pic, this.name);

  factory SenderUser.fromJson(Map<String, dynamic> json) =>
      _$SenderUserFromJson(json);

  Map<String, dynamic> toJson() => _$SenderUserToJson(this);
}

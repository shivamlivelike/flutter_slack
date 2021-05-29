import 'package:date_format/date_format.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slack/models/chat.dart';
import 'package:flutter_slack/models/chatroom.dart';
import 'package:flutter_slack/screens/chat/chat_controller.dart';
import 'package:flutter_slack/utils/app_extensions.dart';
import 'package:flutter_slack/utils/app_widgets.dart';
import 'package:flutter_slack/utils/colors.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends GetResponsiveView<ChatController> {
  final String chatRoomId;

  ChatPage(this.chatRoomId);

  @override
  String? get tag => chatRoomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: EdgeInsets.zero,
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          color: backgroundColor,
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 20,
                      ),
                      Text(
                        "Channel Name",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(child: SizedBox.shrink(), flex: 4),
              Expanded(
                  child: Row(
                children: [
                  Obx(() => controller.chatRoom.value != null
                      ? ChatRoomMembersWithPicAndCount(
                          chatRoom: controller.chatRoom.value!)
                      : SizedBox.shrink()),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person_add),
                  )
                ],
              ))
            ],
          ),
        ),
        Expanded(
          child: SmartRefresher(
            controller: controller.refreshController,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return ChatView(chat: controller.chats[index]);
              },
              separatorBuilder: (context, index) => (index == 0 ||
                      !(controller.chats[index - 1].updated
                          .isSameDate(controller.chats[index].updated)))
                  ? Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                            "${controller.chats[index].updated.showDateOnly()}"),
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white60),
                        ),
                      ),
                    )
                  : Divider(),
              itemCount: controller.chats.length,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: AppTextField(
                  hintText: 'Send Message...',
                  underline: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ChatRoomMembersWithPicAndCount extends StatelessWidget {
  final ChatRoom chatRoom;

  const ChatRoomMembersWithPicAndCount({Key? key, required this.chatRoom})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          child: Stack(
            children: List.generate(
              chatRoom.members.length,
              (index) => Positioned(
                  child: UserPic(
                    height: 28,
                    width: 28,
                    radius: 5,
                    borderWidth: 2,
                    borderColor: backgroundColor,
                    url: chatRoom.members[index].pic,
                  ),
                  top: 0,
                  left: index * 18),
            ),
          ),
          width: 80,
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.only(left: 0, right: 15),
          child: Text(
            "${chatRoom.members.length}",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class ChatView extends StatelessWidget {
  final Chat chat;

  const ChatView({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserPic(height: 35, width: 35, url: chat.sender.pic),
      title: Row(
        children: [
          Text(
            "${chat.sender.name}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "${formatDate(chat.updated, [hh, ':', mm, ' ', am])}",
              style: TextStyle(fontSize: 11, color: Colors.white54),
            ),
          )
        ],
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${faker.lorem.sentence()}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}

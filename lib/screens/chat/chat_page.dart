import 'package:date_format/date_format.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slack/models/chat.dart';
import 'package:flutter_slack/models/chatroom.dart';
import 'package:flutter_slack/screens/chat/chat_controller.dart';
import 'package:flutter_slack/screens/home/home_controller.dart';
import 'package:flutter_slack/utils/app_extensions.dart';
import 'package:flutter_slack/utils/app_widgets.dart';
import 'package:flutter_slack/utils/colors.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends GetResponsiveView<ChatController> {
  final String chatRoomId;

  ChatPage(this.chatRoomId, Key? key) : super(key: key);

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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Row(
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
                Expanded(child: SizedBox.shrink()),
                Row(
                  children: [
                    Obx(() => controller.chatRoom.value != null
                        ? ChatRoomMembersWithPicAndCount(
                            chatRoom: controller.chatRoom.value!,
                            showCount:
                                controller.chatRoom.value!.members.length > 2)
                        : SizedBox.shrink()),
                    Obx(
                      () => controller.chatRoom.value!.chatRoomType ==
                              ChatRoomType.channel
                          ? IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.person_add),
                            )
                          : SizedBox.shrink(),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Expanded(
          child: Obx(() => SmartRefresher(
                controller: controller.refreshController,
                reverse: true,
                onLoading: () {
                  controller.loadData();
                },
                enablePullDown: false,
                enablePullUp: true,
                child: ListView.separated(
                  controller: controller.scrollController,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white60),
                            ),
                          ),
                        )
                      : Divider(),
                  itemCount: controller.chats.length,
                ),
              )),
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
  final bool showCount;

  const ChatRoomMembersWithPicAndCount(
      {Key? key, required this.chatRoom, this.showCount = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.log("MEM>>${chatRoom.members.length}");
    return Row(
      children: [
        ChatRoomMembersWithPic(chatRoom: chatRoom),
        showCount
            ? Container(
                height: 28,
                width: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "${chatRoom.members.length}",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              )
            : SizedBox.shrink()
      ],
    );
  }
}

class ChatRoomMembersWithPic extends StatelessWidget {
  final ChatRoom chatRoom;
  final bool showCurrentUserPic;

  const ChatRoomMembersWithPic(
      {Key? key, required this.chatRoom, this.showCurrentUserPic = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showCurrentUserPic) {
      final homeController = Get.find<HomeController>();
      chatRoom.members.removeWhere((element) =>
          homeController.currentUser.value?.id == element.senderId);
    }
    int count = (chatRoom.members.length > 3 ? 3 : chatRoom.members.length);
    return SizedBox(
        child: Stack(
          alignment: Alignment.center,
          children: List.generate(
              count,
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
                  left: index * 18)),
        ),
        width: 75,
        height: 30);
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

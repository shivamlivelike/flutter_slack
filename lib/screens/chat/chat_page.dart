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
import 'package:flutter_slack/utils/emoji_picker/chooser.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatPage extends GetResponsiveView<ChatController> {
  final String chatRoomId;

  ChatPage(this.chatRoomId, Key? key) : super(key: key);

  @override
  String? get tag => chatRoomId;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned.fill(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 6,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    color: backgroundColor,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                          InkWell(
                            child: Row(
                              children: [
                                Obx(() => controller.chatRoom.value != null
                                    ? ChatRoomMembersWithPicAndCount(
                                        chatRoom: controller.chatRoom.value!,
                                        showCount: controller.chatRoom.value!
                                                .members.length >
                                            2)
                                    : SizedBox.shrink()),
                                Obx(
                                  () =>
                                      controller.chatRoom.value!.chatRoomType ==
                                              ChatRoomType.channel
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Icon(Icons.person_add),
                                            )
                                          : SizedBox.shrink(),
                                )
                              ],
                            ),
                            onTap: controller.chatRoom.value != null
                                ? () {
                                    Get.dialog(Dialog(
                                      backgroundColor: backgroundColor,
                                      child: AddMemberToChatRoom(chatRoomId),
                                    ));
                                  }
                                : null,
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
                                        .isSameDate(
                                            controller.chats[index].updated)))
                                ? Center(
                                    child: Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Text(
                                          "${controller.chats[index].updated.showDateOnly()}"),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 7),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border:
                                            Border.all(color: Colors.white60),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: AppTextField(
                            controller: controller.messageController,
                            hintText: 'Send Message...',
                            underline: false,
                            cursorColor: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(child: SizedBox.shrink()),
                            Padding(
                              padding: EdgeInsets.only(right: 15, bottom: 5),
                              child: IconButton(
                                  onPressed: () {
                                    controller.showEmojis.value =
                                        !controller.showEmojis.value;
                                  },
                                  icon: Icon(Icons.emoji_emotions_outlined)),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 15, bottom: 5),
                                child: IconButton(
                                    onPressed: () {}, icon: Icon(Icons.send)))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              onTap: () {
                controller.showEmojis.value = false;
              },
            ),
          ),
          Positioned(
            child: Obx(() => controller.showEmojis.value
                ? StickerView(controller: controller)
                : SizedBox.shrink()),
            right: 20,
            bottom: 70,
          )
        ],
      ),
    );
  }
}

class AddMemberToChatRoom extends StatelessWidget {
  final String chatRoomId;

  const AddMemberToChatRoom(this.chatRoomId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>(tag: chatRoomId);
    return Container(
      width: 350,
      height: 500,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
                "${controller.chatRoom.value!.members.length} members in ${controller.chatRoom.value!.title}"),
            trailing: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.cancel_outlined),
                color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: TextButton(onPressed: () {}, child: Text("Add People")),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor)),
            child: AppTextField(
              hintText: 'Search People',
              underline: false,
              cursorColor: Colors.white,
            ),
          ),
          Expanded(child: ListView())
        ],
      ),
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

class StickerView extends StatelessWidget {
  final ChatController controller;

  const StickerView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: drawerBackgroundColor,
      child: Container(
        width: 310,
        height: 500,
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: EmojiChooser(
          columns: 10,
          rows: 10,
          width: 300,
          height: 400,
          onSelected: (emoji) {
            String text = controller.messageController.text;
            TextSelection textSelection =
                controller.messageController.selection;
            if (textSelection.isValid) {
              String newText = text.replaceRange(
                  textSelection.start, textSelection.end, emoji.char);
              final emojiLength = emoji.char.length;
              controller.messageController.text = newText;
              controller.messageController.selection = textSelection.copyWith(
                baseOffset: textSelection.start + emojiLength,
                extentOffset: textSelection.start + emojiLength,
              );
            }
          },
        ),
      ),
    );
  }
}

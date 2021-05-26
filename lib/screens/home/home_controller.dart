import 'package:faker/faker.dart';
import 'package:flutter_slack/models/chatroom.dart';
import 'package:flutter_slack/models/slackuser.dart';
import 'package:flutter_slack/screens/chat/chat_controller.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final directMessageChatRoom = <ChatRoom>[].obs;
  final users = <SlackUser>[].obs;
  final selectedChatRoom = Rx<ChatRoom?>(null);

  @override
  void onInit() {
    super.onInit();
    final pics = List.generate(
        60, (index) => "https://randomuser.me/api/portraits/women/$index.jpg");
    final uDate = faker.date.dateTime();
    users.addAll(List.generate(
        faker.randomGenerator.integer(100, min: 30),
        (index) => SlackUser(
            faker.guid.guid(),
            "user${faker.randomGenerator.integer(200, min: 1)}@slacklivelike.com",
            faker.person.name(),
            faker.randomGenerator.boolean(),
            faker.randomGenerator.element(pics),
            uDate,
            uDate)));

    final chatRooms = List.generate(faker.randomGenerator.integer(50), (index) {
      final date = faker.date.dateTime();
      final type = faker.randomGenerator.element(ChatRoomType.values);
      final members = <SenderUser>[];
      switch (type) {
        case ChatRoomType.channel:
          break;
        case ChatRoomType.direct:
          members.addAll(users
              .take(faker.randomGenerator.integer(10, min: 2))
              .map((e) => e.toSenderUser())
              .toList());
          break;
      }
      return ChatRoom(faker.guid.guid(), faker.lorem.word(),
          faker.randomGenerator.boolean(), members, type, date, date);
    });
    directMessageChatRoom.addAll(chatRooms
        .where((element) => element.chatRoomType == ChatRoomType.direct)
        .toList());
    directMessageChatRoom.forEach((chatRoom) {
      Get.put(ChatController(), tag: chatRoom.id);
    });
  }
}
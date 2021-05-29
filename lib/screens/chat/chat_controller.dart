import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slack/models/chat.dart';
import 'package:flutter_slack/models/chatroom.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatController extends GetxController {
  final chatRoom = Rx<ChatRoom?>(null);
  final chats = <Chat>[].obs;
  final refreshController = RefreshController(initialRefresh: false);

  final scrollController = ScrollController();

  ChatController(ChatRoom chatRoom) {
    this.chatRoom.value = chatRoom;
  }

  @override
  void onInit() {
    super.onInit();
    DateTime dateTime = faker.date.dateTime();
    chats.addAll(
        List.generate(faker.randomGenerator.integer(200, min: 50), (index) {
      if (faker.randomGenerator.boolean()) {
        dateTime = faker.date.dateTime();
      }
      return Chat(
          faker.guid.guid(),
          faker.lorem.sentence(),
          faker.randomGenerator.element(chatRoom.value?.members ?? []),
          dateTime,
          dateTime);
    })
          ..sort((c1, c2) => c1.updated.compareTo(c2.updated)));
  }

  @override
  void onReady() {
    super.onReady();
    print("Ready> ${chatRoom.value?.title}");
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}

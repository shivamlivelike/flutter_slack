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
  int lastIndexRead = -1;
  final showEmojis = false.obs;
  final messageController=TextEditingController();

  ChatController(ChatRoom chatRoom) {
    this.chatRoom.value = chatRoom;
  }

  void loadData() async {
    Get.log("load data");
    await Future.delayed(const Duration(milliseconds: 300));
    DateTime dateTime = faker.date.dateTime(maxYear: 2021, minYear: 2019);

    final list =
        List.generate(faker.randomGenerator.integer(100, min: 5), (index) {
      if (faker.randomGenerator.boolean()) {
        dateTime = faker.date.dateTime(maxYear: 2021, minYear: 2019);
      }
      return Chat(
          faker.guid.guid(),
          faker.lorem.sentence(),
          faker.randomGenerator.element(chatRoom.value?.members ?? []),
          dateTime,
          dateTime);
    })
          ..sort((c1, c2) => c2.updated.compareTo(c1.updated));

    chats.addAll(list);
    refreshController.loadComplete();

    Get.log("Data Loaded ${chats.length} , ${list.length}");
  }

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 300));
    Get.log("request loading");
    refreshController.requestLoading();
    // print("Ready> ${chatRoom.value?.title}");
    // scrollController.animateTo(scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}

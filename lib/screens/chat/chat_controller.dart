import 'package:faker/faker.dart';
import 'package:flutter_slack/models/chat.dart';
import 'package:flutter_slack/models/slackuser.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatController extends GetxController {
  final chats = <Chat>[].obs;
  final refreshController = RefreshController(initialRefresh: false);

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
          SenderUser(
              faker.guid.guid(),
              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRd0AQjkrS6zdwv-Rp5AnjpI-nM5EbDfhgBOg&usqp=CAU',
              faker.person.name()),
          dateTime,
          dateTime);
    })
          ..sort((c1, c2) => c1.updated.compareTo(c2.updated)));
  }
}

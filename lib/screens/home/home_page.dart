import 'package:flutter/material.dart';
import 'package:flutter_slack/models/slackuser.dart';
import 'package:flutter_slack/screens/chat/chat_page.dart';
import 'package:flutter_slack/screens/home/home_controller.dart';
import 'package:flutter_slack/utils/app_widgets.dart';
import 'package:flutter_slack/utils/colors.dart';
import 'package:get/get.dart';

class HomePage extends GetResponsiveView<HomeController> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget builder() {
    return Scaffold(
      drawer: screen.isPhone || screen.isTablet
          ? AppDrawer(controller: controller)
          : SizedBox.shrink(),
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: screen.isDesktop,
        leading: screen.isPhone || screen.isTablet
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : SizedBox.shrink(),
        title: Text("Dashboard"),
        actions: [
          AppBarTextField(),
          Obx(() => AppAccountBox(user: controller.currentUser.value))
        ],
      ),
      body: Row(
        children: [
          screen.isDesktop
              ? Expanded(child: AppDrawer(controller: controller), flex: 1)
              : SizedBox.shrink(),
          Expanded(
            flex: 4,
            child: Obx(
              () => controller.selectedChatRoom.value?.id != null
                  ? ChatPage(controller.selectedChatRoom.value!.id,
                      Key(controller.selectedChatRoom.value!.id))
                  : Center(
                      child: Text("Select ChatRoom"),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class AppAccountBox extends StatelessWidget {
  final SlackUser? user;

  const AppAccountBox({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: drawerBackgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            child: UserPic(url: user?.pic),
            alignment: Alignment.center,
          ),
          Expanded(
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(primary: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: user != null
                        ? Text("${user!.name}", textAlign: TextAlign.center)
                        : SizedBox.shrink(),
                  ),
                  Icon(Icons.arrow_drop_down_outlined)
                ],
              ),
            ),
          )
        ],
      ),
      width: 200,
    );
  }
}

class AppBarTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: drawerBackgroundColor,
      ),
      width: 200,
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              hintText: 'Search',
              underline: false,
              contentPadding: EdgeInsets.only(bottom: 10),
              cursorColor: Colors.white,
            ),
          ),
          Container(
            width: 40,
            height: 35,
            child: AppRaisedButton(
              radius: 5,
              child: Icon(Icons.search),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final HomeController controller;

  const AppDrawer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Obx(() => ExpansionTile(
                initiallyExpanded: true,
                collapsedTextColor: Colors.white,
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                title: Text("Channels(${controller.channelChatRoom.length})"),
                children: controller.channelChatRoom
                    .map(
                      (element) => Container(
                        color:
                            controller.selectedChatRoom.value?.id == element.id
                                ? accentColor
                                : backgroundColor,
                        child: ListTile(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          selected:
                              controller.selectedChatRoom.value == element,
                          selectedTileColor: Colors.blue,
                          title: Text(
                            element.title,
                            style: TextStyle(color: Colors.white),
                          ),
                          leading: ChatRoomMembersWithPic(
                              chatRoom: element, showCurrentUserPic: false),
                          onTap: () {
                            controller.changeChatRoom(element);
                          },
                        ),
                      ),
                    )
                    .toList(),
              )),
          Obx(() => ExpansionTile(
                initiallyExpanded: true,
                collapsedTextColor: Colors.white,
                textColor: Colors.white,
                iconColor: Colors.white,
                collapsedIconColor: Colors.white,
                title: Text(
                    "Direct Messages(${controller.directMessageChatRoom.length})"),
                trailing: IconButton(onPressed: () {}, icon: Icon(Icons.add)),
                children: controller.directMessageChatRoom
                    .map((element) => Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 0),
                            selected:
                                controller.selectedChatRoom.value == element,
                            selectedTileColor: Colors.blue,
                            title: Text(
                              element.title,
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: ChatRoomMembersWithPic(
                                chatRoom: element, showCurrentUserPic: false),
                            onTap: () {
                              controller.changeChatRoom(element);
                            },
                          ),
                          color: controller.selectedChatRoom.value?.id ==
                                  element.id
                              ? accentColor
                              : backgroundColor,
                        ))
                    .toList(),
              ))
        ],
      ),
    );
  }
}

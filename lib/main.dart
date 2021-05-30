import 'package:flutter/material.dart';
import 'package:flutter_slack/screens/home/home_controller.dart';
import 'package:flutter_slack/utils/app_extensions.dart';
import 'package:flutter_slack/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/home/home_page.dart';

void main() {
  Get.isLogEnable = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: backgroundColor,
        primaryColor: primaryColor,
        primaryColorDark: primaryDarkColor,
        accentColor: accentColor,
        canvasColor: drawerBackgroundColor,
        scaffoldBackgroundColor: backgroundColor,
        textTheme: GoogleFonts.latoTextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      getPages: [
        GetPage(
            name: Routes.home.path,
            page: () => HomePage(),
            binding: BindingsBuilder(() => {Get.put(HomeController())})),
      ],
      initialRoute: Routes.home.path,
    );
  }
}

enum Routes { login, home }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stu_customer/app/splash_screen/splash_screen.dart';
import 'package:stu_customer/controller/NavigatorController.dart';
import 'package:stu_customer/screen/home.dart';
import 'package:stu_customer/screen/layout.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (context) => NavigatorController(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STU Driver',
      routes: {
        '/': (context) => SplashScreen(
              child: LayoutPage(body: HomePage()),
            ),
        '/home': (context) => LayoutPage(body: HomePage()),
      },
    );
  }
}

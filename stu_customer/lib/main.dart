import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stu_customer/app/splash_screen/splash_screen.dart';
import 'package:stu_customer/controller/NavigatorController.dart';
import 'package:stu_customer/screen/home.dart';
import 'package:stu_customer/screen/layout.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:stu_customer/firebase_options.dart';

const kWebRecaptchaSiteKey = '6Lemcn0dAAAAABLkf6aiiHvpGD6x-zF3nOSDU2M8';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/': (context) => LayoutPage(body: HomePage()),
        '/home': (context) => LayoutPage(body: HomePage()),
      },
    );
  }
}

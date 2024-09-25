// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:stu_customer/authentication/login_screen.dart';
import 'package:stu_customer/global/global.dart';
import 'package:stu_customer/mainScreens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:stu_customer/models/user_model.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        String uid = '/Users/${currentFirebaseUser!.uid}';
        DatabaseReference ref = FirebaseDatabase.instance.ref(uid);
        DatabaseEvent event = await ref.once();
        Map<dynamic, dynamic>? data =
            event.snapshot.value as Map<dynamic, dynamic>?;
        // ignore: await_only_futures
        userModelCurrentInfo = UserModel(
            email: data?["email"],
            id: data?["id"],
            name: data?["name"],
            phone: data?["phone"]);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("lib/images/Loading.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

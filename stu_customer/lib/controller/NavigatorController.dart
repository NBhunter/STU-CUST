import 'package:flutter/material.dart';
import 'package:stu_customer/screenOld/home.dart';

class NavigatorController extends ChangeNotifier {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateToSearchPage() {
    navigatorKey.currentState!.push(MaterialPageRoute(
      builder: (context) => HomePage(), // Điều hướng đến trang tìm kiếm
    ));
  }
}

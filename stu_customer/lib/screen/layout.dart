import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stu_customer/core/utils/size_utils.dart';
import 'package:stu_customer/screen/Mapview.dart';
import 'package:stu_customer/screen/home.dart';
import 'package:stu_customer/screen/make_order.dart';
import 'package:stu_customer/screen/widgets/appbar_image.dart';
import 'package:stu_customer/screen/widgets/custom_app_bar.dart';
import 'package:stu_customer/theme/app_style.dart';
import 'package:stu_customer/core/app_export.dart';

class LayoutPage extends StatefulWidget {
  final Widget body;
  LayoutPage({required this.body});

  @override
  MyUI createState() => MyUI(this.body);
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class MyUI extends State<LayoutPage> {
  bool isSwitched = false;
  int _selectedIndex = 0;
  Widget _currentPage = Container();

  MyUI(Widget initialPage) {
    _currentPage = initialPage;
  }

  @override
  void initState() {
    super.initState();
    _currentPage = widget.body;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _currentPage = MakeOrderPage();
      } else if (index == 0) {
        _currentPage = HomePage();
      } else if (index == 2) {
        _currentPage = FullMap();
      } else if (index == 3) {
        _currentPage = MakeOrderPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Stream<User?> authStateChanges = _auth.authStateChanges();

    authStateChanges.listen((User? user) {
      if (user != null) {
        // Người dùng đã đăng nhập
        print('Người dùng đã đăng nhập với email: ${user.email}');
      } else {
        // Người dùng đã đăng xuất
        print('Người dùng đã đăng xuất');
      }
    });

    User? user = _auth.currentUser;
    if (user == null) {
      // Người dùng Chưa đăng nhập đưa về trang đăng nhập
      Navigator.pushNamed(context, "/login");
    }
    return Scaffold(
      appBar: CustomAppBar(
        height: getVerticalSize(
          91,
        ),
        title: Padding(
          padding: getPadding(
            left: 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    right: 14,
                  ),
                  child: Text(
                    "Chào Băng",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtGilroySemiBold28,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: getPadding(
                    top: 6,
                  ),
                  child: Text(
                    "Chúc một ngày vui vẻ!",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                    style: AppStyle.txtGilroyRegular16,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          AppbarImage(
            height: getSize(
              24,
            ),
            width: getSize(
              24,
            ),
            svgPath: ImageConstant.imgNotification,
            margin: getMargin(
              left: 16,
              top: 3,
              right: 31,
            ),
          ),
          AppbarImage(
            height: getSize(
              24,
            ),
            width: getSize(
              24,
            ),
            svgPath: ImageConstant.imgFilter,
            margin: getMargin(
              left: 24,
              top: 3,
              right: 47,
            ),
          ),
        ],
      ),
      body: _currentPage,
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_rounded),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Tin nhắn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Hồ sơ',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

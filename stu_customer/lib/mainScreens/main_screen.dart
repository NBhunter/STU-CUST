// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:stu_customer/tabPages/home_tab.dart';
import 'package:stu_customer/tabPages/earning_tab.dart';
import 'package:stu_customer/tabPages/order_tab.dart';
import 'package:stu_customer/tabPages/profile_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClicked(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = selectedIndex;
    });
  }

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
            HomeTabPage(),
            EarningsTabPage(),
            OrderTabPage(),
            ProfileTabPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Hoạt động",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Tin nhắn",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Hồ sơ",
          ),
        ],
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontSize: 14),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
    // TabBarView(
    //     physics: const NeverScrollableScrollPhysics(),
    //     controller: tabController,
    //     children: [
    //       HomeTabPage(),
    //       EarningsTabPage(),
    //       OrderTabPage(),
    //       ProfileTabPage(),
    //     ],
    //   ),
    //   bottomNavigationBar: BottomNavigationBar(
    //     items: const [
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.home),
    //         label: "Trang chủ",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.receipt_long),
    //         label: "Hoạt động",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.message),
    //         label: "Tin nhắn",
    //       ),
    //       BottomNavigationBarItem(
    //         icon: Icon(Icons.person),
    //         label: "Hồ sơ",
    //       ),
    //     ],
    //     unselectedItemColor: Colors.blueGrey,
    //     selectedItemColor: Colors.blue,
    //     backgroundColor: Colors.white,
    //     type: BottomNavigationBarType.fixed,
    //     selectedLabelStyle: const TextStyle(fontSize: 14),
    //     showUnselectedLabels: true,
    //     currentIndex: selectedIndex,
    //     onTap: onItemClicked,
    //   ),
    // );
  }
}

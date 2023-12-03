import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;
  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //lưu kích cỡ của button và khoảng cách ở giữa
  double? Imagesize;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //lấy thông tin thiết bị để xử lý kích cỡ của ảnh
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Imagesize = queryData.size.height - 20;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Image.asset(
              '',
              height: Imagesize,
            ),
          ],
        ),
      ),
    );
  }
}

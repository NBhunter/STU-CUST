import 'package:flutter/material.dart';
//import 'package:stu_driver/screen(Old)/map/MapView.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Stack(
                children: [
                  Container(
                    width: 450,
                    height: 73,
                    decoration: BoxDecoration(
                      color: Color(0xFF58B7EC),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                  ),
                  Column(children: [
                    Text(
                      'Xin chào Băng Nguyễn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Inter',
                        height: 0,
                      ),
                    ),
                    Text(
                      'Chúc 1 ngày tốt lành',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color(0xFFD9D1D1),
                        fontSize: 18,
                        fontFamily: 'Inter',
                        height: 1,
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Container(
                width: 389,
                height: 57,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 4,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 76,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: ShapeDecoration(
                                color: Color(0xFF69C1F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image(
                                image: const AssetImage(
                                    'lib/images/Icon_Home/bike_Icon.png'),
                                height: (MediaQuery.of(context).size.height *
                                    0.035),
                              ),
                            ),
                            const Text(
                              'Xe máy',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: ShapeDecoration(
                                color: Color(0xFF69C1F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image(
                                image: const AssetImage(
                                    'lib/images/Icon_Home/bike_Icon.png'),
                                height: (MediaQuery.of(context).size.height *
                                    0.035),
                              ),
                            ),
                            const Text(
                              'Gọi tài xế',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: ShapeDecoration(
                                color: Color(0xFF69C1F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image(
                                image: const AssetImage(
                                    'lib/images/Icon_Home/Shiping_Icon.png'),
                                height: (MediaQuery.of(context).size.height *
                                    0.035),
                              ),
                            ),
                            const Text(
                              'Giao hàng',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontFamily: 'Inter',
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 55,
                              height: 55,
                              decoration: ShapeDecoration(
                                color: Color(0xFF69C1F3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Image(
                                image: const AssetImage(
                                    'lib/images/Icon_Home/Shiping_Icon.png'),
                                height: (MediaQuery.of(context).size.height *
                                    0.035),
                              ),
                            ),
                            const Text(
                              'Đi chợ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                height: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Container(
                width: 389,
                height: 124,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 195,
                        height: 124,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 195,
                                height: 124,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 44,
                              top: 33,
                              child: Text(
                                'advertising \nevent in app',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 207,
                      top: 0,
                      child: Container(
                        width: 182,
                        height: 124,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 182,
                                height: 124,
                                decoration: ShapeDecoration(
                                  color: Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 37,
                              top: 37,
                              child: Text(
                                'advertising\nevent in app',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: 'Inter',
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Container(
                width: 389,
                height: 124,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 389,
                        height: 124,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 178,
                      top: 44,
                      child: Text(
                        'advertising slide 1',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              Container(
                width: 389,
                height: 237,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        width: 389,
                        height: 237,
                        decoration: ShapeDecoration(
                          color: Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 27,
                      top: 97,
                      child: Text(
                        'advertising merchant',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'Inter',
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

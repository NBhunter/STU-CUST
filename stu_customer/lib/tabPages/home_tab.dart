// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:stu_customer/global/API_Key.dart';
import 'package:stu_customer/global/global.dart';
import 'package:stu_customer/tabPages/SearchView/search_location_title.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Location location = Location();
  // dữ liệu location của thiết bị
  double? lngUser;
  double? latUser;
  List<dynamic> startDetails = [];

  //Erro check
  String? error;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  void _requestLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _getLocation();
  }

  void _getLocation() async {
    try {
      final locationResult = await location.getLocation();

      // Update the location variables in state synchronously
      setState(() {
        lngUser = locationResult.longitude!;
        latUser = locationResult.latitude!;
      });

      // Perform the asynchronous HTTP request outside of setState
      final url = Uri.parse(
          'https://rsapi.goong.io/geocode?latlng=$latUser,$lngUser&api_key=$mapKey');

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);

      // Process the JSON response and update state
      setState(() {
        startDetails = jsonResponse['results'] as List<dynamic>;
      });

      // Optionally, you can use the address after decoding it
      String formattedAddress = startDetails[0]['formatted_address'];
      print(formattedAddress); // Do something with the formatted address
    } on PlatformException catch (err) {
      setState(() {
        error = err.code;
        if (err.code == 'PERMISSION_DENIED') {
          error = 'Permission denied';
        }
        print(error);
      });
    }
  }

  // void _getLocation() async {
  //   try {
  //     final locationResult = await location.getLocation();
  //     setState(() async {
  //       lngUser = locationResult.longitude!;
  //       latUser = locationResult.latitude!;

  //       final url = Uri.parse(
  //           'https://rsapi.goong.io/geocode?latlng=$lngUser,$lngUser&api_key=$mapKey');

  //       var response = await http.get(url);
  //       final jsonResponse = jsonDecode(response.body);

  //       // ignore: unused_local_variable
  //       startDetails = jsonResponse['results'] as List<dynamic>;

  //       startDetails[0]['formatted_address'];
  //     });
  //   } on PlatformException catch (err) {
  //     setState(() {
  //       error = err.code;
  //       if (err.code == 'PERMISSION_DENIED') {
  //         error = 'Permission denied';
  //       }
  //       print(error);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                children: [
                  Container(
                    width: 450,
                    height: 80,
                    decoration: const BoxDecoration(
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
                      userModelCurrentInfo?.name != null
                          ? '   Xin chào ${userModelCurrentInfo!.name}'
                          : '   Xin chào người dùng',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Inter',
                        height: 0,
                      ),
                    ),
                    const Text(
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
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (c) => SearchLocationTitlePage()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.width * 0.15,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x3F000000),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: const Text(
                    '    Bạn muốn đi đâu ?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color.fromARGB(255, 5, 5, 5),
                      fontSize: 20,
                      fontFamily: 'Inter',
                      height: 2.3,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.020,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.24,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.width * 0.13,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  201,
                                  219,
                                  228,
                                ),
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.013),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.24,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.width * 0.13,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  201,
                                  219,
                                  228,
                                ),
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.013),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.24,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.width * 0.13,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  201,
                                  219,
                                  228,
                                ),
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
                    SizedBox(width: MediaQuery.of(context).size.width * 0.013),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.24,
                      child: ElevatedButton(
                        onPressed: () => {print("click in bike")},
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                          shadowColor: WidgetStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.24,
                              height: MediaQuery.of(context).size.width * 0.13,
                              decoration: ShapeDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  201,
                                  219,
                                  228,
                                ),
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
              SizedBox(
                width: 389,
                height: 124,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: SizedBox(
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
                                  color: const Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
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
                      child: SizedBox(
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
                                  color: const Color(0xFFD9D9D9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            const Positioned(
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
              SizedBox(
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
                          color: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
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
              SizedBox(
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
                          color: const Color(0xFFD9D9D9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
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

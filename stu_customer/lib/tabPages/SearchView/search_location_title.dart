// ignore_for_file: non_constant_identifier_names, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:stu_customer/global/map_key.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:stu_customer/tabPages/SearchView/Select_Order_View.dart';

class SearchLocationTitlePage extends StatefulWidget {
  const SearchLocationTitlePage({Key? key}) : super(key: key);

  @override
  SearchLocationTitleState createState() => SearchLocationTitleState();
}

class SearchLocationTitleState extends State<SearchLocationTitlePage> {
  ///lưu text bắt đầu và kết thúc
  final TextEditingController _searchStart = TextEditingController();
  final TextEditingController _searchEnd = TextEditingController();

  late FocusNode startFocusNode;
  late FocusNode endFocusNode;

  /// Kích thước màn hình
  double? HeightScreenSize; // Chiều cao màn hình
  double? WidthScreenSize; // Chiều rộng màn hình

  double statusBarHeight = 0; // Chiều cao thanh trạng thái

// Thêm biến boolean để theo dõi lựa chọn
// ignore: unused_field, prefer_final_fields
  bool _isLoading = false; // Biến kiểm tra đã có data chưa

// Dữ liệu vị trí của thiết bị
// ignore: unused_field
  late LocationData _location; // Dữ liệu vị trí
  final Location location = Location(); // Đối tượng vị trí
  bool isLocation = false; // Biến kiểm tra đã lấy được vị trí hay chưa

// Kinh độ và Vĩ độ của người dùng
  late double lngUser; // Kinh độ người dùng
  late double latUser; // Vĩ độ người dùng

  double? lngStart;
  double? latStart;
  double? lngEnd;
  double? latEnd;

  bool isShowEnd = false; // hiển thị  list item cuối cùng
  bool isShowStart = false; // hiển thị  list item cuối cùng

// Danh sách chứa thông tin về nơi bắt đầu
  List<dynamic> Place = []; // Nơi bắt đầu
  List<dynamic> Details = []; // Chi tiết nơi bắt đầu
  List<dynamic> endPlace = []; // Nơi kết thúc
  List<dynamic> endDetails = []; // Chi tiết nơi kết thúc

  String? StartPlaceName;

  String end = "";
  String start = "";
  int endLength = 0;
  int startLength = 0;

  MapboxMap? mapboxMap;
  @override
  void initState() {
    super.initState();
    _getLocation(); // Call _getLocation() in initState()
  }

  /// Get **Screen size** (width and height)
  /// and store it in the HeightScreenSize and WidthScreenSize variables.
  void GetScreenSize(BuildContext context) async {
    try {
      //try để tránh lỗi
      MediaQueryData queryData;
      queryData = MediaQuery.of(context);

      HeightScreenSize = queryData.size.height;
      WidthScreenSize = queryData.size.width;
      statusBarHeight = MediaQuery.of(context).padding.top;

      print('ScreenSize : $HeightScreenSize , $WidthScreenSize');
    } catch (e) {
      print('$e');
    }
  }

/*------------------------------------------------------------------------------------------------------------------*/
  void _getLocation() async {
    try {
      final locationResult = await location.getLocation();
      setState(() async {
        _location = locationResult;
        _isLoading = true;
        isLocation = true;

        final url = Uri.parse(
            'https://rsapi.goong.io/geocode?latlng=${locationResult.latitude},${locationResult.longitude}&api_key=$mapKey');
        var response = await http.get(url);
        final jsonResponse = jsonDecode(response.body);

        // ignore: unused_local_variable
        Details = jsonResponse['results'] as List<dynamic>;

        if (Details.isNotEmpty) {
          // ignore: no_leading_underscores_for_local_identifiers
          // mapboxMap?.setCamera(CameraOptions(
          //     center: Point(
          //             coordinates: Position(
          //                 Details[0]['geometry']['location']['lng'],
          //                 Details[0]['geometry']['location']['lat']))
          //         .toJson(),
          //     zoom: 15.0));

          lngUser = double.parse(
              Details[0]['geometry']['location']['lng'].toString());
          latUser = double.parse(
              Details[0]['geometry']['location']['lat'].toString());

          lngStart = lngUser;
          latStart = latUser;
          _searchStart.text = Details[0]['formatted_address'].toString();
        } else {
          _getLocation();
        }
        setState(() {});
      });
    } on PlatformException catch (err) {
      Fluttertoast.showToast(msg: "$err");
      setState(() {});
    }
  }

/*------------------------------------------------------------------------------------------------------------------*/
  Future<void> getProposePlace(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?api_key=$mapKey&location=$latUser,$lngUser&radius=25&limit=10&input=$input');
      var response = await http.get(url);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        endPlace = jsonResponse['predictions'] as List<dynamic>;
        isShowEnd = true;
      });
    } catch (e) {
      print('$e');
    }
  }

/*------------------------------------------------------------------------------------------------------------------*/
  Widget _buildListLocation(bool locationStatus) {
    return ListView.builder(
      itemCount: endPlace.length,
      itemBuilder: (context, index) {
        final coordinate = endPlace[index];

        String PlaceSubtitle;

        PlaceSubtitle =
            coordinate['structured_formatting']['secondary_text']!.toString();

        return Column(
          children: [
            ListTile(
              subtitle: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(
                    width: WidthScreenSize! - 56,
                    height: 35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coordinate['structured_formatting']['main_text'],
                          // '${coordinate['description']!.toString().substring(0, 50)}...',
                          softWrap: true, textAlign: TextAlign.left,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: WidthScreenSize! / 25,
                            fontFamily: 'Inter',
                            height: 1,
                          ),
                        ),
                        Text(
                          // coordinate['structured_formatting']['secondary_text'],
                          PlaceSubtitle,
                          softWrap: false, textAlign: TextAlign.left,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 90, 90, 90),
                            fontSize: WidthScreenSize! / 30,
                            fontFamily: 'Inter',
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              onTap: () async {
                setState(() {});

                final url = Uri.parse(
                    'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key=$mapKey');
                var response = await http.get(url);
                final jsonResponse = jsonDecode(response.body);

                Details = jsonResponse['results'] as List<dynamic>;
                if (locationStatus) {
                  lngStart = Details[index]['geometry']['location']['lng'];
                  latStart = Details[index]['geometry']['location']['lat'];
                  _searchStart.text = coordinate['description'];
                } else {
                  lngEnd = Details[index]['geometry']['location']['lng'];
                  latEnd = Details[index]['geometry']['location']['lat'];
                  _searchEnd.text = coordinate['description'];
                }

                if (_searchEnd.text.isEmpty) {
                } else if (_searchStart.text.isEmpty) {
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          // ignore: prefer_const_constructors
                          builder: (c) => SelectOrder_ViewPage()));
                }
              },
            ),
            const Divider(),
          ],
        );
      },
    );
  }

  void returnback(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    GetScreenSize(context);
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      body: Padding(
        padding: EdgeInsets.only(top: statusBarHeight),
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: WidthScreenSize,
                    height: HeightScreenSize! -
                        (HeightScreenSize! - ((HeightScreenSize! / 10) * 1.8)),
                    padding: EdgeInsets.only(top: (HeightScreenSize! / 40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          padding:
                              EdgeInsets.only(bottom: (HeightScreenSize! / 32)),
                          iconSize: HeightScreenSize! / 25,
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: (HeightScreenSize! / 100)),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Bạn muốn đi đâu ?',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: WidthScreenSize! / 20,
                                  fontFamily: 'Inter',
                                  height: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: WidthScreenSize! - 10,
                    height: (HeightScreenSize! / 100) * 28,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.only(left: 15, right: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          247, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              247, 70, 70, 70))),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.my_location,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: TextField(
                                          controller: _searchStart,
                                          onChanged: (startText) {
                                            int currentEndLength =
                                                startText.length;

                                            if (startText.length >= 3) {
                                              setState(() {
                                                start = startText;
                                              });
                                              getProposePlace(start);
                                            }
                                            isShowStart = false;
                                            isShowEnd = false;
                                            if (currentEndLength !=
                                                startLength) {
                                              setState(() {});
                                            }
                                            startLength = currentEndLength;
                                          },
                                          onTap: () {},
                                          decoration: const InputDecoration(
                                              hintText: "Nhập điểm đón",
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16)),
                                        ),
                                      ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: WidthScreenSize! - 10,
                    height: (HeightScreenSize! / 100) * 28,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.only(
                        left: 15,
                        right: 8,
                        top: (HeightScreenSize! / 100) * 17),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  padding: const EdgeInsets.only(left: 12),
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          247, 255, 255, 255),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              247, 70, 70, 70))),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, right: 8),
                                        child: TextField(
                                          autofocus: true,
                                          controller: _searchEnd,
                                          onChanged: (endText) {
                                            int currentEndLength =
                                                endText.length;

                                            if (endText.length >= 3) {
                                              setState(() {
                                                end = endText;
                                              });
                                              getProposePlace(end);
                                            }
                                            isShowEnd = true;
                                            if (currentEndLength != endLength) {
                                              setState(() {});
                                            }
                                            endLength = currentEndLength;
                                          },
                                          onTap: () {},
                                          decoration: const InputDecoration(
                                              hintText: "Nhập điểm đến",
                                              border: InputBorder.none,
                                              hintStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 16)),
                                        ),
                                      ))
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              isShowStart
                  ? SingleChildScrollView(
                      child: Container(
                        height: HeightScreenSize! -
                            ((HeightScreenSize! / 10) * 2.8),
                        decoration: const BoxDecoration(color: Colors.white),
                        child: _buildListLocation(true),
                      ),
                    )
                  : isShowEnd
                      ? SingleChildScrollView(
                          child: Container(
                            height: HeightScreenSize! -
                                ((HeightScreenSize! / 10) * 3.3),
                            padding: EdgeInsets.only(
                                bottom: ((HeightScreenSize! / 10) * 3.8)),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            child: _buildListLocation(false),
                          ),
                        )
                      : const Card(),
            ],
          ),
        ),
      ),
    );
  }
}

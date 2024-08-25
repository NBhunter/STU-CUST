import 'package:flutter/material.dart';

class SearchLocationTitlePage extends StatefulWidget {
  const SearchLocationTitlePage({Key? key}) : super(key: key);

  @override
  SearchLocationTitleState createState() => SearchLocationTitleState();
}

class SearchLocationTitleState extends State<SearchLocationTitlePage> {
  ///lưu text bắt đầu và kết thúc
  final TextEditingController _searchStart = TextEditingController();
  final TextEditingController _searchEnd = TextEditingController();

  ///Screen size variables
  double? HeightScreenSize;
  double? WidthScreenSize;

  // add a boolean variable to track selection
  bool _isSelected = false;

  /// Get **Screen size** (width and height)
  /// and store it in the HeightScreenSize and WidthScreenSize variables.
  void GetScreenSize(BuildContext context) async {
    try {
      //try để tránh lỗi
      MediaQueryData queryData;
      queryData = MediaQuery.of(context);

      HeightScreenSize = queryData.size.height;
      WidthScreenSize = queryData.size.width;
      print('Kich cỡ màn hình: $HeightScreenSize , $WidthScreenSize');
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    GetScreenSize(context);

    return Scaffold(
        body: Container(
            height: HeightScreenSize! / 4.4,
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isSelected = !_isSelected; // toggle selection

                          print('status select : $_isSelected');
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: _isSelected
                                ? Colors.blue
                                : Colors.grey, // conditionally set border color
                            width: 1,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: Colors.blue,
                              size: 20,
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              child: TextField(
                                controller: _searchStart,
                                onChanged: (startText) {},
                                onTap: () {
                                  setState(() {
                                    _isSelected =
                                        !_isSelected; // toggle selection

                                    print('status select : $_isSelected');
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: "Điểm bắt đầu",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.black54, fontSize: 16)),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ),
                    // Container(
                    //     padding: const EdgeInsets.only(left: 12),
                    //     decoration: const BoxDecoration(color: Colors.white,border: ),
                    //     child: Row(
                    //       children: [
                    //         const Icon(
                    //           Icons.location_on_outlined,
                    //           color: Colors.blue,
                    //           size: 20,
                    //         ),
                    //         Expanded(
                    //             child: Padding(
                    //           padding: const EdgeInsets.only(left: 8, right: 8),
                    //           child: TextField(
                    //             controller: _searchStart,
                    //             onChanged: (startText) {},
                    //             onTap: () {},
                    //             decoration: const InputDecoration(
                    //                 hintText: "Điểm bắt đầu",
                    //                 border: InputBorder.none,
                    //                 hintStyle: TextStyle(
                    //                     color: Colors.black54, fontSize: 16)),
                    //           ),
                    //         ))
                    //       ],
                    //     )),
                  ],
                ),
              ),
            ])));
  }
}

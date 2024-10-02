// ignore_for_file: unused_field

import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:stu_customer/global/API_Key.dart';
import 'package:stu_customer/global/global.dart';

class SelectOrder_ViewPage extends StatefulWidget {
  const SelectOrder_ViewPage({Key? key}) : super(key: key);

  @override
  SelectOrder_ViewState createState() => SelectOrder_ViewState();
}

// ignore: camel_case_types
class SelectOrder_ViewState extends State<SelectOrder_ViewPage> {
  double? lngStartOrder;
  double? latStartOrder;
  double? lngEndOrder;
  double? latEndOrder;
  CircleAnnotationManager? _circleAnnotationManagerStart;
  CircleAnnotationManager? _circleAnnotationManagerEnd;
  MapboxMap? mapboxMap;
  String duration = "";
  String distance = "";
  String sPriceCust = ""; // giá tiền chở khách
//Biến xử lý giá tiền
  double? dDistance;

  PolylinePoints polylinePoints = PolylinePoints();
  bool isHidden = true;
  String Mapstyle = MapboxStyles.LIGHT;

  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

//format giá tiền
  final oCcy = NumberFormat("#,##0đ", "vi_VN");
  @override
  void initState() {
    super.initState();

    lngStartOrder = Globals.GetlngStartOrder;
    latStartOrder = Globals.GetlatStartOrder;
    lngEndOrder = Globals.GetlngEndOrder;
    latEndOrder = Globals.GetlatEndOrder;
  }

  void getZoom() async {
    mapboxMap?.flyTo(
        CameraOptions(
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

/*------------------------------------------------------------------------------------------------------------------*/
  void _fetchData() async {
    if (latStartOrder != null &&
        lngStartOrder != null &&
        latEndOrder != null &&
        lngEndOrder != null &&
        isHidden != false) {
      // // ignore: no_leading_underscores_for_local_identifiers
      // mapboxMap?.setCamera(CameraOptions(
      //     center: Point(coordinates: Position(lngStartOrder!, latStartOrder!))
      //         .toJson(),
      //     zoom: 15.0));
// //Created start point
//       mapboxMap?.flyTo(
//           CameraOptions(
//               anchor: ScreenCoordinate(x: 0, y: 0),
//               zoom: 15,
//               bearing: 0,
//               pitch: 0),
//           MapAnimationOptions(duration: 2000, startDelay: 0));
//       mapboxMap?.annotations
//           .createCircleAnnotationManager()
//           .then((value) async {
//         setState(() {
//           _circleAnnotationManagerStart =
//               value; // Store the reference to the circle annotation manager
//         });

//         value.create(
//           CircleAnnotationOptions(
//             geometry: Point(
//                 coordinates: Position(
//               lngStartOrder!,
//               latStartOrder!,
//             )).toJson(),
//             circleColor: Colors.red.value,
//             circleRadius: 12.0,
//           ),
//         );
//       });
// //Created End point
//       mapboxMap?.flyTo(
//           CameraOptions(
//               anchor: ScreenCoordinate(x: 0, y: 0),
//               zoom: 15,
//               bearing: 0,
//               pitch: 0),
//           MapAnimationOptions(duration: 2000, startDelay: 0));
//       mapboxMap?.annotations
//           .createCircleAnnotationManager()
//           .then((value) async {
//         setState(() {
//           _circleAnnotationManagerEnd =
//               value; // Store the reference to the circle annotation manager
//         });

//         value.create(
//           CircleAnnotationOptions(
//             geometry: Point(
//                 coordinates: Position(
//               lngEndOrder!,
//               latEndOrder!,
//             )).toJson(),
//             circleColor: Colors.red.value,
//             circleRadius: 12.0,
//           ),
//         );
//       });
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=$latStartOrder,$lngStartOrder&destination=$latEndOrder,$lngEndOrder&vehicle=bike&api_key=$mapKey');
      print(url);
      mapboxMap?.setBounds(CameraBoundsOptions(
          bounds: CoordinateBounds(
              southwest: Point(
                  coordinates: Position(
                lngStartOrder!,
                latStartOrder!,
              )).toJson(),
              northeast: Point(
                  coordinates: Position(
                lngEndOrder!,
                latEndOrder!,
              )).toJson(),
              infiniteBounds: true),
          maxZoom: 15,
          minZoom: 0,
          maxPitch: 10,
          minPitch: 0));
      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];
      duration = jsonResponse['routes'][0]['legs'][0]['duration']['text'];
      distance = jsonResponse['routes'][0]['legs'][0]['distance']['text'];

      dDistance =
          jsonResponse['routes'][0]['legs'][0]['distance']['value'] / 1000;
      _checkmoney();

      List<PointLatLng> result = polylinePoints.decodePolyline(route);
      List<List<double>> coordinates =
          result.map((point) => [point.longitude, point.latitude]).toList();

      String geojson = '''{
      "type": "FeatureCollection",
      "features": [
        {
          "type": "Feature",
          "properties": {
            "name": "Crema to Council Crest"
          },
          "geometry": {
            "type": "LineString",
            "coordinates": $coordinates
          }
        }
      ]
    }''';

      await mapboxMap?.style
          .addSource(GeoJsonSource(id: "line", data: geojson));
      var lineLayerJson = """{
     "type":"line",
     "id":"line_layer",
     "source":"line",
     "paint":{
     "line-join":"round",
     "line-cap":"round",
     "line-color":"rgb(51, 51, 255)",
     "line-width":9.0
     }
     }""";

      await mapboxMap?.style.addPersistentStyleLayer(lineLayerJson, null);

      getZoom();
    }
    setState(() {
      isHidden = false;
    });
  }

/*------------------------------------------------------------------------------------------------------------------*/
  void _checkmoney() async {
    DatabaseReference dbRef;
    final Time = DateTime.now();
    int Price2km = 0;
    int OuterPrice2km = 0;
    dbRef = FirebaseDatabase.instance.ref().child('/Price');
    DatabaseEvent event = await dbRef.once();
    Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;

    if ((Time.hour >= 22 && Time.minute >= 30) || (Time.hour < 6)) {
      Price2km = data["OverTime"]["2km"];
      OuterPrice2km = data["OverTime"]["Outer2km"];
    } else {
      Price2km = data["OnlyGuests"]["2km"];
      OuterPrice2km = data["OnlyGuests"]["Outer2km"];
    }
    int Price = 0;
    if (dDistance!.ceil() <= 2.0) Price = Price2km;
    if (dDistance!.ceil() > 2.0) {
      dDistance = dDistance! - 2.0;
      Price = (dDistance!.ceil() * OuterPrice2km) + Price2km;
    }

    sPriceCust = oCcy.format(Price);
    //setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _fetchData();

    getZoom();
    return Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        body: Center(
            child: Stack(
          children: [
            SizedBox(
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                resourceOptions: ResourceOptions(
                    accessToken:
                        "pk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHJsd2ZzdmcxMjJuMnFvajVidHJlY3Z1In0.eHLIejIOfAR9K_u2O5dd6g"),
                cameraOptions: CameraOptions(
                    center: Point(
                            coordinates:
                                Position(lngStartOrder!, latStartOrder!))
                        .toJson(),
                    zoom: 15.0),
                styleUri: Mapstyle,
                textureView: true,
                onMapCreated: _onMapCreated,
              ),
            ),
            // isHidden
            //     ? const Card()
            //     :
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 280,
                  margin: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  alignment: Alignment.topLeft,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 5),
                    child: ListView(
                      children: [
                        const Text(' STU đưa bạn về ',
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 18)),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: duration,
                              style: TextStyle(
                                  color: Colors.green[800], fontSize: 18)),
                          TextSpan(
                              text: ' ($distance) ',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 18)),
                        ])),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: '(Giá tiền dự kiến: $sPriceCust)',
                              style: const TextStyle(
                                  color: Colors.black87, fontSize: 18)),
                        ])),
                        const Padding(
                            padding: EdgeInsets.only(
                          top: 8,
                        )),
                        const Text(
                          'Ở tình trạng giao thông hiện tại thì đây là tuyến đường nhanh nhất',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const Text(
                          'Khách hàng có nhu cầu đưa xe và người xin vui lòng thông báo với tài xế nhận cuốc',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Align(
                          alignment: FractionalOffset.center,
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 180,
                                  height: 55,
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      // MakeOrder();
                                      Fluttertoast.showToast(
                                          msg: "MakeOrder click ");
                                    },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.person),
                                        Text('Tìm tài xế'),
                                      ],
                                    ),
                                  ),
                                ),
                                // Container(
                                //   width: 15,
                                //   height: 55,
                                // ),
                                // Container(
                                //   width: 18,
                                //   height: 55,
                                //   decoration: BoxDecoration(
                                //     color: Colors.transparent,
                                //   ),
                                //   child: MaterialButton(
                                //     onPressed: () {
                                //       Navigator.pushNamed(
                                //           context, "/EditVehicle");
                                //     },
                                //     minWidth: 60,
                                //     child: Row(
                                //       mainAxisSize: MainAxisSize.min,
                                //       children: [
                                //         Icon(Icons.motorcycle),
                                //         Text('Người và xe'),
                                //       ],
                                //     ),
                                //     color: Colors.blue,
                                //     textColor: Colors.white,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        )));
  }
}

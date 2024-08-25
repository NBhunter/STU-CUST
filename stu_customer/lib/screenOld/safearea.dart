import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: SafeAreaMap()));
}

class AnnotationClickListener extends OnPointAnnotationClickListener {
  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    print("onAnnotationClick, id:");
  }
}

class SafeAreaMap extends StatefulWidget {
  const SafeAreaMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<SafeAreaMap> {
  MapboxMap? mapboxMap;
  CircleAnnotationManager? _circleAnnotationManager;
  PointAnnotationManager? _pointAnnotationManager;

  List<dynamic> places = [];
  String searchText = "";
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  Future<void> fetchData() async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/geocode?address=$searchText&api_key=qsy0OS8PcbxbmdNzOn8Gy0mSEdg4trKTgtcUD5DN');
      // ignore: avoid_print
      print('url $url');
      var response = await http.get(url);
      // ignore: avoid_print

      final jsonResponse = jsonDecode(response.body);
      places = jsonResponse['results'] as List<dynamic>;
      _circleAnnotationManager?.deleteAll();
      _pointAnnotationManager?.deleteAll();
// ignore: no_leading_underscores_for_local_identifiers

      mapboxMap?.setCamera(CameraOptions(
          center: Point(
                  coordinates: Position(
                      places[0]['geometry']['location']['lng'],
                      places[0]['geometry']['location']['lat']))
              .toJson(),
          zoom: 12.0));

      mapboxMap?.flyTo(
          CameraOptions(
              anchor: ScreenCoordinate(x: 0, y: 0),
              zoom: 17,
              bearing: 0,
              pitch: 0),
          MapAnimationOptions(duration: 2000, startDelay: 0));

      mapboxMap?.annotations
          .createCircleAnnotationManager()
          .then((value) async {
        _circleAnnotationManager = value;
        // value.getCirclePitchScale()
        value.create(
          CircleAnnotationOptions(
            geometry: Point(
                coordinates: Position(
              places[0]['geometry']['location']['lng'],
              places[0]['geometry']['location']['lat'],
            )).toJson(),
            circleStrokeColor: Colors.red.value,
            circleRadius: 100.0,
            circleOpacity: 0,
            circleStrokeOpacity: 1.0,
            circleStrokeWidth: 1.0,
          ),
        );
      });

      mapboxMap?.annotations.createPointAnnotationManager().then((value) async {
        _pointAnnotationManager = value;
        value.addOnPointAnnotationClickListener(AnnotationClickListener());
        value.create(PointAnnotationOptions(
          geometry: Point(
                  coordinates: Position(
                      places[0]['geometry']['location']['lng'],
                      places[0]['geometry']['location']['lat']))
              .toJson(),
          textField: "",
          textOffset: [0.0, -2.0],
          textColor: Colors.red.value,
          iconSize: 3,
          iconOffset: [0.0, -5.0],
          symbolSortKey: 10,
          iconImage: "marker-15",
          iconColor: Colors.blue.value,
        ));
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Safe Area'),
        ),
        body: Stack(children: [
          SizedBox(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions: ResourceOptions(accessToken: "{PUBLIC_TOKENS}"),
              cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(106, 21)).toJson(),
                  zoom: 5.0),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),
          ),
          Container(
              height: 70,
              alignment: Alignment.topLeft,
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              decoration: BoxDecoration(color: Colors.grey[200]),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.only(left: 12),
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.blue,
                                  size: 25,
                                ),
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: TextField(
                                    onChanged: (text) {
                                      setState(() {
                                        searchText = text;
                                      });
                                    },
                                    decoration: const InputDecoration(
                                        hintText: "Nhập địa điểm",
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 16)),
                                  ),
                                )),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 4,
                    ),
                    width: 40,
                    height: 50,
                    decoration: const BoxDecoration(),
                    child: IconButton(
                      iconSize: 30,
                      color: Colors.blue,
                      icon: const Icon(Icons.search_rounded),
                      onPressed: () {
                        fetchData();
                      },
                    ),
                  )
                ],
              )),
        ]));
  }
}

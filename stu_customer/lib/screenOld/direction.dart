import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() {
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: FullMap()));
}

class FullMap extends StatefulWidget {
  const FullMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  CircleAnnotationManager? _circleAnnotationManagerStart;
  CircleAnnotationManager? _circleAnnotationManagerEnd;
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  String start = "";
  String end = "";
  String duration = "";
  String distance = "";

  double? lngStart;
  double? latStart;
  double? lngEnd;
  double? latEnd;

  bool isShowStart = false;
  bool isShowEnd = false;
  bool isHidden = true;

  List<dynamic> startPlace = [];
  List<dynamic> startDetails = [];
  List<dynamic> endPlace = [];
  List<dynamic> endDetails = [];
  int startLength = 0;
  int endLength = 0;
  final TextEditingController _searchStart = TextEditingController();
  final TextEditingController _searchEnd = TextEditingController();
  PolylinePoints polylinePoints = PolylinePoints();
  Future<void> getStart(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?api_key={YOUR_API_KEY}&input=$input');
      var response = await http.get(url);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        startPlace = jsonResponse['predictions'] as List<dynamic>;
        _circleAnnotationManagerStart?.deleteAll();
        isShowStart = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Widget _buildListStart() {
    return ListView.builder(
      itemCount: startPlace.length,
      itemBuilder: (context, index) {
        final coordinate = startPlace[index];

        return ListTile(
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
              ),
              SizedBox(
                width: 330,
                height: 30,
                child: Text(
                  coordinate['description'],
                  softWrap: true,
                ),
              )
            ],
          ),
          onTap: () async {
            setState(() {
              isShowStart = false;
            });

            final url = Uri.parse(
                'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key={YOUR_API_KEY}');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);
            startDetails = jsonResponse['results'] as List<dynamic>;

            // ignore: no_leading_underscores_for_local_identifiers
            mapboxMap?.setCamera(CameraOptions(
                center: Point(
                        coordinates: Position(
                            startDetails[index]['geometry']['location']['lng'],
                            startDetails[index]['geometry']['location']['lat']))
                    .toJson(),
                zoom: 12.0));

            mapboxMap?.flyTo(
                CameraOptions(
                    anchor: ScreenCoordinate(x: 0, y: 0),
                    zoom: 15,
                    bearing: 0,
                    pitch: 0),
                MapAnimationOptions(duration: 2000, startDelay: 0));
            mapboxMap?.annotations
                .createCircleAnnotationManager()
                .then((value) async {
              setState(() {
                _circleAnnotationManagerStart =
                    value; // Store the reference to the circle annotation manager
                lngStart = startDetails[index]['geometry']['location']['lng'];
                latStart = startDetails[index]['geometry']['location']['lat'];
              });
              var pointAnnotationStart = value;
              value.create(
                CircleAnnotationOptions(
                  geometry: Point(
                      coordinates: Position(
                    startDetails[index]['geometry']['location']['lng'],
                    startDetails[index]['geometry']['location']['lat'],
                  )).toJson(),
                  circleColor: Colors.blue.value,
                  circleRadius: 12.0,
                ),
              );
            });
            _searchStart.text = coordinate['description'];
          },
        );
      },
    );
  }

  Future<void> getEnd(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?api_key={YOUR_API_KEY}&input=$input');
      var response = await http.get(url);
      setState(() {
        final jsonResponse = jsonDecode(response.body);
        endPlace = jsonResponse['predictions'] as List<dynamic>;
        _circleAnnotationManagerEnd?.deleteAll();
        isShowEnd = true;
      });
    } catch (e) {
      // ignore: avoid_print
      print('$e');
    }
  }

  Widget _buildListEnd() {
    return ListView.builder(
      itemCount: endPlace.length,
      itemBuilder: (context, index) {
        final coordinate = endPlace[index];

        return ListTile(
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                color: Colors.blue,
              ),
              SizedBox(
                width: 330,
                height: 30,
                child: Text(
                  coordinate['description'],
                  softWrap: true,
                ),
              )
            ],
          ),
          onTap: () async {
            setState(() {
              isShowEnd = false;
            });

            final url = Uri.parse(
                'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key={YOUR_API_KEY}');
            var response = await http.get(url);
            final jsonResponse = jsonDecode(response.body);
            endDetails = jsonResponse['results'] as List<dynamic>;

            // ignore: no_leading_underscores_for_local_identifiers
            mapboxMap?.setCamera(CameraOptions(
                center: Point(
                        coordinates: Position(
                            endDetails[index]['geometry']['location']['lng'],
                            endDetails[index]['geometry']['location']['lat']))
                    .toJson(),
                zoom: 12.0));

            mapboxMap?.flyTo(
                CameraOptions(
                    anchor: ScreenCoordinate(x: 0, y: 0),
                    zoom: 15,
                    bearing: 0,
                    pitch: 0),
                MapAnimationOptions(duration: 2000, startDelay: 0));
            mapboxMap?.annotations
                .createCircleAnnotationManager()
                .then((value) async {
              setState(() {
                _circleAnnotationManagerEnd =
                    value; // Store the reference to the circle annotation manager
                lngEnd = endDetails[index]['geometry']['location']['lng'];
                latEnd = endDetails[index]['geometry']['location']['lat'];
              });

              value.create(
                CircleAnnotationOptions(
                  geometry: Point(
                      coordinates: Position(
                    endDetails[index]['geometry']['location']['lng'],
                    endDetails[index]['geometry']['location']['lat'],
                  )).toJson(),
                  circleColor: Colors.red.value,
                  circleRadius: 12.0,
                ),
              );
            });
            _searchEnd.text = coordinate['description'];
          },
        );
      },
    );
  }

  void getZoom() async {
    mapboxMap?.flyTo(
        CameraOptions(
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

  void _fetchData() async {
    if (latStart != null &&
        lngStart != null &&
        latEnd != null &&
        lngEnd != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=$latStart,$lngStart&destination=$latEnd,$lngEnd&vehicle=bike&api_key={YOUR_API_KEY}');

      mapboxMap?.setBounds(CameraBoundsOptions(
          bounds: CoordinateBounds(
              southwest: Point(
                  coordinates: Position(
                lngStart!,
                latStart!,
              )).toJson(),
              northeast: Point(
                  coordinates: Position(
                lngEnd!,
                latEnd!,
              )).toJson(),
              infiniteBounds: true),
          maxZoom: 13,
          minZoom: 0,
          maxPitch: 10,
          minPitch: 0));

      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      var route = jsonResponse['routes'][0]['overview_polyline']['points'];
      duration = jsonResponse['routes'][0]['legs'][0]['duration']['text'];
      distance = jsonResponse['routes'][0]['legs'][0]['distance']['text'];
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
    }
    setState(() {
      isHidden = false;
    });
  }

  void removeLayer() async {
    await mapboxMap?.style.removeStyleLayer("line_layer");
    await mapboxMap?.style.removeStyleSource("line");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Direction'),
        ),
        body: Stack(
          children: [
            SizedBox(
              child: MapWidget(
                key: const ValueKey("mapWidget"),
                resourceOptions:
                    ResourceOptions(accessToken: "{PUBLIC_TOKENS}"),
                cameraOptions: CameraOptions(
                    center: Point(coordinates: Position(105.83991, 21.02800))
                        .toJson(),
                    zoom: 14.0),
                styleUri: MapboxStyles.DARK,
                textureView: true,
                onMapCreated: _onMapCreated,
              ),
            ),
            Container(
                height: 120,
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
                                    Icons.circle_outlined,
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
                                        int currentStartLength =
                                            startText.length;

                                        if (startText.length >= 3 &&
                                            startText[0] != " " &&
                                            startText.contains(" ")) {
                                          setState(() {
                                            start = startText;
                                          });
                                          getStart(start);
                                        }
                                        isShowStart = true;
                                        if (currentStartLength != startLength) {
                                          removeLayer();
                                          setState(() {
                                            isHidden = true;
                                          });
                                        }
                                        startLength = currentStartLength;
                                      },
                                      onTap: () {
                                        getZoom();
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Điểm bắt đầu",
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                    ),
                                  ))
                                ],
                              )),
                          const Padding(
                              padding: EdgeInsets.only(top: 5, bottom: 5)),
                          Container(
                              padding: const EdgeInsets.only(left: 12),
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: Colors.blue,
                                  ),
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: TextField(
                                      controller: _searchEnd,
                                      onChanged: (endText) {
                                        int currentEndLength = endText.length;

                                        if (endText.length >= 3) {
                                          setState(() {
                                            end = endText;
                                          });
                                          getEnd(end);
                                        }
                                        isShowEnd = true;
                                        if (currentEndLength != endLength) {
                                          setState(() {
                                            isHidden = true;
                                          });
                                          removeLayer();
                                        }
                                        endLength = currentEndLength;
                                      },
                                      onTap: () {
                                        getZoom();
                                      },
                                      decoration: const InputDecoration(
                                          hintText: "Điểm kết thúc",
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 16)),
                                    ),
                                  ))
                                ],
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        left: 4,
                      ),
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(),
                      child: IconButton(
                        iconSize: 40,
                        color: Colors.blue[900],
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          _fetchData();
                        },
                      ),
                    )
                  ],
                )),
            isShowStart
                ? Container(
                    height: 120,
                    margin: const EdgeInsets.fromLTRB(10, 75, 10, 0),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: _buildListStart(),
                  )
                : const Card(),
            isShowEnd
                ? Container(
                    height: 120,
                    margin: const EdgeInsets.fromLTRB(10, 130, 10, 0),
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: _buildListEnd(),
                  )
                : const Card(),
            isHidden
                ? const Card()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 100,
                        margin: const EdgeInsets.fromLTRB(0, 200, 0, 0),
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 10),
                          child: ListView(
                            children: [
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: duration,
                                    style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 18)),
                                TextSpan(
                                    text: ' ($distance)',
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 18)),
                              ])),
                              const Padding(
                                  padding: EdgeInsets.only(
                                top: 8,
                              )),
                              const Text(
                                'Ở tình trạng giao thông hiện tại thì đây là tuyến đường nhanh nhất',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                              ),
                            ],
                          ),
                        )),
                  ),
          ],
        ));
  }
}

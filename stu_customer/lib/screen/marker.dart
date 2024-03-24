import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: MarkerMap()));
}

class MarkerMap extends StatefulWidget {
  const MarkerMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<MarkerMap> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;
  CircleAnnotationManager? _circleAnnotationManager;
  // ignore: non_constant_identifier_names
  List<dynamic> Coordinates = [
    {'id': 1, 'lng': 105.8342, 'lat': 21.0278},
    {'id': 2, 'lng': 106.68028, 'lat': 20.86194},
    {'id': 3, 'lng': 106.31250, 'lat': 20.93972},
    {'id': 4, 'lng': 106.16833, 'lat': 20.42000},
    {'id': 5, 'lng': 106.33750, 'lat': 20.44750},
    {'id': 6, 'lng': 106.05639, 'lat': 21.18528},
  ];

  double? lng;
  double? lat;
  int? index;
  final TextEditingController _lng = TextEditingController();
  final TextEditingController _lat = TextEditingController();
  bool isShow = false;
  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    initMarker();
  }

  void initMarker() {
    mapboxMap?.annotations.createCircleAnnotationManager().then((value) async {
      _circleAnnotationManager = value;
      for (var coordinate in Coordinates) {
        final id = coordinate['id'];
        final lng = coordinate['lng'];
        final lat = coordinate['lat'];

        final options = CircleAnnotationOptions(
          geometry: Point(coordinates: Position(lng, lat)).toJson(),
          circleColor: Colors.blue.value,
          circleRadius: 12.0,
        );

        await value.create(options);
      }
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: Coordinates.length,
      itemBuilder: (context, index) {
        final coordinate = Coordinates[index];
        final id = coordinate['id'];
        final lng = coordinate['lng'];
        final lat = coordinate['lat'];

        return ListTile(
          onTap: () {
            mapboxMap?.setCamera(CameraOptions(
                center: Point(
                        coordinates:
                            Position(coordinate['lng'], coordinate['lat']))
                    .toJson(),
                zoom: 12.0));
            mapboxMap?.flyTo(
                CameraOptions(
                    anchor: ScreenCoordinate(x: 0, y: 0),
                    zoom: 14,
                    bearing: 0,
                    pitch: 0),
                MapAnimationOptions(duration: 2000, startDelay: 0));
          },
          subtitle: Row(
            children: [
              Container(
                width: 20,
                decoration: const BoxDecoration(),
                child: const Icon(Icons.location_on, size: 20),
              ),
              const Padding(padding: EdgeInsets.only(right: 5)),
              Container(
                width: 230,
                decoration: const BoxDecoration(),
                child: Text(
                  'Lat: $lat, Lng: $lng',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                width: 50,
                decoration: const BoxDecoration(),
                child: TextButton(
                  onPressed: () {
                    double a = Coordinates[index]['lng'];
                    double b = Coordinates[index]['lat'];
                    setState(() {
                      isShow = false;
                      index ==
                          Coordinates.indexWhere((item) => item['id'] == id);
                      Coordinates.removeAt(index);
                      initMarker();
                      _lng.text = a.toString();
                      _lat.text = b.toString();
                    });
                    _circleAnnotationManager?.deleteAll();
                  },
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.orange, fontSize: 15),
                  ),
                ),
              ),
              Container(
                width: 60,
                decoration: const BoxDecoration(),
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      Coordinates.removeWhere((item) => item['id'] == id);
                      initMarker();
                    });
                    _circleAnnotationManager?.deleteAll();
                  },
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red, fontSize: 15)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Marker'),
          actions: <Widget>[
            isShow
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isShow = !isShow;
                      });
                    },
                    icon: const Icon(Icons.menu))
          ],
        ),
        body: Stack(children: [
          SizedBox(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions: ResourceOptions(accessToken: "{PUBLIC_TOKENS}"),
              cameraOptions: CameraOptions(
                  center:
                      Point(coordinates: Position(105.8342, 21.0278)).toJson(),
                  zoom: 7.0),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),
          ),
          if (isShow)
            Container(
              height: 130,
              padding:
                  const EdgeInsets.only(top: 16, bottom: 16, left: 0, right: 0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              child: _buildListView(),
            )
          else
            Container(
              height: 55,
              padding:
                  const EdgeInsets.only(top: 8, bottom: 8, left: 0, right: 0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      left: 12,
                    ),
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 0,
                    ),
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(width: 1.0, color: Colors.black38)),
                    child: TextField(
                      controller: _lng,
                      onChanged: (long) {
                        setState(() {
                          lng = double.parse(long);
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: "Nhập kinh độ",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 12,
                    ),
                    padding: const EdgeInsets.only(
                      left: 12,
                      top: 0,
                    ),
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        border: Border.all(width: 1.0, color: Colors.black38)),
                    child: TextField(
                      controller: _lat,
                      onChanged: (lati) {
                        setState(() {
                          lat = double.parse(lati);
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: "Nhập vĩ độ",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.black54, fontSize: 16)),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                      top: 0,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Map<String, dynamic> newItem = {
                          'id':
                              Random().nextInt(100) + (Coordinates.length + 1),
                          'lng': lng,
                          'lat': lat
                        };
                        if (lng != null && lat != null) {
                          setState(() {
                            Coordinates.add(newItem);
                            initMarker();
                          });
                          _circleAnnotationManager?.deleteAll();
                          _lng.text = "";
                          _lat.text = "";
                        }
                      },
                      child: const Text('Tạo',
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                ],
              ),
            )
        ]));
  }
}

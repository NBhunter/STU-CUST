import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:stu_customer/screen/autocomplete.dart';
import 'package:stu_customer/screen/marker.dart';
import 'package:stu_customer/screen/safearea.dart';
import 'package:stu_customer/screen/simplemap.dart';

class FullMap extends StatefulWidget {
  const FullMap();

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class FullMapState extends State<FullMap> {
  MapboxMap? mapboxMap;
  LocationData? _currentLocation;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

<<<<<<< HEAD
  String start = "";
  String end = "";
  String duration = "";
  String distance = "";
  String sPriceCust = ""; // giá tiền chở khách
  String sPriceC_D = ""; // giá tiền chở khách và xe

  double? lngStart;
  double? latStart;
  double? lngEnd;
  double? latEnd;
  //Biến xử lý giá tiền
  double? dDistance;
  //lưu kích cỡ của button và khoảng cách ở giữa
  double? Buttonsize;
  double? Midsize;

  String Mapstyle = MapboxStyles.LIGHT;

  bool isShowStart = false; // kiểm tra hiển thị list item bắt đầu
  bool isShowEnd = false; // hiển thị  list item cuối cùng
  bool isHidden = true;
  bool isLocation = false; // đã lấy được vị trí location

  List<dynamic> startPlace = [];
  List<dynamic> startDetails = [];
  List<dynamic> endPlace = [];
  List<dynamic> endDetails = [];
  int startLength = 0;
  int endLength = 0;
  //lưu text bắt đầu và kết thúc
  final TextEditingController _searchStart = TextEditingController();
  final TextEditingController _searchEnd = TextEditingController();

  final Location location = Location();

  bool loading = false;
  // dữ liệu location của thiết bị
  LocationData? _location;
  String? error;
  //format giá tiền
  final oCcy = new NumberFormat("#,##0đ", "vi_VN");
  PolylinePoints polylinePoints = PolylinePoints();
  /*------------------------------------------------------------------------------------------------------------------*/
  Future<void> getStart(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg&input=$input');
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

/*------------------------------------------------------------------------------------------------------------------*/
  Future<void> _getLocation() async {
    setState(() {
      error = null;
      loading = true;
      isShowStart = false;
    });
    try {
      final locationResult = await location.getLocation();
      setState(() {
        _location = locationResult;
        loading = false;
        isShowStart = true;
        isLocation = true;
        lngStart = _location!.longitude;
        latStart = _location!.latitude;

        mapboxMap?.setCamera(CameraOptions(
            center: Point(coordinates: Position(lngStart!, latStart!)).toJson(),
            zoom: 12.0));

        mapboxMap?.flyTo(
            CameraOptions(
                anchor: ScreenCoordinate(x: 0, y: 0),
                zoom: 20,
                bearing: 0,
                pitch: 0),
            MapAnimationOptions(duration: 2000, startDelay: 0));
        mapboxMap?.annotations
            .createCircleAnnotationManager()
            .then((value) async {
          setState(() {
            _circleAnnotationManagerStart =
                value; // Store the reference to the circle annotation manager
            lngStart = lngStart!;
            latStart = latStart!;
          });
          var pointAnnotationStart = value;
          value.create(
            CircleAnnotationOptions(
              geometry: Point(
                  coordinates: Position(
                lngStart!,
                latStart!,
              )).toJson(),
              circleColor: Colors.blue.value,
              circleRadius: 12.0,
            ),
          );
        });
      });
      final url = Uri.parse(
          'https://rsapi.goong.io/geocode?latlng=${latStart},%${lngStart}&api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg');
      var response = await http.get(url);
      final jsonResponse = jsonDecode(response.body);
      startDetails = jsonResponse['results'] as List<dynamic>;
      _searchStart.text = "Vị trí thiết bị";
    } on PlatformException catch (err) {
      setState(() {
        error = err.code;
        loading = false;
        isShowStart = false;
      });
    }
  }

/*------------------------------------------------------------------------------------------------------------------*/
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
                'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg');
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

/*------------------------------------------------------------------------------------------------------------------*/
  Future<void> getEnd(String input) async {
    try {
      final url = Uri.parse(
          'https://rsapi.goong.io/Place/AutoComplete?api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg&input=$input');
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

/*------------------------------------------------------------------------------------------------------------------*/
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
                'https://rsapi.goong.io/geocode?address=${coordinate['description']}&api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg');
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

/*------------------------------------------------------------------------------------------------------------------*/
  void getZoom() async {
    mapboxMap?.flyTo(
        CameraOptions(
          zoom: 13.0,
        ),
        MapAnimationOptions(duration: 2000, startDelay: 0));
  }

/*------------------------------------------------------------------------------------------------------------------*/
  void _fetchData() async {
    if (latStart != null &&
        lngStart != null &&
        latEnd != null &&
        lngEnd != null) {
      final url = Uri.parse(
          'https://rsapi.goong.io/Direction?origin=$latStart,$lngStart&destination=$latEnd,$lngEnd&vehicle=bike&api_key=ssA2OE41HQgN5nFdk7AtOCAqf2cyI5CMLR9M9VCg');

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
    }
    setState(() {
      isHidden = false;
    });
  }

/*------------------------------------------------------------------------------------------------------------------*/
  void removeLayer() async {
    await mapboxMap?.style.removeStyleLayer("line_layer");
    await mapboxMap?.style.removeStyleSource("line");
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
    setState(() {});
  }

/*------------------------------------------------------------------------------------------------------------------*/
=======
  @override
  void initState() {
    super.initState();
  }

>>>>>>> e6ae5ff634c965942b7a4ae388fb4427c0fa786e
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Buttonsize = (queryData.size.width / 2) - 35;
    Midsize = queryData.size.width - (Buttonsize! + Buttonsize!) - 35;
    print('Kich cỡ màn hình: $Midsize');
    _getLocation();
    return Scaffold(
<<<<<<< HEAD
        body: Stack(
      children: [
        SizedBox(
          child: MapWidget(
            key: const ValueKey("mapWidget"),
            resourceOptions: ResourceOptions(
                accessToken:
                    "pk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHJsd2ZzdmcxMjJuMnFvajVidHJlY3Z1In0.eHLIejIOfAR9K_u2O5dd6g"),
            cameraOptions: CameraOptions(
                center:
                    Point(coordinates: Position(105.83991, 21.02800)).toJson(),
                zoom: 14.0),
            styleUri: Mapstyle,
            textureView: true,
            onMapCreated: _onMapCreated,
=======
      body: Center(
        child: Stack(children: [
          SizedBox(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions: ResourceOptions(
                  accessToken:
                      "sk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHF4dHFzYmEwZzhkMmpwemdzd2luNzA2In0.FpC6KZ2YvdcQ-pKOBmVwDQ"),
              cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(10.840130, 106.663147))
                      .toJson(),
                  zoom: 3.0),
              styleUri: MapboxStyles.LIGHT,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),
>>>>>>> e6ae5ff634c965942b7a4ae388fb4427c0fa786e
          ),
        ]),
      ),
    );
  }
}


// import 'dart:io';

// import 'package:location/location.dart';

// import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:stu_customer/screen/autocomplete.dart';
// import 'package:stu_customer/screen/marker.dart';
// import 'package:stu_customer/screen/safearea.dart';
// import 'package:stu_customer/screen/simplemap.dart';

// class FullMap extends StatefulWidget {
//   const FullMap();

//   @override
//   State createState() => FullMapState();
// }

// class FullMapState extends State<FullMap> {
//   MapboxMap? mapboxMap;
//   LocationData? _currentLocation;

//   _onMapCreated(MapboxMap mapboxMap) {
//     this.mapboxMap = mapboxMap;
//   }

//   @override
//   void initState() {
//     super.initState();
//   } 

//   // Future<Position> getPuckPosition() async {

//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Stack(children: [
//           SizedBox(
//             child: MapWidget(
//               key: const ValueKey("mapWidget"),
//               resourceOptions: ResourceOptions(
//                   accessToken:
//                       "pk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHE5NzJydjUxbTluMmtyd291NDl3cXE0In0.Nzy-T8d5OZlTVgOId3pyMg"),
//               cameraOptions: CameraOptions(
//                   center: Point(coordinates: Position(210.840130, 136.663147))
//                       .toJson(),
//                   zoom: 3.0),
//               styleUri: MapboxStyles.LIGHT,
//               textureView: true,
//               onMapCreated: _onMapCreated,
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
// }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    Buttonsize = (queryData.size.width / 2) - 35;
    Midsize = queryData.size.width - (Buttonsize! + Buttonsize!) - 35;
    print('Kich cỡ màn hình: $Midsize');
    _getLocation();
    return Scaffold(
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

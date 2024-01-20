// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:stu_customer/Map/animate_camera.dart';
import 'package:stu_customer/Map/annotation_order_maps.dart';
import 'package:stu_customer/Map/click_annotations.dart';
import 'package:stu_customer/Map/custom_marker.dart';
import 'package:stu_customer/Map/full_map.dart';
import 'package:stu_customer/Map/layer.dart';
import 'package:stu_customer/Map/line.dart';
import 'package:stu_customer/Map/local_style.dart';
import 'package:stu_customer/Map/map_ui.dart';
import 'package:stu_customer/Map/move_camera.dart';
import 'package:stu_customer/Map/offline_regions.dart';
import 'package:stu_customer/Map/page.dart';
import 'package:stu_customer/Map/place_batch.dart';
import 'package:stu_customer/Map/place_circle.dart';
import 'package:stu_customer/Map/place_fill.dart';
import 'package:stu_customer/Map/place_source.dart';
import 'package:stu_customer/Map/place_symbol.dart';
import 'package:stu_customer/Map/scrolling_map.dart';
import 'package:stu_customer/Map/sources.dart';
import 'package:stu_customer/Map/take_snapshot.dart';

final List<ExamplePage> _allPages = <ExamplePage>[
  MapUiPage(),
  FullMapPage(),
  AnimateCameraPage(),
  MoveCameraPage(),
  PlaceSymbolPage(),
  PlaceSourcePage(),
  LinePage(),
  LocalStylePage(),
  LayerPage(),
  PlaceCirclePage(),
  PlaceFillPage(),
  ScrollingMapPage(),
  OfflineRegionsPage(),
  AnnotationOrderPage(),
  CustomMarkerPage(),
  BatchAddPage(),
  TakeSnapPage(),
  ClickAnnotationPage(),
  Sources()
];

class MapsDemo extends StatefulWidget {
  // FIXME: You need to pass in your access token via the command line argument
  // --dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE
  // It is also possible to pass it in while running the app via an IDE by
  // passing the same args there.
  //
  // Alternatively you can replace `String.fromEnvironment("ACCESS_TOKEN")`
  // in the following line with your access token directly.
  static const String ACCESS_TOKEN = String.fromEnvironment(
      "pk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHE5NzJydjUxbTluMmtyd291NDl3cXE0In0.Nzy-T8d5OZlTVgOId3pyMg");

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  @override
  void initState() {
    super.initState();
  }

  /// Determine the android version of the phone and turn off HybridComposition
  /// on older sdk versions to improve performance for these
  ///
  /// !!! Hybrid composition is currently broken do no use !!!
  Future<void> initHybridComposition() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion != null && sdkVersion >= 29) {
        MapboxMap.useHybridComposition = true;
      } else {
        MapboxMap.useHybridComposition = false;
      }
    }
  }

  void _pushPage(BuildContext context, ExamplePage page) async {
    if (!kIsWeb) {
      final location = Location();
      final hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
      }
    }
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) => Scaffold(
              appBar: AppBar(title: Text(page.title)),
              body: page,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MapboxMaps examples')),
      body: MapsDemo.ACCESS_TOKEN.isEmpty ||
              MapsDemo.ACCESS_TOKEN.contains("YOUR_TOKEN")
          ? buildAccessTokenWarning()
          : ListView.separated(
              itemCount: _allPages.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (_, int index) => ListTile(
                leading: _allPages[index].leading,
                title: Text(_allPages[index].title),
                onTap: () => _pushPage(context, _allPages[index]),
              ),
            ),
    );
  }

  Widget buildAccessTokenWarning() {
    return Container(
      color: Colors.red[900],
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            "Please pass in your access token with",
            "--dart-define=ACCESS_TOKEN=ADD_YOUR_TOKEN_HERE",
            "passed into flutter run or add it to args in vscode's launch.json",
          ]
              .map((text) => Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                  ))
              .toList(),
        ),
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

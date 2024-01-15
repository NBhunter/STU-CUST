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
  State createState() => FullMapState();
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

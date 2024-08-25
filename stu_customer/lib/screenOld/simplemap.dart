import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  runApp(
      const MaterialApp(debugShowCheckedModeBanner: false, home: SimpleMap()));
}

class SimpleMap extends StatefulWidget {
  const SimpleMap({super.key});

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<SimpleMap> {
  MapboxMap? mapboxMap;

  _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Goong Map'),
        ),
        body: Stack(children: [
          SizedBox(
            child: MapWidget(
              key: const ValueKey("mapWidget"),
              resourceOptions: ResourceOptions(
                  accessToken:
                      "pk.eyJ1IjoiYmFuZ25ndXllbiIsImEiOiJjbHE5NzJydjUxbTluMmtyd291NDl3cXE0In0.Nzy-T8d5OZlTVgOId3pyMg"),
              cameraOptions: CameraOptions(
                  center: Point(coordinates: Position(121.8401244, 106.6631431))
                      .toJson(),
                  zoom: 3.0),
              styleUri: MapboxStyles.DARK,
              textureView: true,
              onMapCreated: _onMapCreated,
            ),
          ),
        ]));
  }
}

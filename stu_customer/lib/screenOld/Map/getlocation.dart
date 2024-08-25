import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class CustomerLocationController {
  final Location location = Location();

  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {}
      _locationSubscription?.cancel();
    }).listen((currentLocation) {});
  }
}

// ignore_for_file: unused_field, non_constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stu_customer/assistants/geofire_assistant.dart';
import 'package:stu_customer/global/API_Key.dart';
import 'package:stu_customer/global/global.dart';
import 'package:stu_customer/models/active_nearby_available_drivers.dart';

import '../../infoHandler/app_info.dart';
import '../../models/Trips_Info.dart';
import '../../assistants/assistant_methods.dart';

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

  bool isFindDriver = false;

  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  final Location location = Location();
  String? error;
  String? _error;
  late double userCurrentLongtitude;
  late double userCurrentLatitude;
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchLocationContainerHeight = 220;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? userCurrentPosition;
  // var geoLocator = Geolocator();

  double bottomPaddingOfMap = 0;

  List<PointLatLng> pLineCoOrdinatesList = [];
  Set<PolylinePoints> polyLineSet = {};

  // Set<M> markersSet = {};
  // Set<Circle> circlesSet = {};

  String userName = "your Name";
  String userEmail = "your Email";

  bool openNavigationDrawer = true;

  bool activeNearbyDriverKeysLoaded = false;
  // BitmapDescriptor? activeNearbyIcon;

  List<ActiveNearbyAvailableDrivers> onlineNearByAvailableDriversList = [];

  DatabaseReference? referenceRideRequest;
  String driverRideStatus = "Driver is Coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  String userRideRequestStatus = "";
  bool requestPositionInfo = true;
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
  ///Generate Code for Trips from time in devices
  String generateCode() {
    // Get current DateTime
    DateTime now = DateTime.now();

    // Format the DateTime to "yyyyMMddHHmmss"
    String formattedDate = DateFormat('yyMMddHHmmss').format(now);

    // Append the code Ride Type
    String RideType = "STUG";

    // Combine the formatted date and sequence
    String uniqueCode = RideType + formattedDate;

    return uniqueCode;
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  saveRideRequestInformation() {
    //1. save the RideRequest Information
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();

    var originLocation =
        Provider.of<AppInfo>(context, listen: false).userPickUpLocation;
    var destinationLocation =
        Provider.of<AppInfo>(context, listen: false).userDropOffLocation;

    Map originLocationMap = {
      //"key": value,
      "latitude": originLocation!.locationLatitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),
    };

    Map destinationLocationMap = {
      //"key": value,
      "latitude": destinationLocation!.locationLatitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userModelCurrentInfo!.name,
      "userPhone": userModelCurrentInfo!.phone,
      "originAddress": originLocation.locationName,
      "destinationAddress": destinationLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetails =
              (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        userRideRequestStatus =
            (eventSnap.snapshot.value as Map)["status"].toString();
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        PointLatLng driverCurrentPositionLatLng =
            PointLatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted
        // if (userRideRequestStatus == "accepted") {
        //   updateArrivalTimeToUserPickupLocation(driverCurrentPositionLatLng);
        // }

        //status = arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }

        //status = ontrip
        // if (userRideRequestStatus == "ontrip") {
        //   updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        // }

        //status = ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["fareAmount"].toString());

            // var response = await showDialog(
            //   context: context,
            //   barrierDismissible: false,
            //   builder: (BuildContext c) => PayFareAmountDialog(
            //     fareAmount: fareAmount,
            //   ),
            // );

            // if (response == "cashPayed") {
            //   //user can rate the driver now
            //   if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
            //     String assignedDriverId =
            //         (eventSnap.snapshot.value as Map)["driverId"].toString();

            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (c) => RateDriverScreen(
            //                   assignedDriverId: assignedDriverId,
            //                 )));

            //     referenceRideRequest!.onDisconnect();
            //     tripRideRequestInfoStreamSubscription!.cancel();
            //   }
            // }
          }
        }
      }
    });

    onlineNearByAvailableDriversList =
        GeoFireAssistant.activeNearbyAvailableDriversList;
    searchNearestOnlineDrivers();
  }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  searchNearestOnlineDrivers() async {
    //no active driver available
    if (onlineNearByAvailableDriversList.length == 0) {
      //cancel/delete the RideRequest Information
      referenceRideRequest!.remove();

      setState(() {
        polyLineSet.clear();
        // markersSet.clear();
        // circlesSet.clear();
        pLineCoOrdinatesList.clear();
      });

      Fluttertoast.showToast(
          msg:
              "No Online Nearest Driver Available. Search Again after some time, Restarting App Now.");

      Future.delayed(const Duration(milliseconds: 4000), () {
        SystemNavigator.pop();
      });

      return;
    }

    //active driver available
    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    // var response = await Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (c) => SelectNearestActiveDriversScreen(
    //             referenceRideRequest: referenceRideRequest)));
    String chosenDriverId = dList[0]["id"].toString();
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        //send notification to that specific driver
        sendNotificationToDriverNow(chosenDriverId);

        //Display Waiting Response UI from a Driver
        // showWaitingResponseFromDriverUI();

        //Response from a Driver
        FirebaseDatabase.instance
            .ref()
            .child("drivers")
            .child(chosenDriverId!)
            .child("newRideStatus")
            .onValue
            .listen((eventSnapshot) {
          //1. driver has cancel the rideRequest :: Push Notification
          // (newRideStatus = idle)
          if (eventSnapshot.snapshot.value == "idle") {
            Fluttertoast.showToast(
                msg:
                    "The driver has cancelled your request. Please choose another driver.");

            Future.delayed(const Duration(milliseconds: 3000), () {
              Fluttertoast.showToast(msg: "Please Restart App Now.");

              SystemNavigator.pop();
            });
          }

          //2. driver has accept the rideRequest :: Push Notification
          // (newRideStatus = accepted)
          if (eventSnapshot.snapshot.value == "accepted") {
            //design and display ui for displaying assigned driver information
            // showUIForAssignedDriverInfo();
          }
        });
      }
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");
    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        dList.add(driverKeyInfo);
      });
    }
  }

  sendNotificationToDriverNow(String chosenDriverId) {
    //assign/SET rideRequestId to newRideStatus in
    // Drivers Parent node for that specific choosen driver
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("newRideStatus")
        .set(referenceRideRequest!.key);

    //automate the push notification service
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(chosenDriverId)
        .child("token")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String deviceRegistrationToken = snap.snapshot.value.toString();

        //send Notification Now
        AssistantMethods.sendNotificationToDriverNow(
          deviceRegistrationToken,
          referenceRideRequest!.key.toString(),
          context,
        );

        Fluttertoast.showToast(msg: "Notification sent Successfully.");
      } else {
        Fluttertoast.showToast(msg: "Please choose another driver.");
        return;
      }
    });
  }
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*------------------------------------------------------------------------------------------------------------------*/
  /// CancelRoute
  /// Cancel require to the server
  CancelRoute() {
    isFindDriver = false;
    Geofire.removeLocation(TripsCode!);

    setState(() {});
  }

/*------------------------------------------------------------------------------------------------------------------*/
  /// CreatedNewRoute
  /// Send require find a ride to the server
  CreateNewRoute() {
    isFindDriver = true;

    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          print('Lỗi');
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((currentLocation) {
      _location = currentLocation;
    });
    Geofire.initialize("RideRequire");
    //
    TripsCode = generateCode();
    Geofire.setLocation(TripsCode!, latStartOrder!, lngStartOrder!);
    // Create Position
    Position StartPos = Position(lngStartOrder!, latStartOrder!);
    Position EndPos = Position(lngEndOrder!, latEndOrder!);

    // Get Decription
    String StartDecription =
        AssistantMethods.searchAddressForGeographicCordinates(
                StartPos, Position)
            .toString();
    String EndDecription =
        AssistantMethods.searchAddressForGeographicCordinates(EndPos, Position)
            .toString();
    //set up data send to the server
    TripsInfo Trip = new TripsInfo(
      distance: distance,
      idCustomer: currentFirebaseUser!.uid,
      idDriver: '',
      startDescription: StartDecription,
      startLat: latStartOrder!,
      startLng: lngStartOrder!,
      endDescription: EndDecription,
      endLat: latEndOrder!,
      endLng: lngEndOrder!,
      status: 'New',
      type: 'G',
      total: sPriceCust,
    );

    //Update the Trips to Server
    DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("TRIPS").child(TripsCode!);
    ref.set(Trip.toJson()); // Upload trip info to Firebase as JSON
    _locationSubscription?.resume();
    setState(() {});
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
              )),
              northeast: Point(
                  coordinates: Position(
                lngEndOrder!,
                latEndOrder!,
              )),
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
    setState(() {});
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
            const SizedBox(
              child: Text(' Map hiển thị ở đây nè ',
                  style: TextStyle(color: Colors.black87, fontSize: 30)),
              // MapWidget(
              //   key: ValueKey(mapBoxKey),
              //   cameraOptions: CameraOptions(
              //       center: Point(
              //           coordinates: Position(lngStartOrder!, latStartOrder!)),
              //       zoom: 15.0),
              //   styleUri: Mapstyle,
              //   textureView: true,
              //   onMapCreated: _onMapCreated,
              // ),
            ),
            isFindDriver == false
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 280,
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 15, right: 16),
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              const Text(' STU đưa bạn về ',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18)),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: duration,
                                    style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 18)),
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
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
                              ),
                              const Text(
                                'Khách hàng có nhu cầu đưa xe và người xin vui lòng thông báo với tài xế nhận cuốc',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13),
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
                                            CreateNewRoute();
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
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  )
                : Align(
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
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: ListView(
                            children: [
                              const Text('Đang tìm tài xế... ',
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 20)),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Đang tìm tài xế gần bạn nhấn',
                                    style: TextStyle(
                                        color: Colors.green[800],
                                        fontSize: 18)),
                              ])),
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
                                            CancelRoute();
                                            Fluttertoast.showToast(
                                                msg: "cancel click ");
                                          },
                                          color: Colors.blue,
                                          textColor: Colors.white,
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.person),
                                              Text('Huỷ tìm chuyến'),
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

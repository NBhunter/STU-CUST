import 'package:firebase_auth/firebase_auth.dart';
import 'package:stu_customer/models/user_model.dart';

final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //online-active drivers Information List
String? TripsCode;
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";

class Globals {
  static double? _lngStartOrder = 0;
  static double? _latStartOrder = 0;
  static double? _lngEndOrder = 0;
  static double? _latEndOrder = 0;

// Getter for lngStartOrder
  static double? get GetlngStartOrder => _lngStartOrder;

// Setter for lngStartOrder
  static set SetlngStartOrder(double? value) {
    _lngStartOrder = value;
  }

  static double? get GetlatStartOrder => _latStartOrder;

// Setter for latStartOrder
  static set SetlatStartOrder(double? value) {
    _latStartOrder = value;
  }

// Getter for lngEndOrder
  static double? get GetlngEndOrder => _lngEndOrder;

// Setter for lngEndOrder
  static set SetlngEndOrder(double? value) {
    _lngEndOrder = value;
  }

// Getter for latEndOrder
  static double? get GetlatEndOrder => _latEndOrder;

// Setter for latEndOrder
  static set SetlatEndOrder(double? value) {
    _latEndOrder = value;
  }
}

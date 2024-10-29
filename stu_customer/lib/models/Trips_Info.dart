import 'package:location/location.dart';

class TripsInfo {
  final String distance;
  final String endDescription;
  final double endLat; // Replaced endLocation
  final double endLng; // Replaced endLocation
  final String idCustomer;
  final String idDriver;
  final String startDescription;
  final double startLat; // Replaced startLocation
  final double startLng; // Replaced startLocation
  final String status;
  final String total;
  final String type;

  TripsInfo({
    required this.distance,
    required this.idCustomer,
    required this.idDriver,
    required this.startDescription,
    required this.startLat, // Changed from startLocation
    required this.startLng, // Changed from startLocation
    required this.endDescription,
    required this.endLat, // Changed from endLocation
    required this.endLng, // Changed from endLocation
    required this.status,
    required this.total,
    required this.type,
  });

  // Method to convert a Trip object to JSON
  Map<String, dynamic> toJson() {
    return {
      'Distance': distance,
      'ID_Customer': idCustomer,
      'ID_Driver': idDriver,
      'Start_Description': startDescription,
      'Start_Lat': startLat, // Modified to reflect lat and lng
      'Start_Lng': startLng, // Modified to reflect lat and lng
      'End_Description': endDescription,
      'End_Lat': endLat, // Modified to reflect lat and lng
      'End_Lng': endLng, // Modified to reflect lat and lng
      'Status': status,
      'Total': total,
      'Type': type,
    };
  }
}

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/admin/directory_v1.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:provider/provider.dart';
import 'package:stu_customer/infoHandler/app_info.dart';

class PushNotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {""};

    List<String> scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.storage",
      "https://www.googleapis.com/auth/firebase.config",
      "https://www.googleapis.com/auth/firebase.auth",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  static sendNotification(
      String deviceToken, String TripId, BuildContext context) async {
    String dropOffDestinationAddress =
        Provider.of<AppInfo>(context, listen: false)
            .userDropOffLocation!
            .locationName
            .toString();
    String pickUpAddress = Provider.of<AppInfo>(context, listen: false)
        .userPickUpLocation!
        .locationName
        .toString();
    final String serverKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/stu-driver-app-db/messages:send";

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'notification': {
          'title': 'New Trip By $UserName',
          'body':
              'Pickup Location: $pickUpAddress \n DropOff Location: $dropOffDestinationAddress'
        },
        'data': {'tripId': TripId, 'type': 'new_trip'}
      }
    };

    final http.Response response = await http.post(
        Uri.parse(endpointFirebaseCloudMessaging),
        headers: <String, String>{
          'Authorization': 'Bearer $serverKey',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(message));

    if (response.statusCode == 200) {
      print('Notification sent successfully');
      Fluttertoast.showToast(msg: 'Notification sent successfully');
    }
  }
}

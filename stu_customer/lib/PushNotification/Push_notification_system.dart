// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotificationSystem {
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   Future initializeCloudMessaging() async {
//     //1. Terminated
//     FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage remoteMessage){
//       if(remoteMessage!= null){
//         print("Received Background Message: ${remoteMessage.notification?.body}");
//       }
//     })
//     //2. Foreground

//     //3. Background
//   }
// }

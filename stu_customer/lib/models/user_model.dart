import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;

  UserModel({
    this.phone,
    this.name,
    this.id,
    this.email,
  });

  UserModel.fromSnapshot(DataSnapshot snap) {
    phone = (snap.value as dynamic)["phone"];
    name = (snap.value as dynamic)["name"];
    id = snap.key;
    email = (snap.value as dynamic)["email"];
  }

  void GetUserInfo(String Uid) async {
    // ignore: unnecessary_null_comparison
    if (Uid != null) {
      String uid = '/Users/${Uid}';
      DatabaseReference ref = FirebaseDatabase.instance.ref(uid);
      DatabaseEvent event = await ref.once();
      Map<dynamic, dynamic>? data =
          event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        Map<dynamic, dynamic> UserData = data;
        phone = UserData["phone"] ?? "";
        name = UserData["name"] ?? "";
        email = UserData["email"] ?? "";
        id = UserData["id"] ?? "";
      }
    } else {
      print('Error');
    }
  }
}

import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String text;

  GridItem(this.title, this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: InkWell(
        splashColor: Colors.blue.withAlpha(50),
        onTap: () {
          // if (this.text == 'logout') {
          //   _signOut();
          //   Navigator.pushNamed(context, "/login");
          // } else if (this.text == 'history') {
          //   Navigator.pushNamed(context, "/history");
          // }
        },
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: Colors.blue,
              ),
              Text(title),
            ]),
      ),
      // Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // children: <Widget>[
      //   Icon(
      //     icon,
      //     color: Colors.blue,
      //   ),
      //   if (text.isNotEmpty) SizedBox(height: 8),
      //   if (text.isNotEmpty) Text(text),
      //   Text(title),
      // ],
    );
  }

  // Future<void> _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  // }
}

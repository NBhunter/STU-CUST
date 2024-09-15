import 'package:flutter/material.dart';

class SelectOrder_ViewPage extends StatefulWidget {
  const SelectOrder_ViewPage({Key? key}) : super(key: key);

  @override
  SelectOrder_ViewState createState() => SelectOrder_ViewState();
}

// ignore: camel_case_types
class SelectOrder_ViewState extends State<SelectOrder_ViewPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        resizeToAvoidBottomInset: false, // set it to false
        body: Center(
          child: Text("SelectOrder"),
        ));
  }
}

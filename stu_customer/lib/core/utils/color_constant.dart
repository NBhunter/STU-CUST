import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray5001 = fromHex('#f8f9fa');

  static Color blueGray200 = fromHex('#bac1ce');

  static Color blueGray100 = fromHex('#d6dae2');

  static Color gray500 = fromHex('#959494');

  static Color blueGray400 = fromHex('#74839d');

  static Color blue700 = fromHex('#1976d2');

  static Color blueGray300 = fromHex('#9ea8ba');

  static Color blueA700 = fromHex('#0061ff');

  static Color redA200 = fromHex('#ff4b4b');

  static Color gray900 = fromHex('#2a2a2a');

  static Color gray90001 = fromHex('#1e1b14');

  static Color blueGray80001 = fromHex('#2f4254');

  static Color gray50 = fromHex('#f9fbff');

  static Color blue50 = fromHex('#e0ebff');

  static Color blueGray80002 = fromHex('#363853');

  static Color black90066 = fromHex('#66000000');

  static Color black900 = fromHex('#000000');

  static Color blueGray800 = fromHex('#37474f');

  static Color blueGray900 = fromHex('#262b35');

  static Color blueGray40001 = fromHex('#888888');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray70011 = fromHex('#11555555');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

import 'package:flutter/material.dart';

Color hexToColor(String code) {
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class ColorsConsts {
  static Color themeYellow = hexToColor("#f7ae11");

  static List<Color> iconColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellowAccent,
    Colors.pink,
  ];
}

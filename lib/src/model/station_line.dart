import 'package:flutter/material.dart';

class Stationline {
  final String name;
  final String code;

  final Color lineColor;

  @override
  bool operator ==(Object other) =>
      identical(other, this) || other is Stationline && name == other.name;

  @override
  int get hashCode => name.hashCode;

  Stationline({
    required this.name,
    required this.code,
    required this.lineColor,
  });

  factory Stationline.fromJson(Map<String, dynamic> json) {
    final String colorStr = json["Color"];
    final r = colorStr.substring(0, 3);
    final g = colorStr.substring(3, 6);
    final b = colorStr.substring(6);

    final lineColor =
        Color.fromRGBO(int.parse(r), int.parse(g), int.parse(b), 1);

    return Stationline(
      name: json["Name"],
      code: json["code"],
      lineColor: lineColor,
    );
  }
}

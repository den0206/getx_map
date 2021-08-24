import 'package:flutter/material.dart';

import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      "Name": name,
      "code": code,
      "lineColor": lineColor.toString().substring(6, 16),
    };
  }

  factory Stationline.fromMap(Map<String, dynamic> map) {
    final String colorStr = map["lineColor"];
    final color = Color(int.parse(colorStr));

    return Stationline(
      name: map["Name"],
      code: map["code"],
      lineColor: color,
    );
  }

  static String encode(List<Stationline> lines) {
    return json.encode(lines.map((line) => line.toMap()).toList());
  }

  static List<Stationline> decode(String lines) {
    return (json.decode(lines) as List<dynamic>)
        .map((item) => Stationline.fromMap(item))
        .toList();
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/model/station_line.dart';
import 'package:jp_prefecture/jp_prefecture.dart';

class Station implements StationBase {
  final String id;
  final String name;

  final LatLng latLng;
  final JpPrefecture prefecture;

  final RxList<Stationline> lines = RxList<Stationline>();

  String? distance;

  Station({
    required this.id,
    required this.name,
    required this.prefecture,
    required this.latLng,
    this.distance,
  });

  ///https://docs.ekispert.com/v1/
  factory Station.fromJson(Map<String, dynamic> json) {
    final double lati = double.parse(json["GeoPoint"]["lati_d"]);
    final double longi = double.parse(json["GeoPoint"]["longi_d"]);
    final latlng = LatLng(lati, longi);

    final prefStr = json['Prefecture']["Name"];

    return Station(
      id: json['Station']["code"],
      name: json['Station']["Name"],
      prefecture: JpPrefecture.findByName(prefStr) ?? errorPrefecture,
      latLng: latlng,
    );
  }

  ///https://express.heartrails.com/
  factory Station.fromHeartRails(Map<String, dynamic> json) {
    final double longi = json["x"];
    final double lati = json["y"];
    final latlng = LatLng(lati, longi);

    final prefStr = json['prefecture'];

    return Station(
        id: json['name'],
        name: json['name'],
        prefecture: JpPrefecture.findByName(prefStr) ?? errorPrefecture,
        latLng: latlng,
        distance: json["distance"]);
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    final double latitude = map["lati"];
    final double longtude = map["long"];
    final int prefCode = map["prefactureCode"];

    return Station(
        id: map['id'],
        name: map['name'],
        prefecture: JpPrefecture.findByCode(prefCode) ?? errorPrefecture,
        latLng: LatLng(latitude, longtude));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'prefactureCode': prefecture.code,
      'lati': latLng.latitude,
      'long': latLng.longitude,
    };
  }

  static String encode(List<Station> stations) {
    return json.encode(stations.map((station) => station.toMap()).toList());
  }

  static List<Station> decode(String stations) {
    return (json.decode(stations) as List<dynamic>)
        .map((item) => Station.fromMap(item))
        .toList();
  }

  /// save lines

  Map<String, dynamic> toLineMap() {
    return {"id": id, "lines": Stationline.encode(lines)};
  }

  static String encodeLine(List<Station> stations) {
    return json.encode(stations.map((station) => station.toLineMap()).toList());
  }

  factory Station.fromLineMap(Map<String, dynamic> map) {
    final sta = Station(
      id: map['id'],
      name: "line",
      prefecture: errorPrefecture,
      latLng: LatLng(0.0, 0.0),
    );

    sta.lines.addAll(Stationline.decode(map["lines"]));
    return sta;
  }

  static List<Station> decodeLine(String stations) {
    return (json.decode(stations) as List<dynamic>)
        .map((item) => Station.fromLineMap(item))
        .toList();
  }
}

final errorPrefecture =
    JpPrefecture(404, 'Error', 'Error', 'Erro', 'Error', 'Error');

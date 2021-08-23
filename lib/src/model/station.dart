import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/model/station_line.dart';

class Station implements StationBase {
  final String id;
  final String name;
  final String prefacture;
  final String prefactureCode;

  final LatLng latLng;

  final RxList<Stationline> lines = RxList<Stationline>();

  Station({
    required this.id,
    required this.name,
    required this.prefacture,
    required this.prefactureCode,
    required this.latLng,
  });

  ///https://docs.ekispert.com/v1/
  factory Station.fromJson(Map<String, dynamic> json) {
    final double lati = double.parse(json["GeoPoint"]["lati_d"]);
    final double longi = double.parse(json["GeoPoint"]["longi_d"]);
    final latlng = LatLng(lati, longi);

    return Station(
      id: json['Station']["code"],
      name: json['Station']["Name"],
      prefacture: json['Prefecture']["Name"],
      prefactureCode: json['Prefecture']["code"],
      latLng: latlng,
    );
  }

  ///https://express.heartrails.com/
  factory Station.fromHeartRails(Map<String, dynamic> json) {
    final double longi = json["x"];
    final double lati = json["y"];
    final latlng = LatLng(lati, longi);

    return Station(
      id: json['name'],
      name: json['name'],
      prefacture: json['prefecture'],
      prefactureCode: "",
      latLng: latlng,
    );
  }

  factory Station.fromMap(Map<String, dynamic> map) {
    final double latitude = map["lati"];
    final double longtude = map["long"];

    return Station(
        id: map['id'],
        name: map['name'],
        prefacture: map['prefacture'],
        prefactureCode: map['prefactureCode'],
        latLng: LatLng(latitude, longtude));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'prefacture': prefacture,
      'prefactureCode': prefactureCode,
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
}

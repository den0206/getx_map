import 'package:getx_map/src/model/station_line.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class Station {
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
}

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Station {
  final String id;
  final String name;
  final String prefacture;
  final String prefactureCode;

  final LatLng latLng;

  Station({
    required this.id,
    required this.name,
    required this.prefacture,
    required this.prefactureCode,
    required this.latLng,
  });

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
}

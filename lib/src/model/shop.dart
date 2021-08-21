import 'package:google_maps_flutter/google_maps_flutter.dart';

class Shop {
  final String id;
  final String access;
  final String address;
  final String charter;
  final String name;

  final LatLng latLng;
  final String photo;
  final String shopDetailMemo;
  final String stationName;
  final String urls;

  final Genre genre;

  Shop({
    required this.id,
    required this.access,
    required this.address,
    required this.charter,
    required this.name,
    required this.latLng,
    required this.photo,
    required this.shopDetailMemo,
    required this.stationName,
    required this.urls,
    required this.genre,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      access: json['access'],
      address: json['address'],
      charter: json['charter'],
      name: json['name'],
      latLng: LatLng(json['lat'], json['lng']),
      photo: json['photo']["mobile"]["l"],
      shopDetailMemo: json['shop_detail_memo'],
      stationName: json['station_name'],
      urls: json['urls']["pc"],
      genre: Genre.fromJson(json['genre']),
    );
  }
}

class Genre {
  final String code;
  final String name;

  Genre({required this.code, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      code: json['code'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['code'] = this.code;
    data['name'] = this.name;
    return data;
  }
}

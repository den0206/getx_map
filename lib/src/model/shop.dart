import 'dart:convert';

import 'package:getx_map/src/model/route_history.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:getx_map/src/service/database/storage_service.dart';

class Shop implements Identifiable {
  final String id;
  final String access;
  final String address;
  final String name;
  final LatLng latLng;
  final String photo;
  final String shopDetailMemo;
  final String stationName;
  final String urls;
  final String catchCopy;
  final String avarage;
  final int capacity;
  final String couponUrls;
  final String wifi;
  final String smoking;
  final String close;

  final Genre genre;

  bool get isFavorite {
    return StorageService.to.favoriteShop
        .map((favorite) => favorite.id)
        .toList()
        .contains(this.id);
  }

  Shop({
    required this.id,
    required this.access,
    required this.address,
    required this.name,
    required this.latLng,
    required this.photo,
    required this.shopDetailMemo,
    required this.stationName,
    required this.urls,
    required this.catchCopy,
    required this.avarage,
    required this.capacity,
    required this.couponUrls,
    required this.wifi,
    required this.smoking,
    required this.close,
    required this.genre,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    final double lat = json['lat'];
    final double lng = json['lng'];
    final LatLng latLng = LatLng(lat, lng);
    return Shop(
      id: json['id'],
      access: json['mobile_access'],
      address: json['address'],
      name: json['name'],
      latLng: latLng,
      photo: json['photo']["mobile"]["l"],
      shopDetailMemo: json['shop_detail_memo'],
      stationName: json['station_name'],
      urls: json['urls']["pc"],
      genre: Genre.fromJson(json['genre']),
      avarage: json["budget"]["name"],
      capacity: json["capacity"] ?? 0,
      catchCopy: json["catch"],
      couponUrls: json["coupon_urls"]["sp"],
      wifi: json["wifi"],
      smoking: json["non_smoking"],
      close: json["close"],
    );
  }

  factory Shop.fromMap(Map<String, dynamic> map) {
    final double lat = map['lat'];
    final double lng = map['lng'];
    final LatLng latLng = LatLng(lat, lng);
    return Shop(
      id: map['id'],
      access: map['access'],
      address: map['address'],
      name: map['name'],
      latLng: latLng,
      photo: map['photo'],
      shopDetailMemo: map['shopDetailMemo'],
      stationName: map['stationName'],
      urls: map['urls'],
      genre: Genre.fromJson(map['genre']),
      avarage: map['avarage'],
      capacity: map['capacity'] ?? 0,
      catchCopy: map['catchCopy'],
      couponUrls: map['couponUrls'],
      close: map['close'],
      smoking: map['smoking'],
      wifi: map['wifi'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'access': access,
      'address': address,
      'name': name,
      "lat": latLng.latitude,
      "lng": latLng.longitude,
      'photo': photo,
      'shopDetailMemo': shopDetailMemo,
      'stationName': stationName,
      'urls': urls,
      'genre': genre.toMap(),
      'avarage': avarage,
      'capacity': capacity,
      'catchCopy': catchCopy,
      'couponUrls': couponUrls,
      'close': close,
      'smoking': smoking,
      'wifi': wifi,
    };
  }

  static String encode(List<Shop> shops) {
    return json.encode(shops.map((shop) => shop.toMap()).toList());
  }

  static List<Shop> decode(String shops) {
    return (json.decode(shops) as List<dynamic>)
        .map((item) => Shop.fromMap(item))
        .toList();
  }
}

class Genre {
  final String code;
  final String name;
  final String copy;

  Genre({
    required this.code,
    required this.name,
    required this.copy,
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      code: json['code'],
      name: json['name'],
      copy: json['catch'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['code'] = this.code;
    data['name'] = this.name;
    data['catch'] = this.copy;
    return data;
  }
}

// https://webservice.recruit.co.jp/hotpepper/genre/v1/?key=
final allGenre = RestautantGenre.values;

enum RestautantGenre {
  recomended,
  izaka,
  cafe,
  bar,
  yakiniku,
  ramen,
  italian,
  europian,
  washoku,
  sousaku,
  china,
  ethnic,
  diningbar,
}

extension RestautantGenreEXT on RestautantGenre {
  String get title {
    switch (this) {
      case RestautantGenre.recomended:
        return "オススメ";
      case RestautantGenre.izaka:
        return "居酒屋";
      case RestautantGenre.cafe:
        return "カフェ";
      case RestautantGenre.bar:
        return "バー";
      case RestautantGenre.yakiniku:
        return "焼肉";
      case RestautantGenre.ramen:
        return "ラーメン";
      case RestautantGenre.italian:
        return "イタリアン";
      case RestautantGenre.europian:
        return "洋食";
      case RestautantGenre.washoku:
        return "和食";
      case RestautantGenre.sousaku:
        return "創作料理";
      case RestautantGenre.china:
        return "中華料理";
      case RestautantGenre.ethnic:
        return " エスニック";
      case RestautantGenre.diningbar:
        return "バル";
    }
  }

  String? get genreCode {
    switch (this) {
      case RestautantGenre.recomended:
        return null;
      case RestautantGenre.izaka:
        return "G001";
      case RestautantGenre.cafe:
        return "G014";
      case RestautantGenre.bar:
        return "G012";
      case RestautantGenre.yakiniku:
        return "G008";
      case RestautantGenre.ramen:
        return "G013";
      case RestautantGenre.italian:
        return "G006";
      case RestautantGenre.europian:
        return "G005";
      case RestautantGenre.washoku:
        return "G004";
      case RestautantGenre.sousaku:
        return "G003";
      case RestautantGenre.china:
        return "G007";
      case RestautantGenre.ethnic:
        return "G009";
      case RestautantGenre.diningbar:
        return "G002";
    }
  }
}

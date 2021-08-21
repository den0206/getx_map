import 'package:flutter_config/flutter_config.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopAPI {
  final key = FlutterConfig.get("PEPPER_KEY");
  final int perPage = 10;

  int currentIndex = 1;

  Future<List<Shop>> getShops(LatLng latLng) async {
    /// wait a little call api;
    if (currentIndex != 1) await Future.delayed(Duration(milliseconds: 500));

    List<Shop> temp = [];

    final queryParametes = {
      "key": key,
      "lat": latLng.latitude.toString(),
      "lng": latLng.longitude.toString(),
      "range": "5",
      "order": "4",
      "format": "json",
      "start": currentIndex.toString(),
      "count": perPage.toString(),
    };

    final uri = Uri.http(
      "webservice.recruit.co.jp",
      "hotpepper/gourmet/v1",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final List<dynamic> jsonData =
        json.decode(response.body)["results"]["shop"];

    if (jsonData.isNotEmpty)
      temp = jsonData.map((json) => Shop.fromJson(json)).toList();

    currentIndex += temp.length;

    return temp;
  }
}

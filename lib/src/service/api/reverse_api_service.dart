import 'package:flutter_config/flutter_config.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ReverseAPI {
  final apiKey = FlutterConfig.get('HERE_API_KEY');

  Future<Place?> getDetailPlace({required LatLng at}) async {
    final queryParameters = {
      'apiKey': apiKey,
      "at": "${at.latitude},${at.longitude}",
    };

    final uri = Uri.https(
      "revgeocode.search.hereapi.com",
      "/v1/revgeocode",
      queryParameters,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final List<dynamic> jsonData = json.decode(response.body)["items"];
    if (jsonData.isEmpty) {
      return null;
    }
    final element = jsonData.first;

    return Place.fromJson(element);
  }
}

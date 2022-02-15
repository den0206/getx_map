import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:getx_map/src/model/here_route.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class RouteAPI {
  final apiKey = dotenv.env["HERE_API_KEY"];

  Future<List<HereRoute>?> getRoutes({
    required LatLng origin,
    required LatLng destination,
  }) async {
    final queryParameters = {
      'apiKey': apiKey,
      "origin": "${origin.latitude},${origin.longitude}",
      "destination": "${destination.latitude},${destination.longitude}",
      "transportMode": "car",
      "alternatives": "3",
      "return": "polyline,summary,instructions,actions",
    };

    final uri = Uri.https("router.hereapi.com", "/v8/routes", queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }
    final List<dynamic> jsonData = json.decode(response.body)["routes"];
    final ref = jsonData.map((json) => HereRoute.fromJson(json)).toList();

    return ref;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class RouteAPI {
  final apiKey = FlutterConfig.get('HERE_API_KEY');

  Future<List<Route>?> getRoutes({
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
  }
}

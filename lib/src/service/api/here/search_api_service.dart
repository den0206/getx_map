import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:getx_map/src/model/place.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchAPI {
  final apiKey = dotenv.env["HERE_API_KEY"];
  final perPage = 5;

  Future<List<Place>> fetchApi({
    required String query,
    required Position at,
  }) async {
    List<Place> places = [];

    final queryParameters = {
      "apiKey": apiKey,
      "q": query,
      "at": "${at.latitude},${at.longitude}",
      "in": "countryCode:USA",
      "types": "place,street,city,locality,intersection",
      "limit": "$perPage"
    };

    final uri = Uri.https(
        "autosuggest.search.hereapi.com", "/v1/autosuggest", queryParameters);

    print(uri);

    final response = await http.get(uri);

    print(response.statusCode);

    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }
    final List<dynamic> jsonData = json.decode(response.body)["items"];

    places.addAll(jsonData.map((json) => Place.fromJson(json)).toList());

    return places;
  }
}

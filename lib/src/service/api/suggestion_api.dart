import 'package:flutter_config/flutter_config.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuggestionAPI {
  final stationKey = FlutterConfig.get("STATION_KEY");

  Future<List<Suggest>> getStationSuggestion(String q) async {
    List<Suggest> temp = [];

    final queryParametes = {
      "key": stationKey,
      "name": q,
      "type": "train",
    };

    final uri = Uri.https(
      "api.ekispert.jp",
      "v1/json/station/light",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final jsonData = json.decode(response.body)["ResultSet"]["Point"];

    if (jsonData == null) {
      return temp;
    }

    if (jsonData is List) {
      temp = jsonData.map((json) => Suggest.fromJson(json)).toList();
      return temp;
    } else {
      final one = Suggest.fromJson(jsonData as Map<String, dynamic>);

      return [one];
    }
  }
}

import 'package:flutter_config/flutter_config.dart';
import 'package:getx_map/src/model/station_line.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StaionAPI {
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

  Future<Station> getStationDetail(String id) async {
    final queryParametes = {
      "key": stationKey,
      "code": id,
    };

    final uri = Uri.https(
      "api.ekispert.jp",
      "v1/json/station",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final Map<String, dynamic> jsonData =
        json.decode(response.body)["ResultSet"]["Point"];

    print(jsonData);

    final temp = Station.fromJson(jsonData);
    return temp;
  }

  Future<List<Station>> getNearStations(LatLng latLng) async {
    List<Station> temp = [];
    final queryParametes = {
      "method": "getStations",
      "x": latLng.longitude.toString(),
      "y": latLng.latitude.toString(),
    };

    final uri = Uri.https(
      "express.heartrails.com",
      "api/json",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final List<dynamic> jsonData =
        json.decode(response.body)["response"]["station"];

    if (jsonData.isNotEmpty)
      temp = jsonData.map((json) => Station.fromHeartRails(json)).toList();

    return temp;
  }

  Future<List<Stationline>> getStationLines(Station station) async {
    List<Stationline> temp = [];

    final queryParametes = {
      "key": stationKey,
      "code": station.id,
      "type": "operationLine",
    };

    final uri = Uri.https(
      "api.ekispert.jp",
      "v1/json/station/info",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final jsonData =
        json.decode(response.body)["ResultSet"]["Information"]["Line"];

    if (jsonData is List) {
      temp = jsonData.map((json) => Stationline.fromJson(json)).toList();
      return temp;
    } else {
      final one = Stationline.fromJson(jsonData as Map<String, dynamic>);
      return [one];
    }
  }

  Future<Station> heartRailsToExcpertStation({
    required Station heartStation,
  }) async {
    final queryParametes = {
      "key": stationKey,
      "name": heartStation.name,
      "prefectureCode": heartStation.prefecture.code.toString(),
      "limit": "1",
    };

    final uri = Uri.https(
      "api.ekispert.jp",
      "v1/json/station",
      queryParametes,
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      final Exception error = Exception("StatusCode is ${response.statusCode}");
      throw error;
    }

    final Map<String, dynamic> jsonData =
        json.decode(response.body)["ResultSet"]["Point"];
    final temp = Station.fromJson(jsonData);

    temp.distance = heartStation.distance;
    print(temp.toString());
    return temp;
  }
}

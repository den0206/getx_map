import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/station_line.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/api/api_base.dart';

class EkipertApi extends APIBase {
  EkipertApi() : super(EndPoint.ekispert);

  Future<List<Suggest>?> getSuggesion(String q) async {
    try {
      List<Suggest> temp = [];

      final queryParametes = {
        "name": q,
        "type": "train",
      };

      final uri = setUri("v1/json/station/light", queryParametes);
      final res = await getRequest(uri: uri);
      final jsonData = res["ResultSet"]["Point"];
      if (jsonData == null) throw Exception("No Data");
      if (jsonData is List) {
        temp = jsonData.map((json) => Suggest.fromJson(json)).toList();
        return temp;
      } else {
        final one = Suggest.fromJson(jsonData as Map<String, dynamic>);

        return [one];
      }
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }

  Future<Station?> getStationDetail(String id) async {
    try {
      final queryParametes = {
        "code": id,
      };
      final uri = setUri("v1/json/station", queryParametes);
      final res = await getRequest(uri: uri);
      final Map<String, dynamic>? jsonData = res["ResultSet"]["Point"];
      if (jsonData == null) throw Exception("No Data");
      final temp = Station.fromJson(jsonData);
      return temp;
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }

  Future<List<Stationline>?> getStationLines(Station station) async {
    try {
      List<Stationline> temp = [];
      final queryParametes = {
        "code": station.id,
        "type": "operationLine",
      };

      final uri = setUri("v1/json/station/info", queryParametes);
      final res = await getRequest(uri: uri);
      final jsonData = res["ResultSet"]["Information"]["Line"];
      if (jsonData == null) throw Exception("No Data");
      if (jsonData is List) {
        temp = jsonData.map((json) => Stationline.fromJson(json)).toList();
        return temp;
      } else {
        final one = Stationline.fromJson(jsonData as Map<String, dynamic>);
        return [one];
      }
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }

  Future<Station?> heartRailsToExpert(Station heartStation) async {
    try {
      final queryParametes = {
        "name": heartStation.name,
        "prefectureCode": heartStation.prefecture.code.toString(),
        "limit": "1",
      };

      final uri = setUri("v1/json/station", queryParametes);
      final res = await getRequest(uri: uri);
      final Map<String, dynamic>? jsonData = res["ResultSet"]["Point"];
      if (jsonData == null) throw Exception("No Data");

      final temp = Station.fromJson(jsonData);
      temp.distanceFromCenter = heartStation.distanceFromCenter;
      return temp;
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }

  Future<String?> getRouteUrl({
    required Station from,
    required Station to,
  }) async {
    try {
      final queryParametes = {
        "from": from.id.toString(),
        "to": to.id.toString(),
        "contentsMode": "sp",
      };
      final uri = setUri("v1/json/search/course/light", queryParametes);
      final res = await getRequest(uri: uri);
      final String? jsonData = res["ResultSet"]["ResourceURI"];
      if (jsonData == null) throw Exception("No Data");

      return jsonData;
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }
}

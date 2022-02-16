import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/api/api_base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HeartRailsAPI extends APIBase {
  HeartRailsAPI() : super(EndPoint.heartrails);

  Future<List<Station>?> getNearStations(LatLng latLng) async {
    try {
      List<Station> temp = [];
      final queryParametes = {
        "method": "getStations",
        "x": latLng.longitude.toString(),
        "y": latLng.latitude.toString(),
      };

      final uri = setUri("api/json", queryParametes);
      final res = await getRequest(uri: uri);
      final List jsonData = res["response"]["station"];
      if (jsonData.isNotEmpty)
        temp = jsonData.map((json) => Station.fromHeartRails(json)).toList();

      return temp;
    } catch (e) {
      showError(e.toString());
      return null;
    }
  }
}

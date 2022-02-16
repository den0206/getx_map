import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/api/api_base.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PepperApi extends APIBase {
  PepperApi() : super(EndPoint.hotpepper);
  final int perPage = 10;

  Future<List<Shop>?> getShops(
      LatLng latLng, RestautantGenre genre, int currentIndex) async {
    try {
      List<Shop> temp = [];

      final queryParametes = {
        "lat": latLng.latitude.toString(),
        "lng": latLng.longitude.toString(),
        "range": "2",
        "order": "4",
        "format": "json",
        "start": currentIndex.toString(),
        "count": perPage.toString(),
      };

      if (genre.genreCode != null) queryParametes["genre"] = genre.genreCode!;
      print(queryParametes);
      final uri = setUri("hotpepper/gourmet/v1", queryParametes);
      final res = await getRequest(uri: uri);
      final List jsonData = res["results"]["shop"];

      if (jsonData.isNotEmpty)
        temp = jsonData.map((json) => Shop.fromJson(json)).toList();

      return temp;
    } catch (e) {
      print(e);
      showError(e.toString());
      return null;
    }
  }
}

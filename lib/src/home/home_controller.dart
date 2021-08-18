import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/get_station/get_station_screen.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<Station> stations = RxList<Station>();

  Future<void> pushGetScreen() async {
    final station = await Get.toNamed(GetStationScreen.routeName);

    if (station is Station) {
      stations.add(station);
      print(stations.iterator);
    }
  }

  void removeStation(Station? station) {
    if (station != null) stations.remove(station);
  }
}

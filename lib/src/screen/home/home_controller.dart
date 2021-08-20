import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/utils/sample_staion.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxList<Station> stations = RxList<Station>();
  final stationAPI = StaionAPI();

  @override
  void onInit() {
    super.onInit();

    /// add sample
    stations.addAll(sampleStaion);
  }

  Future<void> pushGetScreen(Station? station) async {
    if (station == null) {
      final station = await Get.toNamed(GetStationScreen.routeName);

      if (station is Station) {
        addStation(station);
      }
    } else {
      final int selectedIndex = stations.indexOf(station);
      Get.toNamed(GetStationScreen.routeName, arguments: selectedIndex);
    }
  }

  void pushMapScreen() {
    final value = stations.map((station) => station).toList();

    Get.toNamed(
      MapScreen.routeName,
      arguments: value,
    );
  }

  Future<void> getStationInfo(Station station) async {
    final lines = await stationAPI.getStationLines(station);
    station.lines.addAll(lines);
  }

  void addStation(Station station) {
    if (!stations.map((station) => station.id).contains(station.id))
      stations.add(station);
  }

  void removeStation(Station? station) {
    if (station != null) stations.remove(station);
  }
}

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/station_line.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database_service.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxList<Station?> stations = RxList<Station?>();

  RxList<Station> get completeStations {
    final a = stations.whereType<Station>().toList();
    return a.obs;
  }

  final database = DatabaseService.to;
  final stationAPI = StaionAPI();
  final List<Station> cachedLines = [];

  @override
  void onInit() {
    super.onInit();

    loadDatabse();
  }

  void loadDatabse() {
    final def = database.loadStations(DatabaseKey.home);

    stations.addAll(def);

    final lines = database.loadStations(DatabaseKey.lines);

    cachedLines.addAll(lines);
  }

  Future<void> pushGetScreen(Station? station, int index) async {
    if (station == null) {
      final station = await Get.toNamed(GetStationScreen.routeName);

      if (station is Station) {
        if (!stations.map((station) => station?.id).contains(station.id))
          stations[index] = station;
      }
    } else {
      // final int selectedIndex = stations.indexOf(station);
      Get.toNamed(GetStationScreen.routeName, arguments: index);
    }

    /// save local
    database.setStationList(
      DatabaseKey.home,
      HomeController.to.completeStations,
    );
  }

  void pushMapScreen() {
    if (completeStations.length < 2) {
      return;
    }

    final value = completeStations.map((station) => station).toList();

    Get.toNamed(
      MapScreen.routeName,
      arguments: value,
    );
  }

  Future<void> getStationInfo(Station station) async {
    List<Stationline> lines;
    if (!cachedLines.map((station) => station.id).contains(station.id)) {
      lines = await stationAPI.getStationLines(station);
      station.lines.addAll(lines);
      cachedLines.add(station);
      database.setStationList(DatabaseKey.lines, cachedLines);
    } else {
      print("Exist");
      final temp =
          cachedLines.map((station) => station.id).toList().indexOf(station.id);
      lines = cachedLines[temp].lines;
      station.lines.addAll(lines);
    }
  }

  void removeStation({Station? station, int? index}) {
    if (station != null) stations.remove(station);
    if (index != null) stations.removeAt(index);

    database.setStationList(DatabaseKey.home, completeStations);
  }
}

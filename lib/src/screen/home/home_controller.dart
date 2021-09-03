import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/station_line.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:getx_map/src/service/network_service.dart';

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
    final lines = database.loadStations(DatabaseKey.lines);
    cachedLines.addAll(lines);

    final def = database.loadStations(DatabaseKey.home);
    def.forEach((station) {
      station.lines.addAll(checkedCache(station));
    });
    if (def.isNotEmpty) {
      stations.addAll(def);
    } else {
      stations.add(null);
    }
  }

  Future<void> pushGetScreen(Station? station, int index) async {
    final newStation =
        await Get.toNamed(GetStationScreen.routeName, arguments: station);

    if (newStation is Station) {
      if (!completeStations
          .map((station) => station.id)
          .contains(newStation.id)) {
        newStation.lines.addAll(checkedCache(newStation));
        stations[index] = newStation;
        database.setStationList(
          DatabaseKey.home,
          HomeController.to.completeStations,
        );
      }
    }

    /// save local
  }

  void pushMapScreen() async {
    if (completeStations.length < 2) {
      return;
    }

    final res = await NetworkService.to.checkNetwork();

    if (!res) {
      return;
    }

    final value = completeStations.map((station) => station).toList();

    Get.toNamed(
      MapScreen.routeName,
      arguments: value,
    );
  }

  Future<void> getStationInfo(Station station) async {
    if (!cachedLines.map((station) => station.id).contains(station.id)) {
      final lines = await stationAPI.getStationLines(station);
      station.lines.addAll(lines);
      cachedLines.add(station);
      database.setStationList(DatabaseKey.lines, cachedLines);
    }
  }

  List<Stationline> checkedCache(Station station) {
    List<Stationline> lines;

    if (cachedLines.map((ex) => ex.id).contains(station.id)) {
      final temp =
          cachedLines.map((station) => station.id).toList().indexOf(station.id);
      lines = cachedLines[temp].lines;
      return lines;
    } else {
      return [];
    }
  }

  void removeStation({Station? station, int? index}) {
    if (station != null) stations.remove(station);
    if (index != null) stations.removeAt(index);

    database.setStationList(DatabaseKey.home, completeStations);
  }
}

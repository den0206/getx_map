import 'dart:async';

import 'package:get/get.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/suggestion.dart';

import 'search_station_abstract/search_abstract.dart';

//Reuse Map screen

class GetStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStationController());
  }
}

class GetStationController extends GetxSearchController {
  final Station? selectedStation = Get.arguments ?? null;

  @override
  void onInit() {
    super.onInit();

    loadDatabse();
    _setSelectedIndex();

    focusNode.requestFocus();
  }

  void _setSelectedIndex() {
    if (selectedStation != null) {
      tX.text = selectedStation!.name;
    }
  }

  Future selectSuggest(StationBase base) async {
    late Station station;
    if (base is Suggest) {
      station = await ekispertAPI.getStationDetail(base.id);
    } else if (base is Station) {
      station = base;
    }
    saveDatabase(station);

    Get.back(result: station);
  }
}

    // if (selectedIndex == null) {
    //   Get.back(result: station);
    // } else {
    //   final home = Get.find<HomeController>();
    //   if (!home.completeStations.map((ex) => ex.id).contains(station.id))
    //     home.stations[selectedIndex!] = station;
    //   Get.back(result: station);
    // }
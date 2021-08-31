import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database_service.dart';

class GetStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStationController());
  }
}

class GetStationController extends GetxController {
  RxList<Suggest> suggestions = RxList<Suggest>();

  RxList<Station> predicts = RxList<Station>();

  final TextEditingController tX = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final Station? selectedStation = Get.arguments ?? null;

  final database = DatabaseService.to;
  final stationAPI = StaionAPI();

  String _searchText = "";
  Timer? _searchTimer;

  bool get noSuggest {
    return suggestions.isEmpty;
  }

  @override
  void onInit() {
    super.onInit();

    _loadDatabse();
    _setSelectedIndex();

    focusNode.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
  }

  void _setSelectedIndex() {
    if (selectedStation != null) {
      tX.text = selectedStation!.name;
    }
  }

  void queryChanged(String text) {
    suggestions.clear();

    _searchText = text;
    _searchTimer?.cancel();

    try {
      if (_searchText.length >= 2)
        _searchTimer = Timer(Duration(seconds: 1), () async {
          final temp = await stationAPI.getStationSuggestion(_searchText);
          suggestions.addAll(temp);
        });
    } catch (e) {
      print(e.toString());
    }
  }

  Future selectSuggest(StationBase base) async {
    late Station station;
    if (base is Suggest) {
      station = await stationAPI.getStationDetail(base.id);
    } else if (base is Station) {
      station = base;
    }
    _saveDatabase(station);

    Get.back(result: station);
  }

  void _loadDatabse() {
    final def = database.loadStations(DatabaseKey.search);
    predicts.addAll(def);
  }

  void _saveDatabase(Station station) {
    if (!predicts.contains(station)) {
      predicts.add(station);
      database.setStationList(DatabaseKey.search, predicts);
    }
  }

  void deleteDatabase(StationBase base) {
    if (base is Station) {
      predicts.remove(base);
      database.setStationList(DatabaseKey.search, predicts);
    }
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
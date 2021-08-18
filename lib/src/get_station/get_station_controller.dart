import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';

class GetStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStationController());
  }
}

class GetStationController extends GetxController {
  RxList<Suggest> suggestions = RxList<Suggest>();
  final TextEditingController tX = TextEditingController();

  final stationAPI = StaionAPI();

  String _searchText = "";
  Timer? _searchTimer;

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
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

  Future selectSuggest(Suggest suggest) async {
    final station = await stationAPI.getStationDetail(suggest.id);

    Get.back(result: station);
  }
}

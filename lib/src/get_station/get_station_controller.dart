import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/service/api/suggestion_api.dart';

class GetStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStationController());
  }
}

class GetStationController extends GetxController {
  RxList<Suggest> suggestions = RxList<Suggest>();
  final TextEditingController tX = TextEditingController();
  final apiSearvice = SuggestionAPI();

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
          final temp = await apiSearvice.getStationSuggestion(_searchText);
          suggestions.addAll(temp);
        });
    } catch (e) {
      print(e.toString());
    }
  }

  void selectSuggest(Suggest suggest) {
    print(suggest.id);
  }
}

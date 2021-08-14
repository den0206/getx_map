import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:getx_map/src/service/api/search_api_service.dart';

class OriginAndDestinationResponse {
  final Place origin, destination;
  OriginAndDestinationResponse(this.origin, this.destination);
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchController());
  }
}

class SearchController extends GetxController {
  final Position? currentPosition = MapController.to.currentPosition;

  final SearchAPI api = SearchAPI();
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationCOntroller = TextEditingController();

  Rxn<Place> orgin = Rxn<Place>();
  Rxn<Place> destination = Rxn<Place>();

  String _searchText = "";
  Timer? _searchTimer;

  RxList<Place> queryPlaces = RxList<Place>();

  bool get settedOrigin {
    return orgin.value != null;
  }

  bool get canSubmit {
    return orgin.value != null && destination.value != null;
  }

  @override
  void onInit() {
    super.onInit();

    print(MapController.to.currentPosition);
  }

  @override
  void onClose() {
    super.onClose();
    _searchTimer?.cancel();
  }

  void queryChanged(String text) {
    queryPlaces.clear();

    _searchText = text;
    _searchTimer?.cancel();
    try {
      _searchTimer = Timer(
        Duration(milliseconds: 500),
        () async {
          if (_searchText.length >= 3) {
            if (currentPosition != null) {
              final temp =
                  await api.fetchApi(query: _searchText, at: currentPosition!);

              queryPlaces.addAll(temp);
            }
          } else {}
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void pickPlace(Place place) {
    if (!settedOrigin) {
      orgin.value = place;
      originController.text = place.title;
    } else {
      destination.value = place;
      destinationCOntroller.text = place.title;
    }
  }

  void saveAction() {
    if (canSubmit) {
      final OriginAndDestinationResponse value =
          OriginAndDestinationResponse(orgin.value!, destination.value!);

      Get.back(result: value);
    }
  }
}

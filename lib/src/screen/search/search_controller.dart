import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SearchController());
  }
}

class SearchController extends GetxController {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationCOntroller = TextEditingController();

  Place? orgin, destination;

  RxList<Place> queryPlaces = RxList<Place>();

  bool get settedOrigin {
    return orgin != null;
  }

  @override
  void onInit() {
    super.onInit();

    print(MapController.to.currentPosition);

    // queryPlaces.bindStream(stream)
  }
}

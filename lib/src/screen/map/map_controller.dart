import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';
import 'package:getx_map/src/service/api/route_api_service.dart';
import 'package:getx_map/src/service/map_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final MapService service = MapService();

  static MapController get to => Get.find();

  Position? currentPosition;

  double zoom = 15;
  late BitmapDescriptor _homeIcon;

  void onMapCreated(GoogleMapController controller) async {
    service.init(controller);
    await checkPermission();
    await setPosition();
  }

  @override
  void onInit() async {
    super.onInit();
    _homeIcon = await service.generateIcon("assets/images/car-pin.png");
  }

  Future<void> checkPermission() async {
    final gpsEnable = await Geolocator.isLocationServiceEnabled();

    if (!gpsEnable) {
      await Geolocator.openLocationSettings();
      return;
    }
    zoom = await service.controller.getZoomLevel();
    print("CAN");
  }

  Future<void> setPosition() async {
    currentPosition = await service.getCurrentPostion();

    await service.updateCamera(currentPosition!, zoom);
  }

  Future<void> zoomUp() async {
    await service.setZoom(true);
  }

  Future<void> zoomDown() async {
    await service.setZoom(false);
  }

  Future<void> toSearch() async {
    final result = await Get.toNamed(SearchScreen.routeName);
    final routeAPI = RouteAPI();

    if (result is OriginAndDestinationResponse) {
      final origin = result.origin;
      final destination = result.destination;

      final routes = await routeAPI.getRoutes(
          origin: origin.position, destination: destination.position);

      if (routes != null) {
        service.presentRout(origin, destination, routes.first.points);

        update();
      }
    }
  }
}


  // void onTap(LatLng position) async {
  //   // service.addMarker(position, icon: _homeIcon);
  //   // _addPolyLine(position);
  //   // await _addMarker(position);
  //   update();
  // }
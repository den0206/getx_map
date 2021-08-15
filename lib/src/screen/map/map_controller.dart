import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:getx_map/src/model/place.dart';
import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';
import 'package:getx_map/src/service/api/reverse_api_service.dart';
import 'package:getx_map/src/service/api/route_api_service.dart';
import 'package:getx_map/src/service/map_service.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  final MapService service = MapService();

  static MapController get to => Get.find();

  Position? currentPosition;

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
    // final permission = await checkPermission();

    if (!gpsEnable) {
      await Geolocator.openLocationSettings();
      return;
    }

    print("CAN");
  }

  Future<bool> hasPermission() async {
    final status = await Geolocator.checkPermission();
    print(status);
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }

  Future<void> setPosition() async {
    currentPosition = await service.getCurrentPostion();

    if (currentPosition != null) {
      final Place? currentPlace = await ReverseAPI().getDetailPlace(
          at: LatLng(currentPosition!.latitude, currentPosition!.longitude));

      print(currentPlace?.address);
    }
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
        /// centrer

        await service.presentRout(origin, destination, routes.first.points);
        final center = await service.getCenter();

        service.addCenterMarker(center);
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
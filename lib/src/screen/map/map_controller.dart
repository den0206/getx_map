import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/map_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapController());
  }
}

class MapController extends GetxController {
  final List<Station> stations = Get.arguments;
  final List<Station> nearStations = [];
  final service = MapService();
  final stationAPI = StaionAPI();

  late LatLng centerLatLng;

  @override
  void onInit() {
    super.onInit();
  }

  Future onMapCreate(GoogleMapController controller) async {
    service.init(controller);
    await addStationMarkers();
    await Future.delayed(Duration(seconds: 1));
    await setCenterCircle();

    await getNearStations();
    print(service.markers.map((e) => e.markerId));
  }

  Future addStationMarkers() async {
    stations.forEach((station) {
      service.addStationMarker(station);
    });
    await service.fitMarkerBounds();

    update();
  }

  Future setCenterCircle() async {
    final center = await service.getCenter();
    centerLatLng = center;

    service.addCenterMarker(center);
    // update();
  }

  Future<void> onMapLongPress(LatLng latLng) async {
    print(latLng);

    /// clear markers
    await Future.forEach(nearStations,
        (Station station) async => service.removeStationMarker(station));
    // nearStations.forEach((station) => service.removeStationMarker(station));
    nearStations.clear();

    update();

    centerLatLng = latLng;
    service.addCenterMarker(centerLatLng);
    await getNearStations();
    update();
  }

  Future<void> getNearStations() async {
    final temp = await stationAPI.getNearStations(centerLatLng);

    nearStations.addAll(temp);
    nearStations.forEach((station) {
      service.addStationMarker(
        station,
        onTap: () => pushShopScreen(
          station.latLng,
        ),
      );
    });
    update();
  }

  void pushShopScreen(LatLng latLng) {
    final value = latLng;

    Get.toNamed(ShopsScreen.routeName, arguments: value);
  }

  void zoomStation(Station station) {
    service.updateCamera(station.latLng, setZoom: 15);
  }

  Future<void> zoomUp() async {
    await service.setZoom(true);
  }

  Future<void> zoomDown() async {
    await service.setZoom(false);
  }
}

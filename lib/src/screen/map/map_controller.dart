import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/station.dart';
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
  final service = MapService();

  @override
  void onInit() {
    super.onInit();
  }

  Future onMapCreate(GoogleMapController controller) async {
    service.init(controller);
    await addStationMarkers();
  }

  Future addStationMarkers() async {
    stations.forEach((station) {
      service.addStationMarker(station);
    });
    await service.fitMarkerBounds();

    update();

    await Future.delayed(Duration(seconds: 1));
    await setCenterCircle();
  }

  Future setCenterCircle() async {
    final center = await service.getCenter();

    service.addCenterMarker(center);
    update();
  }

  Future<void> zoomUp() async {
    await service.setZoom(true);
  }

  Future<void> zoomDown() async {
    await service.setZoom(false);
  }
}

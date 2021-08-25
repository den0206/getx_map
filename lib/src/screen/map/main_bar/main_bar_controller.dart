import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';

enum MenuBarState {
  root,
  showMenu,
}

class MainBarController extends GetxController {
  final MapController mapController;

  final RxInt currentIndex = 0.obs;
  final Rx<MenuBarState> currentState = MenuBarState.root.obs;

  RxList<Station> get nearStations {
    return mapController.nearStations.obs;
  }

  Station get currentNearStation {
    return nearStations[currentIndex.value];
  }

  MainBarController(this.mapController);

  @override
  void onInit() {
    super.onInit();

    mapController.setMainBar(this);
  }

  void selectStation(Station station) {
    final index = nearStations.indexOf(station);

    currentIndex.value = index;
    mapController.zoomStation(station);
  }

  void pushShopScreen() {
    final value = currentNearStation.latLng;
    Get.toNamed(ShopsScreen.routeName, arguments: value);
  }

  void backtate() {
    currentState.value = MenuBarState.root;
    mapController.mapService.fitMarkerBounds();
  }
}

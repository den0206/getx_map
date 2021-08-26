import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';

enum MenuBarState {
  root,
  showMenu,
}

class MainBarController extends GetxController {
  final MapController mapController;

  final stationAPI = StaionAPI();
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
    ///IDがのちの変わる為,名前で判別
    final index =
        nearStations.map((ex) => ex.name).toList().indexOf(station.name);
    print(index);

    if (index == currentIndex.value) {
      currentState.value = MenuBarState.showMenu;
      return;
    }

    currentIndex.value = index;
    mapController.zoomStation(station);
  }

  void pushShopScreen() {
    final value = currentNearStation;
    Get.toNamed(ShopsScreen.routeName, arguments: value);
  }

  void searchRoute() async {
    if (!currentNearStation.isExpertType) {
      /// タイプを合わせる
      final Station newStation = await stationAPI.heartRailsToExcpertStation(
          heartStation: currentNearStation);
      mapController.editNearStation(newStation);
    }
  }

  void backRoot() {
    currentState.value = MenuBarState.root;
    mapController.mapService.fitMarkerBounds();
  }
}

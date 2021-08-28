import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuBarState {
  root,
  showMenu,
  route,
}

class MainBarController extends GetxController {
  final MapController mapController;

  final Map<Station, List<String>> routes = {};

  final stationAPI = StaionAPI();

  ///To Do RXn
  final RxnInt currentIndex = RxnInt(0);
  final Rx<MenuBarState> currentState = MenuBarState.root.obs;

  RxList<Station> get nearStations {
    return mapController.nearStations.obs;
  }

  Station get currentNearStation {
    if (currentIndex.value == null) {
      return nearStations[0];
    }
    return nearStations[currentIndex.value!];
  }

  MainBarController(this.mapController);

  @override
  void onInit() {
    super.onInit();

    mapController.setMainBar(this);
  }

  void reset() {
    currentState.value = MenuBarState.root;
    currentIndex.value = null;
  }

  void selectStation(Station station) {
    ///IDが後に変わる為,名前で判別
    final index =
        nearStations.map((ex) => ex.name).toList().indexOf(station.name);

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

  void openUrl(int index) async {
    final url = routes[currentNearStation]?[index];
    if (url == null) {
      throw 'URLが見つかりません';
    }
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  void searchRoute() async {
    final stations = mapController.stations;
    mapController.overlayLoading.value = true;

    try {
      List<String> urls = [];
      if (!currentNearStation.isExpertType) {
        final oldStation = currentNearStation;

        /// タイプを合わせる
        final Station newStation = await stationAPI.heartRailsToExcpertStation(
            heartStation: currentNearStation);
        mapController.editNearStation(newStation, oldStation);

        await Future.delayed(Duration(milliseconds: 500));
      }

      if (routes.containsKey(currentNearStation)) {
        currentState.value = MenuBarState.route;
        return;
      }

      await Future.forEach(
        stations,
        (Station station) async {
          await Future.delayed(Duration(seconds: 2));
          print("delay");
          final url = await stationAPI.getRouteUrl(
              from: station, to: currentNearStation);
          urls.add(url);
        },
      );

      routes[currentNearStation] = urls;
      currentState.value = MenuBarState.route;
    } catch (e) {
      print(e);
    } finally {
      mapController.overlayLoading.value = false;
    }
  }

  void backRoot() {
    currentState.value = MenuBarState.root;
    mapController.mapService.fitMarkerBounds();
  }
}

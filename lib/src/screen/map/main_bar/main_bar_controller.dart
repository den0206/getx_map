import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuBarState {
  root,
  showMenu,
  route,
  favoriteShop,
}

class MainBarController extends GetxController {
  final MapController mapController;

  final Map<Station, List<String>> routes = {};

  final stationAPI = StaionAPI();

  final RxnInt currentIndex = RxnInt(0);
  final Rx<MenuBarState> currentState = MenuBarState.root.obs;
  final List<Shop> favorites = FavoriteShopService.to.favoriteShop;

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

    final index = nearStations.indexWhere((near) => near.name == station.name);

    if (index == currentIndex.value) {
      currentState.value = MenuBarState.showMenu;
      return;
    }

    currentIndex.value = index;
    mapController.zoomStation(station);
  }

  void selectFavorite() {
    currentState.value = MenuBarState.favoriteShop;
  }

  void selectFavoriteShop(Shop shop) {
    final index = favorites.indexWhere((favorite) => favorite.id == shop.id);
    currentIndex.value = index;

    currentState.value = MenuBarState.favoriteShop;
    mapController.zoomShop(shop);
  }

  void pushShopScreen() async {
    final value = currentNearStation;
    final _ = await Get.toNamed(ShopsScreen.routeName, arguments: value);

    mapController.addShopMarkers();
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

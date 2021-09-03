import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/route_history.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/shop_detail/shop_datail_screen.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/open_url_servoice.dart';
import 'package:getx_map/src/service/scraper_service.dart';
import 'package:getx_map/src/utils/common_icon.dart';

enum MenuBarState {
  root,
  showMenu,
  route,
  favoriteShop,
  distance,
  search,
}

class MainBarController extends GetxController {
  final MapController mapController;

  final Map<Station, List<String>> routes = {};
  final Map<Station, List<String>> requireTimes = {};

  final stationAPI = StaionAPI();

  final RxnInt currentIndex = RxnInt(0);
  final Rx<MenuBarState> currentState = MenuBarState.root.obs;
  final List<Shop> favorites = StorageService.to.favoriteShop;

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
    currentIndex.value = null;
    currentState.value = MenuBarState.favoriteShop;
  }

  void selectFavoriteShop(Shop shop) async {
    final index = favorites.indexWhere((favorite) => favorite.id == shop.id);

    if (index == currentIndex.value) {
      final _ = await Get.toNamed(ShopDetailScreen.routeName, arguments: shop);
      mapController.addShopMarkers();
      return;
    }
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

    final openURL = OepnUrlService(url);
    await openURL.showUrlDialog(
      beforeLaunchUrl: () {
        _saveHistory(index, url);
      },
    );
  }

  void _saveHistory(int index, String url) {
    final from = mapController.stations[index];
    final to = currentNearStation;
    final routeUrl = url;
    final route = RouteHistory(from: from, to: to, url: routeUrl);
    StorageService.to.addAndRemoveHistory(route);
  }

  void confirmRoute() {
    if (routes.containsKey(currentNearStation)) {
      currentState.value = MenuBarState.route;
      return;
    }
    Get.dialog(CustomDialog(
      title: "経路確認",
      descripon: "確認しても宜しいでしょうか？",
      icon: CommonIcon.stationIcon,
      mainColor: Colors.blue[400]!,
      onSuceed: () async {
        await searchRoute();
      },
    ));
  }

  Future<void> searchRoute() async {
    final stations = mapController.stations;
    mapController.overlayLoading.value = true;

    try {
      if (!currentNearStation.isExpertType) {
        final oldStation = currentNearStation;

        /// タイプを合わせる
        final Station newStation = await stationAPI.heartRailsToExcpertStation(
            heartStation: currentNearStation);
        mapController.editNearStation(newStation, oldStation);

        await Future.delayed(Duration(milliseconds: 500));
      }

      /// show Ad(every time)
      await mapController.showInterstitialAd(useFrequency: false);

      /// urls
      routes[currentNearStation] = await getRouterUrls(stations);

      /// Require times
      requireTimes[currentNearStation] =
          await getRequireTimesViaUrls(routes[currentNearStation] ?? []);

      currentState.value = MenuBarState.route;
    } catch (e) {
      print(e);
    } finally {
      mapController.overlayLoading.value = false;
    }
  }

  Future<List<String>> getRouterUrls(List<Station> stations) async {
    List<String> urls = [];
    await Future.forEach(
      stations,
      (Station station) async {
        await Future.delayed(Duration(seconds: 2));
        print("delay");
        final url =
            await stationAPI.getRouteUrl(from: station, to: currentNearStation);

        urls.add(url);
      },
    );

    return urls;
  }

  Future<List<String>> getRequireTimesViaUrls(List<String> urls) async {
    final scraper = ScraperService();
    List<String> times = [];
    await Future.forEach(
      urls,
      (String url) async {
        await Future.delayed(Duration(milliseconds: 500));
        final time = await scraper.getRequireTimeViaUrl(url);
        times.add(time);
      },
    );
    return times;
  }

  String requireTimeString(int index) {
    return "約 ${requireTimes[currentNearStation]?[index]}";
  }

  void selectpolyline(int index) {
    mapController.selectedChip(index);
  }

  void backRoot() {
    currentState.value = MenuBarState.root;
    mapController.mapService.fitMarkerBounds();
  }
}

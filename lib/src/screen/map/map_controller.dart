import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
import 'package:getx_map/src/service/generate_probability.dart';
import 'package:getx_map/src/service/map_service.dart';
import 'package:getx_map/src/service/markers_service.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:getx_map/src/utils/distance_format.dart';
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

  final MarkersSearvice markerService = MarkersSearvice.to;
  final mapService = MapService();

  late MainBarController mainBarController;

  int? chipIndex;
  RxBool overlayLoading = false.obs;

  late LatLng centerLatLng;

  @override
  void onInit() {
    super.onInit();
  }

  Future onMapCreate(GoogleMapController controller) async {
    overlayLoading.value = true;
    try {
      mapService.init(controller);
      await addStationMarkers();
      await Future.delayed(Duration(seconds: 1));
      await setCenterCircle();
      addCenterPolyLine();
      await getNearStations();
      addShopMarkers(oninit: true);
    } catch (e) {
      print(e);
    } finally {
      update();
      overlayLoading.value = false;
    }
  }

  Future<void> showInterstitialAd({bool useFrequency = true}) async {
    final interAd = AdmobInterstialService.to;

    if (!useFrequency) {
      await interAd.showInterstitialAd();
      return;
    }

    if (GenerateProbability.to.probability(frequency: 3)) {
      await interAd.showInterstitialAd();
    }
  }

  Future addStationMarkers() async {
    stations.asMap().forEach((int i, Station station) {
      mapService.addStationMarker(station, icon: markerService.userIcons[i]);
    });

    await mapService.fitMarkerBounds();

    // update();
  }

  Future setCenterCircle() async {
    final center = await mapService.getCenter();
    centerLatLng = center;

    mapService.addCenterMarker(center);

    // update();
  }

  void addCenterPolyLine() {
    stations.asMap().forEach(
      (int i, Station station) {
        mapService.addStationToCenterPolyline(
          station: station,
          center: centerLatLng,
          color: ColorsConsts.iconColors[i].withOpacity(0.6),
          onTap: () {
            fitPointsDuration(from: station.latLng, to: centerLatLng);
          },
        );
      },
    );
  }

  Future<void> getNearStations() async {
    final stationAPI = StaionAPI();

    final temp = await stationAPI.getNearStations(centerLatLng);
    final names = temp.map((n) => n.name).toSet();
    temp.retainWhere((x) => names.remove(x.name));

    nearStations.addAll(temp);

    nearStations.forEach((station) {
      mapService.addStationMarker(
        station,
        icon: markerService.stationIcon,
        onTap: () => selectStation(station),
      );
    });
  }

  Future<void> onMapLongPress(LatLng latLng) async {
    print(latLng);

    await showInterstitialAd();

    /// clear markers
    await Future.forEach(nearStations,
        (Station station) async => mapService.removeStationMarker(station));
    nearStations.clear();

    centerLatLng = latLng;
    addCenterPolyLine();
    mapService.addCenterMarker(centerLatLng);
    await getNearStations();
    mainBarController.reset();
    update();
  }

  Future<void> degaultMap() async {
    chipIndex = null;
    await mapService.updateCamera(centerLatLng, setZoom: 10);
  }

  void selectedChip(int index) async {
    final sta = stations[index];
    if (chipIndex == index) {
      // await zoomStation(sta);
      return;
    }

    chipIndex = index;
    fitPointsDuration(from: sta.latLng, to: centerLatLng);

    update();
  }

  Future<void> zoomStation(Station station) async {
    await mapService.updateCamera(station.latLng, setZoom: 15);
    mapService.showInfoService(station.id);
  }

  void fitPointsDuration({required LatLng from, required LatLng to}) {
    mapService.fitPointsDuration(from: from, to: to);
    final distanceInMeters = Geolocator.distanceBetween(
        from.latitude, from.longitude, to.latitude, to.longitude);

    final distance = meterFormatKm(distanceInMeters);
    mainBarController.setDistance(distance);
  }

  Future<void> zoomShop(Shop shop) async {
    await mapService.updateCamera(shop.latLng, setZoom: 15);
    mapService.showInfoService(shop.id);
  }

  Future<void> zoomUp() async {
    await mapService.setZoom(true);
  }

  Future<void> zoomDown() async {
    await mapService.setZoom(false);
  }
}

/// use main bar controller

extension MapControllerEXT on MapController {
  ///constroctor
  void setMainBar(MainBarController controller) {
    this.mainBarController = controller;
  }

  void selectStation(Station nearStation) {
    if (mainBarController.currentState.value == MenuBarState.showMenu) {
      mainBarController.pushShopScreen();
    }
    mainBarController.selectStation(nearStation);
    mainBarController.currentState.value = MenuBarState.showMenu;
  }

  void selectFavorite() {
    mainBarController.selectFavorite();
  }

  void editNearStation(Station newStation, Station oldStation) {
    if (mainBarController.currentIndex.value == null) {
      return;
    }
    nearStations[mainBarController.currentIndex.value!] = newStation;
    mapService.editStationMarker(
      newStation,
      oldStation,
      icon: markerService.stationIcon,
      onTap: () => selectStation(newStation),
    );

    update();
  }

  void addShopMarkers({bool oninit = false}) async {
    bool isUpdate = false;

    final FavoriteShopService shopService = FavoriteShopService.to;

    /// Delete
    if (shopService.deletedIds.isNotEmpty) {
      shopService.deletedIds.forEach(
        (deleteId) {
          if (mapService.checkExistMarker(deleteId)) {
            mapService.removeShopMarker(deleteId);
            isUpdate = true;
          }
        },
      );
      shopService.deletedIds.clear();
    }

    /// Add
    if (shopService.favoriteShop.isNotEmpty) {
      shopService.favoriteShop.forEach(
        (favoriteShop) {
          if (!mapService.checkExistMarker(favoriteShop.id)) {
            mapService.addShopmarker(favoriteShop,
                icon: markerService.restaurnatIcon,
                onTap: () =>
                    mainBarController.selectFavoriteShop(favoriteShop));
            isUpdate = true;
          }
        },
      );
    }

    if (oninit) {
      return;
    }

    if (isUpdate) {
      update();
      await showInterstitialAd();
      await mapService.fitMarkerBounds();
    } else {
      print("Not Update");
    }
  }
}

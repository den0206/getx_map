import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/model/suggestion.dart';
import 'package:getx_map/src/screen/get_station/search_station_abstract/search_abstract.dart';
import 'package:getx_map/src/screen/map/main_bar/main_bar_controller.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/api/station/staion_api.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/generate_probability.dart';
import 'package:getx_map/src/service/map_service.dart';
import 'package:getx_map/src/service/markers_service.dart';
import 'package:getx_map/src/utils/common_icon.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapController());
  }
}

class MapController extends GetxSearchController {
  final List<Station> stations = Get.arguments;
  final List<Station> nearStations = [];

  final MarkersSearvice markerService = MarkersSearvice.to;
  final mapService = MapService();

  final showPanel = false.obs;
  final panelController = PanelController();

  late MainBarController mainBarController;

  RxnInt chipIndex = RxnInt();

  RxBool overlayLoading = false.obs;

  late LatLng centerLatLng;
  late double circumferenceRadius;

  @override
  void onInit() {
    super.onInit();

    loadDatabse();
  }

  Future onMapCreate(GoogleMapController controller) async {
    overlayLoading.value = true;
    try {
      mapService.init(controller);
      await addStationMarkers();
      await Future.delayed(Duration(seconds: 1));
      await setCenterCircle();
      addToCenterPolyLine();
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
      await interAd.showInterstitialAd(useList: true);
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
  }

  Future setCenterCircle() async {
    final center = await mapService.getCenter();
    centerLatLng = center;
    circumferenceRadius =
        mapService.getDistanceCircleRadius(stations, centerLatLng);

    mapService.addCenterMarker(center);
    mapService.addCircumference(centerLatLng, circumferenceRadius);
  }

  void addToCenterPolyLine() {
    stations.asMap().forEach(
      (int i, Station station) {
        station.distanceFromCenter = mapService.getDistanceString(
          from: station.latLng,
          to: centerLatLng,
        );

        mapService.addStationToCenterPolyline(
          station: station,
          center: centerLatLng,
          color: ColorsConsts.iconColors[i].withOpacity(0.6),
          onTap: () {
            selectedChip(i);
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

  Future<void> onMapLongPress(LatLng latLng, {useAD = true}) async {
    print(latLng);

    if (useAD) await showInterstitialAd();

    /// clear markers
    await Future.forEach(nearStations,
        (Station station) async => mapService.removeStationMarker(station));
    nearStations.clear();

    centerLatLng = latLng;
    addToCenterPolyLine();
    mapService.addCenterMarker(centerLatLng);
    await getNearStations();
    mainBarController.reset();
    update();
  }

  Future<void> degaultMap() async {
    chipIndex.value = null;
    await mapService.fitMarkerBounds();
  }

  void selectedChip(int index) async {
    if (chipIndex.value == index) {
      return;
    }

    chipIndex.value = index;

    final station = stations[index];

    mapService.fitPointsDuration(from: station.latLng, to: centerLatLng);
    mainBarController.currentState.value = MenuBarState.distance;
  }

  Future<void> zoomStation(Station station) async {
    await mapService.updateCamera(station.latLng, setZoom: 15);
    mapService.showInfoService(station.id);
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

  void togglecircumferenceCircle() {
    mapService.togglecircumferenceCircle();
    update();
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

    final StorageService shopService = StorageService.to;

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

extension SearcPanelController on MapController {
  void closePanel() {
    tX.clear();
    panelController.close();
    togglePannel();

    FocusScope.of(Get.context!).unfocus();
  }

  void togglePannel() {
    showPanel.value = !showPanel.value;
  }

  Future selectSuggest(StationBase base) async {
    await Get.dialog(CustomDialog(
      title: "${base.name}",
      descripon: "中間に設定しますか？",
      icon: CommonIcon.stationIcon,
      onSuceed: () async {
        await successSearch(base);
      },
    ));
    // await showInterstitialAd(useFrequency: false);
  }

  Future<void> successSearch(StationBase base) async {
    late Station station;
    if (base is Suggest) {
      station = await stationAPI.getStationDetail(base.id);
    } else if (base is Station) {
      station = base;
    }

    saveDatabase(station);

    tX.text = station.name;

    await panelController.close();
    FocusScope.of(Get.context!).unfocus();
    // showPanel.toggle();

    await onMapLongPress(station.latLng, useAD: false);
  }
}

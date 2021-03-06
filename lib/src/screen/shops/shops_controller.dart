import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/shop_detail/shop_datail_screen.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/api/shop/pepper_api.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/open_url_servoice.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

enum CellType { list, row }

class ShopsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopsController());
  }
}

abstract class ShopsScreenAbstract extends GetxController {
  void pushShopDetail(Shop shop) {
    final arg = shop;

    Get.toNamed(ShopDetailScreen.routeName, arguments: arg);
  }

  void toggeleFavorite(Shop shop) {
    StorageService.to.addandRomoveFavorite(shop);
  }

  void openUrl(Shop shop) async {
    final openUrl = OepnUrlService(shop.urls);
    await openUrl.showUrlDialog();
  }
}

class ShopsController extends ShopsScreenAbstract {
  final Station station = Get.arguments;
  RxList<Shop> shops = RxList<Shop>();

  final Rx<CellType> cellType = CellType.list.obs;

  final PepperApi _pepperApi = PepperApi();

  final currentGenreIndex = 0.obs;
  int currentIndex = 1;

  LatLng get latLng {
    return station.latLng;
  }

  RestautantGenre get currentGenre {
    return allGenre[currentGenreIndex.value];
  }

  bool reachLast = false;
  bool isLoading = false;

  bool get showInterAd {
    if (currentIndex == 1) {
      return false;
    } else if (((currentIndex - 1) / 10) % 2 == 0) {
      return true;
    }
    return false;
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchShops();
  }

  Future<void> showInterstitialAd() async {
    final interAd = AdmobInterstialService.to;
    await interAd.showInterstitialAd(useList: true);
  }

  Future<void> fetchShops() async {
    if (reachLast) {
      return;
    }

    if (showInterAd) {
      await showInterstitialAd();
    }

    isLoading = true;

    try {
      if (currentIndex == 1) await Future.delayed(Duration(seconds: 1));
      final temp =
          await _pepperApi.getShops(latLng, currentGenre, currentIndex);
      if (temp == null) return;

      if (temp.length < _pepperApi.perPage) {
        reachLast = true;
      }
      currentIndex += temp.length;

      shops.addAll(temp);
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
    }
  }

  void changeGenre(int index) async {
    currentGenreIndex.value = index;
    if (reachLast) reachLast = false;

    /// reset param;
    currentIndex = 1;
    shops.clear();

    await fetchShops();
  }

  void toggleType() {
    switch (cellType.value) {
      case CellType.list:
        cellType.value = CellType.row;
        break;
      case CellType.row:
        cellType.value = CellType.list;
        break;
    }
  }
}

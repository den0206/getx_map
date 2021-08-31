import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';
import 'package:getx_map/src/screen/shop_detail/shop_datail_screen.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/api/shop/shop_api.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
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

abstract class ShopsBase {
  void pushShopDetail(Shop shop) {
    final arg = shop;

    Get.toNamed(ShopDetailScreen.routeName, arguments: arg);
  }

  void toggeleFavorite(Shop shop) {
    FavoriteShopService.to.addandRomoveFavorite(shop);
  }

  void openUrl(Shop shop) async {
    final openUrl = OepnUrlService(shop.urls);
    await openUrl.showUrlDialog();
  }
}

class ShopsController extends GetxController with ShopsBase {
  final Station station = Get.arguments;
  RxList<Shop> shops = RxList<Shop>();

  final Rx<CellType> cellType = CellType.list.obs;

  final shopAPI = ShopAPI();

  final currentGenreIndex = 0.obs;

  LatLng get latLng {
    return station.latLng;
  }

  RestautantGenre get currentGenre {
    return allGenre[currentGenreIndex.value];
  }

  bool reachLast = false;
  bool isLoading = false;

  bool get showInterAd {
    if (shopAPI.currentIndex == 1) {
      return false;
    } else if (((shopAPI.currentIndex - 1) / 10) % 2 == 0) {
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
      final temp = await shopAPI.getShops(latLng, currentGenre);

      if (temp.length < shopAPI.perPage) {
        reachLast = true;
      }

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
    shopAPI.currentIndex = 1;
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

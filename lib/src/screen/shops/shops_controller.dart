import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/service/api/shop/shop_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class ShopsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopsController());
  }
}

class ShopsController extends GetxController {
  final LatLng latLng = Get.arguments;
  RxList<Shop> shops = RxList<Shop>();

  final shopAPI = ShopAPI();

  final currentGenreIndex = 0.obs;

  RestautantGenre get currentGenre {
    return allGenre[currentGenreIndex.value];
  }

  bool reachLast = false;
  bool isLoading = false;

  @override
  void onInit() async {
    super.onInit();
    await fetchShops();
  }

  Future<void> fetchShops() async {
    if (reachLast) {
      return;
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
}

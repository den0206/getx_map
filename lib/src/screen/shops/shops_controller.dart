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
  final shopAPI = ShopAPI();
  bool reachLast = false;

  RxList<Shop> shops = RxList<Shop>();

  @override
  void onInit() async {
    super.onInit();
    await fetchShops();
  }

  Future<void> fetchShops() async {
    final temp = await shopAPI.getShops(latLng);

    if (temp.length < shopAPI.perPage) {
      reachLast = true;
    }

    shops.addAll(temp);
  }
}

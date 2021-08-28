import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/shop.dart';

class FavoriteShopService extends GetxService {
  static FavoriteShopService get to => Get.find();
  RxList<Shop> favoriteShop = RxList<Shop>();

  @override
  void onInit() {
    super.onInit();
  }

  void addandRomoveFavorite(Shop shop) {
    if (!favoriteShop.contains(shop)) {
      if (favoriteShop.length > 2) {
        favoriteShop.removeAt(0);
      }
      favoriteShop.add(shop);
    } else {
      favoriteShop.remove(shop);
    }

    print(favoriteShop);
  }
}

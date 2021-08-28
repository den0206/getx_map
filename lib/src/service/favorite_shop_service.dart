import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/service/database_service.dart';

class FavoriteShopService extends GetxService {
  static FavoriteShopService get to => Get.find();
  RxList<Shop> favoriteShop = RxList<Shop>();
  List<String> deletedIds = [];

  final databse = DatabaseService.to;

  @override
  void onInit() {
    super.onInit();
    favoriteShop.addAll(databse.loadShops(DatabaseKey.favoriteShop));
    print("INIT FAVORITE SHOP");
  }

  void addandRomoveFavorite(Shop shop) {
    if (!favoriteShop.contains(shop)) {
      if (favoriteShop.length >= 5) {
        favoriteShop.removeAt(0);
      }
      favoriteShop.add(shop);

      if (deletedIds.contains(shop.id)) {
        deletedIds.remove(shop.id);
      }
    } else {
      favoriteShop.remove(shop);

      if (!deletedIds.contains(shop.id)) {
        deletedIds.add(shop.id);
      }
    }

    /// save local
    databse.setShopList(DatabaseKey.favoriteShop, favoriteShop);
  }
}

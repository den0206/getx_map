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
    loadFavorite();
  }

  void loadFavorite() {
    final temp = databse.loadShops(DatabaseKey.favoriteShop);

    favoriteShop.addAll(temp);
  }

  void addandRomoveFavorite(Shop shop) {
    if (!existFavorite(shop)) {
      if (favoriteShop.length >= 5) {
        favoriteShop.removeAt(0);
      }
      favoriteShop.add(shop);

      if (deletedIds.contains(shop.id)) {
        deletedIds.remove(shop.id);
      }
    } else {
      favoriteShop.removeWhere((favorite) => favorite.id == shop.id);

      if (!deletedIds.contains(shop.id)) {
        deletedIds.add(shop.id);
      }
    }

    /// save local
    databse.setShopList(DatabaseKey.favoriteShop, favoriteShop);
  }

  bool existFavorite(Shop shop) {
    return favoriteShop
        .map((favotrite) => favotrite.id)
        .toList()
        .contains(shop.id);
  }

  void clearFavorite() {
    favoriteShop.clear();
    deletedIds.clear();
    databse.deleteKey(DatabaseKey.favoriteShop);
  }
}

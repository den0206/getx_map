import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/route_history.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/service/database/database_service.dart';

class StorageService extends GetxService {
  static StorageService get to => Get.find();
  RxList<Shop> favoriteShop = RxList<Shop>();
  List<String> deletedIds = [];

  RxList<RouteHistory> histories = RxList<RouteHistory>();

  final databse = DatabaseService.to;

  @override
  void onInit() {
    super.onInit();
    loadStorage();
  }

  void loadStorage() {
    final favorite = databse.loadShops();
    favoriteShop.addAll(favorite);

    final history = databse.loadRouteHistory();
    histories.addAll(history);

    print(histories.length);
  }

  void addandRomoveFavorite(Shop shop) {
    if (!existStorage(shop)) {
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
    databse.setShopList(favoriteShop);
  }

  void addAndRemoveHistory(RouteHistory history) {
    if (!existStorage(history)) {
      if (histories.length >= 5) {
        histories.removeAt(0);
      }
      histories.add(history);
    } else {
      histories.removeWhere((ex) => ex.id == history.id);
    }

    databse.setRouteHistory(histories);
  }

  bool existStorage(Identifiable object) {
    return favoriteShop.map((ex) => ex.id).toList().contains(object.id);
  }

  void clearFavorite() {
    favoriteShop.clear();
    deletedIds.clear();
    databse.deleteKey(DatabaseKey.favoriteShop);
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:getx_map/src/model/route_history.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:get/get.dart';

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
  }

  void addandRomoveFavorite(Shop shop) {
    if (!existStorage(favoriteShop, shop)) {
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
    if (!existStorage(histories, history)) {
      if (histories.length >= 5) {
        histories.removeAt(0);
      }
      histories.add(history);
    } else {
      histories.removeWhere((ex) => ex.id == history.id);
    }

    databse.setRouteHistory(histories);
  }

  bool existStorage(List<Identifiable> lists, Identifiable object) {
    return lists.map((ex) => ex.id).toList().contains(object.id);
  }

  void shoeDeleteDialog(DatabaseKey key) {
    Get.dialog(CustomDialog(
      title: "確認",
      descripon: "削除しても宜しいですか？",
      icon: Icons.delete,
      onSuceed: () {
        switch (key) {
          case DatabaseKey.routeHistory:
            clearHistory();
            break;
          case DatabaseKey.favoriteShop:
            clearFavorite();
            break;

          default:
            return;
        }
      },
    ));
  }

  void clearFavorite() {
    favoriteShop.clear();
    deletedIds.clear();
    databse.deleteKey(DatabaseKey.favoriteShop);
  }

  void clearHistory() {
    histories.clear();
    databse.deleteKey(DatabaseKey.routeHistory);
  }
}

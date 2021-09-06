import 'package:get/instance_manager.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:get/get.dart';

class FavoriteShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoriteShopController());
  }
}

class FavoriteShopController extends ShopsScreenAbstract {
  final favoritShops = StorageService.to.favoriteShop;

  RxBool get canDelete {
    return favoritShops.isNotEmpty.obs;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void deleteFavorite() {
    StorageService.to.shoeDeleteDialog(DatabaseKey.favoriteShop);
  }
}

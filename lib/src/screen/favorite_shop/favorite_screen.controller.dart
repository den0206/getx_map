import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:get/get.dart';

class FavoriteShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoriteShopController());
  }
}

class FavoriteShopController extends GetxController with ShopsBase {
  final favoritShops = StorageService.to.favoriteShop;

  RxBool get canDelete {
    return favoritShops.isNotEmpty.obs;
  }

  @override
  void onInit() {
    super.onInit();
  }

  void deleteFavorite() {
    StorageService.to.clearFavorite();
  }
}

import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ShopDetailController());
  }
}

class ShopDetailController extends GetxController {
  final Shop shop = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    print(shop.name);
  }

  void toggeleFavorite() {
    FavoriteShopService.to.addandRomoveFavorite(shop);
  }

  void openUrl(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}

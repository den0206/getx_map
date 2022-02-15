import 'package:getx_map/src/model/shop.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/open_url_servoice.dart';

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
  }

  void toggeleFavorite() {
    StorageService.to.addandRomoveFavorite(shop);
  }

  void openUrl(String url) async {
    final openUrl = OepnUrlService(url);
    await openUrl.showUrlDialog();
  }
}

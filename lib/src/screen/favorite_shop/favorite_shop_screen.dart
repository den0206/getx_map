import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_screen.controller.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/admob_service.dart';

class FavoriteShopScreen extends GetView<FavoriteShopController> {
  const FavoriteShopScreen({Key? key}) : super(key: key);

  static const routeName = '/FavoriteShop';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お気に入り'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 30,
                  color:
                      !controller.canDelete.value ? Colors.grey : Colors.blue,
                ),
                onPressed: !controller.canDelete.value
                    ? null
                    : () {
                        controller.deleteFavorite();
                      },
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: controller.favoritShops.length,
                  itemBuilder: (context, index) {
                    final shop = controller.favoritShops[index];

                    return ShopCell(controller: controller, shop: shop);
                  },
                ),
              ),
            ),
            AdmobBannerService.to.myBannerAd,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_screen.controller.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';

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
      ),
      body: ListView.builder(
        itemCount: controller.favoritShops.length,
        itemBuilder: (context, index) {
          final shop = controller.favoritShops[index];

          return ShopCell(controller: controller, shop: shop);
        },
      ),
    );
  }
}

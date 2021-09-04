import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/screen/widget/common_chip.dart';
import 'package:getx_map/src/screen/widget/custom_badges.dart';
import 'package:getx_map/src/screen/widget/loading_widget.dart';
import 'package:getx_map/src/utils/common_icon.dart';

class ShopsScreen extends GetView<ShopsController> {
  const ShopsScreen({Key? key}) : super(key: key);

  static const routeName = '/ShposScreen';

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
              "${controller.station.name} 駅近くの${controller.currentGenre.title}店"),
          elevation: 0,
          actions: [
            FavoriteShopBadge(),
            IconButton(
              icon: Icon(
                controller.cellType.value == CellType.list
                    ? Icons.grid_view_rounded
                    : Icons.list,
              ),
              onPressed: () {
                controller.toggleType();
              },
            )
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: allGenre.length,
                  itemBuilder: (BuildContext context, int index) {
                    final genre = allGenre[index];
                    return CommonChip(
                      label: genre.title,
                      selected: controller.currentGenreIndex.value == index,
                      onselected: (selected) => controller.changeGenre(index),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: controller.cellType.value == CellType.list
                  ? ListView.builder(
                      itemCount: controller.shops.length,
                      itemBuilder: (BuildContext context, int index) {
                        final shop = controller.shops[index];

                        if (index == controller.shops.length - 1) {
                          controller.fetchShops();
                          if (controller.isLoading) return LoadingCellWidget();
                        }
                        return ShopCell(controller: controller, shop: shop);
                      },
                    )
                  : GridView.builder(
                      itemCount: controller.shops.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        final shop = controller.shops[index];

                        if (index == controller.shops.length - 1) {
                          controller.fetchShops();
                          if (controller.isLoading) return LoadingCellWidget();
                        }
                        return ShopGridCell(shop: shop);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopGridCell extends GetView<ShopsController> {
  const ShopGridCell({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.pushShopDetail(shop);
      },
      child: Card(
        color: Colors.grey[400],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 18.0 / 12.0,
                child: Image.network(
                  shop.photo,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(4.0, 8.0, 8.0, 2.0),
                child: Column(
                  children: [
                    Text(
                      shop.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      shop.shopDetailMemo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ShopCell extends StatelessWidget {
  const ShopCell({
    Key? key,
    required this.controller,
    required this.shop,
  }) : super(key: key);

  final ShopsScreenAbstract controller;

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          controller.pushShopDetail(shop);
        },
        child: Card(
          color: Colors.grey[200],
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Slidable(
            key: Key(shop.id),
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              Obx(
                () => IconSlideAction(
                  caption: shop.isFavorite ? "登録済みです" : "お気に入り",
                  color: shop.isFavorite ? Colors.red : Colors.grey,
                  icon: Icons.favorite,
                  closeOnTap: false,
                  onTap: () {
                    controller.toggeleFavorite(shop);
                  },
                ),
              ),
              IconSlideAction(
                caption: "URL",
                color: Colors.green,
                icon: Icons.launch,
                onTap: () {
                  controller.openUrl(shop);
                },
              ),
            ],
            child: Container(
              height: MediaQuery.of(context).size.height / 6.3,
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      child: Image.network(
                        shop.photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            shop.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            shop.catchCopy,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 100),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CommonIcon.stationIcon,
                            color: Colors.grey[400],
                          ),
                          Flexible(
                            child: Text(
                              shop.stationName,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Expanded(
//               child: ListView.builder(
//                 itemCount: controller.shops.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   final shop = controller.shops[index];

//                   if (index == controller.shops.length - 1) {
//                     controller.fetchShops();
//                     if (controller.isLoading) return LoadingCellWidget();
//                   }
//                   return ShopCell(shop: shop);
//                 },
//               ),
//             ),
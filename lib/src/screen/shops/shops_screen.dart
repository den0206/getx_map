import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/screen/widget/common_chip.dart';
import 'package:getx_map/src/screen/widget/loading_widget.dart';

class ShopsScreen extends GetView<ShopsController> {
  const ShopsScreen({Key? key}) : super(key: key);

  static const routeName = '/ShposScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                  return Obx(
                    () => CommonChip(
                      label: genre.title,
                      selected: controller.currentGenreIndex.value == index,
                      onselected: (selected) => controller.changeGenre(index),
                    ),
                  );
                },
              ),
            ),
          ),
          Obx(
            () => Expanded(
              child: GridView.builder(
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
          ),
        ],
      ),
    );
  }
}

class ShopGridCell extends StatelessWidget {
  const ShopGridCell({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}

class ShopCell extends StatelessWidget {
  const ShopCell({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: Colors.grey[200],
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
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
                    Text(
                      shop.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      shop.shopDetailMemo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
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
                        Icons.directions_transit,
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
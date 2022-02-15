import 'package:get/route_manager.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_screen.controller.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_shop_screen.dart';
import 'package:getx_map/src/screen/get_station/get_station_controller.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/home/home_screen.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/screen/route_history/route_history_screen.dart';
import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';
import 'package:getx_map/src/screen/shop_detail/shop_datail_screen.dart';
import 'package:getx_map/src/screen/shop_detail/shop_detail_controller.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/service/network_service.dart';

import 'screen/shops/shops_screen.dart';

class AppRoot {
  static List<GetPage> pages = [..._mainpages];
}

final List<GetPage> _mainpages = [
  GetPage(
    name: HomeScreen.routeName,
    page: () => HomeScreen(),
  ),
  GetPage(
    name: GetStationScreen.routeName,
    page: () => GetStationScreen(),
    binding: GetStationBinding(),
  ),
  GetPage(
    name: MapScreen.routeName,
    page: () => MapScreen(),
    // binding: MapBinding(),
  ),
  GetPage(
    name: SearchScreen.routeName,
    page: () => SearchScreen(),
    binding: SearchBinding(),
  ),
  GetPage(
    name: ShopsScreen.routeName,
    page: () => ShopsScreen(),
    binding: ShopsBinding(),
  ),
  GetPage(
    name: ShopDetailScreen.routeName,
    page: () => ShopDetailScreen(),
    binding: ShopDetailBindings(),
  ),
  GetPage(
    name: FavoriteShopScreen.routeName,
    page: () => FavoriteShopScreen(),
    binding: FavoriteShopBinding(),
  ),
  GetPage(
    name: NetworkBranchScreen.routeName,
    page: () => NetworkBranchScreen(),
  ),
  GetPage(
    name: RouteHistoryScreen.routeName,
    page: () => RouteHistoryScreen(),
    fullscreenDialog: true,
  )
];

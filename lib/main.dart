import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_screen.controller.dart';
import 'package:getx_map/src/screen/favorite_shop/favorite_shop_screen.dart';
import 'package:getx_map/src/screen/get_station/get_station_controller.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/home/home_screen.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';

import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';
import 'package:getx_map/src/screen/shop_detail/shop_datail_screen.dart';
import 'package:getx_map/src/screen/shop_detail/shop_detail_controller.dart';
import 'package:getx_map/src/screen/shops/shops_controller.dart';
import 'package:getx_map/src/screen/shops/shops_screen.dart';
import 'package:getx_map/src/service/api/token_service.dart';
import 'package:getx_map/src/service/database_service.dart';
import 'package:getx_map/src/service/favorite_shop_service.dart';
import 'package:getx_map/src/service/markers_service.dart';
import 'package:getx_map/src/utils/consts_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Get.put(DatabaseService()).initStorage();

  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'getx-map',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: Colors.grey),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: ColorsConsts.themeYellow,
        cardColor: Colors.grey,
        // scaffoldBackgroundColor: hexToColor("#f7b611"),
      ),
      initialBinding: InitialBindings(),
      getPages: [
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
      ],
      // initialRoute: MapScreen.routeName,
      initialRoute: HomeScreen.routeName,
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MarkersSearvice());
    Get.lazyPut(() => FavoriteShopService());
  }
}

class SampleScreen extends StatelessWidget {
  SampleScreen({Key? key}) : super(key: key);

  final token = TokenService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: token.getToken(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Title'),
          ),
          body: Center(
            child: Text("Sample"),
          ),
        );
      },
    );
  }
}

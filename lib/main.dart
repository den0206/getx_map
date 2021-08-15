import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';
import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'getx-map',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: MapScreen.routeName,
          page: () => MapScreen(),
        ),
        GetPage(
          name: SearchScreen.routeName,
          page: () => SearchScreen(),
          binding: SearchBinding(),
        ),
      ],
      initialRoute: MapScreen.routeName,
    );
  }
}

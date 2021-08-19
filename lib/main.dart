import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/get_station/get_station_controller.dart';
import 'package:getx_map/src/screen/get_station/get_station_screen.dart';
import 'package:getx_map/src/screen/home/home_screen.dart';
import 'package:getx_map/src/screen/map/map_controller.dart';
import 'package:getx_map/src/screen/map/map_screen.dart';

import 'package:getx_map/src/screen/search/search_controller.dart';
import 'package:getx_map/src/screen/search/search_screen.dart';
import 'package:getx_map/src/service/api/token_service.dart';

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
      ],
      // initialRoute: MapScreen.routeName,
      initialRoute: HomeScreen.routeName,
    );
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

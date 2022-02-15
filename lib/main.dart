import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/app_root.dart';

import 'package:getx_map/src/service/network_service.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/markers_service.dart';
import 'package:getx_map/src/utils/consts_color.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'src/service/api/here/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Get.put(DatabaseService()).initStorage();

  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'getx-map',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey,
                toolbarTextStyle: TextStyle(
                  color: Colors.black,
                ),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                )),
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: ColorsConsts.themeYellow,
            cardColor: Colors.grey,
            // scaffoldBackgroundColor: hexToColor("#f7b611"),
          ),
          initialBinding: InitialBindings(),
          getPages: AppRoot.pages,
          initialRoute: NetworkBranchScreen.routeName,
        );
      },
    );
  }
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(MarkersSearvice());
    Get.put(AdmobInterstialService());
    Get.lazyPut(() => StorageService());
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

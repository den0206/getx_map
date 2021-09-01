import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:getx_map/src/screen/home/home_screen.dart';
import 'package:getx_map/src/screen/widget/animated_widget.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:sizer/sizer.dart';

class NetworkService extends GetxService {
  static NetworkService get to => Get.find();

  Rx<InternetConnectionStatus> status = InternetConnectionStatus.connected.obs;
  InternetConnectionChecker _internetChecker = InternetConnectionChecker();

  @override
  void onInit() {
    status.bindStream(_internetChecker.onStatusChange);
    ever(status, (value) {});
    super.onInit();
  }

  Future<bool> checkNetwork() async {
    if (status.value == InternetConnectionStatus.disconnected) {
      await Get.dialog(
        CustomDialog(
          title: "Error",
          descripon: "インターネット接続がありません",
          icon: Icons.wifi_off,
          onSuceed: () {
            Get.back();
          },
        ),
      );

      return false;
    }

    return true;
  }

  @override
  void onClose() {
    super.onClose();
    Get.back();
    status.close();
  }
}

class NetworkBranchScreen extends StatelessWidget {
  const NetworkBranchScreen({Key? key}) : super(key: key);

  static const routeName = '/NetworkBrabch';

  @override
  Widget build(BuildContext context) {
    return GetX<NetworkService>(
      init: NetworkService(),
      builder: (network) {
        return Scaffold(
            body: Stack(
          children: [
            HomeScreen(),
            if (network.status.value == InternetConnectionStatus.disconnected)
              NoInternetBanner(),
          ],
        ));
      },
    );
  }
}

class NoInternetBanner extends StatelessWidget {
  const NoInternetBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeinWidget(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          height: 7.h,
          decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12)),
          child: Center(
              child: Text(
            "インターネット接続がありません",
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }
}

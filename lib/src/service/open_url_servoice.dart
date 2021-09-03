import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_map/src/screen/widget/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class OepnUrlService {
  final String url;

  OepnUrlService(this.url);

  Future<void> showUrlDialog({Function()? beforeLaunchUrl}) async {
    await Get.dialog(
      CustomDialog(
        title: "確認",
        descripon: "外部リンクへ飛びます",
        icon: Icons.launch,
        mainColor: Colors.green[400]!,
        onSuceed: () async {
          if (beforeLaunchUrl != null) beforeLaunchUrl();
          await canLaunch(url)
              ? await launch(url)
              : throw 'Could not launch $url';
        },
      ),
    );
  }
}

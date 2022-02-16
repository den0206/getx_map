import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:getx_map/src/model/route_history.dart';
import 'package:getx_map/src/service/admob_service.dart';
import 'package:getx_map/src/service/database/database_service.dart';
import 'package:getx_map/src/service/database/storage_service.dart';
import 'package:getx_map/src/service/open_url_servoice.dart';
import 'package:getx_map/src/utils/common_icon.dart';

class RouteHistoryScreen extends GetView<StorageService> {
  const RouteHistoryScreen({Key? key}) : super(key: key);

  static const routeName = '/RouteHistory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '履歴',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.close,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                Icons.delete_outline,
                size: 30,
                color: controller.histories.isEmpty ? Colors.grey : Colors.blue,
              ),
              onPressed: controller.histories.isEmpty
                  ? null
                  : () {
                      controller.shoeDeleteDialog(DatabaseKey.routeHistory);
                    },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: controller.histories.length,
                  itemBuilder: (context, index) {
                    final route = controller.histories[index];

                    return RouteCell(route: route);
                  },
                ),
              ),
            ),
            AdmobBannerService.to.myBannerAd,
          ],
        ),
      ),
    );
  }
}

class RouteCell extends GetView<StorageService> {
  const RouteCell({
    Key? key,
    required this.route,
  }) : super(key: key);

  final RouteHistory route;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(route.id),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            label: "Delete",
            icon: Icons.delete,
            backgroundColor: Colors.red,
            onPressed: (context) {
              controller.addAndRemoveHistory(route);
            },
          ),
        ],
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history),
            Spacer(),
            IconRichText(
                icon: CommonIcon.stationIcon,
                text: route.from.name,
                fontWeight: FontWeight.w600),
            Icon(
              Icons.forward_rounded,
              size: 30,
            ),
            IconRichText(
                icon: CommonIcon.stationIcon,
                text: route.to.name,
                fontWeight: FontWeight.w600),
            Spacer(),
          ],
        ),
        onTap: () async {
          final openUrl = OepnUrlService(route.url);
          await openUrl.showUrlDialog();
        },
      ),
    );
  }
}

class IconRichText extends StatelessWidget {
  const IconRichText(
      {Key? key,
      required this.icon,
      required this.text,
      this.iconSize,
      this.fontSize,
      this.fontWeight})
      : super(key: key);

  final IconData icon;
  final String text;

  final double? iconSize;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              size: iconSize ?? 20,
            ),
          ),
          TextSpan(
            text: text,
            style: TextStyle(fontSize: fontSize ?? 15),
          )
        ],
      ),
    );
  }
}

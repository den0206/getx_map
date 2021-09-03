import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_map/src/model/route_history.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';

enum DatabaseKey { home, search, lines, routeHistory, favoriteShop }

extension DatabaseKeyEXT on DatabaseKey {
  String get keyString {
    switch (this) {
      case DatabaseKey.home:
        return "Home";
      case DatabaseKey.search:
        return "Search";
      case DatabaseKey.lines:
        return "StationLine";
      case DatabaseKey.routeHistory:
        return "RouteHistory";
      case DatabaseKey.favoriteShop:
        return "FavoriteShop";
    }
  }
}

class DatabaseService extends GetxService {
  static DatabaseService get to => Get.find();
  final box = GetStorage();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  /// station
  void setStationList(DatabaseKey key, List<Station> stations) {
    if (key == DatabaseKey.search && stations.length > 6) {
      stations.removeAt(0);
    }

    if (key == DatabaseKey.lines && stations.length > 15) {
      stations.remove(0);
    }

    switch (key) {
      case DatabaseKey.home:
      case DatabaseKey.search:
        box.write(key.keyString, Station.encode(stations));
        break;
      case DatabaseKey.lines:
        box.write(key.keyString, Station.encodeLine(stations));
        break;
      default:
        print("UN Authorozation Key");
        return;
    }

    print("Update local");
  }

  List<Station> loadStations(DatabaseKey key) {
    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);

      switch (key) {
        case DatabaseKey.home:
        case DatabaseKey.search:
          return Station.decode(decode);
        case DatabaseKey.lines:
          return Station.decodeLine(decode);
        default:
          return [];
      }
    }
  }

  /// shop
  void setShopList(List<Shop> shops) {
    final key = DatabaseKey.favoriteShop;
    if (shops.length >= 5) {
      shops.removeAt(0);
    }

    final enocode = Shop.encode(shops);
    box.write(key.keyString, enocode);

    print("Update local");
  }

  List<Shop> loadShops() {
    final key = DatabaseKey.favoriteShop;
    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);
      return Shop.decode(decode);
    }
  }

  /// history
  void setRouteHistory(List<RouteHistory> routes) {
    final key = DatabaseKey.routeHistory;
    if (routes.length >= 5) {
      routes.removeAt(0);
    }

    final encode = RouteHistory.encode(routes);

    box.write(key.keyString, encode);
  }

  List<RouteHistory> loadRouteHistory() {
    final key = DatabaseKey.routeHistory;
    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);
      return RouteHistory.decode(decode);
    }
  }

  void deleteKey(DatabaseKey key) {
    box.remove(key.keyString);
  }
}

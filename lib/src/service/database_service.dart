import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_map/src/model/shop.dart';
import 'package:getx_map/src/model/station.dart';

enum DatabaseKey { home, search, lines, favoriteShop }

extension DatabaseKeyEXT on DatabaseKey {
  String get keyString {
    switch (this) {
      case DatabaseKey.home:
        return "Home";
      case DatabaseKey.search:
        return "Search";
      case DatabaseKey.lines:
        return "StationLine";
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

    if (key == DatabaseKey.lines && stations.length > 30) {
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
  void setShopList(DatabaseKey key, List<Shop> shops) {
    if (key == DatabaseKey.favoriteShop && shops.length >= 5) {
      shops.removeAt(0);
    }

    final enocode = Shop.encode(shops);

    switch (key) {
      case DatabaseKey.favoriteShop:
        box.write(key.keyString, enocode);
        break;
      default:
        print("UN Authorozation Key");
        return;
    }

    print("Update local");
  }

  List<Shop> loadShops(DatabaseKey key) {
    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);

      switch (key) {
        case DatabaseKey.favoriteShop:
          return Shop.decode(decode);
        default:
          return [];
      }
    }
  }

  void deleteKey(DatabaseKey key) {
    box.remove(key.keyString);
  }
}

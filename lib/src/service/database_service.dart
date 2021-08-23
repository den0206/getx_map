import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getx_map/src/model/station.dart';

enum DatabaseKey { home, search }

extension DatabaseKeyEXT on DatabaseKey {
  String get keyString {
    switch (this) {
      case DatabaseKey.home:
        return "Home";
      case DatabaseKey.search:
        return "Search";
    }
  }
}

class DatabaseService extends GetxService {
  static DatabaseService get to => Get.find();
  final box = GetStorage();

  Future<void> initStorage() async {
    await GetStorage.init();
  }

  void setStationList(DatabaseKey key, List<Station> stations) {
    if (key == DatabaseKey.search && stations.length > 5) {
      print("Over");
      stations.removeAt(0);
    }

    box.write(key.keyString, Station.encode(stations));
    print("Update local");
  }

  List<Station> loadStations(DatabaseKey key) {
    print(box.read(key.keyString));

    if (box.read(key.keyString) == null) {
      return [];
    } else {
      final String decode = box.read(key.keyString);
      return Station.decode(decode);
    }
  }
}

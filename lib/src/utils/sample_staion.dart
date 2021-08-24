import 'package:getx_map/src/model/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jp_prefecture/jp_prefecture.dart';

final List<Station> sampleStaion = [
  Station(
    id: "22741",
    name: "新宿",
    prefecture: JpPrefecture(1, '北海道', 'hokkaido', 'ほっかいどう', 'ホッカイドウ', '北海道'),
    latLng: LatLng(35.6875, 139.703056),
  ),
  Station(
    id: "22640",
    name: "錦糸町",
    prefecture: JpPrefecture(1, '北海道', 'hokkaido', 'ほっかいどう', 'ホッカイドウ', '北海道'),
    latLng: LatLng(35.693194, 139.817166),
  ),
  Station(
    id: "22645",
    name: "九段下",
    prefecture: JpPrefecture(1, '北海道', 'hokkaido', 'ほっかいどう', 'ホッカイドウ', '北海道'),
    latLng: LatLng(35.692249, 139.754694),
  ),
];

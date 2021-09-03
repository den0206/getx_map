import 'dart:convert';

import 'package:getx_map/src/model/station.dart';

abstract class Identifiable {
  final String id;

  Identifiable({
    required this.id,
  });
}

class RouteHistory implements Identifiable {
  final Station from;
  final Station to;
  final String url;

  String get id {
    final value = from.id.compareTo(to.id);

    if (value < 0) {
      return to.id + from.id;
    } else {
      return from.id + to.id;
    }
  }

  RouteHistory({
    required this.from,
    required this.to,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'from': from.toMap(),
      'to': to.toMap(),
      'url': url,
    };
  }

  factory RouteHistory.fromMap(Map<String, dynamic> map) {
    return RouteHistory(
      from: Station.fromMap(map['from']),
      to: Station.fromMap(map['to']),
      url: map['url'],
    );
  }

  static String encode(List<RouteHistory> routes) {
    return json.encode(routes.map((route) => route.toMap()).toList());
  }

  static List<RouteHistory> decode(String routes) {
    return (json.decode(routes) as List<dynamic>)
        .map((item) => RouteHistory.fromMap(item))
        .toList();
  }

  @override
  String toString() => 'RouteHistory($id, from: $from, to: $to, url: $url)';
}

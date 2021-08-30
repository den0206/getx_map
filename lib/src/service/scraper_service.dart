import 'package:getx_map/src/model/station.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class ScraperService {
  Future<String> getRequireTimeViaUrl(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return "取得できませんでした";
    }
    dom.Document document = parser.parse(response.body);

    final queryId = document.getElementById("route01");
    final spans = queryId?.getElementsByTagName('span');

    return spans?[1].text ?? "取得できませんでした";
  }

  Future<String> getRequireTime(Station from, Station to) async {
    final rawUrl =
        'https://transit.yahoo.co.jp/search/print?from=${from.name}&flatlon=&to=${to.name}';

    final response = await http.get(Uri.parse(rawUrl));

    if (response.statusCode != 200) {
      return "取得できませんでした";
    }

    dom.Document document = parser.parse(response.body);

    final elemets = document.getElementsByClassName("time");

    final time = elemets[1].text;
    return time;
  }
}



/// "https://roote.ekispert.net/ja/result?arr=%E6%96%B0%E5%A4%A7%E4%B9%85%E4%BF%9D&arr_code=22730&connect=true&dep=%E9%A3%AF%E7%94%B0%E6%A9%8B&dep_code=22507&express=true&highway=true&liner=true&local=true&plane=true&research=price&shinkansen=true&ship=true&sleep=false&sort=price&surcharge=3&type=dep&via1=&via1_code=&via2=&via2_code=";

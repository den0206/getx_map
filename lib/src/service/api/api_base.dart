import 'dart:io';
import 'dart:convert';

import 'package:getx_map/src/model/custom_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class APIBase {
  final EndPoint endPoint;
  APIBase(this.endPoint);

  Uri setUri(String path, [Map<String, dynamic>? query]) {
    if (query != null && endPoint.apiKey != null) {
      query["key"] = endPoint.apiKey;
    }
    final r = Uri.https(endPoint.host, path, query);
    print(r);
    return r;
  }

  dynamic _filterResponse(http.Response response) {
    final resJson = json.decode(response.body);
    return _checkStatusCode(response.statusCode, resJson);
  }

  dynamic _checkStatusCode(int statusCode, dynamic responseData) {
    switch (statusCode) {
      case 200:
        return responseData;
      case 400:
        throw FetchDataException("FetchData");
      case 401:
      case 403:
        throw UnauthorisedException("UnAUTH");
      case 404:
        throw NotFoundException("NotFind");
      case 413:
        throw ExceedLimitException("ExceedLimit");
      case 414:
        throw URLTooLongException("Too Long");
      case 429:
      case 529:
        throw TooManyRequestException("Too Many");
      case 456:
        throw QuotaExceedException("Quota Exceed");
      case 503:
        throw ResourceUnavailableException("Unavailable");
      case 500:
      default:
        throw BadRequestException("Invalid");
    }
  }

  Future<dynamic> getRequest({required Uri uri}) async {
    try {
      final res = await http.get(uri);
      return _filterResponse(res);
    } on SocketException {
      throw Exception("No Internet");
    }
  }
}

enum EndPoint { ekispert, heartrails, hotpepper }

extension EndPointEXT on EndPoint {
  String get host {
    switch (this) {
      case EndPoint.ekispert:
        return "api.ekispert.jp";
      case EndPoint.heartrails:
        return "express.heartrails.com";
      case EndPoint.hotpepper:
        return "webservice.recruit.co.jp";
    }
  }

  String? get apiKey {
    switch (this) {
      case EndPoint.ekispert:
        return dotenv.env["STATION_KEY"];
      case EndPoint.heartrails:
        return null;
      case EndPoint.hotpepper:
        return dotenv.env["PEPPER_KEY"];
    }
  }
}

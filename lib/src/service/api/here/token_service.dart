import 'dart:convert';
import 'dart:math';
import 'dart:async';

import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TokenService {
  final String key = dotenv.env["ACCESS_KEY"]!;
  final String secretKey = dotenv.env["SECRET_KEY"]!;

  Future<void> getToken() async {
    Uri requestUrl = Uri.https("account.api.here.com", "oauth2/token");
    var ms = new DateTime.now().toUtc().millisecondsSinceEpoch;
    var timestamp = (ms / 1000).round();

    final Map<String, String> authHeader = {
      // "grant_type": "client_credentials",
      // "format": "json",
      "oauth_consumer_key": key,
      "oauth_nonce": _randomString(8),
      "oauth_signature_method": "HMAC-SHA256",
      "oauth_timestamp": timestamp.toString(),

      "oauth_version": "1.0",
    };

    authHeader["oauth_signature"] =
        _generateSignature("POST", requestUrl, authHeader);

    String oAuthHeader = _generateOAuthHeader(authHeader);

    Map<String, String> _headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "$oAuthHeader"
    };

    print(_headers);

    final response = await http.post(
      requestUrl,
      headers: _headers,
      encoding: Encoding.getByName("utf-8"),
      body: "grant_type=client_credentials",
    );

    print(response.body);
    print(response.statusCode);
  }

  String createSignature({
    required String signingKey,
    required String encodedBaseString,
  }) {
    final encodedString = utf8.encode(encodedBaseString);
    final secretKey = utf8.encode(signingKey);

    Hmac _sigHasher = Hmac(sha256, secretKey);

    final _hash = _sigHasher.convert(encodedString).bytes;
    return base64.encode(_hash);
  }

  String _generateOAuthHeader(Map<String, String> data) {
    var oauthHeaderValues = _filterMap(data, (k) => k.startsWith("oauth_"));

    return "OAuth " + _toOAuthHeader(oauthHeaderValues);
  }

  Map<String, String> _filterMap(
      Map<String, String> map, bool test(String key)) {
    return new Map.fromIterable(map.keys.where(test), value: (k) => map[k]!);
  }

  String _toOAuthHeader(Map<String, String> data) {
    var items = data.keys.map((k) => "$k=\"${_encode(data[k]!)}\"").toList();
    items.sort();

    return items.join(",");
  }

  String _randomString(int length) {
    var rand = new Random();
    var codeUnits = new List.generate(length, (index) {
      return rand.nextInt(26) + 97;
    });

    return new String.fromCharCodes(codeUnits);
  }

  String _generateSignature(
      String requestMethod, Uri url, Map<String, String> data) {
    var sigString = _toQueryString(data);
    var fullSigData = "$requestMethod" +
        "&" +
        "${_encode(url.toString())}" +
        "&" +
        "grant_type=client_credentials&" +
        "${_encode(sigString)}";

    print(fullSigData);
    var bytes = utf8.encode("$secretKey");
    Hmac _sigHasher = Hmac(sha256, bytes);

    final _hash = _sigHasher.convert(fullSigData.codeUnits).bytes;

    // return fullSigData;

    return base64.encode(_hash);
  }

  String _toQueryString(Map<String, String> data) {
    var items = data.keys.map((k) => "$k=${_encode(data[k]!)}").toList();
    items.sort();

    return items.join("&");
  }

  String _encode(String data) => percent.encode(data.codeUnits);
}



//  final String grantType = 'client_credentials';
//     final String oauthConsumerKey = key;
//     final String oauthNonce = _randomString(6);
//     final String oauthSignatureMethod = 'HMAC-SHA256';
//     final String oauthTimestamp = timestamp.toString();
//     final String oauthVersion = '1.0';

//     String encoded_base_string;

//     final String encoded_parameter_string;

//     encoded_parameter_string = _encode(create_parameter_String(
//       grant_type: grantType,
//       oauth_consumer_key: oauthConsumerKey,
//       oauth_nonce: oauthNonce,
//       oauth_signature_method: oauthSignatureMethod,
//       oauth_timestamp: oauthTimestamp,
//       oauth_version: oauthVersion,
//     ));

//     encoded_base_string = 'POST' + '&' + _encode(url);
//     encoded_base_string = encoded_base_string + '&' + encoded_parameter_string;
//     print(encoded_base_string);

//     final String access_key_secret = secretKey;
//     final String signing_key = _encode(access_key_secret) + '&';

//     String oauth_signature = createSignature(
//       signingKey: signing_key,
//       encodedBaseString: encoded_base_string,
//     );

//     String encodedOauthSignature = _encode(oauth_signature);

//     final Map<String, String> headers = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization':
//           'OAuth oauth_consumer_key=$oauthConsumerKey,oauth_nonce=$oauthNonce,oauth_signature=$encodedOauthSignature,oauth_signature_method="HMAC-SHA256",oauth_timestamp=$oauthTimestamp,oauth_version="1.0"'
//     };
//     Uri requestUrl = Uri.https("account.api.here.com", "oauth2/token");

//     print(headers);

//     final response = await http.post(
//       requestUrl,
//       headers: headers,
//       // encoding: Encoding.getByName("utf-8"),
//       body: {
//         "grant_type": "client_credentials",
//         'clientId': key,
//         'clientSecret': secretKey,
//       },
//     );

//     print(response.body);

  // String create_parameter_String({
  //   required String grant_type,
  //   required String oauth_consumer_key,
  //   required String oauth_nonce,
  //   required String oauth_signature_method,
  //   required String oauth_timestamp,
  //   required String oauth_version,
  // }) {
  //   String parameter_string = '';
  //   parameter_string = parameter_string + 'grant_type=' + grant_type;
  //   parameter_string =
  //       parameter_string + '&oauth_consumer_key=' + oauth_consumer_key;
  //   parameter_string = parameter_string + '&oauth_nonce=' + oauth_nonce;
  //   parameter_string =
  //       parameter_string + '&oauth_signature_method=' + oauth_signature_method;
  //   parameter_string = parameter_string + '&oauth_timestamp=' + oauth_timestamp;
  //   parameter_string = parameter_string + '&oauth_version=' + oauth_version;

  //   return parameter_string;
  // }
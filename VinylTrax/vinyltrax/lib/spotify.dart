import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class Spotify extends ChangeNotifier {
  static final Logger _log = Logger('Spotify');

/*
##########################################################################
Authentication Data
##########################################################################
*/
  static Map<String, String> get _headers => <String, String>{
        'Authorization': 'Basic ' +
            '003a85697ea64567b8ecc50ccc8bd5c7' +
            ':' +
            '4d10b04baea343d3875114679f649e42'
      };

  static void search(String query) async {
    final authenticate =
        'https://accounts.spotify.com/authorize?client_id=003a85697ea64567b8ecc50ccc8bd5c7&redirect_uri=http://localhost:8888/callback&response_type=code&state=s';
    late var content;

    try {
      content = (await DefaultCacheManager().getSingleFile(
        authenticate,
        headers: _headers,
      ))
          .readAsStringSync();
    } catch (error) {
      print(error);
      return;
    }

    final code = Uri.parse(content).queryParameters['code'];
    print(Uri.parse(content));
    print(code);
    // var code =
    //     'AQAJLWMJgnfVsvnhHZIPwJukAqPZZ1FSt5Bh58r-6fh4f3rWfNt4du2-qWRLGpyU05YeSMWTpQqvvKtlW65qaq07NrvfKXmGmhYwY9x4Y3gqZFM4uDINYt_PV-H9BTRU5FCFvrlMCQzzAhBYRvAr7ip2BkM_Pm_93_OFlt6OQxLJYg';
    // final tokens = getAuthTokens(code, "http://localhost:8888/callback");
    print("authorization complete");
  }

/*
##########################################################################
getAuthTokens

get authentication tokens from spotify using client_id credentials
##########################################################################
*/
  static Future<JsonCodec> getAuthTokens(
      String code, String redirectUri) async {
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to load token with status code ${response.statusCode}');
    }
  }
}

import 'dart:convert';
import 'dart:io';
import './const.dart';

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
            '${Const.SPOTIFY_CLIENT_ID}' +
            ':' +
            '${Const.SPOTIFY_CLIENT_SECRET}'
      };

  static void search(String query) async {
    final authenticate =
        'https://accounts.spotify.com/authorize?client_id=${Const.SPOTIFY_CLIENT_ID}&redirect_uri=https://sagewalsh.github.io/vinyltrax/&response_type=code&status=s';
    late var content;

    try {
      content = await http.post(
        Uri.parse(authenticate),
        // headers: _headers,
        // body: _headers,
      );
    } catch (error) {
      print(error);
      return;
    }

    print(content.body);
    // final code = Uri.parse(content).queryParameters['code'];
    // print(Uri.parse(content));
    // print(code);
    // Randomize given state and check that the state remains the same when returned for security purposes
    // var code =
    //     'AQCpj79CqK6FjPrh0EptTreHgFm56ZtUCtY8tAhUSjBzQPhYjoy1jmbdYikLI_D3FNVVSOyBmJaEqeVHiCOblSRud9QSV86nXU_cYP1eBXFoQGj2yHNczfQidTMa2Dm_-rgqNdCBR2kGv-V8YXUpfo6Zi_mRtjWncajnTJMq-aDYX55Rv8942_Fr';
    // final tokens = getAuthTokens(code, "https://sagewalsh.github.io/vinyltrax");
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

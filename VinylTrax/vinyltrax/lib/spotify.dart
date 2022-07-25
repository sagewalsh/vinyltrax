import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import './const.dart';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class Spotify extends ChangeNotifier {
  static final Logger _log = Logger('Spotify');
  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);

/*
##########################################################################
Spotify Client Credentials
##########################################################################
*/
  static Future<String> authenticate() async {
    // cURL
    var url = 'https://accounts.spotify.com/api/token';
    var headers = {
      'Authorization': 'Basic ' +
          stringToBase64.encode(
              '${Const.SPOTIFY_CLIENT_ID}:${Const.SPOTIFY_CLIENT_SECRET}'),
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    var form = {'grant_type': 'client_credentials'};

    // POST
    late var content;
    try {
      content = await http.post(
        Uri.parse(url),
        headers: headers,
        body: form,
      );
    } catch (e) {
      log(e.toString());
    }

    // Token
    return json.decode(content.body)["access_token"];
  }

/*
##########################################################################
Search

given a search query returns artists, albums, and tracks related
to the query.

{
  albums: [
    [0]: id
    [1]: album name
    [2]: [artist name, artist id]
    [3]: coverart
  , ... ]

  singles: [
    [0]: id
    [1]: single / EP name
    [2]: [artist name, artist id]
    [3]: coverart
  ]

  artists: [
    [0]: id
    [1]: name
    [2]: image
  , ... ]

  tracks: [
    [0]: id
    [1]: name
    [2]: [artist name, artist id]
    [3]: album id
    [4]: album coverart
  ]
}
##########################################################################
*/
  static Future<Map<String, dynamic>> search(String query) async {
    Map<String, dynamic> results = {};

    // ###################################################################
    // authenticate
    // ###################################################################
    authenticate().then((token) async {
      var _headers = {
        "Authorization": "Bearer $token",
        "Content-Type": 'application/json',
      };
      late var content;

      // ###################################################################
      // GET Spotify search query
      // ###################################################################
      try {
        content = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/search?q=$query&type=artist,album,track&limit=50'),
          headers: _headers,
        );
      } catch (e) {
        print(e);
      }

      // ###################################################################
      // Break down json results
      // ###################################################################
      var body = json.decode(content.body);
      var albums = body["albums"]["items"] as List<dynamic>;
      var artists = body["artists"]["items"] as List<dynamic>;
      var tracks = body["tracks"]["items"] as List<dynamic>;

      // ###################################################################
      // Collect Albums, Singles and EPs
      // ###################################################################
      List<dynamic> list = [];
      List<dynamic> singles = [];
      albums.forEach((element) {
        var data = element as Map<String, dynamic>;

        // Default image value if no image provided
        String image;
        (data["images"] as List<dynamic>).isEmpty
            ? image =
                'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
            : image = data["images"][0]["url"];

        // Compiled artists
        var art = [];
        (data["artists"] as List<dynamic>).forEach((element) {
          var temp = element as Map<String, dynamic>;
          art.add([
            temp["name"],
            temp["id"],
          ]);
        });

        // Full Album
        if (data["album_type"] == "single") {
          singles.add([
            data["id"],
            data["name"],
            art,
            image,
          ]);
        }
        // Single or EP
        else if (data["album_type"] == "album") {
          list.add([
            data["id"],
            data["name"],
            art,
            image,
          ]);
        }
      });

      results["albums"] = list;
      results["singles"] = singles;

      // ###################################################################
      // Collect Artists
      // ###################################################################
      list = [];
      artists.forEach((element) {
        var data = element as Map<String, dynamic>;

        // Default image value if no image provided
        String image;
        (data["images"] as List<dynamic>).isEmpty
            ? image =
                'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
            : image = data["images"][0]["url"];

        // Artist data
        list.add([
          data["id"],
          data["name"],
          image,
        ]);
      });

      results["artists"] = list;

      // ###################################################################
      // Collect Tracks
      // ###################################################################
      list = [];
      tracks.forEach((element) {
        var data = element as Map<String, dynamic>;

        // Default image value if no image provided
        String image;
        (data["album"]["images"] as List<dynamic>).isEmpty
            ? image =
                'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
            : image = data["album"]["images"][0]["url"];

        // Compiled artists
        var art = [];
        (data["artists"] as List<dynamic>).forEach((element) {
          var temp = element as Map<String, dynamic>;
          art.add([
            temp["name"],
            temp["id"],
          ]);
        });

        list.add([
          data["id"],
          data["name"],
          art,
          data["album"]["id"],
          image,
        ]);
      });

      results["tracks"] = list;
    });
    return results;
  }
}

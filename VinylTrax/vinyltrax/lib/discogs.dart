import 'dart:convert';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

class CollectionAlbum {
  var id, artist, title, year;

  CollectionAlbum({
    required this.id,
    required this.artist,
    required this.title,
    required this.year,
  });

  factory CollectionAlbum.fromJson(Map<String, dynamic> json) {
    final info = json['basic_information'] as Map<String, dynamic>;
    return CollectionAlbum(
      id: json['instance_id'] as int,
      artist: _oneNameForArtists(info['artists'] as List<dynamic>?),
      title: info['title'] as String,
      year: info['year'] as int,
    );
  }

  @override
  String toString() {
    var string = "\nTitle: " + title.toString();
    string += "\nArtist: " + artist.toString();
    string += "\nYear: " + year.toString();
    return string;
  }
}

String _oneNameForArtists(List<dynamic>? artists) {
  if (artists?.isEmpty ?? true) {
    return '(unknown)';
  }
  return (artists![0]['name'] as String).replaceAllMapped(
    RegExp(r'^(.+) \([0-9]+\)$'),
    (m) => m[1]!,
  );
}

class Collection extends ChangeNotifier {
  static final Logger _log = Logger('Collection');

  static String printAlbumDetails(String query) {
    // print("ALBUM DETAILS");
    // var _uri = _getUri("/database/search?q={$query}");
    // var uri = "";
    // FutureBuilder<String>(
    //   future: _uri,
    //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
    //     if (snapshot.hasData) {
    //       print("Data: " + snapshot.data.toString());
    //       uri = snapshot.data.toString();
    //     } else {
    //       print("No data");
    //     }
    //     return SizedBox(
    //       width: 20,
    //     );
    //   },
    // );
    // // print(uri);
    // return uri;
    _getUri("/database/search?q={$query}");
    return "";
  }

  static Map<String, String> get _headers => <String, String>{
        'Authorization':
            'Discogs key=pHCSKEvAYcdziOzwcJoV, secret=XXFgxrfktsLtrovCnjzUqcSaxgZeJryP',
        'User-Agent': "Sage",
      };

  static void _getUri(String apiPath) async {
    final url = 'https://api.discogs.com$apiPath';
    late String content;

    try {
      content =
          (await DefaultCacheManager().getSingleFile(url, headers: _headers))
              .readAsStringSync();
    } on SocketException catch (e) {
      throw Exception(
          'Could not connect to Discogs. Please check your internet connection and try again later.');
    } on HttpExceptionWithStatus catch (e) {
      // If that response was not OK, throw an error.
      if (e.statusCode == 404) {
        throw Exception(
            'Oops! Couldn\'t find what you\'re looking for on Discogs (404 error).');
      } else if (e.statusCode >= 400) {
        throw Exception(
            'The Discogs service is currently unavailable (${e.statusCode}). Please try again later.');
      }
    } on HttpException catch (e) {
      // If that response was not OK, throw an error.
      throw Exception(
          'The Discogs service is currently unavailable. Please try again later.');
    } on FileSystemException catch (e) {
      _log.severe('Failed to read the chached file', e);
    }
    var results = json.decode(content) as Map<String, dynamic>;
    print(results["results"][0]);
    // _get(results["results"][0]["uri"]);
  }

  static Future<Map<String, dynamic>> _get(String apiPath) async {
    final url = 'https://api.discogs.com$apiPath';
    late String content;

    try {
      content =
          (await DefaultCacheManager().getSingleFile(url, headers: _headers))
              .readAsStringSync();
    } on SocketException catch (e) {
      throw Exception(
          'Could not connect to Discogs. Please check your internet connection and try again later.');
    } on HttpExceptionWithStatus catch (e) {
      // If that response was not OK, throw an error.
      if (e.statusCode == 404) {
        throw Exception(
            'Oops! Couldn\'t find what you\'re looking for on Discogs (404 error).');
      } else if (e.statusCode >= 400) {
        throw Exception(
            'The Discogs service is currently unavailable (${e.statusCode}). Please try again later.');
      }
    } on HttpException catch (e) {
      // If that response was not OK, throw an error.
      throw Exception(
          'The Discogs service is currently unavailable. Please try again later.');
    } on FileSystemException catch (e) {
      _log.severe('Failed to read the chached file', e);
    }

    var results = json.decode(content) as Map<String, dynamic>;
    List<dynamic> releases = results["releases"];
    releases.forEach((element) {
      element as Map<String, dynamic>;
      print("\n\n" +
          CollectionAlbum(
                  artist: element["artist"],
                  title: element["title"],
                  year: element["year"],
                  id: element["id"])
              .toString());
    });
    // print(results["results"][0]["uri"]);
    return json.decode(content);
  }
}

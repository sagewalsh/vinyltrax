import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import './const.dart';

class Collection extends ChangeNotifier {
  static final Logger _log = Logger('Collection');

/*
##########################################################################
Authentication Data
##########################################################################
*/
  static Map<String, String> get _headers => <String, String>{
        'Authorization':
            'Discogs key=${Const.DISCOGS_CONSUMER_KEY}, secret=${Const.DISCOGS_CONSUMER_SECRET}',
        'User-Agent': "VinylTrax",
      };

/*
artistData
Collect data about the artist including name, profile, and bandmembers
*/
  static Future<List<dynamic>> artistData(String artistID) async {
    List<dynamic> data = [];
    var query = "/artists/$artistID";
    final url = "https://api.discogs.com$query";
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

    var results = json.decode(content) as Map<Object?, Object?>;
    data = [
      results["id"].toString(),
      results["name"].toString(),
      results["profile"].toString(),
    ];
    if (results["members"] != null) data.add(results["members"]);
    return data;
  }

/*
TESTING
to replace albumsBy
Returns a Map with the album title as the key and a list as the value:
[0]: AlbumName
[1]: AlbumID
[2]: ArtistName
[3]: CoverArt
*/
  static Future<Map<String, List<String>>> testing(
    String artistName,
    int i,
    Map<String, List<String>> albums,
  ) async {
    var query = "/database/search?q={$artistName}&format=album";
    final url = "https://api.discogs.com$query&page=$i&per_page=500";
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

    var j = json.decode(content);
    var results = j["results"] as List<dynamic>;

    // Breakdown the results
    results.forEach((element) {
      element = element as Map<dynamic, dynamic>;

      // artistName += " ?";
      var artist_album = element["title"].toString().split(" - ");
      var first_last = artistName.split(" ");

      // if statement
      if (!albums.containsKey(element["master_id"]) &&
          (artist_album[0] == artistName)) {
        // print(" ");
        List<String> data = [];
        element.forEach((key, value) {
          // print(key.toString() + ": " + value.toString());
          data.add(artist_album[1]);
          data.add(element["id"].toString());
          data.add(artist_album[0]);
          data.add(element["cover_image"].toString());
        });
        albums.addAll({element["master_id"].toString(): data});
      }
    });
    // print("int i : " + i.toString());
    // print("pages: " + j["pagination"]["pages"].toString());
    if (i == j["pagination"]["pages"]) return albums;
    return testing(artistName, i + 1, albums);
  }

/*
##########################################################################
albumsBy
Albums by a certain Artist given ArtistID

Returns a Map with the album title as the key and a list as the value:
[0]: AlbumName
[1]: AlbumID
[2]: ArtistName
[3]: CoverArt
##########################################################################
*/
  static Future<Map<String, List<String>>> albumsBy(String artistID) async {
    Map<String, List<String>> albums = {};
    Map<String, List<String>> second = {};
    var query = "/artists/$artistID/releases?";
    final url = 'https://api.discogs.com$query&per_page=500';
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

    var results = json.decode(content)["releases"] as List<dynamic>;
    // print(results);

    for (int j = 0; j < results.length; j++) {
      List<String> data = [];

      if (!albums.containsKey(results[j]["title"]) &&
          // results[j]["artist"] != "Various" &&
          // results[j]["main_release"] != null &&
          !results[j]["format"].toString().contains("Single") &&
          results[j]["role"] == "Main") {
        data.add(results[j]["title"]);

        results[j]["main_release"] != null
            ? data.add(results[j]["main_release"].toString())
            : data.add(results[j]["id"].toString());

        data.add(results[j]["artist"]);
        results[j]["thumb"] == ""
            ? data.add(
                "https://images.pexels.com/photos/12509854/pexels-photo-12509854.jpeg?cs=srgb&dl=pexels-mati-mango-12509854.jpg&fm=jpg")
            : data.add(results[j]["thumb"]);
        albums[results[j]["title"]] = data;
      } else if (!second.containsKey(results[j]["title"]) &&
          !results[j]["format"].toString().contains("Single") &&
          results[j]["role"] == "Main") {
        data.add(results[j]["title"]);

        results[j]["main_release"] != null
            ? data.add(results[j]["main_release"].toString())
            : data.add(results[j]["id"].toString());

        data.add(results[j]["artist"]);
        results[j]["thumb"] == ""
            ? data.add(
                "https://images.pexels.com/photos/12509854/pexels-photo-12509854.jpeg?cs=srgb&dl=pexels-mati-mango-12509854.jpg&fm=jpg")
            : data.add(results[j]["thumb"]);
        second[results[j]["title"]] = data;
      }
    }
    // albums.length < 20
    //     ? albums.addEntries(second.entries)
    //     : print(albums.length);
    return albums;
  }

/*
##########################################################################
Album data given albumid

Returns a list of album details:
[0]: [ [ artistName, artistID ], ... ]
[1]: albumName
[2]: [ genre, ... ]
[3]: year
[4]: [ [ trackName, duration ], ... ]
[5]: [ [ contributorName, role, id ], ... ]
[6]: coverArt
##########################################################################
*/
  static Future<List<dynamic>> album(String albumID) async {
    // add checks to albumID
    List<dynamic> details = [];
    var query = "/releases/$albumID";
    final url = "https://api.discogs.com$query";
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

    var results = json.decode(content);

    List<dynamic> list = [];
    (results["artists"] as List<dynamic>).forEach((element) {
      list.add([element["name"], element["id"]]);
    });
    details.add(list);
    list = [];
    details.add(results["title"]);
    details.add(results["genres"]);
    details.add(results["year"]);
    (results["tracklist"] as List<dynamic>).forEach((element) {
      list.add([element["title"], element["duration"]]);
    });
    details.add(list);
    list = [];
    (results["extraartists"] as List<dynamic>).forEach((element) {
      list.add([element["name"], element["role"], element["id"]]);
    });
    details.add(list);
    list = [];
    results["thumb"] == ""
        ? details.add(
            "https://images.pexels.com/photos/12509854/pexels-photo-12509854.jpeg?cs=srgb&dl=pexels-mati-mango-12509854.jpg&fm=jpg")
        : details.add(results["thumb"]);

    // print(" ");
    // print(albumID);
    // details.forEach((element) {
    //   print(element);
    // });
    // print(results["master_id"]);
    return details;
  }

/*
##########################################################################
getArtists
i: 0-19
[i]: "ArtistName"
[i+1]: "ArtistID"
[i+2]: "CoverArt"
##########################################################################
*/
  static Future<List<String>> getArtists(String input) async {
    List<String> artists = [];
    String query = "/database/search?q={$input}";
    final url = 'https://api.discogs.com$query&type=artist&per_page=500';
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

    var results = json.decode(content)["results"] as List<dynamic>;
    // print(results);

    for (int j = 0; j < results.length; j++) {
      if (artists.length >= 30) {
        // print(artists.toString());
        return artists;
      }

      if (!artists.contains(results[j]["title"])) {
        // print("id: " +
        //     results[j]["id"].toString() +
        //     "   title: " +
        //     results[j]["title"].toString());
        artists.add(results[j]["title"]);
        artists.add(results[j]["id"].toString());
        results[j]["thumb"] == ""
            ? artists.add(
                "https://images.pexels.com/photos/12509854/pexels-photo-12509854.jpeg?cs=srgb&dl=pexels-mati-mango-12509854.jpg&fm=jpg")
            : artists.add(results[j]["thumb"]);
        // print(artists.length);
        // print(results);
      }
    }
    // print(artists.toString());
    return artists;
  }

/*
##########################################################################
getAlbums
i: 0-39
[i]: "ArtistName - AlbumName"
[i+1]: "id"
[i+2]: "barcode"
[i+3]: CoverArt
##########################################################################
*/
  static Future<List<String>> getAlbums(String input) async {
    List<String> albums = [];
    String query = "/database/search?q={$input}";
    final url = 'https://api.discogs.com$query&type=release&per_page=500';
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

    var results = json.decode(content)["results"] as List<dynamic>;

    for (int j = 0; j < results.length; j++) {
      if (albums.length >= 40) {
        return albums;
      }

      // If the result is a released album
      if (!albums.contains(results[j]["title"])) {
        var barcodes = results[j]["barcode"] as List<dynamic>;
        for (int k = 0; k < barcodes.length; k++) {
          barcodes[k] = barcodes[k].toString().replaceAll(" ", "");
          if (RegExp(r'^[0-9 ]+$').hasMatch(barcodes[k].toString()) &&
              barcodes[k].toString().length >= 6 &&
              !albums.contains(barcodes[k])) {
            // print(albums.length.toString() +
            //     ".   "
            //         "id: " +
            //     results[j]["id"].toString() +
            //     "   title: " +
            //     results[j]["title"].toString());

            albums.add(results[j]["title"]);
            albums.add(results[j]["id"].toString());
            albums.add(barcodes[k].toString());
            results[j]["thumb"] == ""
                ? albums.add(
                    "https://images.pexels.com/photos/12509854/pexels-photo-12509854.jpeg?cs=srgb&dl=pexels-mati-mango-12509854.jpg&fm=jpg")
                : albums.add(results[j]["thumb"]);
            break;
          }
        }
      }
    }
    // print(albums.toString());
    return albums;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

class Collection extends ChangeNotifier {
  static final Logger _log = Logger('Collection');
/*
##########################################################################
Search
##########################################################################
*/
  // static List<Future<List<String>>> search(String query) {
  //   List<Future<List<String>>> results = [];
  //   // results.add(getArtists("/database/search?q={$query}"));
  //   // results.add(getAlbums("/database/search?q={$query}"));
  //   getArtists("/database/search?q={$query}");
  //   // getAlbums("/database/search?q={$query}");
  //   return results;
  // }

/*
##########################################################################
Authentication Data
##########################################################################
*/
  static Map<String, String> get _headers => <String, String>{
        'Authorization':
            'Discogs key=pHCSKEvAYcdziOzwcJoV, secret=XXFgxrfktsLtrovCnjzUqcSaxgZeJryP',
        'User-Agent': "Sage",
      };

/*
##########################################################################
Albums by a certain Artist given ArtistID


##########################################################################
*/
  static Future<List<String>> albumsBy(String artistID) async {
    List<String> albums = [];
    var query = "/artists/$artistID/releases?sort=year";
    final url = 'https://api.discogs.com$query';
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
    print(results[0]);

    for (int j = 0; j < results.length; j++) {
      // if (albums.length == 20) {
      //   // print(artists.toString());
      //   return albums;
      // }

      // print(results.length);
      if (!albums.contains(results[j]["title"])) {
        print("id: " +
            results[j]["id"].toString() +
            "   title: " +
            results[j]["title"].toString());
        albums.add(results[j]["title"]);
        albums.add(results[j]["id"].toString());
        // print(artists.length);
      }
    }
    // print(results);
    print(albums.length);
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

    details.forEach((element) {
      print(element);
    });
    return details;
  }

/*
##########################################################################
getArtists
i: 0-19
[i]: "ArtistName"
[i+1]: "ArtistID"
##########################################################################
*/
  static Future<List<String>> getArtists(String input) async {
    List<String> artists = [];
    String query = "/database/search?q={$input}";
    final url = 'https://api.discogs.com$query';
    late String quantity;

    try {
      quantity =
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

    var data = json.decode(quantity)["pagination"]["items"];

    for (int i = 1; i < data / 50; i++) {
      // print("page #: " + i.toString());
      final url = 'https://api.discogs.com$query&page=$i';
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
        if (artists.length >= 20) {
          // print(artists.toString());
          return artists;
        }

        if (results[j]["type"] == "artist" &&
            !artists.contains(results[j]["title"])) {
          // print("id: " +
          //     results[j]["id"].toString() +
          //     "   title: " +
          //     results[j]["title"].toString());
          artists.add(results[j]["title"]);
          artists.add(results[j]["id"].toString());
          // print(artists.length);
        }
      }
    }
    print(artists.toString());
    return artists;
  }

/*
##########################################################################
getAlbums
i: 0-39
[i]: "ArtistName - AlbumName"
[i+1]: "id"
[i+2]: "barcode"
##########################################################################
*/
  static Future<List<String>> getAlbums(String input) async {
    List<String> albums = [];
    String query = "/database/search?q={$input}";
    final url = 'https://api.discogs.com$query';
    late String quantity;

    try {
      quantity =
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

    var data = json.decode(quantity)["pagination"]["items"];

    for (int i = 1; i < data / 50; i++) {
      final url = 'https://api.discogs.com$query&page=$i';
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
        if (albums.length >= 60) {
          return albums;
        }

        // If the result is a released album
        if (results[j]["type"] == "release" &&
            !albums.contains(results[j]["title"])) {
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
              break;
            }
          }
        }
      }
    }
    print(albums.toString());
    return albums;
  }

// /*
// ##########################################################################
// Collection Album Data
// ##########################################################################
// */
// class CollectionAlbum {
//   var id, artist, title, year;

//   CollectionAlbum({
//     required this.id,
//     required this.artist,
//     required this.title,
//     required this.year,
//   });

//   factory CollectionAlbum.fromJson(Map<String, dynamic> json) {
//     final info = json['basic_information'] as Map<String, dynamic>;
//     return CollectionAlbum(
//       id: json['instance_id'] as int,
//       artist: _oneNameForArtists(info['artists'] as List<dynamic>?),
//       title: info['title'] as String,
//       year: info['year'] as int,
//     );
//   }

//   @override
//   String toString() {
//     var string = "\nTitle: " + title.toString();
//     string += "\nArtist: " + artist.toString();
//     string += "\nYear: " + year.toString();
//     return string;
//   }
// }

// String _oneNameForArtists(List<dynamic>? artists) {
//   if (artists?.isEmpty ?? true) {
//     return '(unknown)';
//   }
//   return (artists![0]['name'] as String).replaceAllMapped(
//     RegExp(r'^(.+) \([0-9]+\)$'),
//     (m) => m[1]!,
//   );
// }

// /*
// ##########################################################################
// _getUri
// ##########################################################################
// */
//   static void _getUri(String apiPath) async {
//     final url = 'https://api.discogs.com$apiPath';
//     late String content;

//     try {
//       content =
//           (await DefaultCacheManager().getSingleFile(url, headers: _headers))
//               .readAsStringSync();
//     } on SocketException catch (e) {
//       throw Exception(
//           'Could not connect to Discogs. Please check your internet connection and try again later.');
//     } on HttpExceptionWithStatus catch (e) {
//       // If that response was not OK, throw an error.
//       if (e.statusCode == 404) {
//         throw Exception(
//             'Oops! Couldn\'t find what you\'re looking for on Discogs (404 error).');
//       } else if (e.statusCode >= 400) {
//         throw Exception(
//             'The Discogs service is currently unavailable (${e.statusCode}). Please try again later.');
//       }
//     } on HttpException catch (e) {
//       // If that response was not OK, throw an error.
//       throw Exception(
//           'The Discogs service is currently unavailable. Please try again later.');
//     } on FileSystemException catch (e) {
//       _log.severe('Failed to read the chached file', e);
//     }
//     var results = json.decode(content) as Map<String, dynamic>;
//     print(results["results"][0]["title"]);
//     print(results["results"][0]["type"]);
//     // _get(results["results"][0]["uri"]);
//   }

// /*
// ##########################################################################
// _get
// ##########################################################################
// */
//   static Future<Map<String, dynamic>> _get(String apiPath) async {
//     final url = 'https://api.discogs.com$apiPath';
//     late String content;

//     try {
//       content =
//           (await DefaultCacheManager().getSingleFile(url, headers: _headers))
//               .readAsStringSync();
//     } on SocketException catch (e) {
//       throw Exception(
//           'Could not connect to Discogs. Please check your internet connection and try again later.');
//     } on HttpExceptionWithStatus catch (e) {
//       // If that response was not OK, throw an error.
//       if (e.statusCode == 404) {
//         throw Exception(
//             'Oops! Couldn\'t find what you\'re looking for on Discogs (404 error).');
//       } else if (e.statusCode >= 400) {
//         throw Exception(
//             'The Discogs service is currently unavailable (${e.statusCode}). Please try again later.');
//       }
//     } on HttpException catch (e) {
//       // If that response was not OK, throw an error.
//       throw Exception(
//           'The Discogs service is currently unavailable. Please try again later.');
//     } on FileSystemException catch (e) {
//       _log.severe('Failed to read the chached file', e);
//     }

//     var results = json.decode(content) as Map<String, dynamic>;
//     List<dynamic> releases = results["releases"];
//     releases.forEach((element) {
//       element as Map<String, dynamic>;
//       print("\n\n" +
//           CollectionAlbum(
//                   artist: element["artist"],
//                   title: element["title"],
//                   year: element["year"],
//                   id: element["id"])
//               .toString());
//     });
//     // print(results["results"][0]["uri"]);
//     return json.decode(content);
//   }
}

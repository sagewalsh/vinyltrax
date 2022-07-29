import 'dart:convert';
import 'dart:developer';
import '../const.dart';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;

class Spotify extends ChangeNotifier {
  static final Logger _log = Logger('Spotify');
  static final Codec<String, String> stringToBase64 = utf8.fuse(base64);

/*
##########################################################################
artist

[0]: image
[1]: genres
##########################################################################
*/
  static Future<List<dynamic>> artist(String artistid) async {
    List<dynamic> data = [];
    // ###################################################################
    // authenticate
    // ###################################################################
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
    var token = json.decode(content.body)["access_token"];

    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json',
    };

    // ###################################################################
    // GET albums and compilations
    // ###################################################################
    try {
      content = await http.get(
        Uri.parse('https://api.spotify.com/v1/artists/$artistid'),
        headers: _headers,
      );
    } catch (e) {
      print(e);
    }

    // ###################################################################
    // Break down json results
    // ###################################################################
    var body = json.decode(content.body);
    // body.forEach((key, value){
    //   print(key.toString() + ": " + value.toString());
    // });

    Set<String> genres = {};
    if (body["genres"] != null)
      body["genres"].forEach((type) {
        if (type.toString().toLowerCase().contains("blue") ||
            type.toString().toLowerCase().contains("r&b")) genres.add("Blues");

        if (type.toString().toLowerCase().contains("pop")) genres.add("Pop");

        if (type.toString().toLowerCase().contains("military"))
          genres.add("Brass and Military");

        if (type.toString().toLowerCase().contains("children"))
          genres.add("Children's");

        if (type.toString().toLowerCase().contains("classical"))
          genres.add("Classical");

        if (type.toString().toLowerCase().contains("electro") ||
            type.toString().toLowerCase().contains("dubstep") ||
            type.toString().toLowerCase().contains("techno"))
          genres.add("Electronic");

        if (type.toString().toLowerCase().contains("folk") ||
            type.toString().toLowerCase().contains("country"))
          genres.add("Folk and Country");

        if (type.toString().toLowerCase().contains("funk") ||
            type.toString().toLowerCase().contains("soul"))
          genres.add("Funk / Soul");

        if (type.toString().toLowerCase().contains("hip hop") ||
            type.toString().toLowerCase().contains("rap"))
          genres.add("Hip Hop");

        if (type.toString().toLowerCase().contains("jazz")) genres.add("Jazz");

        if (type.toString().toLowerCase().contains("latin"))
          genres.add("Latin");

        if (type.toString().toLowerCase().contains("reggae"))
          genres.add("Reggae");

        if (type.toString().toLowerCase().contains("rock") ||
            type.toString().toLowerCase().contains("punk") ||
            type.toString().toLowerCase().contains("metal")) genres.add("Rock");
      });

    data = [
      body["images"][0]["url"],
      genres.toList(),
    ];

    return data;
  }

/*
##########################################################################
albumsBy

returns:
[0]: id
[1]: name
[2]: artists
[3]: coverart
[4]: year
##########################################################################
*/
  static Future<Map<String, List<dynamic>>> albumsBy(String artistid) async {
    Map<String, List<dynamic>> returning = {};
    Map<String, List<dynamic>> albums;
    // ###################################################################
    // authenticate
    // ###################################################################
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
    var token = json.decode(content.body)["access_token"];

    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json',
    };

    int offset = 0;
    var body;
    List<dynamic> data;

    List<dynamic> val = [];

    while (true) {
      // ###################################################################
      // GET albums and compilations
      // ###################################################################
      try {
        content = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/artists/$artistid/albums?offset=$offset&limit=50&include_groups=album,compilation'),
          headers: _headers,
        );
      } catch (e) {
        print(e);
      }

      // ###################################################################
      // Break down json results
      // ###################################################################
      body = json.decode(content.body);

      // body.forEach((key, value) {
      //   print(key.toString() + ": " + value.toString());
      // });

      data = body["items"] as List<dynamic>;

      // (data[0] as Map<String, dynamic>).forEach((key, value) {
      //   print(key.toString() + ": " + value.toString());
      // });

      // ###################################################################
      // Collect Album data
      // ###################################################################
      albums = {};
      data.forEach((record) {
        // Don't repeat albums
        if (!albums.containsKey(record["name"])) {
          // Default image if one is not provided
          String image;
          (record["images"] as List<dynamic>).isEmpty
              ? image =
                  'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
              : image = record["images"][0]["url"];

          // Compiled artists
          var art = [];
          (record["artists"] as List<dynamic>).forEach((element) {
            var temp = element as Map<String, dynamic>;
            art.add([
              temp["name"],
              temp["id"],
            ]);
          });

          // album data
          albums[record["name"].toString()] = [
            record["id"],
            record["name"],
            art,
            image,
            record["release_date"].toString().split("-")[0],
          ];
        }
      });

      val += albums.values.toList();
      val.sort(((a, b) => a[4].toString().compareTo(b[4].toString())));
      returning["albums"] = val;

      offset += 50;
      if (offset > body["total"]) break;
    }

    offset = 0;
    val = [];
    while (true) {
      // ###################################################################
      // GET singles
      // ###################################################################
      try {
        content = await http.get(
          Uri.parse(
              'https://api.spotify.com/v1/artists/$artistid/albums?offset=$offset&limit=50&include_groups=single'),
          headers: _headers,
        );
      } catch (e) {
        print(e);
      }

      // ###################################################################
      // Break down json results
      // ###################################################################
      body = json.decode(content.body);
      data = body["items"] as List<dynamic>;

      // body.forEach((key, value) {
      //   print(key.toString() + ": " + value.toString());
      // });

      // (data[0] as Map<String, dynamic>).forEach((key, value) {
      //   print(key.toString() + ": " + value.toString());
      // });

      // ###################################################################
      // Collect Album data
      // ###################################################################
      albums = {};
      data.forEach((record) {
        // Don't repeat albums
        if (!albums.containsKey(record["name"])) {
          // Default image if one is not provided
          String image;
          (record["images"] as List<dynamic>).isEmpty
              ? image =
                  'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
              : image = record["images"][0]["url"];

          // Compiled artists
          var art = [];
          (record["artists"] as List<dynamic>).forEach((element) {
            var temp = element as Map<String, dynamic>;
            art.add([
              temp["name"],
              temp["id"],
            ]);
          });

          // album data
          albums[record["name"].toString()] = [
            record["id"],
            record["name"],
            art,
            image,
            record["release_date"].toString().split("-")[0],
          ];
        }
      });

      val += albums.values.toList();
      val.sort(((a, b) => a[4].toString().compareTo(b[4].toString())));
      returning["singles"] = val;

      offset += 50;
      if (offset > body["total"]) break;
    }

    // ###################################################################
    // GET albums artist appears on
    // ###################################################################
    try {
      content = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/artists/$artistid/albums?limit=50&include_groups=appears_on'),
        headers: _headers,
      );
    } catch (e) {
      print(e);
    }

    // ###################################################################
    // Break down json results
    // ###################################################################
    body = json.decode(content.body);
    data = body["items"] as List<dynamic>;

    // (data[0] as Map<String, dynamic>).forEach((key, value) {
    //   print(key.toString() + ": " + value.toString());
    // });

    // ###################################################################
    // Collect Album data
    // ###################################################################
    albums = {};
    data.forEach((record) {
      // Don't repeat albums
      if (!albums.containsKey(record["name"])) {
        // Default image if one is not provided
        String image;
        (record["images"] as List<dynamic>).isEmpty
            ? image =
                'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
            : image = record["images"][0]["url"];

        // Compiled artists
        var art = [];
        (record["artists"] as List<dynamic>).forEach((element) {
          var temp = element as Map<String, dynamic>;
          art.add([
            temp["name"],
            temp["id"],
          ]);
        });

        // album data
        albums[record["name"].toString()] = [
          record["id"],
          record["name"],
          art,
          image,
          record["release_date"].toString().split("-")[0],
        ];
      }
    });

    val = albums.values.toList();
    val.sort(((a, b) => a[4].toString().compareTo(b[4].toString())));
    returning["appears"] = val;

    // returning.forEach((key, value) {
    //   print(key.toString() + ": " + value.toString());
    // });

    return returning;
  }

/*
##########################################################################
album

given an albumID, returns a list of album details:
[0]: [ [ artist name, artist id ] ]
[1]: album name
[2]: [ genres ]
[3]: year
[4]: [ [ track name, duration, [ feat. artist name, feat. artist id ] ] ]
[5]: coverart
##########################################################################
*/
  static Future<List<dynamic>> album(String albumid) async {
    List<dynamic> details = [];

    // ###################################################################
    // authenticate
    // ###################################################################
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
    var token = json.decode(content.body)["access_token"];

    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json',
    };

    // ###################################################################
    // GET Spotify search query
    // ###################################################################
    try {
      content = await http.get(
        Uri.parse('https://api.spotify.com/v1/albums/$albumid?'),
        headers: _headers,
      );
    } catch (e) {
      print(e);
    }
    var body = json.decode(content.body);

    // PRINT DATA
    // (body as Map<String, dynamic>).forEach((key, value) {
    //   print(key.toString() + ": " + value.toString());
    // });

    // Compiled artists
    var art = [];
    var id = [];
    var gen = [];
    (body["artists"] as List<dynamic>).forEach((element) {
      art.add([
        element["name"],
        element["id"],
      ]);
      id.add(element["id"]);
    });

    // Compiled tracks
    var tracks = [];
    (body["tracks"]["items"] as List<dynamic>).forEach((element) {
      // calculate track duration
      var time = "";
      if (element["duration_ms"] != null) {
        element["duration_ms"] > 3599999
            ? time = Duration(milliseconds: element["duration_ms"])
                .toString()
                .split(".")[0]
            : time = new Duration(milliseconds: element["duration_ms"])
                .toString()
                .substring(2, 7);
      }

      // compile track details
      var data = [
        element["name"],
        time,
        [],
      ];

      // compile featured artists
      (element["artists"] as List<dynamic>).forEach((artist) {
        if (!id.contains(artist["id"])) {
          (data[2] as List<dynamic>).add([
            artist["name"],
            artist["id"],
          ]);
        }
      });

      tracks.add(data);
    });

    // Compile genres
    var data = await artist(id[0]);

    // Default image value if no image provided
    String image;
    (body["images"] as List<dynamic>).isEmpty
        ? image =
            'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
        : image = body["images"][0]["url"];

    details = [
      art,
      body["name"],
      data[1],
      body["release_date"].toString().split("-")[0],
      tracks,
      image,
    ];

    // details.forEach((element) {
    //   print(element);
    // });

    return details;
  }

/*
##########################################################################
barcode 

This is the helper function for the Discogs Barcode Search.
Given artist and album names returned by the Discogs Barcode function,
returns album details.

[0]: [ [ artist name, artist id ] ]
[1]: album name
[2]: [ genres ]
[3]: year
[4]: [ [ track name, duration, [ feat. artist name, feat. artist id ] ] ]
[5]: coverart
[6]: id
##########################################################################
*/
  static Future<List<dynamic>> barcode(String artist, String album) async {
    var details = [];
    // ###################################################################
    // authenticate
    // ###################################################################
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
    var token = json.decode(content.body)["access_token"];

    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json',
    };

    // ###################################################################
    // GET Spotify search query
    // ###################################################################
    try {
      content = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/search?q=$artist+album:$album&type=album&limit=1'),
        headers: _headers,
      );
    } catch (e) {
      print(e);
    }
    var results = json.decode(content.body)["albums"]["items"];
    if (results.isNotEmpty) {
      var url = json.decode(content.body)["albums"]["items"][0]["href"];

      // print(url);

      // ###################################################################
      // GET album details
      // ###################################################################
      try {
        content = await http.get(
          Uri.parse(url),
          headers: _headers,
        );
      } catch (e) {
        print(e);
      }
      var body = json.decode(content.body);

      // Compiled artists
      var art = [];
      var id = [];
      var gen = [];
      (body["artists"] as List<dynamic>).forEach((element) {
        art.add([
          element["name"],
          element["id"],
        ]);
        id.add(element["id"]);
      });

      // Compiled tracks
      var tracks = [];
      (body["tracks"]["items"] as List<dynamic>).forEach((element) {
        // calculate track duration
        var time = "";
        if (element["duration_ms"] != null) {
          element["duration_ms"] > 3599999
              ? time = Duration(milliseconds: element["duration_ms"])
                  .toString()
                  .split(".")[0]
              : time = new Duration(milliseconds: element["duration_ms"])
                  .toString()
                  .substring(2, 7);
        }

        // compile track details
        var data = [
          element["name"],
          time,
          [],
        ];

        // compile featured artists
        (element["artists"] as List<dynamic>).forEach((artist) {
          if (!id.contains(artist["id"])) {
            (data[2] as List<dynamic>).add([
              artist["name"],
              artist["id"],
            ]);
          }
        });

        tracks.add(data);
      });

      // Compile genres
      var data = await Spotify.artist(id[0]);

      // Default image value if no image provided
      String image;
      (body["images"] as List<dynamic>).isEmpty
          ? image =
              'https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg'
          : image = body["images"][0]["url"];

      details = [
        art,
        body["name"],
        data[1],
        body["release_date"].toString().split("-")[0],
        tracks,
        image,
        body["id"],
      ];
    }
    return details;
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
    [0]: album id
    [1]: name
    [2]: [artist name, artist id]
    [3]: album coverart
    [4]: track id
  ]
}
##########################################################################
*/
  static Future<Map<String, List<dynamic>>> search(String query) async {
    Map<String, List<dynamic>> results = {};

    // ###################################################################
    // authenticate
    // ###################################################################
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
    var token = json.decode(content.body)["access_token"];

    var _headers = {
      "Authorization": "Bearer $token",
      "Content-Type": 'application/json',
    };

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

      // print("");
      // data.forEach((key, value) {print(key.toString() + ": " + value.toString());});

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

    // print(list[0][0]);
    results["artists"] = list;

    // ###################################################################
    // Collect Tracks
    // ###################################################################
    list = [];
    tracks.forEach((element) {
      var data = element as Map<String, dynamic>;

      if (data["album"]["album_type"] != "single") {
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
          data["album"]["id"],
          data["name"],
          art,
          image,
          data["id"],
        ]);
      }
    });
    results["tracks"] = list;

    // results.forEach((key, value) {
    //   print(key.toString() + ": " + value.toString());
    // });
    return results;
  }

  /*
  ##########################################################################
  empty

  Returns an empty Future array
  ##########################################################################
  */
  static Future<List<dynamic>> empty() async {
    return [];
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:googleapis/androidpublisher/v3.dart';
import '../discogs/discogs.dart';
import '../spotify/spotify.dart';
import 'package:diacritic/diacritic.dart';
import 'package:uuid/uuid.dart';
import '../auth.dart';

class Database {
  static final fb = FirebaseDatabase.instance;
  // static final ref = fb.ref();
  static DatabaseReference userRef = fb.ref();
  static final uuid = Uuid();

  static void clear() async {
    await fb.ref().remove();
  }

  static Future<bool> createUser(String userid, String email) async {
    var timestamp = DateTime.now();
    String date = (timestamp.month.toString() +
        "-" +
        timestamp.day.toString() +
        "-" +
        timestamp.year.toString());
    await fb.ref().update({
      "$userid": {
        "Albums": "",
        "Artists": "",
        "Wishlist": "",
        "User": {
          "Email": email,
          "Name": "Anonymous",
          "Date": date,
        }
      }
    });
    return true;
  }

  static Future<List<String>> getUser() async {
    List<String> user = [];
    var snapshot = await userRef.child("User").get();
    if (snapshot.exists) {
      var value = snapshot.value as Map<dynamic, dynamic>;
      user = [
        value["Name"],
        value["Email"],
        value["Date"],
      ];
    }
    return user;
  }

  static void logIn(String userid) {
    userRef = fb.ref().child(userid);
  }

  static void updateName(String name) async {
    await userRef.update({
      "User/Name": name,
    });
  }

  static void updateEmail(String email) async {
    await userRef.update({
      "User/Email": email,
    });
  }

  /*
  createAlbum

  Creating your own album with the bare minimum data to 
  act as a placeholder for unrecognized albums.

  artist: [ artist name, artist id ]
  album: "album name"
  format: "Vinyl" / "CD"
  year: "year"
  */
  static void createAlbum({
    required List<dynamic> artist,
    required String album,
    required String format,
    required String year,
  }) {
    var id = "CREATED" + uuid.v4().toString();
    if (format == "Vinyl")
      id += "1";
    else if (format == "CD") id += "2";

    // print(id);

    var genre = [];
    String image =
        "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg";
    Spotify.artist(artist[1].toString()).then((value) async {
      if (value[0] != null) image = value[0];
      if (value[1] != null) genre = value[1];
      var creation = [
        id,
        format,
        [artist],
        album,
        genre,
        year,
        [],
        image,
      ];
      addSpotToInv(creation);
    });
  }

  /*
  Returns only the display information from Album JSON
  in order of the Album's name.

  Data is returned as a list of text widgets
  [0]: Album Name
  [1]: Artist Name
  [2]: Cover Art
  [3]: Album ID
  [4]: format
  */
  static Future<List<List<dynamic>>> displayByName() async {
    // Get a snapshot from the album database
    final snapshot = await userRef.child("Albums").get();

    if (snapshot.exists && snapshot.value != "") {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Artist": name, "Name": album name, ... }, Map {...}, ]
      var list = values.entries.toList();

      // Sort the list of album data based on the album name
      list.sort(((a, b) {
        var albumA = (a.value as Map<Object?, Object?>)["Name"] as String;
        var albumB = (b.value as Map<Object?, Object?>)["Name"] as String;
        if (albumA.startsWith("(")) {
          albumA = albumA.substring(1);
        }
        if (albumB.startsWith("(")) {
          albumB = albumB.substring(1);
        }
        albumA = removeDiacritics(albumA);
        albumB = removeDiacritics(albumB);
        return albumA.toLowerCase().compareTo(albumB.toLowerCase());
      }));

      //Convert list of maps into list of widgets
      return _displayAlbum(list);
    } else {
      // Something went wrong when getting a snapshot from the database
      print("No data available");
      return [];
    }
  }

  /*
  Returns only the display information from Album JSON of
  a given genre.

  Data returned as a list of text widgets
  [
    [0]: albumID
    [1]: albumName
    [2]: [ [ artistName, artistID ], ... ]
    [3]: coverArt
    [4]: format
    [5]: year
  ,
  ...
  ]
  */
  static Future<List<List<dynamic>>> displayByGenre(
      String genre, String format) async {
    // Get a snapshot from the album database
    final snapshot = await userRef.child("Albums").get();

    if (snapshot.exists && snapshot.value != "") {
      // List of album data that are of the given genre
      List<MapEntry<Object?, Object?>> list = [];
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;

      // For every album in the database: check if it is the correct genre
      values.forEach((key, value) {
        var album = value as Map<Object?, Object?>;
        if (album["Genres"] != null &&
            (album["Genres"] as List<Object?>).contains(genre) &&
            (album["Format"] == format || format == "All")) {
          // Add the album to the list
          list += {key: value}.entries.toList();
        }
      });

      // Convert list of maps into list of widgets
      var ordered = _displayAlbum(list);
      ordered.sort(
        (a, b) {
          // Order by album name:
          // return a[1].toString().compareTo(b[1].toString());

          // Order by Artist name:
          String aart = "";
          var data = a[2] as List<dynamic>;
          for (int i = 0; i < data.length; i++) {
            aart += data[i][0].toString().toLowerCase();
            if (i + 1 < data.length) {
              aart += " & ";
            }
          }

          String bart = "";
          data = b[2] as List<dynamic>;
          for (int j = 0; j < data.length; j++) {
            bart += data[j][0].toString().toLowerCase();
            if (j + 1 < data.length) {
              bart += " & ";
            }
          }

          aart = removeDiacritics(aart);
          bart = removeDiacritics(bart);
          return aart.compareTo(bart);
        },
      );
      return ordered;
    } else {
      return [];
    }
  }

  /*
  Returns only the display information from Album JSON of
  a given genre.

  Data returned as a list of text widgets
  [
    [0]: albumID
    [1]: albumName
    [2]: [ [ artistName, artistID ], ... ]
    [3]: coverArt
    [4]: format
    [5]: year
  ,
  ...
  ]
  */
  static Future<List<List<dynamic>>> displayByCategory(
      String category, String format) async {
    // Get a snapshot from the album database
    final snapshot = await userRef.child("Albums").get();

    if (snapshot.exists && snapshot.value != "") {
      // List of album data that are of the given genre
      List<MapEntry<Object?, Object?>> list = [];
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;

      // For every album in the database: check if it is the correct genre
      values.forEach((key, value) {
        var album = value as Map<Object?, Object?>;
        if (album["Category"] != null &&
            (album["Category"] as Map<Object?, Object?>)
                .containsValue(category) &&
            (album["Format"] == format || format == "All")) {
          // Add the album to the list
          list += {key: value}.entries.toList();
        }
      });

      // Convert list of maps into list of widgets
      var ordered = _displayAlbum(list);
      ordered.sort(
        (a, b) {
          // Order by album name:
          // return a[1].toString().compareTo(b[1].toString());

          // Order by Artist name:
          String aart = "";
          var data = a[2] as List<dynamic>;
          for (int i = 0; i < data.length; i++) {
            aart += data[i][0].toString().toLowerCase();
            if (i + 1 < data.length) {
              aart += " & ";
            }
          }

          String bart = "";
          data = b[2] as List<dynamic>;
          for (int j = 0; j < data.length; j++) {
            bart += data[j][0].toString().toLowerCase();
            if (j + 1 < data.length) {
              bart += " & ";
            }
          }

          aart = removeDiacritics(aart);
          bart = removeDiacritics(bart);
          return aart.compareTo(bart);
        },
      );
      return ordered;
    } else {
      return [];
    }
  }

  /*
  _albumDisplay
  Helper Function  
  Given a list of map entries containing album data:
  Returns a list of text widgets of album data used when 
  displaying albums.

  Converts a list of map entries filled with album data into 
  a dynamic list

  [
    [0]: albumID
    [1]: albumName
    [2]: [ [ artistName, artistID ], ... ]
    [3]: coverArt
    [4]: format
    [5]: year
  ,
  ...
  ]
  */
  static List<List<dynamic>> _displayAlbum(
      List<MapEntry<Object?, Object?>> list) {
    List<List<dynamic>> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      var temp = [
        albumdata["UniqueID"],
        albumdata["Name"],
        albumdata["Artist"],
        albumdata["Cover"],
        albumdata["Format"],
        albumdata["Year"],
      ];
      results.add(temp);
      // print(albumdata["UniqueID"]);
      // print(albumdata["Category"]);
    });
    return results;
  }

/*
Returns all of the artists in the database in order of
the Artist's name. 

Data is returned as a list of text widgets
[0]: Artist Name
[1]: Artist ID
[2]: Image
*/
  static Future<List<dynamic>> artists(String format) async {
    // Get a snapshot from the artist database
    final snapshot = await userRef.child("Artists").get();
    // List of artists to return
    List<dynamic> results = [];

    if (snapshot.exists && snapshot.value != "") {
      // Map{ ArtistID: {Artist Data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Name": Artist name, "Albums": [], ... }, Map{...} ]
      var list = values.entries.toList();

      // Sort the list of artists based on their name
      list.sort(((a, b) {
        var albumA = (a.value as Map<Object?, Object?>)["Name"].toString();
        var albumB = (b.value as Map<Object?, Object?>)["Name"].toString();
        albumA = removeDiacritics(albumA);
        albumB = removeDiacritics(albumB);
        return albumA.toLowerCase().compareTo(albumB.toLowerCase());
      }));

      // Add each artist and their id to the returning list
      list.forEach((element) {
        var artistdata = element.value as Map<Object?, Object?>;
        // print(artistdata);
        // print(element);
        if (format == "All") {
          // print("all entered");
          results.add(artistdata["Name"]);
          results.add(artistdata["UniqueID"]);
          results.add(artistdata["Image"]);
        } else {
          // print("else entered");
          var albums = artistdata["Albums"] as Map<Object?, Object?>;

          // print(albums);
          albums.forEach((key, value) {
            // print(key.toString() + ": " + value.toString());
            if (!results.contains(artistdata["Name"]) &&
                ((value.toString().endsWith("1") && format == "Vinyl") ||
                    value.toString().endsWith("2") && format == "CD")) {
              results.add(artistdata["Name"]);
              results.add(artistdata["UniqueID"]);
              results.add(artistdata["Image"]);
            }
          });
        }
      });
    }
    // print(results);
    // Return artists and their ids
    return results;
  }

/*
Given an Artist ID:
Returns a list of text widgets of album data for each album
that artist has in the database.

Data is returned as a list of text widgets:
  [
    [0]: albumID
    [1]: albumName
    [2]: [ [ artistName, artistID ], ... ]
    [3]: coverArt
    [4]: format
    [5]: year
  ,
  ...
  ]
*/
  static Future<List<List<dynamic>>> albumsBy(
      {required String artistid, String format = "All"}) async {
    // Get a snapshot from the ARTIST database
    final snapArtist = await userRef.child("Artists").get();
    // Get a snapshot from the ALBUM database
    final snapAlbum = await userRef.child("Albums").get();

    // Map{ AlbumID: {Album data} }
    var albumValues = snapAlbum.value as Map<Object?, Object?>;
    // List of mapped album data
    List<MapEntry<Object?, Object?>> albums = [];

    if (snapArtist.exists) {
      // Map{ ArtistID: {Artist data} }
      var values = snapArtist.value as Map<Object?, Object?>;

      // If the artist is in the database
      if (values.containsKey(artistid)) {
        // Map{ "Name": name, "Albums": [], ... }
        var artist = values[artistid] as Map<Object?, Object?>;
        // AlbumIDs of the albums the given artist has created
        var albumids = artist["Albums"] as Map<Object?, Object?>;

        albumids.forEach((key, id) {
          if (albumValues.containsKey(id.toString()) &&
              ((id.toString().endsWith("1") && format == "Vinyl") ||
                  (id.toString().endsWith("2") && format == "CD") ||
                  format == "All")) {
            // Add album data to returned list
            albums +=
                {id.toString(): albumValues[id.toString()]}.entries.toList();
          }
        });

        // print("hello");

        // Return the album data of the given Artist's albums
        var list = _displayAlbum(albums);

        list.sort((a, b) {
          return b[5].toString().compareTo(a[5].toString());
        });

        return list;
      }
    }
    return [];
  }

/*
albumDetails
Given an AlbumID:
Returns a list of the albums full data in the JSON.

Data is returned as a list of strings
[0]: [ [ artistName, artistID ], ... ]
[1]: albumName
[2]: [ genre, ... ]
[3]: year
[4]: [ [ trackName, duration ], ... ]
[5]: [ [ contributorName, role, id ], ... ]
[6]: coverArt
*/
  static Future<List<dynamic>> albumDetails(String albumid) async {
    // Get a snapshot from the database
    final snapshot = await userRef.child("Albums").get();

    // print("albumDetails id: " + albumid);

    if (snapshot.exists) {
      // Map{ albumID: {albumData} }
      var values = snapshot.value as Map<Object?, Object?>;
      if (values.containsKey(albumid)) {
        var list = {albumid: values[albumid.toString()]}.entries.toList();
        // Convert list of maps into list of string data
        return _albumDetails(list);
      }
    }
    return [];
  }

/*
_albumDetails
Helper Function.
Given a list of map entries containing album data:
Returns a list of text widgets of full album used when
displaying a specific album's data.

Converts a list of map entries filled with album data into a 
list of text widgets.

Data is returned as a list of strings
[0]: [ [ artistName, artistID ], ... ]
[1]: albumName
[2]: [ genre, ... ]
[3]: year
[4]: [ [ trackName, duration ], ... ]
[5]: [ [ contributorName, role, id ], ... ]
[6]: coverArt
[7]: format
*/
  static List<dynamic> _albumDetails(List<MapEntry<Object?, Object?>> list) {
    List<dynamic> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      results.add(albumdata["Artist"]);
      results.add(albumdata["Name"]);
      results.add(albumdata["Genres"]);
      results.add(albumdata["Year"]);
      results.add(albumdata["Tracklist"]);
      results.add(albumdata["Contributors"]);
      results.add(albumdata["Cover"]);
      results.add(albumdata["Format"]);
      print(albumdata["Category"]);
    });
    return results;
  }

/*
search
[
  [
    0: Artist Name
    1: Unique ID
    2: Image
  ],
]
Search the user's inventory for given text
*/
  static Future<List<List<dynamic>>> search(String input) async {
    List<List<dynamic>> results = [];
    // Get a snapshot of the Artists database
    final snapArtist = await userRef.child("Artists").get();
    // Get a snapshot of the Albums database
    final snapAlbums = await userRef.child("Albums").get();

    if (snapArtist.exists && snapAlbums.exists) {
      // Map{ ArtistID: {Artist data} }
      var artvalues = snapArtist.value as Map<Object?, Object?>;
      // Map{ AlbumID: {Album data} }
      var albumValues = snapAlbums.value as Map<Object?, Object?>;
      // List of albums
      List<MapEntry<Object?, Object?>> list = [];

      // Traverse the artists looking for the inputted name
      artvalues.forEach((key, value) {
        list = [];
        var artist = value as Map<Object?, Object?>;

        // If the input relates to an artist name
        if (artist["Name"]
                .toString()
                .toLowerCase()
                .contains(input.toLowerCase()) ||
            input
                .toLowerCase()
                .contains(artist["Name"].toString().toLowerCase())) {
          // Add the artist to the results
          results.add([
            artist["Name"],
            artist["UniqueID"],
            artist["Image"],
          ]);
          // AlbumIDs of the albums the given artist has created
          var albumids = artist["Albums"] as Map<Object?, Object?>;

          albumids.forEach((key, value) {
            if (albumValues.containsKey(value.toString())) {
              // Add album data to returned list
              list = {value.toString(): albumValues[value.toString()]}
                  .entries
                  .toList();

              // Return the album data of the given Artist's albums
              // results.add(_displayAlbum(list));
              results.addAll(_displayAlbum(list));
            }
          });
        }
      });

      list = [];
      albumValues.forEach((key, value) {
        var album = value as Map<Object?, Object?>;

        if (album["Name"]
                .toString()
                .toLowerCase()
                .contains(input.toLowerCase()) ||
            input
                .toLowerCase()
                .contains(album["Name"].toString().toLowerCase())) {
          list += {key: value}.entries.toList();
        }
      });
      if (list.isNotEmpty) results.addAll(_displayAlbum(list));
    }
    return results;
  }

/*
#############################################################################
removeAlbum

remove album from inventory
#############################################################################
*/
  static void removeAlbum(String albumID) async {
    // Get album data
    var snapshot = await userRef.child("Albums/$albumID").get();
    if (snapshot.exists) {
      var values = snapshot.value as Map<Object?, Object?>;

      // Get IDs of artists on the album
      List<String> artistIDs = [];
      (values["Artist"] as List<dynamic>).forEach((element) {
        artistIDs.add(element[1].toString());
        // print(element[1]);
      });

      // Delete the album from album database
      await userRef.child("Albums/$albumID").remove();

      // Delete the album under each artist
      artistIDs.forEach((element) async {
        var artsnap = await userRef.child("Artists/$element").get();
        if (artsnap.exists) {
          var data = artsnap.value as Map<Object?, Object?>;
          Map<Object?, Object?> albums = {};
          albums.addAll(data["Albums"] as Map<Object?, Object?>);
          albums.removeWhere((key, value) => value == albumID);

          // If the artist has no more albums: delete the artist
          if (albums.isEmpty) {
            await userRef.child("Artists/$element").remove();
          }
          // Otherwise: update the artist's albums list
          else {
            await userRef.update({
              "Artists/$element/Albums": albums,
            });
          }
        }
      });
    }
  }

/*
#############################################################################
Add an album to your inventory

Given Album Data from Discogs in the form:
[0]: albumID
[1]: format
[2]: [ [ artistName, artistID ], ... ]
[3]: albumName
[4]: [ genre, ... ]
[5]: year
[6]: [ [ trackName, duration ], ... ]
[7]: [ [ contributorName, role, id ], ... ]
[8]: CoverArt
#############################################################################
*/
  static Future<String> addDisToInv(List<dynamic> albumdata) async {
    // If album was in wishlist: delete it
    var wishshot = await userRef.child("Wishlist/${albumdata[0]}").get();
    if (wishshot.exists) {
      await userRef.child("Wishlist/${albumdata[0]}").remove();
    }

    // var id = uuid.v4();

    // Vinyl Copies of records get a 1 added to the end
    // CD Copies of records get a 2 added to the end
    if (albumdata[1] == "Vinyl")
      albumdata[0] += "1";
    else if (albumdata[1] == "CD") albumdata[0] += "2";

    var snapshot = await userRef.child("Albums/${albumdata[0]}").get();
    if (!snapshot.exists) {
      // Add album data to database
      await userRef.update({
        "Albums/${albumdata[0]}": {
          "UniqueID": albumdata[0],
          "Name": albumdata[3],
          "Artist": albumdata[2],
          "Year": albumdata[5],
          "Genre": albumdata[4],
          "Cover": albumdata[8],
          "Tracklist": albumdata[6],
          "Contributors": albumdata[7],
          "Format": albumdata[1],
        }
      });
      // Add album to each artist's data
      (albumdata[2] as List<dynamic>).forEach((element) async {
        var snapshot = await userRef.child("Artists/${element[1]}").get();
        // If the artist exitst
        if (snapshot.exists) {
          var snapalbum = await userRef.child("Artists/${element[1]}/Albums");
          var newAlbum = snapalbum.push();
          newAlbum.set(albumdata[0]);
        }
        // If the artist doesn't exist
        else {
          print("snapshot does not exist");
          String image =
              "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg";
          Collection.artistData(element[1].toString()).then((value) async {
            if (value[3] != null) {
              image = value[3][0]["resource_url"];
            }

            // Create new artist
            await userRef.update({
              "Artists/${element[1]}": {
                "UniqueID": element[1],
                "Name": element[0],
                "Image": image,
              }
            });
            var snapalbum = await userRef.child("Artists/${element[1]}/Albums");
            var newAlbum = snapalbum.push();
            newAlbum.set(albumdata[0]);
            ;
          });
        }
      });
      return "Album Added!";
    } else {
      return "You already own this album.";
    }
  }

/*
#############################################################################
addToWish

Add an album to your wishlist

Given Album Data from Discogs in the form:
[0]: albumID
[1]: [ [ artistName, artistID ], ... ]
[2]: albumName
[3]: [ genre, ... ]
[4]: year
[5]: [ [ trackName, duration ], ... ]
[6]: [ [ contributorName, role, id ], ... ]
[7]: CoverArt
#############################################################################
*/
  static void addToWish(List<dynamic> albumdata) async {
    var snapshot = await userRef.child("Wishlist/${albumdata[0]}").get();
    if (!snapshot.exists) {
      await userRef.update({
        "Wishlist/${albumdata[0]}": {
          "UniqueID": albumdata[0],
          "Name": albumdata[2],
          "Artist": albumdata[1],
          "Year": albumdata[4],
          "Genre": albumdata[3],
          "Cover": albumdata[6],
          "Tracklist": albumdata[5],
          // "Contributors": albumdata[6],
          "Format": "Wishlist",
        }
      });
    }
  }

  /*
  #############################################################################
  check if album is already in inventory
  #############################################################################
  */
  static Future<bool> checkInv(String albumid, String format) async {
    bool found = false;
    var snapshot = await userRef.child("Albums").get();
    if (snapshot.exists) {
      var data = snapshot.value! as Map<Object?, Object?>;
      data.forEach((key, value) {
        if (key.toString().contains(albumid) &&
            ((key.toString().endsWith("1") && format == "Vinyl") ||
                (key.toString().endsWith("2") && format == "CD"))) found = true;
      });
    }
    return found;
  }

  /*
  addSpotToInv
  [0]: albumID
  [1]: format
  [2]: [ [ artist name, artist id ] ]
  [3]: album name
  [4]: [ genres ]
  [5]: year
  [6]: [ [ track name, duration, [ feat. artist name, feat. artist id ] ] ]
  [7]: coverart
  */
  static void addSpotToInv(List<dynamic> albumdata) async {
    // If album was in wishlist: delete it
    var wishshot = await userRef.child("Wishlist/${albumdata[0]}").get();
    if (wishshot.exists) {
      await userRef.child("Wishlist/${albumdata[0]}").remove();
    }

    var id = albumdata[0];

    // Vinyl Copies of records get a 1 added to the end
    // CD copies of records get a 2 added to the end
    if (albumdata[1] == "Vinyl")
      id += "1";
    else if (albumdata[1] == "CD") id += "2";

    print(id);
    var snapshot = await userRef.child("Albums/$id").get();
    if (!snapshot.exists) {
      // Add album data to database
      await userRef.update({
        "Albums/$id": {
          "UniqueID": id,
          "Name": albumdata[3],
          "Artist": albumdata[2],
          "Year": albumdata[5],
          "Cover": albumdata[7],
          "Genres": albumdata[4],
          "Tracklist": albumdata[6],
          "Format": albumdata[1],
        }
      });

      // Add album to each artist's data
      var genre = [];
      (albumdata[2] as List<dynamic>).forEach((element) async {
        var snapshot = await userRef.child("Artists/${element[1]}").get();

        // If the artist exists
        if (snapshot.exists) {
          var snapalbum = await userRef.child("Artists/${element[1]}/Albums");
          var newAlbum = snapalbum.push();
          newAlbum.set(id);
          var snap = await userRef.child("Artists/${element[1]}/Genres").get();
          genre = snap.value as List<dynamic>;
        }

        // If the artist doesn't exist
        else {
          String image =
              "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg";
          Spotify.artist(element[1].toString()).then((value) async {
            if (value[0] != null) {
              image = value[0];
            }
            genre = value[1];

            // Create new artist
            await userRef.update({
              "Artists/${element[1]}": {
                "UniqueID": element[1],
                "Name": element[0],
                "Image": image,
                "Genres": genre,
              }
            });

            var snapAlbum = await userRef.child("Artists/${element[1]}/Albums");
            var newAlbum = snapAlbum.push();
            newAlbum.set(id);
          });
        }
      });
    } else {
      albumdata[0] += "a";
      addSpotToInv(albumdata);
    }
  }

  /*
  addSpotToWish
  */
  static void addSpotToWish(List<dynamic> albumdata) async {}

/*
#############################################################################
displayWish

Return data to view wishlist items
  Data is returned as a list of text widgets
  [
    [0]: albumID
    [1]: albumName
    [2]: [ [ artistName, artistID ], ... ]
    [3]: coverArt
    [4]: format
    [5]: year
  ,
  ...
  ]
#############################################################################
*/
  static Future<List<List<dynamic>>> displayWish(String order) async {
    // Get a snapshot from the album database
    final snapshot = await userRef.child("Wishlist").get();

    if (snapshot.exists && snapshot.value != "") {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;

      // List[ Map{ "Artist": name, "Name": album name, ... }, Map {...}, ]
      var list = values.entries.toList();

      // Order by album name
      if (order == "Albums") {
        // Sort the list of album data based on the album name
        list.sort(((a, b) {
          var albumA = (a.value as Map<Object?, Object?>)["Name"].toString();
          var albumB = (b.value as Map<Object?, Object?>)["Name"].toString();
          albumA = removeDiacritics(albumA);
          albumB = removeDiacritics(albumB);
          return albumA.toLowerCase().compareTo(albumB.toLowerCase());
        }));
      }
      // Order by artist name
      else if (order == "Artist") {
        list.sort(((a, b) {
          // Order by Artist name:
          String aart = "";
          var data =
              (a.value as Map<Object?, Object?>)["Artist"] as List<dynamic>;
          for (int i = 0; i < data.length; i++) {
            aart += data[i][0].toString();
            if (i + 1 < data.length) {
              aart += " & ";
            }
          }

          String bart = "";
          data = (b.value as Map<Object?, Object?>)["Artist"] as List<dynamic>;
          for (int j = 0; j < data.length; j++) {
            bart += data[j][0].toString();
            if (j + 1 < data.length) {
              bart += " & ";
            }
          }

          aart = removeDiacritics(aart);
          bart = removeDiacritics(bart);
          return aart.compareTo(bart);
        }));
      }

      //Convert list of maps into list of widgets
      return _displayAlbum(list);
    } else {
      // Something went wrong when getting a snapshot from the database
      print("No data available");
      return [];
    }
  }

/*
#############################################################################
updatePressData

Add pressing data to an album
#############################################################################
*/
  static void updatePressData({
    required String albumID,
    required String numLP,
    required String colorLP,
    required String rpmSize,
    required String year,
    required String manufacturer,
  }) async {
    var snapshot = await userRef.child("Albums/$albumID").get();
    if (snapshot.exists) {
      await userRef.update({
        "Albums/$albumID/Pressing": {
          "numLP": numLP,
          "colorLP": colorLP,
          "rpmSize": rpmSize,
          "year": year,
          "manufacturer": manufacturer,
        }
      });
    }
  }

/*
#############################################################################
getPressData

Get pressing data to an album
[
  0: numLP
  1: colorLP
  2: rpmSize
  3: year
  4: manufacturer
]
#############################################################################
*/
  static Future<List<String>> getPressData(String albumID) async {
    List<String> data = [];
    var snapshot = await userRef.child("Albums/$albumID/Pressing").get();
    if (snapshot.exists) {
      data = [
        (snapshot.value as Map<Object?, Object?>)["numLP"].toString(),
        (snapshot.value as Map<Object?, Object?>)["colorLP"].toString(),
        (snapshot.value as Map<Object?, Object?>)["rpmSize"].toString(),
        (snapshot.value as Map<Object?, Object?>)["year"].toString(),
        (snapshot.value as Map<Object?, Object?>)["manufacturer"].toString(),
      ];
    }
    return data;
  }

/*
#############################################################################
addNotes

Add notes to an album
This function overwrites any existing notes on an album.
If you wish to modify notes that already exist, I suggested getting the
text, updating it and sending it back.
#############################################################################
*/
  static void addNotes({required String albumID, required String note}) async {
    var snapshot = await userRef.child("Albums/$albumID").get();
    if (snapshot.exists) {
      await userRef.update({
        "Albums/$albumID/Notes": note,
      });
    }
  }

/*
#############################################################################
getNotes

Get notes to an album
#############################################################################
*/
  static Future<String> getNotes(String albumID) async {
    String note = "";
    var snapshot = await userRef.child("Albums/$albumID/Notes").get();
    if (snapshot.exists) {
      note = snapshot.value as String;
    }
    return note;
  }

/*
#############################################################################
deleteNotes

Deletes the notes on a given album
#############################################################################
*/
  static void deleteNotes(String albumID) async {
    var snapref = await userRef.child("Albums/$albumID/Notes");
    snapref.remove();
  }

/*
#############################################################################
USER CREATED CATEGORIES
#############################################################################
*/
  static void createCategory(String category) async {
    var snapshot = await userRef.child("Categories");
    var newCat = snapshot.push();
    newCat.set(category);
  }

  static void deleteCategory(String category) async {
    var snapshot = await userRef.child("Categories").get();
    if (snapshot.exists) {
      var categories = snapshot.value as Map<Object?, Object?>;
      categories.removeWhere((key, value) => value == category);
      await userRef.update({
        "Categories": categories,
      });
    }
  }

  static void addCatTag(String albumID, String category) async {
    var snapshot = await userRef.child("Albums/$albumID/Category");
    var catTag = snapshot.push();
    catTag.set(category);
  }

  static void removeCatTag(String albumID, String category) async {
    var snapshot = await userRef.child("Albums/$albumID/Category").get();
    if (snapshot.exists) {
      var categories = snapshot.value as Map<Object?, Object?>;
      categories.removeWhere((key, value) => value == category);
      await userRef.update({
        "Albums/$albumID/Category": categories,
      });
    }
  }

  static Future<List<String>> getCategories() async {
    List<String> categories = [];
    var snapshot = await userRef.child("Categories").get();
    if (snapshot.exists) {
      var data = snapshot.value! as Map<dynamic, dynamic>;
      data.forEach((key, value) {
        categories.add(value.toString());
      });
    }
    return categories;
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'discogs.dart';
import 'dart:developer';

class Database {
  static final fb = FirebaseDatabase.instance;
  static final ref = fb.ref();

  static void clear() async {
    await ref.remove();
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
    final snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Artist": name, "Name": album name, ... }, Map {...}, ]
      var list = values.entries.toList();

      // Sort the list of album data based on the album name
      list.sort(((a, b) {
        var albumA = a.value as Map<Object?, Object?>;
        var albumB = b.value as Map<Object?, Object?>;
        return albumA["Name"]
            .toString()
            .toLowerCase()
            .compareTo(albumB["Name"].toString().toLowerCase());
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
    final snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      // List of album data that are of the given genre
      List<MapEntry<Object?, Object?>> list = [];
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;

      // For every album in the database: check if it is the correct genre
      values.forEach((key, value) {
        var album = value as Map<Object?, Object?>;
        if ((album["Genre"] as List<Object?>).contains(genre) &&
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
            aart += data[i][0].toString();
            if (i + 1 < data.length) {
              aart += " & ";
            }
          }

          String bart = "";
          data = b[2] as List<dynamic>;
          for (int j = 0; j < data.length; j++) {
            bart += data[j][0].toString();
            if (j + 1 < data.length) {
              bart += " & ";
            }
          }

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
    final snapshot = await ref.child("Artists").get();
    // List of artists to return
    List<dynamic> results = [];

    if (snapshot.exists) {
      // Map{ ArtistID: {Artist Data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Name": Artist name, "Albums": [], ... }, Map{...} ]
      var list = values.entries.toList();

      // Sort the list of artists based on their name
      list.sort(((a, b) {
        var albumA = a.value as Map<Object?, Object?>;
        var albumB = b.value as Map<Object?, Object?>;
        return albumA["Name"]
            .toString()
            .toLowerCase()
            .compareTo(albumB["Name"].toString().toLowerCase());
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
    final snapArtist = await ref.child("Artists").get();
    // Get a snapshot from the ALBUM database
    final snapAlbum = await ref.child("Albums").get();

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
          return a[5].toString().compareTo(b[5].toString());
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
    final snapshot = await ref.child("Albums").get();

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
      results.add(albumdata["Genre"]);
      results.add(albumdata["Year"]);
      results.add(albumdata["Tracklist"]);
      results.add(albumdata["Contributors"]);
      results.add(albumdata["Cover"]);
      results.add(albumdata["Format"]);
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
    final snapArtist = await ref.child("Artists").get();
    // Get a snapshot of the Albums database
    final snapAlbums = await ref.child("Albums").get();

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
    var snapshot = await ref.child("Albums/$albumID").get();
    if (snapshot.exists) {
      var values = snapshot.value as Map<Object?, Object?>;

      // Get IDs of artists on the album
      List<String> artistIDs = [];
      (values["Artist"] as List<dynamic>).forEach((element) {
        artistIDs.add(element[1].toString());
      });

      // Delete the album from album database
      await ref.child("Albums/$albumID").remove();

      // Delete the album under each artist
      artistIDs.forEach((element) async {
        var artsnap = await ref.child("Artists/$element").get();
        if (artsnap.exists) {
          var data = artsnap.value as Map<Object?, Object?>;
          List<dynamic> albums = [];
          albums.addAll(data["Albums"] as List<dynamic>);
          albums.remove(albumID);

          // If the artist has no more albums: delete the artist
          if (albums.isEmpty) {
            await ref.child("Artists/$element").remove();
          }
          // Otherwise: update the artist's albums list
          else {
            await ref.update({
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
  static Future<String> addAlbumToInv(List<dynamic> albumdata) async {
    // If album was in wishlist: delete it
    var wishshot = await ref.child("Wishlist/${albumdata[0]}").get();
    if (wishshot.exists) {
      await ref.child("Wishlist/${albumdata[0]}").remove();
    }

    // Vinyl Copies of records get a 1 added to the end
    // CD Copies of records get a 2 added to the end
    if (albumdata[1] == "Vinyl")
      albumdata[0] += "1";
    else if (albumdata[1] == "CD") albumdata[0] += "2";

    var snapshot = await ref.child("Albums/${albumdata[0]}").get();
    if (!snapshot.exists) {
      // Add album data to database
      await ref.update({
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
        var snapshot = await ref.child("Artists/${element[1]}").get();
        // If the artist exitst
        if (snapshot.exists) {
          var snapalbum = await ref.child("Artists/${element[1]}/Albums");
          var newAlbum = snapalbum.push();
          newAlbum.set(albumdata[0]);
        }
        // If the artist doesn't exist
        else {
          print("snapshot does not exist");
          // Create new artist
          await ref.update({
            "Artists/${element[1]}": {
              "UniqueID": element[1],
              "Name": element[0],
              "Image":
                  "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg",
            }
          });
          var snapalbum = await ref.child("Artists/${element[1]}/Albums");
          var newAlbum = snapalbum.push();
          newAlbum.set(albumdata[0]);
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
    var snapshot = await ref.child("Wishlist/${albumdata[0]}").get();
    if (!snapshot.exists) {
      await ref.update({
        "Wishlist/${albumdata[0]}": {
          "UniqueID": albumdata[0],
          "Name": albumdata[2],
          "Artist": albumdata[1],
          "Year": albumdata[4],
          "Genre": albumdata[3],
          "Cover": albumdata[7],
          "Tracklist": albumdata[5],
          "Contributors": albumdata[6],
          "Format": "Wishlist",
        }
      });
    }
  }

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
    final snapshot = await ref.child("Wishlist").get();

    if (snapshot.exists) {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Artist": name, "Name": album name, ... }, Map {...}, ]
      var list = values.entries.toList();

      // Order by album name
      if (order == "Albums") {
        // Sort the list of album data based on the album name
        list.sort(((a, b) {
          var albumA = a.value as Map<Object?, Object?>;
          var albumB = b.value as Map<Object?, Object?>;
          return albumA["Name"]
              .toString()
              .toLowerCase()
              .compareTo(albumB["Name"].toString().toLowerCase());
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
pressingData

Add pressing data to an album
#############################################################################
*/
  static void pressingData({
    required String albumID,
    String numLP = "",
    String colorLP = "",
    String rpmSize = "",
    String year = "",
    String manufacturer = "",
  }) async {
    var snapshot = await ref.child("Albums/$albumID").get();
    if (snapshot.exists) {
      await ref.update({
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
addNotes

Add notes to an album
This function overwrites any existing notes on an album.
If you wish to modify notes that already exist, I suggested getting the
text, updating it and sending it back.
#############################################################################
*/
  static void addNotes({required String albumID, required String note}) async {
    var snapshot = await ref.child("Albums/$albumID").get();
    if (snapshot.exists) {
      await ref.update({
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
    var snapshot = await ref.child("Albums/$albumID/Notes").get();
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
    var snapref = await ref.child("Albums/$albumID/Notes");
    snapref.remove();
  }

  static void fillartists() async {
    var list = [
      3853178,
      47333,
      69866,
      318185,
      293333,
      445868,
      141549,
      159169,
      2218596,
      21731,
      163505,
      132066,
      63332,
      29735,
      1031,
      461584,
      2635770,
      140140,
      2165577,
      84752,
      1500084,
      36158,
      994835,
      80395,
      810616,
      71725,
      234647
    ];
    list.forEach((element) {
      Collection.artistData(element.toString()).then((value) {
        ref.update({
          "Artists/${value[0]}": {
            "UniqueID": value[0],
            "Name": value[1],
            "Albums": [],
            "Image":
                "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg",
          }
        });
      });
    });
  }

  static Future<bool> fill(String id, String format) async {
    Collection.album(id).then((result) {
      var album = [];
      album.add(id);
      album.add(format);
      album.addAll(result);
      Database.addAlbumToInv(album);
    });
    return true;
  }

  /*
  Fills the firebase realtime database with dummy data
  */
  static void startingData() {
    // Arular
    fill("424354", "CD");

    // Folklore
    fill("461651", "Vinyl");

    //Stiff Upper Lip
    fill("487630", "Vinyl");

    // Let's Do It For Johnny!!
    fill("512610", "Vinyl");

    // Drunk Enough to Dance
    fill("512612", "Vinyl");

    // Mama Said
    fill("609305", "Vinyl");

    // Love.Angel.Music.Baby
    fill("676489", "Vinyl");

    // Loose
    fill("726173", "Vinyl");

    // Circus
    fill("796353", "Vinyl");

    // The Open Door
    fill("802389", "Vinyl");

    // Under the Iron Sea
    fill("803017", "Vinyl");

    // The Razors Edge
    fill("813717", "Vinyl");

    // Fly On the Wall
    fill("864310", "Vinyl");

    // Dirty Deedds Done Dirt Cheap
    fill("864991", "Vinyl");

    // Mirage
    fill("873439", "Vinyl");

    // Lap of Luxury
    fill("877057", "Vinyl");

    // Blow Up You Video
    fill("1001639", "Vinyl");

    // X & Y
    fill("1044164", "Vinyl");

    // Our Love to Admire
    fill("1055329", "Vinyl");

    // The Album
    fill("1116735", "Vinyl");

    // Bare Trees
    fill("1118530", "Vinyl");

    // Powerage
    fill("1152320", "Vinyl");

    // It Is Time For a Love Revolution
    fill("1236130", "Vinyl");

    // Kala
    fill("1278408", "Vinyl");

    // Viva La Vida Or Death And All His Friends
    fill("1373719", "Vinyl");

    // Viva La Vida
    fill("1406749", "Vinyl");

    // Viva La Cobra
    fill("1436737", "Vinyl");

    // Evening Out With Your Girlfriend
    fill("1462121", "Vinyl");

    // Black Ice
    fill("1596665", "Vinyl");

    // In Color
    fill("1603248", "Vinyl");

    // Infinity on High
    fill("1740745", "Vinyl");

    // All Shook Up
    fill("1760271", "Vinyl");

    // One on One
    fill("1760282", "Vinyl");

    // Buddha
    fill("1800929", "Vinyl");

    // Don't Believe The Truth
    fill("1865972", "Vinyl");

    // Mi Plan
    fill("1937233", "Vinyl");

    // Wild Young Hearts
    fill("1941286", "Vinyl");

    // Back In Black
    fill("1949857", "Vinyl");

    // Sorry for Partyin
    fill("1997838", "Vinyl");

    // Let There Be Rock
    fill("2078177", "Vinyl");

    // Dream Police
    fill("2107112", "Vinyl");

    // Next Position Please
    fill("2140555", "Vinyl");

    // Night Train
    fill("2267965", "Vinyl");

    // The ArchAndroid
    fill("2358638", "Vinyl");

    // Cheap Trick
    fill("2372199", "Vinyl");

    // Penguin
    fill("2415058", "Vinyl");

    // Interpol
    fill("2435602", "Vinyl");

    // Sketches For My Sweethear the Drunk
    fill("2513116", "Vinyl");

    // Highway to Hell
    fill("2520300", "Vinyl");

    // High Voltage
    fill("2588535", "Vinyl");

    // A Hangover You Don't Deserve
    fill("2612166", "Vinyl");

    // Folie À Deux
    fill("2621572", "Vinyl");

    // While the City Sleeps, We Rule the Streets
    fill("2728452", "Vinyl");

    // Lungs
    fill("2804664", "Vinyl");

    // For Those About to Rock
    fill("2817619", "Vinyl");

    // Grace
    fill("2825029", "Vinyl");

    // Rumours
    fill("2832092", "Vinyl");

    // James Blake
    fill("2832463", "Vinyl");

    // Rock On Honorable Ones
    fill("2921774", "Vinyl");

    // Busted
    fill("3050774", "Vinyl");

    // Black and White America
    fill("3069737", "Vinyl");

    // Night Shades
    fill("3078209", "Vinyl");

    // Parachutes
    fill("3092119", "Vinyl");

    // Arrival
    fill("3104211", "Vinyl");

    // ABBA
    fill("3105226", "Vinyl");

    // Waterloo
    fill("3105284", "Vinyl");

    // Voulez-Vous
    fill("3105488", "Vinyl");

    // Petergreen's Fleetwood Mac
    fill("3107317", "Vinyl");

    // Mylo Xyloto
    fill("3174863", "Vinyl");

    // Ceremonials
    fill("3210249", "Vinyl");

    // Antics
    fill("3415175", "Vinyl");

    // Blue Side Park
    fill("3492331", "Vinyl");

    // Boys and Girls
    fill("20240365", "Vinyl");

    // Fleetwood Mac
    fill("3586233", "Vinyl");

    // Strangeland
    fill("3592552", "Vinyl");

    // Fishin for Woos
    fill("3630396", "Vinyl");

    // The Doctor
    fill("3984662", "Vinyl");

    // Whats the time Mr Wolf
    fill("4248516", "Vinyl");

    // If You Leave
    fill("4389520", "Vinyl");

    // Overgrown
    fill("4445420", "Vinyl");

    // Save Rock and Roll
    fill("4488806", "Vinyl");

    // Flick of the Switch
    fill("4689119", "Vinyl");

    // Mr Wonderful
    fill("4727885", "Vinyl");

    // Ring Ring
    fill("4998939", "Vinyl");

    // Matangi
    fill("5126620", "Vinyl");

    // Pax-AM Days
    fill("5148207", "Vinyl");

    // Blink-182
    fill("5224539", "Vinyl");

    // Metropolis: The Chase Suite
    fill("5303025", "Vinyl");

    // The Great Burrito Extortion Case
    fill("5381927", "Vinyl");

    // Lunch Drunk Love
    fill("5387555", "Vinyl");

    // Ballbreaker
    fill("5587613", "Vinyl");

    // Definitely Maybe
    fill("5697791", "Vinyl");

    // Ghost Stories
    fill("5699282", "Vinyl");

    // Dude Ranch
    fill("5757545", "Vinyl");

    // Cheshire Cat
    fill("5868594", "Vinyl");

    // Infinity on High
    fill("5869463", "Vinyl");

    // Electric Lady
    fill("5970762", "Vinyl");

    // El Pintor
    fill("6058798", "Vinyl");

    // The Vistors
    fill("6111979", "Vinyl");

    // Whats the Story Morning Glory?
    fill("6127871", "Vinyl");

    // Hozier
    fill("6160782", "Vinyl");

    // Rock or Bust
    fill("6343565", "Vinyl");

    // Songs People Actually Liked, Volume 1: The First Ten Years 1994-2003
    fill("6621374", "Vinyl");

    // Tell me when to whoa!
    fill("6621531", "Vinyl");

    // Sound and Color
    fill("10021212", "Vinyl");

    // Turn on the Bright Lights
    fill("6799508", "Vinyl");

    // Then Play On
    fill("6941523", "Vinyl");

    //
    fill("6974841", "Vinyl");

    // American Beauty / American Psycho
    fill("3104211", "Vinyl");

    // How Big how blue how beautiful
    fill("7064888", "Vinyl");

    // A Rush of blood to the head
    fill("7266689", "Vinyl");

    // Dig out your soul
    fill("7315964", "Vinyl");

    // A head full of dreams
    fill("7810100", "Vinyl");

    // Not to disappear
    fill("7975258", "Vinyl");

    // You and i
    fill("8235792", "Vinyl");

    // Play
    fill("8465720", "Vinyl");

    // Merry Flippin' Christmas Volumes 1 And 2
    fill("8568544", "Vinyl");

    // This is what the truth feels like
    fill("8576403", "Vinyl");
  }
}

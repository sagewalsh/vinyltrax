import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'discogs.dart';

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
  static Future<List<dynamic>> displayByName() async {
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
      return _albumDisplay(list);
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
  [0]: Album Name
  [1]: Artist Name
  [2]: Cover Art
  [3]: Album ID
  */
  static Future<List<Text>> displayByGenre(String genre) async {
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
        if (album["Genre"] == genre) {
          // Add the album to the list
          list += {key: value}.entries.toList();
        }
      });
      // Convert list of maps into list of widgets
      return _displayAlbums(list);
    } else {
      return [];
    }
  }

  /*
  Helper Function.
  Given a list of map entries containing album data:
  Returns a list of text widgets of album data used when 
  displaying albums.

  Converts a list of map entries filled with album data into 
  a list of text widgets

  [0]: Album Name
  [1]: Artist Name
  [2]: Cover Art
  [3]: Album ID
  */
  static List<Text> _displayAlbums(List<MapEntry<Object?, Object?>> list) {
    List<Text> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      results.add(Text(albumdata["Name"].toString()));
      results.add(Text(albumdata["Artist"].toString()));
      results.add(Text(albumdata["Cover"].toString()));
      results.add(Text(albumdata["UniqueID"].toString()));
    });
    return results;
  }

  /*
  _albumDisplay
  Helper Function  
  Given a list of map entries containing album data:
  Returns a list of text widgets of album data used when 
  displaying albums.

  Converts a list of map entries filled with album data into 
  a dynamic list

  [0]: albumID
  [1]: albumName
  [2]: [ [ artistName, artistID ], ... ]
  [3]: coverArt
  [4]: format
  */
  static List<dynamic> _albumDisplay(List<MapEntry<Object?, Object?>> list) {
    List<dynamic> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      results.add(albumdata["UniqueID"]);
      results.add(albumdata["Name"]);
      results.add(albumdata["Artist"]);
      results.add(albumdata["Cover"]);
      results.add(albumdata["Format"]);
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
  static Future<List<dynamic>> artists() async {
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
        results.add(artistdata["Name"]);
        results.add(artistdata["UniqueID"]);
        results.add(artistdata["Image"]);
      });
    }
    // Return artists and their ids
    return results;
  }

/*
Given an Artist ID:
Returns a list of text widgets of album data for each album
that artist has in the database.

Data is returned as a list of text widgets:
[0]: Album Name
[1]: Artist Name
[2]: Cover Art
[4]: format
*/
  static Future<List<dynamic>> albumsBy(String artistid) async {
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
        var albumids = artist["Albums"] as List<Object?>;

        albumids.forEach((element) {
          if (albumValues.containsKey(element.toString())) {
            // Add album data to returned list
            albums += {element.toString(): albumValues[element.toString()]}
                .entries
                .toList();
          }
        });
        // Return the album data of the given Artist's albums
        return _albumDisplay(albums);
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

    print("albumDetails id: " + albumid);

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

  static Future<List<List<Text>>> search(String input) async {
    List<List<Text>> results = [];
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
            Text(artist["Name"].toString()),
            Text(artist["UniqueID"].toString()),
            Text(artist["Image"].toString()),
          ]);
          // AlbumIDs of the albums the given artist has created
          var albumids = artist["Albums"] as List<Object?>;

          albumids.forEach((element) {
            if (albumValues.containsKey(element.toString())) {
              // Add album data to returned list
              list = {element.toString(): albumValues[element.toString()]}
                  .entries
                  .toList();

              // Return the album data of the given Artist's albums
              results.add(_displayAlbums(list));
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
      if (list.isNotEmpty) results.add(_displayAlbums(list));
    }
    return results;
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
  static void addAlbumToInv(List<dynamic> albumdata) async {
    // Vinyl Copies of records get a 1 added to the end
    // CD Copies of records get a 2 added to the end
    if (albumdata[1] == "Vinyl")
      albumdata[0] += "1";
    else if (albumdata[1] == "CD") albumdata[0] += "2";

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
    for (int i = 0; i < (albumdata[2] as List<dynamic>).length; i++) {
      final snapshot = await ref.child("Artists/${albumdata[2][i][1]}").get();
      // If the artist already exists
      if (snapshot.exists) {
        // Create a list of already existing albums
        List<dynamic> albums = [];
        ((snapshot.value as Map<Object?, Object?>)["Albums"] as List<dynamic>)
            .forEach((element) {
          albums.add(element);
        });
        // if (!albums.contains(albumdata[0]))
        // Add new album to list
        albums.add(albumdata[0]);

        // Update artist's albums
        ref.update({
          "Artists/${albumdata[2][i][1]}/Albums": albums,
        });
      }
      // If the artist doesn't exist
      else {
        // Create new artist
        await ref.update({
          "Artists/${albumdata[2][i][1]}": {
            "UniqueID": albumdata[2][i][1],
            "Name": albumdata[2][i][0],
            "Albums": [albumdata[0]],
            "Image":
                "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg",
          }
        });
      }
    }
  }

/*
#############################################################################
Add an album to your wishlist
#############################################################################
*/

/*
#############################################################################
Add pressing data to an album
#############################################################################
*/

  /*
  Fills the firebase realtime database with dummy data
  */
  static void startingData() async {
    // Arular
    Collection.album("424354").then((result) {
      var album = [];
      album.add("424354");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Folklore
    Collection.album("461651").then((result) {
      var album = [];
      album.add("461651");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    //Stiff Upper Lip
    Collection.album("487630").then((result) {
      var album = [];
      album.add("487630");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Let's Do It For Johnny!!
    Collection.album("512610").then((result) {
      var album = [];
      album.add("512610");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Drunk Enough to Dance
    Collection.album("512612").then((result) {
      var album = [];
      album.add("512612");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Mama Said
    Collection.album("609305").then((result) {
      var album = [];
      album.add("609305");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Love.Angel.Music.Baby
    Collection.album("676489").then((result) {
      var album = [];
      album.add("676489");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Loose
    Collection.album("726173").then((result) {
      var album = [];
      album.add("726173");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Circus
    Collection.album("796353").then((result) {
      var album = [];
      album.add("796353");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Open Door
    Collection.album("802389").then((result) {
      var album = [];
      album.add("802389");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Under the Iron Sea
    Collection.album("803017").then((result) {
      var album = [];
      album.add("803017");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Razors Edge
    Collection.album("813717").then((result) {
      var album = [];
      album.add("813717");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Fly On the Wall
    Collection.album("864310").then((result) {
      var album = [];
      album.add("864310");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Dirty Deedds Done Dirt Cheap
    Collection.album("864991").then((result) {
      var album = [];
      album.add("864991");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Mirage
    Collection.album("873439").then((result) {
      var album = [];
      album.add("873439");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Lap of Luxury
    Collection.album("877057").then((result) {
      var album = [];
      album.add("877057");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Blow Up You Video
    Collection.album("1001639").then((result) {
      var album = [];
      album.add("4616100163951");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // X & Y
    Collection.album("1044164").then((result) {
      var album = [];
      album.add("1044164");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Our Love to Admire
    Collection.album("1055329").then((result) {
      var album = [];
      album.add("1055329");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Album
    Collection.album("1116735").then((result) {
      var album = [];
      album.add("1116735");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Bare Trees
    Collection.album("1118530").then((result) {
      var album = [];
      album.add("1118530");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Powerage
    Collection.album("1152320").then((result) {
      var album = [];
      album.add("1152320");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // It Is Time For a Love Revolution
    Collection.album("1236130").then((result) {
      var album = [];
      album.add("1236130");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Kala
    Collection.album("1278408").then((result) {
      var album = [];
      album.add("1278408");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Viva La Vida Or Death And All His Friends
    Collection.album("1373719").then((result) {
      var album = [];
      album.add("1373719");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Viva La Vida
    Collection.album("1406749").then((result) {
      var album = [];
      album.add("1373719");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Viva La Cobra
    Collection.album("1436737").then((result) {
      var album = [];
      album.add("1436737");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Evening Out With Your Girlfriend
    Collection.album("1462121").then((result) {
      var album = [];
      album.add("1462121");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Black Ice
    Collection.album("1596665").then((result) {
      var album = [];
      album.add("1596665");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // In Color
    Collection.album("1603248").then((result) {
      var album = [];
      album.add("1603248");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Infinity on High
    Collection.album("1740745").then((result) {
      var album = [];
      album.add("1740745");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // All Shook Up
    Collection.album("1760271").then((result) {
      var album = [];
      album.add("1760271");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // One on One
    Collection.album("1760282").then((result) {
      var album = [];
      album.add("1760282");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Buddha
    Collection.album("1800929").then((result) {
      var album = [];
      album.add("1800929");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Don't Believe The Truth
    Collection.album("1865972").then((result) {
      var album = [];
      album.add("1865972");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Mi Plan
    Collection.album("1937233").then((result) {
      var album = [];
      album.add("1937233");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Wild Young Hearts
    Collection.album("1941286").then((result) {
      var album = [];
      album.add("1941286");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Back In Black
    Collection.album("1949857").then((result) {
      var album = [];
      album.add("1949857");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Sorry for Partyin
    Collection.album("1997838").then((result) {
      var album = [];
      album.add("1997838");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Let There Be Rock
    Collection.album("2078177").then((result) {
      var album = [];
      album.add("2078177");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Dream Police
    Collection.album("2107112").then((result) {
      var album = [];
      album.add("2107112");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Next Position Please
    Collection.album("2140555").then((result) {
      var album = [];
      album.add("2140555");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Night Train
    Collection.album("2267965").then((result) {
      var album = [];
      album.add("2267965");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The ArchAndroid
    Collection.album("2358638").then((result) {
      var album = [];
      album.add("2358638");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Cheap Trick
    Collection.album("2372199").then((result) {
      var album = [];
      album.add("2372199");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Penguin
    Collection.album("2415058").then((result) {
      var album = [];
      album.add("2415058");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Interpol
    Collection.album("2435602").then((result) {
      var album = [];
      album.add("2435602");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Sketches For My Sweethear the Drunk
    Collection.album("2513116").then((result) {
      var album = [];
      album.add("2513116");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Highway to Hell
    Collection.album("2520300").then((result) {
      var album = [];
      album.add("2520300");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // High Voltage
    Collection.album("2588535").then((result) {
      var album = [];
      album.add("2588535");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // A Hangover You Don't Deserve
    Collection.album("2612166").then((result) {
      var album = [];
      album.add("2612166");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Folie À Deux
    Collection.album("2621572").then((result) {
      var album = [];
      album.add("2621572");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // While the City Sleeps, We Rule the Streets
    Collection.album("2728452").then((result) {
      var album = [];
      album.add("2728452");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Lungs
    Collection.album("2804664").then((result) {
      var album = [];
      album.add("2804664");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // For Those About to Rock
    Collection.album("2817619").then((result) {
      var album = [];
      album.add("2817619");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Grace
    Collection.album("2825029").then((result) {
      var album = [];
      album.add("2825029");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Rumours
    Collection.album("2832092").then((result) {
      var album = [];
      album.add("2832092");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // James Blake
    Collection.album("2832463").then((result) {
      var album = [];
      album.add("2832463");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Rock On Honorable Ones
    Collection.album("2921774").then((result) {
      var album = [];
      album.add("2921774");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Busted
    Collection.album("3050774").then((result) {
      var album = [];
      album.add("3050774");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Black and White America
    Collection.album("3069737").then((result) {
      var album = [];
      album.add("3069737");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Night Shades
    Collection.album("3078209").then((result) {
      var album = [];
      album.add("3078209");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Parachutes
    Collection.album("3092119").then((result) {
      var album = [];
      album.add("3092119");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Arrival
    Collection.album("3104211").then((result) {
      var album = [];
      album.add("3104211");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // ABBA
    Collection.album("3105226").then((result) {
      var album = [];
      album.add("3105226");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Waterloo
    Collection.album("3105284").then((result) {
      var album = [];
      album.add("3105284");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Voulez-Vous
    Collection.album("3105488").then((result) {
      var album = [];
      album.add("3105488");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Petergreen's Fleetwood Mac
    Collection.album("3107317").then((result) {
      var album = [];
      album.add("3107317");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Mylo Xyloto
    Collection.album("3174863").then((result) {
      var album = [];
      album.add("3174863");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Ceremonials
    Collection.album("3210249").then((result) {
      var album = [];
      album.add("3210249");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Antics
    Collection.album("3415175").then((result) {
      var album = [];
      album.add("3415175");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Blue Side Park
    Collection.album("3492331").then((result) {
      var album = [];
      album.add("3492331");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Boys and Girls
    Collection.album("3529250").then((result) {
      var album = [];
      album.add("3529250");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Fleetwood Mac
    Collection.album("3586233").then((result) {
      var album = [];
      album.add("3586233");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Strangeland
    Collection.album("3592552").then((result) {
      var album = [];
      album.add("3592552");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Fishin for Woos
    Collection.album("3630396").then((result) {
      var album = [];
      album.add("3630396");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Doctor
    Collection.album("3984662").then((result) {
      var album = [];
      album.add("3984662");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Whats the time Mr Wolf
    Collection.album("4248516").then((result) {
      var album = [];
      album.add("4248516");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // If You Leave
    Collection.album("4389520").then((result) {
      var album = [];
      album.add("4389520");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Overgrown
    Collection.album("4445420").then((result) {
      var album = [];
      album.add("4445420");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Save Rock and Roll
    Collection.album("4488806").then((result) {
      var album = [];
      album.add("4488806");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Flick of the Switch
    Collection.album("4689119").then((result) {
      var album = [];
      album.add("4689119");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Mr Wonderful
    Collection.album("4727885").then((result) {
      var album = [];
      album.add("4727885");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Ring Ring
    Collection.album("4998939").then((result) {
      var album = [];
      album.add("4998939");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Matangi
    Collection.album("5126620").then((result) {
      var album = [];
      album.add("5126620");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Pax-AM Days
    Collection.album("5148207").then((result) {
      var album = [];
      album.add("5148207");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Blink-182
    Collection.album("5224539").then((result) {
      var album = [];
      album.add("5224539");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Metropolis: The Chase Suite
    Collection.album("5303025").then((result) {
      var album = [];
      album.add("5303025");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Great Burrito Extortion Case
    Collection.album("5381927").then((result) {
      var album = [];
      album.add("5381927");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Lunch Drunk Love
    Collection.album("5387555").then((result) {
      var album = [];
      album.add("5387555");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Ballbreaker
    Collection.album("5587613").then((result) {
      var album = [];
      album.add("5587613");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Definitely Maybe
    Collection.album("5697791").then((result) {
      var album = [];
      album.add("5697791");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Ghost Stories
    Collection.album("5699282").then((result) {
      var album = [];
      album.add("5699282");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Dude Ranch
    Collection.album("5757545").then((result) {
      var album = [];
      album.add("5757545");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Cheshire Cat
    Collection.album("5868594").then((result) {
      var album = [];
      album.add("5868594");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Infinity on High
    Collection.album("5869463").then((result) {
      var album = [];
      album.add("5869463");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Electric Lady
    Collection.album("5970762").then((result) {
      var album = [];
      album.add("5970762");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // El Pintor
    Collection.album("6058798").then((result) {
      var album = [];
      album.add("6058798");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // The Vistors
    Collection.album("6111979").then((result) {
      var album = [];
      album.add("6111979");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Whats the Story Morning Glory?
    Collection.album("6127871").then((result) {
      var album = [];
      album.add("6127871");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Hozier
    Collection.album("6160782").then((result) {
      var album = [];
      album.add("6160782");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Rock or Bust
    Collection.album("6343565").then((result) {
      var album = [];
      album.add("6343565");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Songs People Actually Liked, Volume 1: The First Ten Years 1994-2003
    Collection.album("6621374").then((result) {
      var album = [];
      album.add("6621374");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Tell me when to whoa!
    Collection.album("6621531").then((result) {
      var album = [];
      album.add("6621531");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Sound and Color
    Collection.album("6764040").then((result) {
      var album = [];
      album.add("6764040");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Turn on the Bright Lights
    Collection.album("6799508").then((result) {
      var album = [];
      album.add("6799508");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Then Play On
    Collection.album("6941523").then((result) {
      var album = [];
      album.add("6941523");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    //
    Collection.album("6974841").then((result) {
      var album = [];
      album.add("6974841");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // American Beauty / American Psycho
    Collection.album("3104211").then((result) {
      var album = [];
      album.add("3104211");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // How Big how blue how beautiful
    Collection.album("7064888").then((result) {
      var album = [];
      album.add("7064888");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // A Rush of blood to the head
    Collection.album("7266689").then((result) {
      var album = [];
      album.add("7266689");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Dig out your soul
    Collection.album("7315964").then((result) {
      var album = [];
      album.add("7315964");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // A head full of dreams
    Collection.album("7810100").then((result) {
      var album = [];
      album.add("7810100");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Not to disappear
    Collection.album("7975258").then((result) {
      var album = [];
      album.add("7975258");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // You and i
    Collection.album("8235792").then((result) {
      var album = [];
      album.add("8235792");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Play
    Collection.album("8465720").then((result) {
      var album = [];
      album.add("8465720");
      album.add("Vinyl");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // Merry Flippin' Christmas Volumes 1 And 2
    Collection.album("8568544").then((result) {
      var album = [];
      album.add("8568544");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });

    // This is what the truth feels like
    Collection.album("8576403").then((result) {
      var album = [];
      album.add("8576403");
      album.add("CD");
      album.addAll(result);
      Database.addAlbumToInv(album);
    });
  }
}

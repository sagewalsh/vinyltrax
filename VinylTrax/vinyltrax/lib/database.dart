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

    // // Add album to each artist's data
    // for (int i = 0; i < (albumdata[2] as List<dynamic>).length; i++) {
    //   final snapshot = await ref.child("Artists/${albumdata[2][i][1]}").get();
    //   // If the artist already exists
    //   if (snapshot.exists) {
    //     // print("SNAPSHOT EXISTS");
    //     // Create a list of already existing albums

    //     if ((snapshot.value as Map<Object?, Object?>)["Albums"] != null) {
    //       print("Albums Exists");
    //       List<dynamic> albums = (snapshot.value
    //           as Map<Object?, Object?>)["Albums"] as List<dynamic>;
    //       if (!albums.contains(albumdata[0])) albums += [albumdata[0]];
    //       // Update artist's albums
    //       ref.update({
    //         "Artists/${albumdata[2][i][1]}/Albums": albums,
    //       });
    //     } else {
    //       ref.update({
    //         "Artists/${albumdata[2][i][1]}/Albums": [albumdata[0]],
    //       });
    //     }
    //   }
    //   // If the artist doesn't exist
    //   else {
    //     print("snapshot does not exist");
    //     // Create new artist
    //     await ref.update({
    //       "Artists/${albumdata[2][i][1]}": {
    //         "UniqueID": albumdata[2][i][1],
    //         "Name": albumdata[2][i][0],
    //         "Albums": [albumdata[0]],
    //         "Image":
    //             "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg",
    //       }
    //     });
    //   }
    // }

    // Add album to each artist's data
    (albumdata[2] as List<dynamic>).forEach((element) async {
      var snapshot = await ref.child("Artists/${element[1]}").get();
      // If the artist exitst
      if (snapshot.exists) {
        if ((snapshot.value as Map<Object?, Object?>)["Albums"] != null) {
          print("Albums Exists");
          List<dynamic> albums = (snapshot.value
              as Map<Object?, Object?>)["Albums"] as List<dynamic>;
          if (!albums.contains(albumdata[0])) albums += [albumdata[0]];
          // Update artist's albums
          ref.update({
            "Artists/${element[1]}/Albums": albums,
          });
        } else {
          ref.update({
            "Artists/${element[1]}/Albums": [albumdata[0]],
          });
        }
      }
      // If the artist doesn't exist
      else {
        print("snapshot does not exist");
        // Create new artist
        await ref.update({
          "Artists/${element[1]}": {
            "UniqueID": element[1],
            "Name": element[0],
            "Albums": [albumdata[0]],
            "Image":
                "https://images.pexels.com/photos/12397035/pexels-photo-12397035.jpeg?cs=srgb&dl=pexels-zero-pamungkas-12397035.jpg&fm=jpg",
          }
        });
      }
    });
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
  static void startingData() async {
    // Arular
    await fill("424354", "CD");

    // Folklore
    await fill("461651", "Vinyl");

    //Stiff Upper Lip
    await fill("487630", "Vinyl");

    // Let's Do It For Johnny!!
    await fill("512610", "Vinyl");

    // Drunk Enough to Dance
    await fill("512612", "Vinyl");

    // Mama Said
    await fill("609305", "Vinyl");

    // Love.Angel.Music.Baby
    await fill("676489", "Vinyl");

    // Loose
    await fill("726173", "Vinyl");

    // Circus
    await fill("796353", "Vinyl");

    // The Open Door
    await fill("802389", "Vinyl");

    // Under the Iron Sea
    await fill("803017", "Vinyl");

    // The Razors Edge
    await fill("813717", "Vinyl");

    // Fly On the Wall
    await fill("864310", "Vinyl");

    // Dirty Deedds Done Dirt Cheap
    await fill("864991", "Vinyl");

    // Mirage
    await fill("873439", "Vinyl");

    // Lap of Luxury
    await fill("877057", "Vinyl");

    // Blow Up You Video
    await fill("1001639", "Vinyl");

    // X & Y
    await fill("1044164", "Vinyl");

    // Our Love to Admire
    await fill("1055329", "Vinyl");

    // The Album
    await fill("1116735", "Vinyl");

    // Bare Trees
    await fill("1118530", "Vinyl");

    // Powerage
    await fill("1152320", "Vinyl");

    // It Is Time For a Love Revolution
    await fill("1236130", "Vinyl");

    // Kala
    await fill("1278408", "Vinyl");

    // Viva La Vida Or Death And All His Friends
    await fill("1373719", "Vinyl");

    // Viva La Vida
    await fill("1406749", "Vinyl");

    // Viva La Cobra
    await fill("1436737", "Vinyl");

    // Evening Out With Your Girlfriend
    await fill("1462121", "Vinyl");

    // Black Ice
    await fill("1596665", "Vinyl");

    // In Color
    await fill("1603248", "Vinyl");

    // Infinity on High
    await fill("1740745", "Vinyl");

    // All Shook Up
    await fill("1760271", "Vinyl");

    // One on One
    await fill("1760282", "Vinyl");

    // Buddha
    await fill("1800929", "Vinyl");

    // Don't Believe The Truth
    await fill("1865972", "Vinyl");

    // Mi Plan
    await fill("1937233", "Vinyl");

    // Wild Young Hearts
    await fill("1941286", "Vinyl");

    // Back In Black
    await fill("1949857", "Vinyl");

    // Sorry for Partyin
    await fill("1997838", "Vinyl");

    // Let There Be Rock
    await fill("2078177", "Vinyl");

    // Dream Police
    await fill("2107112", "Vinyl");

    // Next Position Please
    await fill("2140555", "Vinyl");

    // Night Train
    await fill("2267965", "Vinyl");

    // The ArchAndroid
    await fill("2358638", "Vinyl");

    // Cheap Trick
    await fill("2372199", "Vinyl");

    // Penguin
    await fill("2415058", "Vinyl");

    // Interpol
    await fill("2435602", "Vinyl");

    // Sketches For My Sweethear the Drunk
    await fill("2513116", "Vinyl");

    // Highway to Hell
    await fill("2520300", "Vinyl");

    // High Voltage
    await fill("2588535", "Vinyl");

    // A Hangover You Don't Deserve
    await fill("2612166", "Vinyl");

    // Folie À Deux
    await fill("2621572", "Vinyl");

    // While the City Sleeps, We Rule the Streets
    await fill("2728452", "Vinyl");

    // Lungs
    await fill("2804664", "Vinyl");

    // For Those About to Rock
    await fill("2817619", "Vinyl");

    // Grace
    await fill("2825029", "Vinyl");

    // Rumours
    await fill("2832092", "Vinyl");

    // James Blake
    await fill("2832463", "Vinyl");

    // Rock On Honorable Ones
    await fill("2921774", "Vinyl");

    // Busted
    await fill("3050774", "Vinyl");

    // Black and White America
    await fill("3069737", "Vinyl");

    // Night Shades
    await fill("3078209", "Vinyl");

    // Parachutes
    await fill("3092119", "Vinyl");

    // Arrival
    await fill("3104211", "Vinyl");

    // ABBA
    await fill("3105226", "Vinyl");

    // Waterloo
    await fill("3105284", "Vinyl");

    // Voulez-Vous
    await fill("3105488", "Vinyl");

    // Petergreen's Fleetwood Mac
    await fill("3107317", "Vinyl");

    // Mylo Xyloto
    await fill("3174863", "Vinyl");

    // Ceremonials
    await fill("3210249", "Vinyl");

    // Antics
    await fill("3415175", "Vinyl");

    // Blue Side Park
    await fill("3492331", "Vinyl");

    // Boys and Girls
    await fill("3529250", "Vinyl");

    // Fleetwood Mac
    await fill("3586233", "Vinyl");

    // Strangeland
    await fill("3592552", "Vinyl");

    // Fishin for Woos
    await fill("3630396", "Vinyl");

    // The Doctor
    await fill("3984662", "Vinyl");

    // Whats the time Mr Wolf
    await fill("4248516", "Vinyl");

    // If You Leave
    await fill("4389520", "Vinyl");

    // Overgrown
    await fill("4445420", "Vinyl");

    // Save Rock and Roll
    await fill("4488806", "Vinyl");

    // Flick of the Switch
    await fill("4689119", "Vinyl");

    // Mr Wonderful
    await fill("4727885", "Vinyl");

    // Ring Ring
    await fill("4998939", "Vinyl");

    // Matangi
    await fill("5126620", "Vinyl");

    // Pax-AM Days
    await fill("5148207", "Vinyl");

    // Blink-182
    await fill("5224539", "Vinyl");

    // Metropolis: The Chase Suite
    await fill("5303025", "Vinyl");

    // The Great Burrito Extortion Case
    await fill("5381927", "Vinyl");

    // Lunch Drunk Love
    await fill("5387555", "Vinyl");

    // Ballbreaker
    await fill("5587613", "Vinyl");

    // Definitely Maybe
    await fill("5697791", "Vinyl");

    // Ghost Stories
    await fill("5699282", "Vinyl");

    // Dude Ranch
    await fill("5757545", "Vinyl");

    // Cheshire Cat
    await fill("5868594", "Vinyl");

    // Infinity on High
    await fill("5869463", "Vinyl");

    // Electric Lady
    await fill("5970762", "Vinyl");

    // El Pintor
    await fill("6058798", "Vinyl");

    // The Vistors
    await fill("6111979", "Vinyl");

    // Whats the Story Morning Glory?
    await fill("6127871", "Vinyl");

    // Hozier
    await fill("6160782", "Vinyl");

    // Rock or Bust
    await fill("6343565", "Vinyl");

    // Songs People Actually Liked, Volume 1: The First Ten Years 1994-2003
    await fill("6621374", "Vinyl");

    // Tell me when to whoa!
    await fill("6621531", "Vinyl");

    // Sound and Color
    await fill("6764040", "Vinyl");

    // Turn on the Bright Lights
    await fill("6799508", "Vinyl");

    // Then Play On
    await fill("6941523", "Vinyl");

    //
    await fill("6974841", "Vinyl");

    // American Beauty / American Psycho
    await fill("3104211", "Vinyl");

    // How Big how blue how beautiful
    await fill("7064888", "Vinyl");

    // A Rush of blood to the head
    await fill("7266689", "Vinyl");

    // Dig out your soul
    await fill("7315964", "Vinyl");

    // A head full of dreams
    await fill("7810100", "Vinyl");

    // Not to disappear
    await fill("7975258", "Vinyl");

    // You and i
    await fill("8235792", "Vinyl");

    // Play
    await fill("8465720", "Vinyl");

    // Merry Flippin' Christmas Volumes 1 And 2
    await fill("8568544", "Vinyl");

    // This is what the truth feels like
    await fill("8576403", "Vinyl");
  }
}

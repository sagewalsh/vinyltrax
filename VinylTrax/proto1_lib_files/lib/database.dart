import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Database {
  static final fb = FirebaseDatabase.instance;
  static final ref = fb.ref();

  /*
  Returns only the display information from Album JSON
  in order of Artist Name.

  Data returned as a list of text widgets.
  [0]: Album Name
  [1]: Artist Name
  [2]: Cover art
  */
  static Future<List<Text>> displayByArtist() async {
    // Get a snapshot from the album database
    final snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;
      // List[ Map{ "Artist" : name, "Name": album name, ... }, Map {...}, ]
      var list = values.entries.toList();

      // Sort the list of album data based on the artist name
      list.sort(
        (a, b) {
          var albumA = a.value as Map<Object?, Object?>;
          var albumB = b.value as Map<Object?, Object?>;
          return albumA["Artist"]
              .toString()
              .toLowerCase()
              .compareTo(albumB["Artist"].toString().toLowerCase());
        },
      );

      // Convert list of maps into list of widgets
      return _displayAlbums(list);
    } else {
      // Something went wrong when getting a snapshot from the database
      print("No data available");
      return [];
    }
  }

  /*
  Returns only the display information from Album JSON
  in order of the Album's name.

  Data is returned as a list of text widgets
  [0]: Album Name
  [1]: Artist Name
  [2]: Cover Art
  */
  static Future<List<Text>> displayByName() async {
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
      return _displayAlbums(list);
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
  */
  static List<Text> _displayAlbums(List<MapEntry<Object?, Object?>> list) {
    List<Text> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      results.add(Text(albumdata["Name"].toString()));
      results.add(Text(albumdata["Artist"].toString()));
      results.add(Text(albumdata["Cover"].toString()));
    });
    return results;
  }

/*
Returns all of the artists in the database in order of
the Artist's name. 

Data is returned as a list of text widgets
[0]: Artist Name
[1]: Artist ID
*/
  static Future<List<Text>> artists() async {
    // Get a snapshot from the artist database
    final snapshot = await ref.child("Artists").get();
    // List of artists to return
    List<Text> results = [];

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
        results.add(Text(artistdata["Name"].toString()));
        results.add(Text(artistdata["UniqueID"].toString()));
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
*/
  static Future<List<Text>> albumsBy(String artistid) async {
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
        return _displayAlbums(albums);
      }
    }
    return [];
  }

/*
Given an AlbumID:
Returns a list of the albums full data in the JSON.

Data is returned as a list of text widgets
[0]: Album Name
[1]: Artist Name
[2]: Cover Art
[3]: Genre
[4]: Year
*/
  static Future<List<Text>> fullData(int albumid) async {
    // Get a snapshot from the database
    final snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      // Map{ AlbumID: {Album data} }
      var values = snapshot.value as Map<Object?, Object?>;
      if (values.containsKey(albumid.toString())) {
        var list =
            {albumid.toString(): values[albumid.toString()]}.entries.toList();
        // Convert list of maps into list of widgets
        return _albumData(list);
      }
    }
    // Something went wrong when getting a snapshot from the database
    print("No data available");
    return [];
  }

/*
Helper Function.
Given a list of map entries containing album data:
Returns a list of text widgets of full album used when
displaying a specific album's data.

Converts a list of map entries filled with album data into a 
list of text widgets.

[0]: Album Name
[1]: Artist Name
[2]: Cover Art
[3]: Genre
[4]: Year
*/
  static List<Text> _albumData(List<MapEntry<Object?, Object?>> list) {
    List<Text> results = [];
    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      String tracklist = "Tracklist:";
      results.add(Text(albumdata["Name"].toString()));
      results.add(Text(albumdata["Artist"].toString()));
      results.add(Text(albumdata["Cover"].toString()));
      results.add(Text(albumdata["Genre"].toString()));
      results.add(Text(albumdata["Year"].toString()));
      var tracks = albumdata["Tracklist"] as List<Object?>;
      for (int i = 0; i < tracks.length; i++) {
        tracklist += "\n   " + (i + 1).toString() + ". " + tracks[i].toString();
      }
      results.add(Text(tracklist));
    });
    return results;
  }
/*
#############################################################################
Below: Code that is viable to be changed or removed at a later date
#############################################################################
*/
  // /*
  // Given an Artist ID prints the albums listed in the
  // album array under JSON Artist:
  //     Database --> Artist --> Albums: [<Object?>]
  // */
  // static Future<Text> albumsFrom(int artistid) async {
  //   String results = "\nAlbums by ";
  //   var snapshot =
  //       await ref.child("Artists/" + artistid.toString() + "/Name").get();
  //   results += snapshot.value.toString() + "\n";
  //   var path = "Artists/" + artistid.toString() + "/Albums";
  //   snapshot = await ref.child(path).get();
  //   if (snapshot.exists) {
  //     List<Object?> albums = snapshot.value as List<Object?>;
  //     for (int i = 0; i < albums.length; i++) {
  //       results += "\n" + albums[i].toString();
  //     }
  //     return Text(results);
  //   } else {
  //     return Text("Something went wrong at path: " + path);
  //   }
  // }

  // /*
  // Given an Album ID prints the data listed in
  // JSON Album:
  //     Database --> Album --> artist, genre, name, tracklist, uniqueid, year
  // */
  // static void albumGivenID(int albumid) async {
  //   var snapshot = await ref.child("Albums").get();

  //   if (snapshot.exists) {
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     if (values.containsKey(albumid.toString())) {
  //       var list =
  //           {albumid.toString(): values[albumid.toString()]}.entries.toList();
  //       _printAlbumData(list);
  //     } else {
  //       print("Album ID: " + albumid.toString() + " does not exist.");
  //     }
  //   } else {
  //     print("Something went wrong at path: " + "Albums");
  //   }
  // }

  // /*
  // Given an Album name prints the data listed in
  // JSON Album:
  //     Database --> Album --> artist, genre, name, tracklist, uniqueid, year
  // */
  // static Future<Text> albumGivenName(String name) async {
  //   var snapshot = await ref.child("Albums").get();

  //   if (snapshot.exists) {
  //     List<MapEntry<Object?, Object?>> list = [];
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     values.forEach((key, value) {
  //       var album = value as Map<Object?, Object?>;
  //       if (album["Name"] == name) {
  //         list += {key: value}.entries.toList();
  //       }
  //     });
  //     // _printAlbumData(list);
  //     return _alertAlbumData(list);
  //   }
  //   return Text("");
  // }

  // /*
  // Outputs album data to the console ordered by Album
  // title alphabetically
  // */
  // static Future<Text> albumsOrderName() async {
  //   final snapshot = await ref.child("Albums").get();
  //   if (snapshot.exists) {
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     var list = values.entries.toList();

  //     list.sort(((a, b) {
  //       var albumA = a.value as Map<Object?, Object?>;
  //       var albumB = b.value as Map<Object?, Object?>;
  //       return albumA["Name"]
  //           .toString()
  //           .toLowerCase()
  //           .compareTo(albumB["Name"].toString().toLowerCase());
  //     }));
  //     // _printAlbumData(list);
  //     return _alertAlbumData(list);
  //   } else {
  //     print("No data available");
  //   }
  //   return Text("");
  // }

  // /*
  // Outputs all the albums of a given genre
  // */
  // static Future<Text> albumsOrderGenre(String genre) async {
  //   final snapshot = await ref.child("Albums").get();

  //   if (snapshot.exists) {
  //     List<MapEntry<Object?, Object?>> list = [];
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     values.forEach((key, value) {
  //       var album = value as Map<Object?, Object?>;
  //       if (album["Genre"] == genre) {
  //         list += {key: value}.entries.toList();
  //       }
  //     });
  //     return _alertAlbumData(list);
  //   } else {
  //     return Text("No data available");
  //   }
  // }

  // /*
  // Outputs album data to the console ordered by Artist name
  // alphabetically
  // */
  // static Future<Text> albumsOrderArtist() async {
  //   final snapshot = await ref.child("Albums").get();
  //   if (snapshot.exists) {
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     var list = values.entries.toList();

  //     list.sort(
  //       (a, b) {
  //         var albumA = a.value as Map<Object?, Object?>;
  //         var albumB = b.value as Map<Object?, Object?>;
  //         return albumA["Artist"]
  //             .toString()
  //             .toLowerCase()
  //             .compareTo(albumB["Artist"].toString().toLowerCase());
  //       },
  //     );

  //     // _printAlbumData(list);
  //     return _alertAlbumData(list);
  //   } else {
  //     print("No data available");
  //   }
  //   return Text("");
  // }

  // /*
  // Helper Function
  // Given a list of Map Entries for album data,
  // prints the album data to the console
  // */
  // static void _printAlbumData(List<MapEntry<Object?, Object?>> list) {
  //   list.forEach((element) {
  //     print("\n");
  //     var albumdata = element.value as Map<Object?, Object?>;
  //     print("   Name: " + albumdata["Name"].toString());
  //     print("   Artist: " + albumdata["Artist"].toString());
  //     print("   Genre: " + albumdata["Genre"].toString());
  //     print("   Year: " + albumdata["Year"].toString());
  //     print("   Tracklist: ");
  //     var tracks = albumdata["Tracklist"] as List<Object?>;
  //     for (int i = 0; i < tracks.length; i++) {
  //       print("      " + (i + 1).toString() + ". " + tracks[i].toString());
  //     }
  //   });
  // }

  // /*
  // Helper Function
  // Given a list of Map Entries for album data,
  // builds a widget that holds to formatted data
  // */
  // static Text _alertAlbumData(List<MapEntry<Object?, Object?>> list) {
  //   String data = "";

  //   list.forEach((element) {
  //     var albumdata = element.value as Map<Object?, Object?>;
  //     data += "\n\nName: " + albumdata["Name"].toString();
  //     data += "\nArtist: " + albumdata["Artist"].toString();
  //     data += "\nGenre: " + albumdata["Genre"].toString();
  //     data += "\nYear: " + albumdata["Year"].toString();
  //     data += "\nTracklist: ";
  //     var tracks = albumdata["Tracklist"] as List<Object?>;
  //     tracks.forEach((element) {
  //       data += "\n   " + element.toString();
  //     });
  //   });

  //   return Text(data);
  // }

  // /*
  // Returns a list of text widgets of album data used when
  // displaying albums
  // */
  // static Future<List<Text>> displayAlbum(int albumid) async {
  //   var snapshot = await ref.child("Albums").get();

  //   if (snapshot.exists) {
  //     var values = snapshot.value as Map<Object?, Object?>;
  //     List<Text> results = [];
  //     if (values.containsKey(albumid.toString())) {
  //       // print(values[albumid.toString()]);
  //       var albumdata = values[albumid.toString()] as Map<Object?, Object?>;
  //       // print(albumdata["Name"]);
  //       // print(albumdata["Artist"]);
  //       // print(albumdata["Genre"]);
  //       results.add(Text(albumdata["Name"].toString()));
  //       results.add(Text(albumdata["Artist"].toString()));
  //       // results.add(Text(albumdata["Cover"].toString()));
  //     }
  //   }
  //   return [Text("")];
  // }

  // /*
  // Given an Artist ID prints the name of the artist
  // listed in JSON Artist:
  //     Database --> Artist --> Name: String
  // */
  // static void artistGivenID(int artistid) async {
  //   var path = "Artists/" + artistid.toString() + "/Name";
  //   final snapshot = await ref.child(path).get();
  //   if (snapshot.exists) {
  //     print(snapshot.value);
  //   } else {
  //     print("Something went wrong at path: " + path);
  //   }
  // }

  /*
  Fills the firebase realtime database with dummy data
  */
  static void startingData() async {
    await ref.set(
      {
        "Albums": {
          1216: {
            "UniqueID": 1216,
            "Name": "The Life of Pablo",
            "Artist": "Kanye West",
            "Year": 2016,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Ultralight Beam (explicit)",
              "Saint Pablo (explicit)",
            ]
          },
          1217: {
            "UniqueID": 1217,
            "Name": "My Beautiful Dark Twisted Fantasy",
            "Artist": "Kanye West",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Dark Fantasy (explicit)",
              "Who Will Survive in America (explicit)",
            ]
          },
          1218: {
            "UniqueID": 1218,
            "Name": "808s & Heartbreak",
            "Artist": "Kanye West",
            "Year": 2008,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Say You Will",
              "Coldest Winter",
            ]
          },
          1219: {
            "UniqueID": 1219,
            "Name": "If I Can't Have Love I Want Power",
            "Artist": "Halsey",
            "Year": 2021,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "The Tradition",
              "People Disappear Here",
            ]
          },
          1220: {
            "UniqueID": 1220,
            "Name": "Manic",
            "Artist": "Halsey",
            "Year": 2020,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Ashley",
              "929",
            ]
          },
          1221: {
            "UniqueID": 1221,
            "Name": "Badlands",
            "Artist": "Halsey",
            "Year": 2015,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Castle",
              "I Walk the Line",
            ]
          },
          1222: {
            "UniqueID": 1222,
            "Name": "good kid, m.A.A.d city",
            "Artist": "Kendrick Lamar",
            "Year": 2012,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Sherane a.k.a Master Splinter's Daughter",
              "Bitch, Don't Kill My Vibe"
            ]
          },
          1223: {
            "UniqueID": 1223,
            "Name": "DAMN.",
            "Artist": "Kendrick Lamar",
            "Year": 2017,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "BLOOD. (explicit)",
              "DUCKWORTH (explicit)",
            ]
          },
          1224: {
            "UniqueID": 1224,
            "Name": "ANTI",
            "Artist": "Rihanna",
            "Year": 2016,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Consideration (feat. SZA) (explicit)",
              "Sex With Me (explicit)",
            ]
          },
          1225: {
            "UniqueID": 1225,
            "Name": "Loud",
            "Artist": "Rihanna",
            "Year": 2010,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "S&M",
              "Skin",
            ]
          },
          1226: {
            "UniqueID": 1226,
            "Name": "Good Girl Gone Bad: Reloaded",
            "Artist": "Rihanna",
            "Year": 2008,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Umbrella (feat. JAY Z)",
              "Take a Bow",
            ]
          },
          1227: {
            "UniqueID": 1227,
            "Name": "Black Holes and Revelations",
            "Artist": "Muse",
            "Year": 2006,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Take a Bow",
              "Knights of Cydonia",
            ]
          },
          1228: {
            "UniqueID": 1228,
            "Name": "Will of the People",
            "Artist": "Muse",
            "Year": 2022,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Will of the People",
              "We are F*****g F****d",
            ]
          },
          1229: {
            "UniqueID": 1229,
            "Name": "Animal",
            "Artist": "Ke\$ha",
            "Year": 2010,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Your Love is My Drug",
              "c U Next Tuesday",
            ]
          },
          1230: {
            "UniqueID": 1230,
            "Name": "Rainbow",
            "Artist": "Ke\$ha",
            "Year": 2017,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Bastards",
              "Spaceship",
            ]
          },
          1231: {
            "UniqueID": 1231,
            "Name": "High Road",
            "Artist": "Ke\$ha",
            "Year": 2020,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Tonight",
              "Summer",
            ]
          },
          1232: {
            "UniqueID": 1232,
            "Name": "Cuz I Love You",
            "Artist": "Lizzo",
            "Year": 2019,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Cuz I Love You",
              "Lingerie",
            ]
          },
          1233: {
            "UniqueID": 1233,
            "Name": "Special",
            "Artist": "Lizzo",
            "Year": 2022,
            "Genre": "Pop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "About Damn Time",
              "Grrrls",
            ]
          },
          1234: {
            "UniqueID": 1234,
            "Name": "The Eminem Show",
            "Artist": "Eminem",
            "Year": 2002,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Curtains Up",
              "Curtains Close",
            ]
          },
          1235: {
            "UniqueID": 1235,
            "Name": "The Marshall Mathers LP",
            "Artist": "Eminem",
            "Year": 2000,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Public Service Announcement 2000",
              "Criminal",
            ]
          },
          1236: {
            "UniqueID": 1236,
            "Name": "Recovery",
            "Artist": "Eminem",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Cold Wind Blows",
              "Session One",
            ]
          },
          1237: {
            "UniqueID": 1237,
            "Name": "dont smile at me",
            "Artist": "Billie Eilish",
            "Year": 2017,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "COPYCAT",
              "&burn",
            ]
          },
          1238: {
            "UniqueID": 1238,
            "Name": "WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?",
            "Artist": "Billie Eilish",
            "Year": 2019,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "!!!!!!!!",
              "goodbye",
            ]
          },
          1239: {
            "UniqueID": 1239,
            "Name": "Happier Than Ever",
            "Artist": "Billie Eilish",
            "Year": 2021,
            "Genre": "Alternative",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Getting Older",
              "Male Fantasy",
            ]
          },
          1240: {
            "UniqueID": 1240,
            "Name": "Invasion of Privacy",
            "Artist": "Cardi B",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Get Up 10",
              "I Do",
            ]
          },
          1241: {
            "UniqueID": 1241,
            "Name": "Oxnard",
            "Artist": "Anderson .Paak",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "The Chase",
              "Left to Right",
            ]
          },
          1242: {
            "UniqueID": 1242,
            "Name": "Malibu",
            "Artist": "Anderson .Paak",
            "Year": 2016,
            "Genre": "R&B",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "The Bird",
              "The Dreamer",
            ]
          },
          1243: {
            "UniqueID": 1243,
            "Name": "Ventura",
            "Artist": "Anderson .Paak",
            "Year": 2019,
            "Genre": "R&B",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Come Home",
              "What Can We Do?",
            ]
          },
          // 1244: {
          //   "UniqueID": 1244,
          //   "Name": "An Evening with Silk Sonic",
          //   "Artist": {"Bruno Mars", "Anderson .Paak", "Silk Sonic"},
          //   "Year": 2021,
          //   "Genre": "R&B",
          //   "Cover":
          //       "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
          //   "Tracklist": [
          //     "Silk Sonic Intro",
          //     "Blast Off",
          //   ]
          // },
          1245: {
            "UniqueID": 1245,
            "Name": "Take Care",
            "Artist": "Drake",
            "Year": 2011,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Over My Dead Body",
              "The Ride",
            ]
          },
          1246: {
            "UniqueID": 1246,
            "Name": "Nothing Was the Same",
            "Artist": "Drake",
            "Year": 2013,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Tuscan Leather",
              "All Me",
            ]
          },
          1247: {
            "UniqueID": 1247,
            "Name": "If You're Reading This It's Too Late",
            "Artist": "Drake",
            "Year": 2015,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Legend",
              "6PM in New York",
            ]
          },
          1248: {
            "UniqueID": 1248,
            "Name": "Views",
            "Artist": "Drake",
            "Year": 2016,
            "Genre": "Hip-Hop",
            "Cover":
                "https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?cs=srgb&dl=pexels-pixabay-45201.jpg&fm=jpg",
            "Tracklist": [
              "Keep the Family Close",
              "Hotline Bling",
            ]
          }
        },
        "Artists": {
          1111: {
            "UniqueID": 1111,
            "Name": "Kanye West",
            "Albums": [
              1216,
              1217,
              1218,
            ],
          },
          1112: {
            "UniqueID": 1112,
            "Name": "Halsey",
            "Albums": [
              1219,
              1220,
              1221,
            ]
          },
          1113: {
            "UniqueID": 1113,
            "Name": "Kendrick Lamar",
            "Albums": [
              1222,
              1223,
            ]
          },
          1114: {
            "UniqueID": 1114,
            "Name": "Rihanna",
            "Albums": [
              1224,
              1225,
              1226,
            ]
          },
          1115: {
            "UniqueID": 1115,
            "Name": "Muse",
            "Albums": [
              1227,
              1228,
            ]
          },
          1116: {
            "UniqueID": 1116,
            "Name": "Ke\$ha",
            "Albums": [
              1229,
              1230,
              1231,
            ]
          },
          1117: {
            "UniqueID": 1117,
            "Name": "Lizzo",
            "Albums": [
              1232,
              1233,
            ]
          },
          1118: {
            "UniqueID": 1118,
            "Name": "Eminem",
            "Albums": [
              1234,
              1235,
              1236,
            ]
          },
          1119: {
            "UniqueID": 1119,
            "Name": "Billie Eilish",
            "Albums": [
              1237,
              1238,
              1239,
            ]
          },
          1120: {
            "UniqueID": 1120,
            "Name": "Cardi B",
            "Albums": [
              1240,
            ]
          },
          1121: {
            "UniqueID": 1121,
            "Name": "Anderson .Paak",
            "Albums": [
              1241,
              1242,
              1243,
            ]
          },
          1122: {
            "UniqueID": 1122,
            "Name": "Drake",
            "Albums": [
              1245,
              1246,
              1247,
              1248,
            ]
          },
        },
      },
    );
  }
}

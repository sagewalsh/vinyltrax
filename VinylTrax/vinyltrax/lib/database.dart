import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/material.dart';

class Database {
  static final fb = FirebaseDatabase.instance;
  static final ref = fb.ref();

  /*
  Given an Album ID prints the data listed in 
  JSON Album:
      Database --> Album --> artist, genre, name, tracklist, uniqueid, year
  */
  static void albumGivenID(int albumid) async {
    var snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      var values = snapshot.value as Map<Object?, Object?>;
      if (values.containsKey(albumid.toString())) {
        var list =
            {albumid.toString(): values[albumid.toString()]}.entries.toList();
        _printAlbumData(list);
      } else {
        print("Album ID: " + albumid.toString() + " does not exist.");
      }
    } else {
      print("Something went wrong at path: " + "Albums");
    }
  }

  /*
  Given an Album name prints the data listed in 
  JSON Album:
      Database --> Album --> artist, genre, name, tracklist, uniqueid, year
  */
  static Future<Text> albumGivenName(String name) async {
    var snapshot = await ref.child("Albums").get();

    if (snapshot.exists) {
      List<MapEntry<Object?, Object?>> list = [];
      var values = snapshot.value as Map<Object?, Object?>;
      values.forEach((key, value) {
        var album = value as Map<Object?, Object?>;
        if (album["Name"] == name) {
          list += {key: value}.entries.toList();
        }
      });
      // _printAlbumData(list);
      return _alertAlbumData(list);
    }
    return Text("");
  }

  /*
  Outputs album data to the console ordered by Album
  title alphabetically
  */
  static void albumsOrderName() async {
    final snapshot = await ref.child("Albums").get();
    if (snapshot.exists) {
      var values = snapshot.value as Map<Object?, Object?>;
      var list = values.entries.toList();

      list.sort(((a, b) {
        var albumA = a.value as Map<Object?, Object?>;
        var albumB = b.value as Map<Object?, Object?>;
        return albumA["Name"]
            .toString()
            .toLowerCase()
            .compareTo(albumB["Name"].toString().toLowerCase());
      }));

      _printAlbumData(list);
    } else {
      print("No data available");
    }
  }

  /*
  Outputs album data to the console ordered by Artist name
  alphabetically
  */
  static Future<Text> albumsOrderArtist() async {
    final snapshot = await ref.child("Albums").get();
    if (snapshot.exists) {
      var values = snapshot.value as Map<Object?, Object?>;
      var list = values.entries.toList();

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

      // _printAlbumData(list);
      return _alertAlbumData(list);
    } else {
      print("No data available");
    }
    return Text("");
  }

  /*
  Helper Function
  Given a list of Map Entries for album data,
  prints the album data to the console
  */
  static void _printAlbumData(List<MapEntry<Object?, Object?>> list) {
    list.forEach((element) {
      print("\n");
      var albumdata = element.value as Map<Object?, Object?>;
      print("   Name: " + albumdata["Name"].toString());
      print("   Artist: " + albumdata["Artist"].toString());
      print("   Genre: " + albumdata["Genre"].toString());
      print("   Year: " + albumdata["Year"].toString());
      print("   Tracklist: ");
      var tracks = albumdata["Tracklist"] as List<Object?>;
      for (int i = 0; i < tracks.length; i++) {
        print("      " + (i + 1).toString() + ". " + tracks[i].toString());
      }
    });
  }

  /*
  Helper Function
  Given a list of Map Entries for album data,
  builds a widget that holds to formatted data
  */
  static Text _alertAlbumData(List<MapEntry<Object?, Object?>> list) {
    String data = "";

    list.forEach((element) {
      var albumdata = element.value as Map<Object?, Object?>;
      data += "\n\nName: " + albumdata["Name"].toString();
      data += "\nArtist: " + albumdata["Artist"].toString();
      data += "\nGenre: " + albumdata["Genre"].toString();
      data += "\nYear: " + albumdata["Year"].toString();
      data += "\nTracklist: ";
      var tracks = albumdata["Tracklist"] as List<Object?>;
      tracks.forEach((element) {
        data += "\n   " + element.toString();
      });
    });

    return Text(data);
  }

  /*
  Given an Artist ID prints the albums listed in the 
  album array under JSON Artist:
      Database --> Artist --> Albums: [<Object?>]
  */
  static void albumsFrom(int artistid) async {
    var path = "Artists/" + artistid.toString() + "/Albums";
    final snapshot = await ref.child(path).get();
    if (snapshot.exists) {
      List<Object?> albums = snapshot.value as List<Object?>;
      for (int i = 0; i < albums.length; i++) {
        print(albums[i]);
      }
    } else {
      print("Something went wrong at path: " + path);
    }
  }

  /*
  Given an Artist ID prints the name of the artist
  listed in JSON Artist:
      Database --> Artist --> Name: String
  */
  static void artist(int artistid) async {
    var path = "Artists/" + artistid.toString() + "/Name";
    final snapshot = await ref.child(path).get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print("Something went wrong at path: " + path);
    }
  }

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
            "Tracklist": [
              "Ultralight Beam (explicit)",
              "Saint Pablo (explicit)"
            ]
          },
          1217: {
            "UniqueID": 1217,
            "Name": "My Beautiful Dark Twisted Fantasy",
            "Artist": "Kanye West",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Tracklist": [
              "Dark Fantasy (explicit)",
              "Who Will Survive in America (explicit)"
            ]
          },
          1218: {
            "UniqueID": 1218,
            "Name": "808s & Heartbreak",
            "Artist": "Kanye West",
            "Year": 2008,
            "Genre": "Hip-Hop",
            "Tracklist": ["Say You Will", "Coldest Winter"]
          },
          1219: {
            "UniqueID": 1219,
            "Name": "If I Can't Have Love I Want Power",
            "Artist": "Halsey",
            "Year": 2021,
            "Genre": "Alternative",
            "Tracklist": ["The Tradition", "People Disappear Here"]
          },
          1220: {
            "UniqueID": 1220,
            "Name": "Manic",
            "Artist": "Halsey",
            "Year": 2020,
            "Genre": "Alternative",
            "Tracklist": ["Ashley", "929"]
          },
          1221: {
            "UniqueID": 1221,
            "Name": "Badlands",
            "Artist": "Halsey",
            "Year": 2015,
            "Genre": "Alternative",
            "Tracklist": ["Castle", "I Walk the Line"]
          },
          1222: {
            "UniqueID": 1222,
            "Name": "good kid, m.A.A.d city",
            "Artist": "Kendrick Lamar",
            "Year": 2012,
            "Genre": "Hip-Hop",
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
            "Tracklist": ["BLOOD. (explicit)", "DUCKWORTH (explicit)"]
          },
          1224: {
            "UniqueID": 1224,
            "Name": "ANTI",
            "Artist": "Rihanna",
            "Year": 2016,
            "Genre": "Pop",
            "Tracklist": [
              "Consideration (feat. SZA) (explicit)",
              "Sex With Me (explicit)"
            ]
          },
          1225: {
            "UniqueID": 1225,
            "Name": "Loud",
            "Artist": "Rihanna",
            "Year": 2010,
            "Genre": "Pop",
            "Tracklist": ["S&M", "Skin"]
          },
          1226: {
            "UniqueID": 1226,
            "Name": "Good Girl Gone Bad: Reloaded",
            "Artist": "Rihanna",
            "Year": 2008,
            "Genre": "Pop",
            "Tracklist": ["Umbrella (feat. JAY Z)", "Take a Bow"]
          },
          1227: {
            "UniqueID": 1227,
            "Name": "Black Holes and Revelations",
            "Artist": "Muse",
            "Year": 2006,
            "Genre": "Alternative",
            "Tracklist": ["Take a Bow", "Knights of Cydonia"]
          },
          1228: {
            "UniqueID": 1228,
            "Name": "Will of the People",
            "Artist": "Muse",
            "Year": 2022,
            "Genre": "Alternative",
            "Tracklist": ["Will of the People", "We are F*****g F****d"]
          },
          1229: {
            "UniqueID": 1229,
            "Name": "Animal",
            "Artist": "Ke\$ha",
            "Year": 2010,
            "Genre": "Pop",
            "Tracklist": ["Your Love is My Drug", "c U Next Tuesday"]
          },
          1230: {
            "UniqueID": 1230,
            "Name": "Rainbow",
            "Artist": "Ke\$ha",
            "Year": 2017,
            "Genre": "Pop",
            "Tracklist": ["Bastards", "Spaceship"]
          },
          1231: {
            "UniqueID": 1231,
            "Name": "High Road",
            "Artist": "Ke\$ha",
            "Year": 2020,
            "Genre": "Pop",
            "Tracklist": ["Tonight", "Summer"]
          },
          1232: {
            "UniqueID": 1232,
            "Name": "Cuz I Love You",
            "Artist": "Lizzo",
            "Year": 2019,
            "Genre": "Pop",
            "Tracklist": ["Cuz I Love You", "Lingerie"]
          },
          1233: {
            "UniqueID": 1233,
            "Name": "Special",
            "Artist": "Lizzo",
            "Year": 2022,
            "Genre": "Pop",
            "Tracklist": ["About Damn Time", "Grrrls"]
          },
          1234: {
            "UniqueID": 1234,
            "Name": "The Eminem Show",
            "Artist": "Eminem",
            "Year": 2002,
            "Genre": "Hip-Hop",
            "Tracklist": ["Curtains Up", "Curtains Close"]
          },
          1235: {
            "UniqueID": 1235,
            "Name": "The Marshall Mathers LP",
            "Artist": "Eminem",
            "Year": 2000,
            "Genre": "Hip-Hop",
            "Tracklist": ["Public Service Announcement 2000", "Criminal"]
          },
          1236: {
            "UniqueID": 1236,
            "Name": "Recovery",
            "Artist": "Eminem",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Tracklist": ["Cold Wind Blows", "Session One"]
          },
          1237: {
            "UniqueID": 1237,
            "Name": "dont smile at me",
            "Artist": "Billie Eilish",
            "Year": 2017,
            "Genre": "Alternative",
            "Tracklist": ["COPYCAT", "&burn"]
          },
          1238: {
            "UniqueID": 1238,
            "Name": "WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?",
            "Artist": "Billie Eilish",
            "Year": 2019,
            "Genre": "Alternative",
            "Tracklist": ["!!!!!!!!", "goodbye"]
          },
          1239: {
            "UniqueID": 1239,
            "Name": "Happier Than Ever",
            "Artist": "Billie Eilish",
            "Year": 2021,
            "Genre": "Alternative",
            "Tracklist": ["Getting Older", "Male Fantasy"]
          },
          1240: {
            "UniqueID": 1240,
            "Name": "Invasion of Privacy",
            "Artist": "Cardi B",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Tracklist": ["Get Up 10", "I Do"]
          },
          1241: {
            "UniqueID": 1241,
            "Name": "Oxnard",
            "Artist": "Anderson .Paak",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Tracklist": ["The Chase", "Left to Right"]
          },
          1242: {
            "UniqueID": 1242,
            "Name": "Malibu",
            "Artist": "Anderson .Paak",
            "Year": 2016,
            "Genre": "R&B",
            "Tracklist": ["The Bird", "The Dreamer"]
          },
          1243: {
            "UniqueID": 1243,
            "Name": "Ventura",
            "Artist": "Anderson .Paak",
            "Year": 2019,
            "Genre": "R&B",
            "Tracklist": ["Come Home", "What Can We Do?"]
          },
          // 1244:{
          //   "UniqueID": 1244,
          //   "Name": "An Evening with Silk Sonic",
          //   "Artist": {"Bruno Mars", "Anderson .Paak", "Silk Sonic"},
          //   "Year": 2021,
          //   "Genre": "R&B",
          //   "Tracklist": ["Silk Sonic Intro","Blast Off"]
          // },
          1245: {
            "UniqueID": 1245,
            "Name": "Take Care",
            "Artist": "Drake",
            "Year": 2011,
            "Genre": "Hip-Hop",
            "Tracklist": ["Over My Dead Body", "The Ride"]
          },
          1246: {
            "UniqueID": 1246,
            "Name": "Nothing Was the Same",
            "Artist": "Drake",
            "Year": 2013,
            "Genre": "Hip-Hop",
            "Tracklist": ["Tuscan Leather", "All Me"]
          },
          1247: {
            "UniqueID": 1247,
            "Name": "If You're Reading This It's Too Late",
            "Artist": "Drake",
            "Year": 2015,
            "Genre": "Hip-Hop",
            "Tracklist": ["Legend", "6PM in New York"]
          },
          1248: {
            "UniqueID": 1248,
            "Name": "Views",
            "Artist": "Drake",
            "Year": 2016,
            "Genre": "Hip-Hop",
            "Tracklist": ["Keep the Family Close", "Hotline Bling"]
          }
        },
        "Artists": {
          1111: {
            "UniqueID": 1111,
            "Name": "Kanye West",
            "Albums": [
              "The Life of Pablo",
              "My Beautiful Dark Twisted Fantasy",
              "808s & Heartbreak",
            ],
          },
          1112: {
            "UniqueID": 1112,
            "Name": "Halsey",
            "Albums": [
              "If I Can't Have Love I Want Power",
              "Manic",
              "Badlands",
            ]
          },
          1113: {
            "UniqueID": 1113,
            "Name": "Kendrick Lamar",
            "Albums": [
              "good kid, m.A.A.d city",
              "DAMN.",
            ]
          },
          1114: {
            "UniqueID": 1114,
            "Name": "Rihanna",
            "Albums": [
              "ANTI",
              "Loud",
              "Good Girls Gone Bad: Reloaded",
            ]
          },
          1115: {
            "UniqueID": 1115,
            "Name": "Muse",
            "Albums": [
              "Black Holes and Revelations",
              "Will of the People",
            ]
          },
          1116: {
            "UniqueID": 1116,
            "Name": "Ke\$ha",
            "Albums": [
              "Animal",
              "Rainbow",
              "High Road",
            ]
          },
          1117: {
            "UniqueID": 1117,
            "Name": "Lizzo",
            "Albums": [
              "Cuz I Love You",
              "Special",
            ]
          },
          1118: {
            "UniqueID": 1118,
            "Name": "Eminem",
            "Albums": [
              "The Eminem Show",
              "The Marshall Mathers LP",
              "Recovery",
            ]
          },
          1119: {
            "UniqueID": 1119,
            "Name": "Billie Eilish",
            "Albums": [
              "dont smile at me",
              "WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?",
              "Happier Than Ever",
            ]
          },
          1120: {
            "UniqueID": 1120,
            "Name": "Cardi B",
            "Albums": [
              "Invasion of Privacy",
            ]
          },
          1121: {
            "UniqueID": 1121,
            "Name": "Anderson .Paak",
            "Albums": [
              "Oxnard",
              "Malibu",
              "Ventura",
            ]
          },
          1122: {
            "UniqueID": 1122,
            "Name": "Drake",
            "Albums": [
              "Take Care",
              "Nothing Was the Same",
              "If You're Reading This It's Too Late",
              "Views",
            ]
          },
        },
      },
    );
  }
}

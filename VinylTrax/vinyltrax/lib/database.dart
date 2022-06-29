import 'package:firebase_database/firebase_database.dart';

class Database {
  static final fb = FirebaseDatabase.instance;

  static void startingData() async {
    final ref = fb.ref();

    await ref.set(
      {
        "Albums": {
          1216: {
            "UniqueID": 1216,
            "Name": "The Life of Pablo",
            "Artist": "Kanye West",
            "Year": 2016,
            "Genre": "Hip-Hop",
            "Tracklist":
                "Ultralight Beam (explicit)\n...\nSaint Pablo (explicit)"
          },
          1217: {
            "UniqueID": 1217,
            "Name": "My Beautiful Dark Twisted Fantasy",
            "Artist": "Kanye West",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Tracklist":
                "Dark Fantasy (explicit)\n...\nWho Will Survive in America (explicit)"
          },
          1218: {
            "UniqueID": 1218,
            "Name": "808s & Heartbreak",
            "Artist": "Kanye West",
            "Year": 2008,
            "Genre": "Hip-Hop",
            "Tracklist": "Say You Will\n...\nColdest Winter"
          },
          1219: {
            "UniqueID": 1219,
            "Name": "If I Can't Have Love I Want Power",
            "Artist": "Halsey",
            "Year": 2021,
            "Genre": "Alternative",
            "Tracklist": "The Tradition\n...\nPeople Disappear Here"
          },
          1220: {
            "UniqueID": 1220,
            "Name": "Manic",
            "Artist": "Halsey",
            "Year": 2020,
            "Genre": "Alternative",
            "Tracklist": "Ashley\n...\n929"
          },
          1221: {
            "UniqueID": 1221,
            "Name": "Badlands",
            "Artist": "Halsey",
            "Year": 2015,
            "Genre": "Alternative",
            "Tracklist": "Castle\n...\nI Walk the Line"
          },
          1222: {
            "UniqueID": 1222,
            "Name": "good kid, m.A.A.d city",
            "Artist": "Kendrick Lamar",
            "Year": 2012,
            "Genre": "Hip-Hop",
            "Tracklist":
                "Sherane a.k.a Master Splinter's Daughter\n...\nBitch, Don't Kill My Vibe"
          },
          1223: {
            "UniqueID": 1223,
            "Name": "DAMN.",
            "Artist": "Kendrick Lamar",
            "Year": 2017,
            "Genre": "Hip-Hop",
            "Tracklist": "BLOOD. (explicit)\n...\nDUCKWORTH (explicit)"
          },
          1224: {
            "UniqueID": 1224,
            "Name": "ANTI",
            "Artist": "Rihanna",
            "Year": 2016,
            "Genre": "Pop",
            "Tracklist":
                "Consideration (feat. SZA) (explicit)\n...\nSex With Me (explicit)"
          },
          1225: {
            "UniqueID": 1225,
            "Name": "Loud",
            "Artist": "Rihanna",
            "Year": 2010,
            "Genre": "Pop",
            "Tracklist": "S&M\n...\nSkin"
          },
          1226: {
            "UniqueID": 1226,
            "Name": "Good Girl Gone Bad: Reloaded",
            "Artist": "Rihanna",
            "Year": 2008,
            "Genre": "Pop",
            "Tracklist": "Umbrella (feat. JAY Z)\n...\nTake a Bow"
          },
          1227: {
            "UniqueID": 1227,
            "Name": "Black Holes and Revelations",
            "Artist": "Muse",
            "Year": 2006,
            "Genre": "Alternative",
            "Tracklist": "Take a Bow\n...\nKnights of Cydonia"
          },
          1228: {
            "UniqueID": 1228,
            "Name": "Will of the People",
            "Artist": "Muse",
            "Year": 2022,
            "Genre": "Alternative",
            "Tracklist": "Will of the People\n...\nWe are F*****g F****d"
          },
          1229: {
            "UniqueID": 1229,
            "Name": "Animal",
            "Artist": "Ke\$ha",
            "Year": 2010,
            "Genre": "Pop",
            "Tracklist": "Your Love is My Drug\n...\nc U Next Tuesday"
          },
          1230: {
            "UniqueID": 1230,
            "Name": "Rainbow",
            "Artist": "Ke\$ha",
            "Year": 2017,
            "Genre": "Pop",
            "Tracklist": "Bastards\n...\nSpaceship"
          },
          1231: {
            "UniqueID": 1231,
            "Name": "High Road",
            "Artist": "Ke\$ha",
            "Year": 2020,
            "Genre": "Pop",
            "Tracklist": "Tonight\n...\nSummer"
          },
          1232: {
            "UniqueID": 1232,
            "Name": "Cuz I Love You",
            "Artist": "Lizzo",
            "Year": 2019,
            "Genre": "Pop",
            "Tracklist": "Cuz I Love You\n...\n"
          },
          1233: {
            "UniqueID": 1233,
            "Name": "Special",
            "Artist": "Lizzo",
            "Year": 2022,
            "Genre": "Pop",
            "Tracklist": "About Damn Time\n...\nGrrrls"
          },
          1234: {
            "UniqueID": 1234,
            "Name": "The Eminem Show",
            "Artist": "Eminem",
            "Year": 2002,
            "Genre": "Hip-Hop",
            "Tracklist": "Curtains Up\n...\nCurtains Close"
          },
          1235: {
            "UniqueID": 1235,
            "Name": "The Marshall Mathers LP",
            "Artist": "Eminem",
            "Year": 2000,
            "Genre": "Hip-Hop",
            "Tracklist": "Public Service Announcement 2000\n...\nCriminal"
          },
          1236: {
            "UniqueID": 1236,
            "Name": "Recovery",
            "Artist": "Eminem",
            "Year": 2010,
            "Genre": "Hip-Hop",
            "Tracklist": "Cold Wind Blows\n...\nSession One"
          },
          1237: {
            "UniqueID": 1237,
            "Name": "dont smile at me",
            "Artist": "Billie Eilish",
            "Year": 2017,
            "Genre": "Alternative",
            "Tracklist": "COPYCAT\n...\n&burn"
          },
          1238: {
            "UniqueID": 1238,
            "Name": "WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?",
            "Artist": "Billie Eilish",
            "Year": 2019,
            "Genre": "Alternative",
            "Tracklist": "!!!!!!!!\n...\ngoodbye"
          },
          1239: {
            "UniqueID": 1239,
            "Name": "Happier Than Ever",
            "Artist": "Billie Eilish",
            "Year": 2021,
            "Genre": "Alternative",
            "Tracklist": "Getting Older\n...\nMale Fantasy"
          },
          1240: {
            "UniqueID": 1240,
            "Name": "Invasion of Privacy",
            "Artist": "Cardi B",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Tracklist": "Get Up 10\n...\nI Do"
          },
          1241: {
            "UniqueID": 1241,
            "Name": "Oxnard",
            "Artist": "Anderson .Paak",
            "Year": 2018,
            "Genre": "Hip-Hop",
            "Tracklist": "The Chase\n...\nLeft to Right"
          },
          1242: {
            "UniqueID": 1242,
            "Name": "Malibu",
            "Artist": "Anderson .Paak",
            "Year": 2016,
            "Genre": "R&B",
            "Tracklist": "The Bird\n...\nThe Dreamer"
          },
          1243: {
            "UniqueID": 1243,
            "Name": "Ventura",
            "Artist": "Anderson .Paak",
            "Year": 2019,
            "Genre": "R&B",
            "Tracklist": "Come Home\n...\nWhat Can We Do?"
          },
          // 1244:{
          //   "UniqueID": 1244,
          //   "Name": "An Evening with Silk Sonic",
          //   "Artist": {"Bruno Mars", "Anderson .Paak", "Silk Sonic"},
          //   "Year": 2021,
          //   "Genre": "R&B",
          //   "Tracklist": "Silk Sonic Intro\n...\nBlast Off"
          // },
          1245: {
            "UniqueID": 1245,
            "Name": "Take Care",
            "Artist": "Drake",
            "Year": 2011,
            "Genre": "Hip-Hop",
            "Tracklist": "Over My Dead Body\n...\nThe Ride"
          },
          1246: {
            "UniqueID": 1246,
            "Name": "Nothing Was the Same",
            "Artist": "Drake",
            "Year": 2013,
            "Genre": "Hip-Hop",
            "Tracklist": "Tuscan Leather\n...\nAll Me"
          },
          1247: {
            "UniqueID": 1247,
            "Name": "If You're Reading This It's Too Late",
            "Artist": "Drake",
            "Year": 2015,
            "Genre": "Hip-Hop",
            "Tracklist": "Legend\n...\n6PM in New York"
          },
          1248: {
            "UniqueID": 1248,
            "Name": "Views",
            "Artist": "Drake",
            "Year": 2016,
            "Genre": "Hip-Hop",
            "Tracklist": "Keep the Family Close\n...\nHotline Bling"
          }
        }
      },
    );
  }
}

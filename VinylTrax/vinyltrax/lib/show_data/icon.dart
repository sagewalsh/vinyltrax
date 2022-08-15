import 'package:flutter/material.dart';
import '../inventory/database.dart';
import '../pages/nextPage.dart';
import 'package:marquee/marquee.dart';
import '../pages/settingspage.dart' as settings;

// For location:
// 'inv' - Inventory
// 'wish' - Wishlist
// 'discogs' - Discogs
// 'spotify' - Spotify
class ShowIcon extends StatelessWidget {
  final String coverArt;
  final String artistName;
  final String albumName;
  final bool isArtist;
  final String location;
  final String id;

  //const AlbumIcon({Key? key}) : super(key: key);
  ShowIcon({
    this.artistName = "",
    this.albumName = "",
    required this.coverArt,
    required this.isArtist,
    required this.location,
    required this.id,
  });

  Widget buildAnimatedText(
          String text, double fontSize, BuildContext context) =>
      Container(
        height: MediaQuery.of(context).size.height * .0262, //18
        width: MediaQuery.of(context).size.width * .38, //150
        child: Marquee(
          style: TextStyle(
              fontSize: fontSize,
              color: settings.darkTheme ? Colors.white : Colors.black),
          pauseAfterRound: Duration(seconds: 1),
          text: text,
          blankSpace: MediaQuery.of(context).size.width * .0765,
          velocity: 25,
        ),
      );

  @override
  Widget build(BuildContext context) {
    double fontSize = MediaQuery.of(context).size.width * 0.036;
    Widget outputAlb = SizedBox();
    Widget outputArt = SizedBox();

    if (albumName.length > 19)
      outputAlb = buildAnimatedText(albumName, fontSize, context);
    else
      outputAlb = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            albumName,
            style: TextStyle(
                fontSize: fontSize,
                color: settings.darkTheme ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ));

    if (artistName.length > 19)
      outputArt = buildAnimatedText(
          artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""), fontSize, context);
    else
      outputArt = SizedBox(
          width: MediaQuery.of(context).size.width * .38,
          height: MediaQuery.of(context).size.height * .0262,
          child: Text(
            artistName.replaceAll(RegExp(r'\([0-9]+\)'), ""),
            style: TextStyle(
                fontSize: fontSize,
                color: settings.darkTheme ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ));

    Widget avatar = SizedBox();
    if (this.isArtist) {
      avatar = CircleAvatar(
          radius: MediaQuery.of(context).size.height * 0.093,
          foregroundImage: NetworkImage(coverArt));
    } else {
      avatar = ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image(
          height: MediaQuery.of(context).size.height * 0.18,
          width: MediaQuery.of(context).size.height * 0.18,
          image: NetworkImage(coverArt),
        ),
      );
    }

    List<Widget> children = [];
    if (albumName == "")
      children = [avatar, outputArt];
    else
      children = [avatar, outputArt, outputAlb];

    return GestureDetector(
      onTap: () {
        // print(MediaQuery.of(context).size.width);
        // print(MediaQuery.of(context).size.height);
        // print(albumName);
        var route = new MaterialPageRoute(builder: (BuildContext context) {
          if (location == 'inv') {
            if (isArtist)
              return new NextPageArtist(id: id, name: artistName);
            else
              return new NextPageAlbum(id, albumName);
          } else if (location == "wish") {
            return new NextPageSpotAlb(
              id,
              albumName,
              type: "wish",
            );
          } else if (location == 'discogs') {
            if (isArtist)
              return new NextPageDisArt(id, artistName);
            else
              return new NextPageDisAlb(id, albumName);
          } else {
            if (isArtist)
              return new NextPageSpotArt(id, artistName);
            else
              return new NextPageSpotAlb(id, albumName);
          }
        });
        Navigator.of(context).push(route);
      },
      onLongPress: () {
        if ((location == 'inv' || location == 'wish') && !isArtist) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Removal of:\n$albumName",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16)),
                  content: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (location == 'inv') {
                              // Remove album from inventory
                              Database.removeAlbum(id);
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(
                                        Duration(seconds: 1),
                                            () {
                                          Navigator.of(context)
                                              .pushNamed('inven');
                                        });
                                    return AlertDialog(
                                      title: Text(
                                          'Album Deleted',
                                          textAlign:
                                          TextAlign.center),
                                    );
                                  });
                            }
                            else if (location == 'wish') {
                              //remove from wishlist code here
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    Future.delayed(
                                        Duration(seconds: 1),
                                            () {
                                          Navigator.of(context)
                                              .pushNamed('wish');
                                        });
                                    return AlertDialog(
                                      title: Text(
                                          'Removed from wishlist',
                                          textAlign:
                                          TextAlign.center),
                                    );
                                  });
                            }
                          },
                          child: Text("Yes")),
                      SizedBox(width: 20),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(
                                context); //returns user back to page
                          },
                          child: Text("No")),
                    ],
                  ),
                );
              });
        }
      },
      child: Column(
        children: children,
      ),
    );
  }
}

/*
#############################################################################
ICON LIST CLASS
#############################################################################
*/

class IconList extends StatelessWidget {
  //IconList({Key? key}) : super(key: key);

  List<Widget> children = <Widget>[];

  IconList(this.children);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.0765,
          vertical: MediaQuery.of(context).size.height * 0.0062),
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Wrap(
              direction: Axis.horizontal,
              spacing: MediaQuery.of(context).size.width * 0.0765,
              runSpacing: MediaQuery.of(context).size.width * 0.051,
              children: children += [
                SizedBox(
                  height: 10,
                  width: MediaQuery.of(context).size.width,
                )
              ]),
        ),
      ),
    );
  }
}

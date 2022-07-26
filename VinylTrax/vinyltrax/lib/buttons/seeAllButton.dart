import 'package:flutter/material.dart';
import 'package:vinyltrax/show_data/iconList.dart';

import '../show_data/icon.dart';

class SeeAllButton extends StatefulWidget {
  AsyncSnapshot<List<String>> snapshot;
  String type;

  SeeAllButton(this.snapshot, this.type);

  @override
  State<SeeAllButton> createState() => _SeeAllButtonState();
}

class _SeeAllButtonState extends State<SeeAllButton> {

  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];

    if (widget.type == "Albums") {
      if (widget.snapshot.hasData) {
        for (int i = 0; i < widget.snapshot.data!.length; i += 4) {
          var data = [
            widget.snapshot.data![i],
            widget.snapshot.data![i + 1],
            widget.snapshot.data![i + 2],
            widget.snapshot.data![i + 3],
          ];
          var artist_album = data[0].split(" - ");
          children.add(ShowIcon(
            artistName: artist_album[0],
            albumName: artist_album[1],
            coverArt: data[3],
            isArtist: false,
            location: 'discogs',
            id: data[1],
          ));
        }
      }
    }
    else if (widget.type == "Artists") {
      for (int i = 0; i < widget.snapshot.data!.length; i += 3) {
        var data = [
          widget.snapshot.data![i],
          widget.snapshot.data![i + 1],
          widget.snapshot.data![i + 2],
        ];
        children.add(ShowIcon(
          artistName: data[0],
          coverArt: data[2],
          isArtist: true,
          location: 'discogs',
          id: data[1],
        ));
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text("See more", style: TextStyle(color: Colors.black)),
        backgroundColor: Color(0xFFFFFEF9),
        leading: BackButton(
          color: Colors.black,
          onPressed: () {
            //kinda broken rn
            Navigator.of(context).pop();
            //gonna figure this out
          },
        ),
      ),
      body: IconList(children)
    );
  }
}

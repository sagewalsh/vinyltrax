import 'package:flutter/material.dart';
import '../pages/settingspage.dart' as settings;
import '../show_data/icon.dart';

class SpotAllButton extends StatefulWidget {
  AsyncSnapshot<Map<String, List<dynamic>>> snapshot;
  String type;

  SpotAllButton(this.snapshot, this.type);

  @override
  State<SpotAllButton> createState() => _SpotAllButtonState();
}

class _SpotAllButtonState extends State<SpotAllButton> {
  @override
  Widget build(BuildContext context) {
    List<Widget> children = <Widget>[];
    var map = widget.snapshot.data!;

    var key = widget.type.toLowerCase().split(" ")[0];
    var value = map[key]!;
    if (key.toString() == "artists") {
      value.forEach((data) {
        children.add(ShowIcon(
          artistName: data[1].toString(),
          coverArt: data[2],
          isArtist: true,
          location: 'spotify',
          id: data[0],
        ));
      });
    } else {
      value.forEach((data) {
        // Compile artist names
        String artName = "";
        for (int i = 0; i < (data[2] as List<dynamic>).length; i++) {
          artName += data[2][i][0].toString();
          if (i + 1 < (data[2] as List<dynamic>).length) {
            artName += " & ";
          }
        }
        children.add(ShowIcon(
          artistName: artName,
          albumName: data[1],
          coverArt: data[3],
          isArtist: false,
          location: 'spotify',
          id: data[0],
        ));
      });
    }

    return Scaffold(
        backgroundColor:
            settings.darkTheme ? Color(0xFF1C1C1C) : Color(0xFFFFFDF6),
        appBar: AppBar(
          title: Text("See All",
              style: TextStyle(
                  color: settings.darkTheme ? Colors.white : Colors.black)),
          backgroundColor:
              settings.darkTheme ? Color(0xFF181818) : Color(0xFFFFFDF6),
          leading: BackButton(
            color: settings.darkTheme ? Colors.white : Colors.black,
            onPressed: () {
              //kinda broken rn
              Navigator.of(context).pop();
              //gonna figure this out
            },
          ),
        ),
        body: IconList(children));
  }
}

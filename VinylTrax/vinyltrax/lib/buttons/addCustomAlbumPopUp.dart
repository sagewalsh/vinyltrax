import 'package:flutter/material.dart';
import '../inventory/database.dart';

class AddCustomAlbumPopUp extends StatefulWidget {
  String artistID;
  AddCustomAlbumPopUp(this.artistID);

  @override
  State<AddCustomAlbumPopUp> createState() => _AddCustomAlbumPopUpState();
}

class _AddCustomAlbumPopUpState extends State<AddCustomAlbumPopUp> {
  String year = "Pick a Year";
  DateTime current = DateTime.now();
  String genre = "";
  String format = "";

  TextEditingController _albumController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Custom Album"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _albumController,
            decoration: InputDecoration(hintText: "Enter Album Name"),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Pressing Year: "),
              TextButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return YearPicker(
                            onChanged: (DateTime val) {
                              setState(() {
                                year = val.year.toString();
                                current = val;
                                Navigator.of(context).pop();
                              });
                            },
                            firstDate: DateTime(1300),
                            lastDate: DateTime.now(),
                            selectedDate: current,
                          );
                        });
                  },
                  child: Text(year)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Genre: "),
              DropdownButton(
                  value: genre,
                  items: [
                    "",
                    "Blues",
                    "Brass and Military",
                    "Children's",
                    "Classical",
                    "Electronic",
                    "Folk and Country",
                    "Funk / Soul",
                    "Hip Hop",
                    "Jazz",
                    "Latin",
                    "Pop",
                    "Reggae",
                    "Rock"
                  ].map((String value) {
                    return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ));
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      genre = val!;
                    });
                  }
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Format: "),
              DropdownButton(
                  value: format,
                  items: [
                    "",
                    "Vinyl",
                    "CD"
                  ].map((String value) {
                    return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ));
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      format = val!;
                    });
                  }
              ),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              //_albumController.text will get album name
              //add custom record here
              //Database.createAlbum(artist: artist, album: album, format: format, year: year);
              Navigator.pop(context);
            },
            child: Text("Confirm")
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel")
        ),
      ],
    );
  }
}

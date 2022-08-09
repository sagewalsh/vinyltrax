import 'package:flutter/material.dart';
import '../inventory/database.dart';
import 'package:vinyltrax/pages/settingspage.dart' as settings;

class AddCustomAlbumPopUp extends StatefulWidget {
  List<String> artist;
  AddCustomAlbumPopUp(this.artist);

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
              Text("Year of Recording: "),
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
                  child: Text(
                    year,
                    style: TextStyle(
                      color: settings.darkTheme
                          ? Color(0xFFBB86FC)
                          : Color(0xFFFF5A5A),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Format: "),
              DropdownButton(
                  value: format,
                  items: ["", "Vinyl", "CD"].map((String value) {
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
                  }),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            //_albumController.text will get album name
            //add custom record here
            if (_albumController.text != "" &&
                format != "" &&
                year != "Pick a Year") {
              Database.createAlbum(
                  artist: [widget.artist[1], widget.artist[0]],
                  album: _albumController.text,
                  format: format,
                  year: year);
              Navigator.pop(context);
            } else {
              null;
            }
          },
          child: Text(
            "Confirm",
            style: TextStyle(
              color: settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
            ),
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color:
                    settings.darkTheme ? Color(0xFFBB86FC) : Color(0xFFFF5A5A),
              ),
            )),
      ],
    );
  }
}

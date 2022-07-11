import 'package:flutter/material.dart';
import '../database.dart';

class AddAlbumPopUp extends StatefulWidget {
  Future<List<dynamic>> input;
  String albumID;
  //const AddAlbumPopUp({Key? key}) : super(key: key);

  AddAlbumPopUp(this.input, this.albumID);

  @override
  State<AddAlbumPopUp> createState() => _AddAlbumPopUpState(albumID);
}

class _AddAlbumPopUpState extends State<AddAlbumPopUp> {
  String locationValue = 'Inventory';
  String format = 'Vinyl';
  bool visible = true;
  double height = 150;
  String albumID;

  _AddAlbumPopUpState(this.albumID);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<List<dynamic>>(
          future: widget.input,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            var data = snapshot.data!;
            return AlertDialog(
              title: Text(
                  "Add ${data[1].toString()} by ${data[0][0][0].toString()}"),
              content: SizedBox(
                height: height,
                child: Column(
                  children: [
                    DropdownButtonFormField(
                      value: locationValue,
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (String? newVal) {
                        locationValue = newVal!;
                        setState(() {
                          if (newVal == 'Inventory') {
                            height = 150;
                            visible = true;
                          } else {
                            height = 100;
                            visible = false;
                          }
                        });
                      },
                      onSaved: (String? value) {
                        setState(() {
                          locationValue = value!;
                        });
                      },
                      items: <String>['Inventory', 'Wishlist']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem(
                            value: value, child: Text(value));
                      }).toList(),
                    ),
                    Visibility(
                      visible: visible,
                      child: DropdownButtonFormField(
                          value: format,
                          items: <String>['Vinyl', 'CD']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newVal) {
                            format = newVal!;
                          },
                          onSaved: (String? value) {
                            setState(() {
                              format = value!;
                            });
                          }),
                    ),
                    TextButton(
                        onPressed: () {
                          //lets us go back to the album page
                          Navigator.of(context).pop();
                          // Test function, allows us to see if everything works properly
                          print(
                              'Location: $locationValue \nFormat: $format \nAlbum Name: ${snapshot.data?[0].toString()}'
                              ' \nArtist: ${snapshot.data?[1].toString()}');
                          List<dynamic> album = [albumID, format];
                          album += snapshot.data!;
                          Database.addAlbumToInv(album);
                        },
                        child: Text("Add")),
                  ],
                ),
              ),
            );
          });
    });
  }
}

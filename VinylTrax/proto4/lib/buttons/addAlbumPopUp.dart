import 'package:flutter/material.dart';
import '../inventory/database.dart';

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
  late double height;
  String albumID;

  _AddAlbumPopUpState(this.albumID);

  @override
  Widget build(BuildContext context) {
    // height = MediaQuery.of(context).size.height * 0.186; //150
    height = MediaQuery.of(context).size.height * 0.24;
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
                            height =
                                MediaQuery.of(context).size.height * 0.24; //150
                            visible = true;
                          } else {
                            height = MediaQuery.of(context).size.height * 0.15;
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
                    Container(
                      //height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                // Add album to inventory
                                if (locationValue == "Inventory") {
                                  List<dynamic> album = [albumID, format];
                                  album += snapshot.data!;
                                  Database.addSpotToInv(album);
                                }

                                // Add album to wishlist
                                else if (locationValue == "Wishlist") {
                                  List<dynamic> album = [albumID];
                                  album += snapshot.data!;
                                  Database.addToWish(album);
                                }

                                //lets us go back to the album page
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      Future.delayed(Duration(seconds: 1), () {
                                        Navigator.pushNamed(context, 'search');
                                      });
                                      return AlertDialog(
                                        title: Text('Album Added',
                                            textAlign: TextAlign.center),
                                      );
                                    });
                              },
                              child: Text("Add")),
                          TextButton(
                              onPressed: () {
                                //lets us go back to the album page
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }
}

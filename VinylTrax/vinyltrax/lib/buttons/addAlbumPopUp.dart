import 'package:flutter/material.dart';
import '../inventory/database.dart';

class AddAlbumPopUp extends StatefulWidget {
  Future<List<dynamic>> input;
  final String type;
  //const AddAlbumPopUp({Key? key}) : super(key: key);

  AddAlbumPopUp(this.input, this.type);

  @override
  State<AddAlbumPopUp> createState() => _AddAlbumPopUpState();
}

class _AddAlbumPopUpState extends State<AddAlbumPopUp> {
  String locationValue = 'Inventory';
  String format = 'Vinyl';
  bool visible = true;
  late double height;

  _AddAlbumPopUpState();

  @override
  Widget build(BuildContext context) {
    // height = MediaQuery.of(context).size.height * 0.186; //150
    //height = MediaQuery.of(context).size.height * 0.14;
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder<List<dynamic>>(
          future: widget.input,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            var data = snapshot.data ?? ["E", "E", "E", "E", "E", "E", "E"];
            String albumID = data[6];
            return AlertDialog(
              title: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(style: TextStyle(fontSize: 18), children: [
                    TextSpan(
                        text: "Add\n",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    TextSpan(
                        text: "${data[1].toString()}\n",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    TextSpan(
                        text: "by\n",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                    TextSpan(
                        text: "${data[0][0][0].toString()}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ])),
              //title: Text(
              //   "Add ${data[1].toString()} by ${data[0][0][0].toString()}"),
              content: SizedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField(
                      value: locationValue,
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (String? newVal) {
                        locationValue = newVal!;
                        setState(() {
                          if (newVal == 'Inventory') {
                            height =
                                MediaQuery.of(context).size.height * 0.13; //150
                            visible = true;
                          } else {
                            height = MediaQuery.of(context).size.height * 0.06;
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
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      // Add album to inventory
                      if (locationValue == "Inventory") {
                        List<dynamic> album = [albumID, format];
                        album += snapshot.data!;
                        addAlbum(album);
                      }

                      // Add album to wishlist
                      else if (locationValue == "Wishlist") {
                        List<dynamic> album = [albumID];
                        album += snapshot.data!;
                        Database.addToWish(album);
                        //lets us go back to the album page
                        showDialog(
                            context: context,
                            builder: (context) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                              return AlertDialog(
                                title: Text('Album Added',
                                    textAlign: TextAlign.center),
                              );
                            });
                      }
                    },
                    child: Text("Add")),
                TextButton(
                    onPressed: () {
                      //lets us go back to the album page
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
              ],
            );
          });
    });
  }

  /*
  ##############################################################################
  Helper method to add album to inventory
  ##############################################################################
  */
  void addAlbum(List<dynamic> album) {
    Database.checkInv(album[0], album[1]).then((exists) {
      /*
      ###################################################
      User Already has a Copy of this Album
      ###################################################
      */
      if (exists) {
        Navigator.of(context).pop();
        /*
        ###################################################
        warning pop up
        ###################################################
        */
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                "Warning! \nYou already have this album.\nContinue?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Database.addSpotToInv(album);
                      Navigator.of(context).pop();

                      /*
                      ###################################################
                      success pop up
                      ###################################################
                      */
                      showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 1), () {
                              if (widget.type == "wish") {
                                Navigator.pushNamed(context, "wish");
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            });
                            return AlertDialog(
                              title: Text('Album Added',
                                  textAlign: TextAlign.center),
                            );
                          });
                    },
                    child: Text("Yes"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            );
          },
        );
      }
      /*
      ###################################################
      Add to User's Inventory
      ###################################################
      */
      else {
        Database.addSpotToInv(album);
        Navigator.of(context).pop();

        /*
        ###################################################
        success pop up
        ###################################################
        */
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(Duration(seconds: 1), () {
                if (widget.type == "wish") {
                  Navigator.pushNamed(context, "wish");
                } else {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              });
              return AlertDialog(
                title: Text('Album Added', textAlign: TextAlign.center),
              );
            });
      }
    });
  }
}

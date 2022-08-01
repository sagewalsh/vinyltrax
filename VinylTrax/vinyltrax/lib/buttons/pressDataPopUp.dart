import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vinyltrax/inventory/getInvPressing.dart';
import '../inventory/database.dart';
import '../inventory/invDetails.dart';

class PressDataPopUp extends StatefulWidget {
  final String albumid;
  // const PressDataPopUp({Key? key}) : super(key: key);
  PressDataPopUp(this.albumid);

  @override
  State<PressDataPopUp> createState() => _PressDataPopUpState();
}

class _PressDataPopUpState extends State<PressDataPopUp> {
  // int numLP = 1;
  // String colorLP = 'Black';
  // int rpmSize = 30;
  // String year = 'Pick a year';
  // DateTime current = DateTime.now();
  // String manufacturer = "Enter a Manufacturer";
  String numLP = "";
  String colorLP = "";
  String rpmSize = "";
  String year = "Pick a year";
  String manufacturer = "";
  DateTime current = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify Pressing Data Below"),
      content: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Number of LPs: "),
                DropdownButton(
                    value: numLP,
                    items: ["", "1", "2", "3", "4+"].map((String value) {
                      return DropdownMenuItem(
                          value: value, child: Text(value.toString()));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        numLP = value!;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Color of LPs: "),
                DropdownButton(
                    value: colorLP,
                    items: [
                      "",
                      "Red",
                      "Pink",
                      "Purple",
                      "Deep Purple",
                      "Indigo",
                      "Blue",
                      "Light Blue",
                      "Cyan",
                      "Teal",
                      "Green",
                      "Light Green",
                      "Lime",
                      "Yellow",
                      "Amber",
                      "Orange",
                      "Deep Orange",
                      "Brown",
                      "Grey",
                      "Blue Grey",
                      "Black",
                      "Other",
                    ].map((String value) {
                      return DropdownMenuItem(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: colorOptions[value],
                              fontWeight: FontWeight.bold,
                            ),
                          ));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        colorLP = value!;
                      });
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("RPM Size: "),
                DropdownButton(
                    value: rpmSize,
                    items: ["", "33", "45", "78"].map((String value) {
                      return DropdownMenuItem(
                          value: value, child: Text(value.toString()));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        rpmSize = value!;
                      });
                    }),
              ],
            ),
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
            TextField(
              decoration: InputDecoration(
                hintText: "Enter a Manufacturer",
              ),
              onSubmitted: (String text) {
                setState(() {
                  manufacturer = text;
                });
              },
            ),
            TextButton(
                onPressed: () {
                  if (year == "Pick a year") year = "";
                  Database.updatePressData(
                    albumID: widget.albumid,
                    numLP: numLP,
                    colorLP: colorLP,
                    rpmSize: rpmSize,
                    year: year,
                    manufacturer: manufacturer,
                  );
                  Navigator.pop(context);
                  Navigator.pop(context);
                  var route =
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return InvDetails([widget.albumid, ""]);
                  });
                  Navigator.of(context).push(route);
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}

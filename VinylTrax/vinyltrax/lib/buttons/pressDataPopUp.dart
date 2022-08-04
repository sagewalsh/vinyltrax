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
  TextEditingController _controller = TextEditingController();
  String numLP = "";
  String colorLP = "";
  String rpmSize = "";
  String year = "Pick a year";
  String manufacturer = "";

  DateTime current = DateTime.now();

  @override
  void initState() {
    Database.getPressData(widget.albumid).then((result) {
      setState (() {
        numLP = result[0];
        colorLP = result[1];
        rpmSize = result[2];
        year = result[3];
        manufacturer = result[4];
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Modify Pressing Data Below"),
      content: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [

            //Number of LPs
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

            // Color picker
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

            //RPM Size
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

            // Year picker
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

            // Manufacturer
            TextField(
              controller: _controller..text = manufacturer,
              decoration: InputDecoration(
                hintText: "Enter a Manufacturer",
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      manufacturer = _controller.text;
                    });
                  },
                  icon: Icon(Icons.check),
                )
              ),
              onSubmitted: (String text) {
                setState(() {
                  manufacturer = text;
                });
              },
            ),

            //Final Submission
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

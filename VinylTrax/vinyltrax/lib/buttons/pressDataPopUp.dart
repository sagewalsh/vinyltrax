import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../inventory/database.dart';

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
                    items: ["", "Black", "Colored"].map((String value) {
                      return DropdownMenuItem(value: value, child: Text(value));
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
                    items: ["", "30", "45", "78"].map((String value) {
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
                  Database.updatePressData(
                    albumID: widget.albumid,
                    numLP: numLP,
                    colorLP: colorLP,
                    rpmSize: rpmSize,
                    year: year,
                    manufacturer: manufacturer,
                  );
                  Navigator.of(context).pop();
                },
                child: Text("Done"))
          ],
        ),
      ),
    );
  }
}
